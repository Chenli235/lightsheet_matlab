function image = grap_oneimage(mmc)

mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);


numOfImages = 100000;
intervalMs = 0;
stopOnOverflow = false;

mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
checkBuffer = mmc.getRemainingImageCount();
pause(0.2);
if checkBuffer==0
    pause(0.2);
end
image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
width = mmc.getImageWidth();
height = mmc.getImageHeight();
pixelType = 'uint16';
image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
image = reshape(image, [width, height]); % image should be interpreted as a 2D array
image = rot90(image);
image = image(:,end:-1:1);
%imwrite(image,["test_images/Rollingshutter_" + ".tiff"]);
mmc.stopSequenceAcquisition;
end