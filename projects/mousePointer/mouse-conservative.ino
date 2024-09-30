#include "Mouse.h"
#include "Keyboard.h"

#define DOF 6
#define TX 0 // translation X
#define TY 1 // translation Y
#define TZ 2 // translation Z
#define RX 3 // rotation X
#define RY 4 // rotation Y
#define RZ 5 // rotation Z

#define SELECTED_APP 1 // 0 for Blender, 1 for Fusion 360 (index of appSetting[] )

#define MAX_APP 5 // number of apps. Currently no function to switch between apps.
#define MAX_MOTION_SET 5 // number of motion set (rotation, translation, zoom, ..) for each app
#define MAX_KEYS 5 // number of simultaneously pressed keys and buttons

#define INVALID -1 // invalid flag / terminator

typedef struct {
  boolean valid;
  int mouseXAxis;
  int mouseYAxis;
  int wheelAxis;
  int polarity;
  int buttons[MAX_KEYS];
  int keys[MAX_KEYS];
} MotionSetting;

typedef struct {
  boolean valid;
  char appName[20];
  MotionSetting motionSetting[MAX_MOTION_SET];
} AppSetting;

////////////////////////////////
// settings for apps (example)
// * relationship between knob motion and mouse direction
// * key and mouse button bindings
// * polarity (invert motion)
////////////////////////////////

AppSetting appSetting[MAX_APP] = {
  { // setting example for Blender
    true,
    "Blender",
    {
      { // rotation of the object
        true,
        RX,
        RY,
        INVALID,
        1,
        {MOUSE_MIDDLE, INVALID},
        {INVALID},
      },
      { // translation of the object
        true,
        TX,
        TY,
        INVALID,
        1,
        {MOUSE_MIDDLE, INVALID},
        {KEY_LEFT_SHIFT, INVALID},
      },
      { // zoom of the object
        true,
        INVALID,
        TZ,
        INVALID,
        1,
        {MOUSE_MIDDLE, INVALID},
        {KEY_LEFT_CTRL, INVALID},
      },
      {
        false // terminator (end of the settings of this app)
      }
    }
  },
  { // setting example for Fusion 360
    true,
    "Fusion360",
    {
      { // rotation of the object
        true,
        RX,
        RY,
        INVALID,
        1,
        {MOUSE_MIDDLE, INVALID},
        {KEY_LEFT_SHIFT, INVALID},
      },
      { // translation of the object
        true,
        TX,
        TY,
        INVALID,
        1,
        {MOUSE_MIDDLE, INVALID},
        {KEY_LEFT_CTRL, INVALID},
      },
      { // zoom of the object
        true,
        INVALID,
        INVALID,
        TZ, // wheel rotation
        -1, // motion inverted
        {INVALID},
        {INVALID},
      },
      {
        false // terminator (end of the settings of this app)or
      }
    }
  },
  {
    false // terminator
  }
};

/// hardware settings
#define TOTAL_DELAY 30 // motion sending cycle
#define INT_DELAY 1 // delay between key and button operations
#define DEAD_THRES 0 // threshold to ignore small motion
#define SPEED_PARAM 300 // larger is slower

// ports of analog input for joysticks
int port[DOF] = {A0, A2, A6, A1, A3, A7};

// conversion matrix from sensor input to rigid motion
int coeff[DOF][DOF] = {
  { 0,  0,  0,-20,-20, 40}, // TX
  { 0,  0,  0,-17, 17,  0}, // TY
  {-3, -3, -3,  0,  0,  0}, // TZ
  {-6,  6,  0,  0,  0,  0}, // RY
  { 3,  3, -6,  0,  0,  0}, // RX
  { 0,  0,  0,  2,  2,  2}, // RZ
};

#define abs(x) ((x)<0?(-x):(x))

int origin[DOF]; // initial sensor values

void setup() {
  Mouse.begin();
  Keyboard.begin();
  delay(300);
  for(int i = 0; i < DOF; i++) {
    origin[i] = analogRead(port[i]);
  }
}

int sx, sy, sw;
void move(int x, int y, int w) {
  Mouse.move(x, y, w);
  sx += x;
  sy += y;
  sw += w;
}

