Tour Into The Picture 

Applicable version: Matlab 2020a，2021b, 2022a
Toolbox Installation: Image Processing Toolbox
System Enviorment: Mac, Windows, Ubuntu

This program is dedicated to rebuilding 2-dimensions image into 3-dimensions.

*********Structure description***********

G05
├── Readme.txt                    		 // help
├── picture                        		 // store all needed images
├── main.m 				     		 // the main function, also the code for GUI， including the points-adding functions and so on.
├── main.fig                       		 // the interface design
├── lib                   	    		 // all functions needed
│   ├── CalculatePointCoordinates.m		 // determind the points for spidery mesh
│   ├── CutImage.m     	        		 // cut off the foreground
│   ├── ForegroundCalculation.m         	 // determind the position of foreground and helpful information for resize
│   ├── ImageCropping.m              	 // cut the 2-dimensions image into desired form
│   ├── ProjectiveRectification.m         	 // do projective Rectification to the cutted images
│   └── Transform3D.m 				 // Stitching the finished images to form a 3d room

***********Instructions for use***********

To complete the 3-dimensions reconstruction:
1. "change a picture": Choose picture for reconstruction. Programm only accepts files in "*.jpg"，"*.jpeg" or "*.png" formats. 
2. "add a point": First click this button, and the add a point in the picture. You can choose 5 points maximal.
3. "front background": Klick this button to choose the front ground. You can only choose a front ground in the picture.
4. "reset": Rest all the points and front ground you choose.
5. "START": Once the selection is complete, start the reconstruction.

After completion of the 3-dimensions reconstruction:
6. up, down, left and right keys to control the perspective of the 3d image.
7. q, a, w, s, e, d, r, f to adjust the position of the coordinate system. 
8. k, o, l, p to remove or restore occluded layers.
Using the camera toolbar can also help to adjust the field of view.

*************Fault-tolerant design*********

If the selection of a point is incorrect, that point can be removed by clicking on it. 

After starting the program, if no picture is chosen, a warning will be given, and later picture can still be chosen by clicking "change a picture"
After clicking the button "change a picture". If no picture is chosen, then the old picture remains.
A warning will turn up, if the selection of point or foreground is outside the picture.
Only 5 points can be chosen, if less than 5 points were chosen and the button "START" is clicked, a warning shows up.
After 5 points were chosen, the button "add a point" is non-operable.
Only 1 foreground can be chosen, if the button "foreground" is clicked, when there is a chosen foreground in the image, a warning shows up.

Points' positions are flexible, and the program will automatically build the spidery mesh.

******************************************

