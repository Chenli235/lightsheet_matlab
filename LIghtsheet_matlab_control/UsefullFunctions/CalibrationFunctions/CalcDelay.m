%This function changes the delay between the trigger signal of the camera
%and the galvo. While changing the delay it evaluates the resulting image
%accordingly it provide the optimal delay time
%inputs:
%mmc - the java structure for controlling mmc
%afg - the function generator
%verticalP - the vertical point of the image that will be evaluated
%horizontalP - the vertical point of the image that will be evaluated
%rangeMs - the radius of the delay in ms that will be tested
%stepSizeMs - the scan resolution in MS
%windowSize - the radius of the square around the specified point that will
%be used for evaluation
%methodOfQuality - how to evaluate the image quality, 1 for peak power, 2
%for mean value
%averageNumber - how many images to evaluate in order to reduce the noise
%showFigure - true to show the figures or false to show only the end
%results
%OutputsL
%optimalDelay - returns the optimal delay that should be used 

function [optimalDelay] = CalcDelay(mmc, afg, verticalP, horizontalP, rangeMs, stepSizeMs, windowSize, methodOfQuality, averageNumber, showFigure)
    
    %Parameters:
    pixelType = 'uint16';
    width = 2048;
    height = 2048;
    %Num of sequence images to acquire
    numOfImages = 100000;
    intervalMs = 0;
    stopOnOverflow = false;

    %In order to grab imaes the camera has to start acquiring a sequence    
    mmc.setCircularBufferMemoryFootprint(1024*2);
    %Set the shutter off
    mmc.setAutoShutter(false);    
    %Clear any images from the circular buffer and prep the camera
    mmc.clearCircularBuffer;    
    
    %open the shutter and start acquiring images
    mmc.setShutterOpen(false);
    mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
    pause(0.2);    
    
    %Get the current delay value
    val = query(afg, ':source2:pulse:delay?');
    display(['Delay is currently to ',val,'sec']);
    currentDelayMs = str2num(val)*1000; %delay in ms
    
    %The delay vector
    delayVector = currentDelayMs + (-rangeMs:stepSizeMs:rangeMs);
    
    %The window to check for the delay
    vVec = verticalP + (-windowSize:windowSize);
    hVec = horizontalP + (-windowSize:windowSize);
    
    %Define the preformance vector
    evalVector = zeros(1,size(delayVector,2));
    
    %Make the delay long enough to capture a new image and change the delay
%     actualFrameRate = mmc.getProperty(cameraLabel, 'FrameRate');
%     actualFrameRate = str2num(actualFrameRate);
    
    %Go over the delay vector and estimate the image quality
    for ii = 1:size(delayVector,2)
        
        %Prep the average image
        imageAve = zeros(height, width);
        
        %Change the delay
        fwrite(afg, [':source2:pulse:delay ',num2str(delayVector(ii)),'ms']);
        val = query(afg, ':source2:pulse:delay?');
        display(['Delay is currently to ',val,'sec']);
        
        %Average the images
        for jj = 1:averageNumber
               mmc.setShutterOpen(true);
               pause(0.25);               
               img = mmc.getLastImage();
               img = typecast(img, pixelType);      % pixels must be interpreted as unsigned integers
               img = reshape(img, [width, height]); % image should be interpreted as a 2D array
               img = transpose(img);                % make column-major order for MATLAB
               mmc.setShutterOpen(false);
               imageAve = imageAve + double(img)/averageNumber;     
               
        end
        
        %Evaluate the images
        cutImage = imageAve(vVec, hVec);
        if (showFigure)
            figure; imshow(cutImage,[]); title(['The delay is ',(val),'sec']);
        end
        
        %How to evaluate the image quality 
        if (methodOfQuality == 2)
            evalVector(ii) = mean2(cutImage);
        else
            evalVector(ii) = max(cutImage(:));
        end            
        
    end
    
    %Stop the sequence after all images were acquired
    mmc.stopSequenceAcquisition
    mmc.clearCircularBuffer;    
    
    %Find and show the best parameters
    maxVal = max(evalVector);
    k = (evalVector == maxVal);    
    display(['Best delay value = ',num2str(delayVector(k)) ,' ms']);
        
    %Set the best delay
    fwrite(afg, [':source2:pulse:delay ',num2str(delayVector(k)),'ms']);
    val = query(afg, ':source2:pulse:delay?');
    display(['Delay is currently to ',val,'sec']);
    
    figure; plot(delayVector,evalVector); title('Delay ms vs. eval matrix');    
    optimalDelay = delayVector(k);
    
    %Return the shutter to its default state
    mmc.setShutterOpen(false);
    mmc.setAutoShutter(true); 
        
end

