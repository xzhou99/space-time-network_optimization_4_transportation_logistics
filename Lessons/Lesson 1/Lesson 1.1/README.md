Lesson 1: Learning Transportation Network Analysis

Lesson 1.1: Introduction with the West Jordan Network.

Download the software using the following link:
https://github.com/xzhou99/dtalite_software_release/blob/gh-pages/1_Software_Download/DTALite-NEXTA-Software-Package.zip

White Paper on DTALite: 
DTALite: A queue-based mesoscopic traffic simulator for fast model evaluation and calibration. Use the following link.
http://www.tandfonline.com/doi/full/10.1080/23311916.2014.961345#.VGy47vnF_o9


Steps to follow:

1) Download and Open the West Jordan Network.
  a) Download Lesson 1.1 from the given link.

  b) Extract the zip file to a known locationon your computer, and open NeXTA.exe file. 

  c) Open West Jordan Network in NeXTA. 

2) Viewing/Editing Network Attributes in NeXTA.
  a) Click a node/link --> View the attributes in the bottom left corner of the screen 

  b) Right-click on node/link to view properties.

3) Run Traffic Simulation using the simulation button on screen.

4) Create the Work Zone Network.
  a) Copy the same data set 'Salt_Lake_City_West_Jordan' folder at the same place and rename the folder as 'West_Jordan_WZ'.
     Rename the 'Base_condition.tnp' to 'West_Jordan_WZ.tnp' inside the newly created folder.
  
  b) Reduce number of lanes on all links between node 1 and node 3 to lane 1 and save.

  c) Run traffic simulation again and open the output summary file.

5) Compare simulation results for both Networks( with and without work zone)
  a) Close NeXTA --> Open NeXTA again --> File --> Close --> Open West_Jordan_WZ network --> Open Base_Condition network
    
  b) Go to Windows menu --> select Tile Vertically --> Synchronized display 

  c) Select Link MOE in GIS layer panel --> Ctrl + f --> find node 5022 --> select link going from node 11124 to 
     link 5022.

