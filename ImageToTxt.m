function [imageWidth, imageHeight] = imageToTxt()
  message = "Please enter the image name without the extension: ";
  imageName = input(message, 's');
  imageLocation = strcat('inputImages/', imageName, '.jpg');
  message = strcat("Transforming image <", imageLocation, "> to binary .txt file...");
  disp(message);
  IMAGE = imread(imageLocation);
  imageHeight = size(IMAGE)(1);
  imageWidth = size(IMAGE)(2);
  SCALED_IMAGE = zeros(imageHeight + 2, imageWidth + 2);
  SCALED_IMAGE(2:imageHeight+1, 2:imageWidth+1) = IMAGE;
  SCALED_IMAGE = reshape(SCALED_IMAGE.',1,[]);
  SCALED_IMAGE = uint8(SCALED_IMAGE);
  fid = fopen('input.txt', 'w'); 
  fwrite(fid, SCALED_IMAGE, "char", 'ieee-le');
  fclose(fid);
  message = strcat('Image with dimensions <', mat2str(imageWidth), 'x');
  message = strcat(message, mat2str(imageHeight), '> transformed');
  disp(message);
endfunction
