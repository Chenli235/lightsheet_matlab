%% change delay time
mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);

mmc.setProperty('HamamatsuHam_DCAM','SENSOR MODE','PROGRESSIVE'); %AREA
mmc.setProperty('HamamatsuHam_DCAM','READOUT DIRECTION', 'BACKWARD'); %    BACKWARD
mmc.setProperty('HamamatsuHam_DCAM', 'TRIGGER SOURCE', 'EXTERNAL'); %  INTERNAL
mmc.setProperty('HamamatsuHam_DCAM', 'TriggerPolarity', 'POSITIVE');
numOfImages = 100000;
intervalMs = 0;
stopOnOverflow = false;
% set the afg scan
Max_voltage = 1235;
Min_voltage = -680;
offset = 350;
SetAfgRamp(afg,Min_voltage,Max_voltage,4,50,1);
%fwrite(afg, [':source1:voltage:offset ',num2str(offset),'mv']);
fwrite(afg, ':output1 on;');
lines_covered = 20;
%mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL', 0.01);
internalLineInterval = mmc.getProperty('HamamatsuHam_DCAM','INTERNAL LINE INTERVAL');

exposureTime = lines_covered * str2num(internalLineInterval);
mmc.setProperty('HamamatsuHam_DCAM', 'Exposure', exposureTime);
mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',2048*6.5*10^-6/(1/4/2)); % 0.6656 (25 hz)
mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',(1/4/4));
%mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);

lineSpeed = 6.5*10^-6/(str2num(internalLineInterval)*10^-3);
time = 2048*6.5*10^-6/lineSpeed;
freq = 1/(2*time);
delay = 1/4/4;
delay_vector = delay + [-0.005:0.0001:0.005];
% best dalay time is 0.0122
mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
for i = 1:length(delay_vector)
    disp(i);
    
    mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delay_vector(i));
    %mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
    checkBuffer = mmc.getRemainingImageCount();
    pause(0.2);
    if checkBuffer==0
        pause(0.25);
    end
    image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
    width = mmc.getImageWidth();
    height = mmc.getImageHeight();
    pixelType = 'uint16';
    image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
    image = reshape(image, [width, height]); % image should be interpreted as a 2D array
    image = rot90(image);
    image = image(:,end:-1:1);
    imwrite(image,["test_images/DelayTime_" + num2str(i) + ".tiff"]);
    %mmc.stopSequenceAcquisition;
end

checkBuffer = mmc.getRemainingImageCount();
if checkBuffer==0
    pause(2);
end

% image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
% width = mmc.getImageWidth();
% height = mmc.getImageHeight();
% pixelType = 'uint16';
% image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
% image = reshape(image, [width, height]); % image should be interpreted as a 2D array
% image = rot90(image);
% image = image(:,end:-1:1);
% imwrite(image,'testrollingshutter.tiff');


%mmc.stopSequenceAcquisition;
disp('done.')

%% change line speed
mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);

mmc.setProperty('HamamatsuHam_DCAM','SENSOR MODE','PROGRESSIVE'); %AREA
mmc.setProperty('HamamatsuHam_DCAM','READOUT DIRECTION', 'BACKWARD'); %    BACKWARD
mmc.setProperty('HamamatsuHam_DCAM', 'TRIGGER SOURCE', 'EXTERNAL'); %  INTERNAL
mmc.setProperty('HamamatsuHam_DCAM', 'TriggerPolarity', 'POSITIVE');
numOfImages = 100000;
intervalMs = 0;
stopOnOverflow = false;
% set the afg scan
Max_voltage = 1239;
Min_voltage = -706;
offset = 350;
SetAfgRamp(afg,Min_voltage,Max_voltage,4,50,1);
%fwrite(afg, [':source1:voltage:offset ',num2str(offset),'mv']);
fwrite(afg, ':output1 on;');
lines_covered = 13;
%mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL', 0.01);
internalLineInterval = mmc.getProperty('HamamatsuHam_DCAM','INTERNAL LINE INTERVAL');
exposureTime = lines_covered * str2num(internalLineInterval);
mmc.setProperty('HamamatsuHam_DCAM', 'Exposure', exposureTime);
delay = 1/4/4;
delay_vector = delay + [-0.005:0.0001:0.005];
mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delay_vector(27));

