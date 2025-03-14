# Convert a .stl to a suitable object
Here are common operations involved while converting a generic _.stl_ file to a suitable freecad object
ready for being freely modified
- Create a new freecad project file
- Import the file in a workspace
- **Mesh** workspace
    - Click on the imported object
    - **Meshes / Analize / Check Solid Mesh** option
    - if the mesh is accepted as a solid and valid mesh we can continue
    - if a problem arises you can use the mesh repair utility, it's not powerful but still way better than fixing meshes manually.  
      **Meshes / Analize / Evaluate and Repair Mesh** option. A nice utility runs several tests on it to fix whatever is possible
- **Part** workspace
    - Select the desired object
    - **Part / Create shape from mesh** option
    - keep default settings for that option, then a new mesh object will be created from it, it's now time to hide the original src part
    - Select the newly created object
    - **Part / Create a copy / Refine shape** option and a newly created and refined shape will be created from it
    - Select the newly created object and hide the old one
- If you want to work in **Part** workspace then execute these steps too
    - **Part / Convert to solid** option and a new object will be created from it, old shape might be hidden or deleted too
    - Now the object can be edited with common tools
- If you want to work in **Part Design** workspace then
   - Select the object and go to the **Part Design** workspace
   - **Part Design / Create body** option
   - A new Object body will be created from it