// return mouse pointer to the original position
#define THRES_AVOID_MOUSE_ACCEL 10
void resetMove(void) {
  int mx, my, mw;
  sx = -sx;
  sy = -sy;
  sw = -sw;
  while(abs(sx) || abs(sy) || abs(sw)) {
    mx = sx;
    if(mx > THRES_AVOID_MOUSE_ACCEL)
      mx = THRES_AVOID_MOUSE_ACCEL;
    else if(mx < -THRES_AVOID_MOUSE_ACCEL)
      mx = -THRES_AVOID_MOUSE_ACCEL;

    my = sy;
    if(my > THRES_AVOID_MOUSE_ACCEL)
      my = THRES_AVOID_MOUSE_ACCEL;
    else if(my < -THRES_AVOID_MOUSE_ACCEL)
      my = -THRES_AVOID_MOUSE_ACCEL;

    mw = sw;
    if(mw > THRES_AVOID_MOUSE_ACCEL)
      mw = THRES_AVOID_MOUSE_ACCEL;
    else if(mw < -THRES_AVOID_MOUSE_ACCEL)
      mw = -THRES_AVOID_MOUSE_ACCEL;

    delay(INT_DELAY);
    Mouse.move(mx, my, mw);
    sx -= mx;
    sy -= my;
    sw -= mw;
  }
}

void loop() {
  int sv[DOF]; // sensor value
  int mv[DOF]; // motion vector
  static int previousMotionNo = INVALID;
  int maxMotionMagnitude = 0, newMotionNo = INVALID;
  int x = 0, y = 0, w = 0, magnitude = 0;
  MotionSetting currentMotion;
  AppSetting currentApp = appSetting[SELECTED_APP]; // select app here

  // read sensor value and subtract original position
  for(int i = 0; i < DOF; i++) {
    sv[i] = analogRead(port[i]) - origin[i];
  }

  // calculate the motion of the "mushroom" knob
  for(int i = 0; i < DOF; i++) {
    mv[i] = 0;
    for(int j = 0; j < DOF; j++) {
      mv[i] += coeff[i][j] * sv[j];
    }
    mv[i] /= SPEED_PARAM;
    if(mv[i] > 127) {
      mv[i] = 127;
    }
    else if(mv[i] < -128) {
      mv[i] = -128;
    }
  }

  // find intended operation with maximum motion (ex. rotation or translation)
  for(int j = 0; j < MAX_MOTION_SET; j++) {
    currentMotion = currentApp.motionSetting[j];
    if(currentMotion.valid == false)
      break;
    if(currentMotion.mouseXAxis != INVALID)
      x = mv[currentMotion.mouseXAxis];
    if(currentMotion.mouseYAxis != INVALID)
      y = mv[currentMotion.mouseYAxis];
    if(currentMotion.wheelAxis != INVALID)
      w = mv[currentMotion.wheelAxis];
    magnitude = abs(x) + abs(y) + abs(w);
    if(magnitude < DEAD_THRES)
      break;
    if(magnitude > maxMotionMagnitude) { // select operation with largest motion
      newMotionNo = j;
      maxMotionMagnitude = magnitude;      
    }
  }

  if(newMotionNo != previousMotionNo) { // operation changes. reset all keys and buttons.
    Keyboard.releaseAll();
    if(previousMotionNo != INVALID) {
      currentMotion = currentApp.motionSetting[previousMotionNo];
      for(int k = 0; k < MAX_KEYS; k++) {
        if(currentMotion.buttons[k] == INVALID)
          break;
        Mouse.release(currentMotion.buttons[k]);
      }
    }
    previousMotionNo = INVALID;
    resetMove(); // return mouse position
  }

  if(newMotionNo == INVALID)
    return;

  currentMotion = currentApp.motionSetting[newMotionNo];
  if(newMotionNo != previousMotionNo) {
    for(int k = 0; k < MAX_KEYS; k++) {
      if(currentMotion.keys[k] == INVALID)
        break;
      Keyboard.press(currentMotion.keys[k]);
      delay(INT_DELAY);
    }
    for(int k = 0; k < MAX_KEYS; k++) {
      if(currentMotion.buttons[k] == INVALID)
        break;
      Mouse.press(currentMotion.buttons[k]);
      delay(INT_DELAY);
    }
  }

  x = 0;
  y = 0;
  w = 0;
  if(currentMotion.mouseXAxis != INVALID)
    x = mv[currentMotion.mouseXAxis];
  if(currentMotion.mouseYAxis != INVALID)
    y = mv[currentMotion.mouseYAxis];
  if(currentMotion.wheelAxis != INVALID)
    w = mv[currentMotion.wheelAxis];
  x *= currentMotion.polarity;
  y *= currentMotion.polarity;
  w *= currentMotion.polarity;
  move(x, y, w);
  delay(TOTAL_DELAY);
  previousMotionNo = newMotionNo;
}