lineSpeed = 2048*6.5*10^-6/0.125;
lineSpeedVector = lineSpeed + [-0.005:0.0001:0.005];
mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',2048*6.5*10^-6/0.125); % 0.6656 (25 hz)
%% best line speed 0.1072s
for i = 1:length(lineSpeedVector)
    mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',lineSpeedVector(i));
    mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
    checkBuffer = mmc.getRemainingImageCount();
    pause(0.25);
    if checkBuffer==0
        pause(0.25);
    end
    image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
    width = mmc.getImageWidth();
    height = mmc.getImageHeight();
    pixelType = 'uint16';
    image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
    image = reshape(image, [width, height]); % image should be interpreted as a 2D array
    image = rot90(image);
    image = image(:,end:-1:1);
    imwrite(image,["test_images_linespeed/lineSpeed_" + num2str(i) + ".tiff"]);
    mmc.stopSequenceAcquisition;
    
end

checkBuffer = mmc.getRemainingImageCount();
if checkBuffer==0
    pause(2);
end
disp('done.');
%%
% go back to normal readout mode
mmc.setProperty('HamamatsuHam_DCAM','SENSOR MODE','AREA'); 
mmc.setProperty('HamamatsuHam_DCAM','READOUT DIRECTION', 'DIVERGE');
mmc.setProperty('HamamatsuHam_DCAM', 'TRIGGER SOURCE', 'INTERNAL'); %  
mmc.setProperty('HamamatsuHam_DCAM', 'Exposure', 10);
disp('done.')


%% get one image
mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);

mmc.setProperty('HamamatsuHam_DCAM','SENSOR MODE','PROGRESSIVE'); %AREA
mmc.setProperty('HamamatsuHam_DCAM','READOUT DIRECTION', 'BACKWARD'); %    BACKWARD
mmc.setProperty('HamamatsuHam_DCAM', 'TRIGGER SOURCE', 'EXTERNAL'); %  INTERNAL
mmc.setProperty('HamamatsuHam_DCAM', 'TriggerPolarity', 'POSITIVE');
numOfImages = 100000;
intervalMs = 0;
stopOnOverflow = false;
% set the afg scan
Max_voltage = 1239;
Min_voltage = -706;
offset = 350;
SetAfgRamp(afg,Min_voltage,Max_voltage,10,50,1);
%fwrite(afg, [':source1:voltage:offset ',num2str(offset),'mv']);
fwrite(afg, ':output1 on;');
lines_covered = 10;
%mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL', 0.01);
internalLineInterval = mmc.getProperty('HamamatsuHam_DCAM','INTERNAL LINE INTERVAL');

exposureTime = lines_covered * str2num(internalLineInterval);
mmc.setProperty('HamamatsuHam_DCAM', 'Exposure', exposureTime);
mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',2048*6.5*10^-6/0.05); % 0.6656 (25 hz) 0.05(10hz)
mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',1/20/4);
%mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);

lineSpeed = 6.5*10^-6/(str2num(internalLineInterval)*10^-3);
time = 2048*6.5*10^-6/lineSpeed;
freq = 1/(2*time);
delay = 0.0122;

mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delay);
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
imwrite(image,["test_images/Rollingshutter_" + ".tiff"]);
mmc.stopSequenceAcquisition;
disp('done')


%% test angle with light-sheet mode
% set light-sheet ramp function first

mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);

Top_mV = 1235;
Bot_mV = -680;
mid = round((Top_mV + Bot_mV)/2);
frequency = 4;
SetAfgRamp(afg,Bot_mV,Top_mV,frequency,50,1);
fwrite(afg, ':output1 on;');
numOfImages = 100000;
intervalMs = 0;
stopOnOverflow = false;

% set light-sheet mode of camear

lines_covered = 20;
%interval = ((1/frequency/2)/2048)*10^3;
delayTime = 1/frequency/4;%0.05
mmc.setProperty('HamamatsuHam_DCAM','SENSOR MODE','PROGRESSIVE'); %AREA
mmc.setProperty('HamamatsuHam_DCAM','READOUT DIRECTION', 'BACKWARD'); %    BACKWARD
%mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL',(1/frequency/2)/2048*10^3);
frequency1 = frequency;
mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',2048*6.5*10^-6/(1/frequency1/2));
interval = mmc.getProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL');
interval = str2num(interval);
mmc.setProperty('HamamatsuHam_DCAM', 'Exposure',lines_covered*interval);
mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delayTime);


mmc.setProperty('HamamatsuHam_DCAM', 'TRIGGER SOURCE', 'EXTERNAL'); %  INTERNAL
mmc.setProperty('HamamatsuHam_DCAM', 'TriggerPolarity', 'POSITIVE');


