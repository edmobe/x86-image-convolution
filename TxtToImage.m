function txtToImage(imageWidth, imageHeight)
  disp("Transforming binary .txt files to images and saving them in OutputImages folder...");
  size = imageWidth * imageHeight;
  % Original
  fid = fopen('input.txt', 'r', 'ieee-le');
  inputOriginal = fread(fid);
  originalSize = (imageWidth + 2) * (imageHeight + 2);
  inputOriginal = inputOriginal(1:originalSize);
  originalImage = reshape(inputOriginal, [], imageHeight + 2)';
  outputOriginal = originalImage(2:imageHeight+1, 2:imageWidth+1);
  outputOriginal = uint8(outputOriginal);
  imwrite(outputOriginal, "OutputImages/input.jpg");
  fclose(fid);
  % Sharpened
  fid = fopen('normSharpened.txt', 'r', 'ieee-le');
  inputNormSharpened = fread(fid);
  inputNormSharpened = inputNormSharpened(1:size);
  normSharpenedImage = reshape(inputNormSharpened, [], imageHeight)';
  outputNormSharpened = uint8(normSharpenedImage);
  imwrite(outputNormSharpened, "OutputImages/normSharpened.jpg");
  fclose(fid);
  % Oversharpened
  fid = fopen('overSharpened.txt', 'r', 'ieee-le');
  inputOverSharpened = fread(fid);
  inputOverSharpened = inputOverSharpened(1:size);
  overSharpenedImage = reshape(inputOverSharpened, [], imageHeight)';
  outputOverSharpened = uint8(overSharpenedImage);
  imwrite(outputOverSharpened, "OutputImages/overSharpened.jpg");
  fclose(fid);
  disp("Images saved in OutputImages folder!");
 endfunction