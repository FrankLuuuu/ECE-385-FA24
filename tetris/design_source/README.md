# ECE385 Final Project: Tetris
Frank Lu (yuzhelu2), Kathryn Thompson (kyt3)

Below I will entail the steps required in order to run our implementation of Tetris.

1. Download the .zip file.
2. Unzip the folder once downloaded.
3. Create a project in Vivado for the game. 
4. Import the sources and constraint files from their respective directories.
5. Click Run Synthesis to synthesize the project.
6. Click Run Implementation. 
7. Click Generate Bitstream.
8. Once this is completed, you will be able to export the bitstream. To do this, click on File in the top left corner, then click Export Hardware. 
9. Keep clicking Next, when prompted, enter a unique name you would like the code to be exported as. 
10. Open Vitis. 
11. In the bottom left corner, right click on mb_usb_hdmi_top and select Update hardware. The file should be the same name as the one from Step 9. 
12. Verify this worked in the top left panel. 
13. Build the project by clicking CTRL + B. 
14. Click the Down arrow next to the Green Play button in Vitis. 
15. Select Run as configuration. 
16. Under the Target tab, confirm that the correct bit stream file is selected. If it the file does not appear, double click on the ```Single Application Debug (GDB)```
17.