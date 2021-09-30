
imgFolder = 'I:\program\matlab\traning_data\SBMnet_dataset\illuminationChanges\Dataset3Camera1\input\'; %指定路径
filename=dir('I:\program\matlab\traning_data\SBMnet_dataset\illuminationChanges\Dataset3Camera1\input\*.jpg');
baseTrainNum=1800;%测试样本范围
idx=baseTrainNum;

img_w=240;% soure image width
img_h=320;% soure image height
DBr=zeros(img_w,img_h,idx,'single');%
imagesequence1=zeros(1,idx);
imagesequence2=zeros(1,idx);
  for t=1:(idx)
      img=imread([imgFolder,filename(t).name]);
      II=imresize(img,[img_w img_h]);
      imagesequence1(t)=II(100,10);
      imagesequence2(t)=II(100,15);
  end

  imagesequence3=zeros(1,800);
   imagesequence4=zeros(1,800);
  for i=1:1:idx
%       if(i==1)
%         imagesequence3(i)=imagesequence1(i);
%         imagesequence4(i)=imagesequence2(i);
%       end
      if(i>1000)
      imagesequence3((i-1000))=imagesequence1(i);
      imagesequence4((i-1000))=imagesequence2(i);
      end
  end
  
y1=imagesequence3;
x1=1001:1:idx;
y2=imagesequence4;
x2=1001:1:idx;
%y=linspace(imagesequence(1),imagesequence(idx),100) ;

plot(x1,y1,x2,y2);
title('');
xlabel('时间序列上八百帧图像');
ylabel('像素点值');
legend('坐标位置为(100,10)','坐标位置为(100,15)');


 
 

     