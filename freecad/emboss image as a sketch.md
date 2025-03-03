To import a scalable vector graphic picture  and treat it as a sketch in freecad you need to do these things:

- File/Import
- Select the required SVG file
- Opt for SVG as Geometry import type
- Now a plentitude of subparts might be present in your model. You need to convert
them as a sketch and fix all selections across the required axis and position
    - Go to Draft workspace
    - Select all Selections parts need to be merged as a single sketch
    - From Modification menu select: "Draft to sketch"
    - A new sketch will be created after it
    - Hide or delete imported Selection* objects
    - Select the newly created sketch
    - From the properties of the sketch you can change:
        - The angle, for example: 0, 90, 180, 270
        - The axis. After changing the angle set the correct axis to 0 or 1
        - The position if the sketch has to be moved
    - Move the newly created sketch into your required freecad object
- Go back to "Part Design" Workspace
- Edit or fix the sketch accordingly

    
