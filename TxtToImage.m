clear;
width = 960;
height = 1280;
size = width * height;
% Image 1
fid = fopen("normSharpened.txt", 'r', 'ieee-le');
inputNormSharpened = fread(fid);
inputNormSharpened = inputNormSharpened(1:size);
normSharpenedImage = reshape(inputNormSharpened, [], height)';
outputNormSharpened = uint8(normSharpenedImage);
imwrite(outputNormSharpened, "normSharpened.jpg");
fclose(fid);
% Image 2
fid = fopen("overSharpened.txt", 'r', 'ieee-le');
inputOverSharpened = fread(fid);
inputOverSharpened = inputOverSharpened(1:size);
overSharpenedImage = reshape(inputOverSharpened, [], height)';
outputOverSharpened = uint8(overSharpenedImage);
imwrite(outputOverSharpened, "overSharpened.jpg");
fclose(fid);