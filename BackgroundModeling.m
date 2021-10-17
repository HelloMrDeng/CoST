%%----------------------------step1 Background Modeling-------------------------------------%%
clear all
clc
close all
TrainPath ='I:\program\matlab\traning_data\SBMnet_dataset\basic\PETS2006\input_section\';
FileName = dir('I:\program\matlab\traning_data\SBMnet_dataset\basic\PETS2006\input_section\*.jpg'); % load the training frames

TrainNumber=87; %the number of training frames

img_w=240; % soure image width
img_h=320; % soure image height

refnum=20; % set the number of correlation blocks for each pixel sequence

DBr=zeros(img_w,img_h,TrainNumber,'single'); % pre-allocate the space and used for storing the data
DBLKr=zeros(img_w/8,img_h/8,refnum,4,'single');


DBg=zeros(img_w,img_h,TrainNumber,'single');%
DBLKg=zeros(img_w/8,img_h/8,refnum,4,'single');


DBb=zeros(img_w,img_h,TrainNumber,'single');%
DBLKb=zeros(img_w/8,img_h/8,refnum,4,'single');


for t=1:TrainNumber
    img=imread([TrainPath,FileName(t).name]);
    II=imresize(img,[img_w img_h]);
    DBr(:,:,t)=II(:,:,1); % separate the information in RGB channel    
    DBg(:,:,t)=II(:,:,2);   
    DBb(:,:,t)=II(:,:,3);
    
end

tic
[DBLKr,GammaSumr]=trainncc2(DBr,refnum);
toc;
[DBLKg,GammaSumg]=trainncc2(DBg,refnum);
[DBLKb,GammaSumb]=trainncc2(DBb,refnum);%ÑµÁ·


save DBLKr DBLKr
save DBLKg DBLKg
save DBLKb DBLKb
save GammaSumr GammaSumr
save GammaSumg GammaSumg
save GammaSumb GammaSumb

save img_w img_w
save img_h img_h


