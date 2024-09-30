# Blender related tips and tricks

## Cut an object in two (method one, the official supported one)
Bisect tool can be used to cut an object from a line in Blender
- Select the object to split
- Enter _Edit/Object Mode_
- Select the **Bisect** tool, it's in the same menu of the knife object
    - Click and hold the Knife tool to open the drop-down menu for the Bisect tool
- Left click and drag to create a line where you want to cut the object
    - As a tedious alternative it's still possible to carefully pick each single vertex for a more clean cut.
        You can follow precise lines or even customize the whole process, take your time with it.
        It's basically the same as editing and selecting faces individually (with bisect selected)
- Menu **Vertex/Rip Vertices** or press **_V_** to cut
- Right click, then select Select Loops, then select Loop Inner Region
- Press 'p' to open the Separate menu, then click Selection 

Here are few nice examples for it:
- https://www.youtube.com/watch?v=ZYYkdNhfMhw
- https://www.youtube.com/watch?v=fVOYv8HdMxI

## Cut an object in two (method two, creative and user made, this one really rocks)
But these are the best for it, these tricks do **NOT** use knife or bisect tools and are instead focused
on using planes objects or thin cubes. It's possible to bisect an object suitable for personal needs and
ready for printing:
- https://www.youtube.com/watch?v=j5at2x0CcX8
- https://www.youtube.com/watch?v=moPDPB4MY2U

Brief summary and ideas:
### Using planes
- Add/Mesh/Plane
- Shape your plane accordingly, for example:
    - Go to Edit Mode then Add arbitrary vertexes, move them freely
    - Edit Mode / Loop Cut tool to add new faces in the Plane and later adjust them to follow a shape
- Exit from Edit Mode
- add: Modifiers / Generate / Solidify, thickness set to _0.001 m_, Apply to confirm
- Select the target object
- add: Modifiers / Generate / Boolean, Select the newly created Plane, Apply to confirm
- Edit Mode for the target object
- Select an object, a face or a vertex
- menu: Select / Select Loops / Select Loop Inner-Region
- menu: Mesh / Separate or Press 'p' to enter in the same menu, Select 'Selection' choice. Now two objects
  will be created from the original. Use the _eye/visible icon_ to see them accordingly
- Exit from _edit mode_


