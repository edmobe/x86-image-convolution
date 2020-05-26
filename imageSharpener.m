#! octave-interpreter-name -qf
# a sample Octave program
clear;
disp("=====================================================================");
[imageWidth, imageHeight] = imageToTxt();
disp("=====================================================================");
disp("Calling assembly program...")
system('Debug\Project.exe');
disp("=====================================================================");
txtToImage(imageWidth, imageHeight);
disp("=====================================================================");
input("Press any key to continue...");
system("explorer OutputImages");
exit();