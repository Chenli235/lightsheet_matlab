s1 = daq.createSession('mcc');

galvoX1 = addAnalogOutputChannel(s1,'Board1', 'Ao1', 'Voltage');
galvoY1= addAnalogOutputChannel(s1,'Board1', 'Ao3', 'Voltage');
% data0 = linspace(-2,2,5000)';
% data1 = linspace(-2,2,5000)';
% queueOutputData(s,[data0 data1]);
% startBackground(s);
outputSingleScan(s1,[0.03,0])% set galvo x and y zero
release(s1);
clear s1;
clear galvoX1;
clear galvoY1;

images_file = dir('*.tiff');
len=length(images_file);
resolution = [];
for i=1:len
    i
%     oldname = images_file(i).name;
%     newname = [oldname(1:3),'8',oldname(5:end)];
%     command = ['rename' 32 oldname 32 newname];
%     status = dos(command);
    D = dir(images_file(i).name);
    if D.bytes/1000 > 500
        quality = brisque(imread(images_file(i).name));
        resolution = [resolution,quality];
    end
end
plot(resolution)
original_img = imread('beam.tiff');
new_img = original_img(750:1200,:);
imshow(new_img,[0,2500]);
x=[1024,1024];y=[125,325];
line(x,y,'linewidth',6);

x=[1024-153*6,1024-153*6];y=[125,325];
line(x,y,'linewidth',6);
x=[1024+153*6,1024+153*6];y=[125,325];
line(x,y,'linewidth',6);

x=[1024-153*4,1024-153*4];y=[125,325];
line(x,y,'linewidth',6);
x=[1024+153*4,1024+153*4];y=[125,325];
line(x,y,'linewidth',6);

x=[1024-153*2,1024-153*2];y=[125,325];
line(x,y,'linewidth',6);
x=[1024+153*2,1024+153*2];y=[125,325];
line(x,y,'linewidth',6);

x=[1024-153*2,1024-153*2];y=[125,325];
line(x,y,'linewidth',6);
x=[1024+153*2,1024+153*2];y=[125,325];
line(x,y,'linewidth',6);



% beam width 13, 17, 19,28
%x=[-600,-400,-200,0,200,400,600];
%x = ['-600um','-400um','-200um','0um','200um','400um','600um']
x = categorical({'-600um','-400um','-200um','0um','200um','400um','600um'});
x = reordercats(x,{'-600um','-400um','-200um','0um','200um','400um','600um'});
y=[34.5272,20.29166,11.0824,7.388,9.1904,16.399,25.424296];
bar(x,y,0.5);ylabel('FWHM(um)');ylim([5,40]);
for i=-5:1:5
    x=1:361;
    y=double(new_img(:,1024+i*153))';
    f=fit(x',y','gauss1');
    width = [width,f.c1/sqrt(2)*2.355*1.7*0.65];
end

for pos=-0.05:0.01:0.05
    pos
end

fprintf(controlParameters.sDetLens,'1TP?');pos = fscanf(controlParameters.sDetLens);
pos=getpos(pos)

fprintf(controlParameters.sDetLens,['1PA','0']);



if 3<2 || 3>5
    disp('right');
end

[x,z] = meshgrid(-5:0.01:5);
y=0*ones(1001);
y1 = -0.2*z;
mesh(x,y,z);hold on;mesh(x,y1,z);
xlim([-5,5]);ylim([-5,5]);


img = imread('img_-0.05.tiff');
img2 = mat2cell(img,[1024 1024],[1024 1024]);
Sx = fspecial('sobel');
measure = [];
for i=1:2
    for j=1:2
        Gx = imfilter(double(cell2mat(img2(i,j))),Sx,'replicate','conv');
        Gy = imfilter(double(cell2mat(img2(i,j))),Sx,'replicate','conv');
        G = Gx.^2 + Gy.^2;
        measure = [measure,std2(G)^2/1024/1024];
    end
end
round(measure)
bar3(measure)
zlim([0,2.2e8]);

imscore = [];
for i=1:61
    img = imread(['img',num2str(i),'.tiff']);
    Gx = imfilter(double(img),Sx,'replicate','conv');
    Gy = imfilter(double(img),Sx,'replicate','conv');
    G = Gx.^2 + Gy.^2;
    imscore = [imscore,std2(G)^2/2048/2048];
end
x=[-0.06:0.002:0.06];
plot(x,imscore);



