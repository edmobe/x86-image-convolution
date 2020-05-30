clear;
disp("=====================================================================");
[imageWidth, imageHeight] = source("imageToTxt.m");
disp("=====================================================================");
disp("Calling assembly program...")
system('Debug\Project.exe');
disp("=====================================================================");
txtToImage(imageWidth, imageHeight);
disp("=====================================================================");
input("Press any key to continue...");
system("explorer OutputImages");
exit();