%mmc.getProperty('HamamatsuHam_DCAM', 'INTERNAL LINE INTERVAL');
% Property = mmc.getDevicePropertyNames('HamamatsuHam_DCAM');
% for i = 1:Property.size()-1
%     disp(Property.get(i));
% end    
% grap an image
mmc.stopSequenceAcquisition;
mmc.clearCircularBuffer;
mmc.setCircularBufferMemoryFootprint(1024*10);
%mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
pause(0.5);
checkBuffer = mmc.getRemainingImageCount();
if checkBuffer==0
    pause(2);
end
pause(1)
speedVec = 0.1055 + [-0.001:0.0002:0.001];
%mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',0.27024);
%mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',0.0247);
delayVec = 0.061 + [-0.001:0.0002:0.00];
%delayVec = [0.024:0.0001:0.025]
% mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',0.0125);
% mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',0.26624);
% mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
%         checkBuffer = mmc.getRemainingImageCount();
%         pause(2);
%         if checkBuffer==0
%             pause(0.5);
%         end
% image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
% width = mmc.getImageWidth();
% height = mmc.getImageHeight();
% pixelType = 'uint16';
% image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
% image = reshape(image, [width, height]); % image should be interpreted as a 2D array
% image = rot90(image);
% image = image(:,end:-1:1);
% imwrite(image,["test_images_1/Rollingshutter_"+".tiff"]);
%         

for i = 1:length(delayVec)
    for j = 1:length(speedVec)
        
        mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delayVec(i));
        mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',speedVec(j));
        mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
        checkBuffer = mmc.getRemainingImageCount();
        pause(1.0);
        if checkBuffer==0
            pause(0.5);
        end
        image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
        width = mmc.getImageWidth();
        height = mmc.getImageHeight();
        pixelType = 'uint16';
        image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
        image = reshape(image, [width, height]); % image should be interpreted as a 2D array
        image = rot90(image);
        image = image(:,end:-1:1);
        imwrite(image,["test_images/Rollingshutter_DELAY_" + num2str(delayVec(i)) + '_SPEED_' + num2str(speedVec(j)) + ".tiff"]);
        mmc.stopSequenceAcquisition;
    end
end
mmc.stopSequenceAcquisition;
   
    
for i = 1:length(speedVec)
    disp(i);
    %mmc.setProperty('HamamatsuHam_DCAM','TRIGGER DELAY',delayVec(i));
    mmc.setProperty('HamamatsuHam_DCAM', 'INTERNAL LINE SPEED',speedVec(i));
    mmc.startSequenceAcquisition(numOfImages, intervalMs, stopOnOverflow);
    checkBuffer = mmc.getRemainingImageCount();
    pause(0.2);
    if checkBuffer==0
        pause(0.5);
    end
    image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
    width = mmc.getImageWidth();
    height = mmc.getImageHeight();
    pixelType = 'uint16';
    image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
    image = reshape(image, [width, height]); % image should be interpreted as a 2D array
    image = rot90(image);
    image = image(:,end:-1:1);
    imwrite(image,["delay_10hz/Rollingshutter_Brain_" + num2str(i) + ".tiff"]);
    mmc.stopSequenceAcquisition;
end
% image = mmc.getLastImage();  % returned as a 1D array of signed integers in row-major order
% width = mmc.getImageWidth();
% height = mmc.getImageHeight();
% pixelType = 'uint16';
% image = typecast(image, pixelType);      % pixels must be interpreted as unsigned integers
% image = reshape(image, [width, height]); % image should be interpreted as a 2D array
% image = rot90(image);
% image = image(:,end:-1:1);
% imwrite(image,["test_images/Rollingshutter_Brain" + ".tiff"]);
%mmc.stopSequenceAcquisition;


% -0.40, -0.35,-0.30,-0.25, -0.2, -0.15, -0.1,-0.05 
%
%% good parameters delay:   speed: 
%                         0.0241         0.261
%                         0.0242         0.261
%                         0.0246         0.267                                   
%                         0.02465        0.267
% 4 hz good parameters
% delay: 0.0615 speed: 0.1055
%        0.0605        0.1055
%        0.0608        0.1053 
%        0.061         0.1053
%%
top = 1235;
bot = -680;
%SetAfgRamp(afg,bot,top,4,50,1);
fwrite(afg, ':source1:function DC');
fwrite(afg, [':source1:voltage:offset ',num2str(278),'mv']);
fwrite(afg, ':output1 on;');




