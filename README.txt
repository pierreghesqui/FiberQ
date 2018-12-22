FIBERQ : Open-source algorithm for automatic quantification of DNA fibers
-------------------------------------------------------------------------
PLEASE CITE THE FOLLOWING ARTICLE IF YOU USE THIS SOFTWARE :
TODO...

In this file, you will find a description of the software FiberQ for the 
quantification of DNA fiber length. 
This is the matlab implementation of the algorithm described in detail in the paper : 

TODO: REFERENCE OF THE PAPER

There are two ways to use FiberQ :

--> If you don't have any programming experience, you can use a free compiled version of the code availaible here (This version works only on windows) : http://biophotonics.ca/fibers/. 

--> If you have matlab R2018a (or later), you can use the source code. You will need the following toolboxes : 
- Image Processing Toolbox
- Statistics and Machine Mearning Toolbox
- Curve Fitting Toolbox
- Computer Vision System Toolbox

1) Open Matlab and change the default directory to '\FiberQ'.
2) Click on "main_FiberQ.mlapp"
3) Click on "help" and follow the instructions

RESULTS : 
---------
Once the algorithm processed your images, the "Results" folder inside the folder containing the processed images contains the results. 
In the "Results" Folder, there should be two excel files containing the ratios (second/first pulse length) of each segmented fiber. 
	- FolderBicolor.xls: contain the results for Bicolor fibers. (length are given in pixels)
	- FolderResults.xls: contain the results for all segmented fibers
You will also find a subfolder per processed image :
	-imBox.png shows bounding box surrounding segmented fibers
	-Segm_Label.png highlights segmented fibers. The number written in white corresponds the Fiber_Label in the excel files
	-Segm_ratio.png highlights segmented fibers. Each bicolor fiber is assigned with their ratios (second/first pulse length)
	-highDensityArea.png highlights the area where fiber density is too high. Fibers in those zones are not analysed