%%-----------------------------for foreground detecting--------------------------%% 

clear all
clc
load DBLKr % Background model in RGB channel
load DBLKg 
load DBLKb 
load img_w % soure image width
load img_h % soure image height
load GammaSumr % Gamma in RGB channel
load GammaSumg 
load GammaSumb 


af=2.5;% threshold (C)for Gaussian model

TestPath='I:\program\matlab\traning_data\SBMnet_dataset\basic\PETS2006\input\'; %load the testing frames
TestFileName = dir('I:\program\matlab\traning_data\SBMnet_dataset\basic\PETS2006\input\*.jpg');

test_t=20; %testing frame
imgt=imread([TestPath,TestFileName(test_t).name]);
IItest=imresize(imgt,[img_w img_h]);

IIr=double(IItest(:,:,1)); % three-channel segmentation
IIg=double(IItest(:,:,2)); 
IIb=double(IItest(:,:,3)); 

tic
[IIBr,re_blockr]=subncc1(IIr,DBLKr,af,GammaSumr); %the result of foreground detection in RGB channel
toc
[IIBg,re_blockg]=subncc1(IIg,DBLKg,af,GammaSumg);
[IIBb,re_blockb]=subncc1(IIb,DBLKb,af,GammaSumb);
IIB=IIBr+IIBg+IIBb;

IIB2=medfilt2(IIB,[3,3]);% Median filter
figure;
imshow(IIB2);

TestFileNamestr=num2str(test_t);
s=strcat('./subpre/',TestFileNamestr,'detection.bmp'); % save the result
imwrite(IIB2,s);

save TestFileName TestFileName
save IItest IItest
save IIB2 IIB2
save test_t test_t
save re_blockr re_blockr
save re_blockg re_blockg
save re_blockb re_blockb