rng('shuffle');
nmmodes=2;
x=input('Image Number');

mkdir(['all']);
mkdir(['a']);
mkdir(['b']);
mkdir(['c']);
mkdir(['d']);
mkdir(['e']);
mkdir(['f']);
mkdir(['ref']);

ImageFolder =['\',sprintf('%d',x),'\'];
load('final_zernike_avg.mat')
base=zeros(1,68);
base(1:length(nwbias3))=nwbias3;
%base(3)=0
clear nwbias3
r=1;
for i=-0.3:0.05:0.3
    for j=-0.3:0.05:0.3
        nwbias3(r,1)=i;
        nwbias3(r,2)=j;
        r=r+1;
    end
end

save([sprintf('%d_final_zernike.mat',x)],'nwbias3')
mirrorSN = 'BAX362';
dm = asdkDM( mirrorSN );
mirrorSN = 'BAX362';
Z2C = importdata( [mirrorSN '-Z2C.mat'] );
nZern = size(Z2C, 1);
zernikeVector = zeros( 1, nZern );
zernikeVector=zernikeVector+base;
dm.Send( zernikeVector * Z2C );
results = grap_oneimage(mmc);
imwrite(results,['ref\',sprintf('ref_%d.tiff',x)]);
for mm=1:length(nwbias3)
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_a.tiff',mm,x)]);
    imwrite(results,['a\',sprintf('%d_img_abr_c1_%d_c2_%d_a.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
    
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector(3)=0.25;
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_b.tiff',mm,x)]);
    imwrite(results,['b\',sprintf('%d_img_abr_c1_%d_c2_%d_b.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
    
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector(3)=0.25;
    zernikeVector(4)=zernikeVector(4)+0.25;
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_c.tiff',mm,x)]);
    imwrite(results,['c\',sprintf('%d_img_abr_c1_%d_c2_%d_c.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
    
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector(3)=0.25;
    zernikeVector(4)=zernikeVector(4)+0.25;
    zernikeVector(10)=zernikeVector(10)+0.25;
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_d.tiff',mm,x)]);
    imwrite(results,['d\',sprintf('%d_img_abr_c1_%d_c2_%d_d.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
    
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector(3)=0.25;
    zernikeVector(4)=zernikeVector(4)+0.25;
    zernikeVector(10)=zernikeVector(10)+0.25;
    zernikeVector(6)=zernikeVector(6)+0.25;
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_e.tiff',mm,x)]);
    imwrite(results,['e\',sprintf('%d_img_abr_c1_%d_c2_%d_e.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
    
    zernikeVector = zeros( 1, nZern );
    zernikeVector(4:4+nmmodes-1)=nwbias3(mm,:);
    zernikeVector(3)=0.25;
    zernikeVector(4)=zernikeVector(4)+0.25;
    zernikeVector(10)=zernikeVector(10)+0.25;
    zernikeVector(6)=zernikeVector(6)+0.25;
    zernikeVector(8)=zernikeVector(8)+0.25;
    zernikeVector=zernikeVector+base;
    dm.Send( zernikeVector * Z2C ); % Send command to mirror
    disp(zernikeVector);
    results = grap_oneimage(mmc); % get the modified image
    %imwrite(mat2gray(results),sprintf('2_md_%d_stp_%d.tiff',md,k));
    imwrite(results,['all\',sprintf('img_%d_abr_%d_f.tiff',mm,x)]);
    imwrite(results,['f\',sprintf('%d_img_abr_c1_%d_c2_%d_f.tiff',x,nwbias3(mm,1),nwbias3(mm,2))]);
end



