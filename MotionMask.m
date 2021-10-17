%%---------------------------step4 generate the motion mask-------------------------------------------------------%%
load IIB2; % result of foreground detection
load lc; % result of superpixel segmentation
load test_t;
load TestFileName;
load maskim_dbscan;

[w,h]=size(IIB2); % 240x320
MASK2=zeros(w,h,'single');

%Compute the number of foreground pixels from result by CPB
ForegroundPixelNumber=0;
ForegroundPixelInformation = zeros(w,h,3);
for x=1:w
    for y=1:h
        if  IIB2(x,y)~=0
            ForegroundPixelNumber=ForegroundPixelNumber+1;          
        end
    end
end


%Record the position of foreground pxiels
p1=zeros(1,ForegroundPixelNumber);
p2=zeros(1,ForegroundPixelNumber);
n=1;
for x=1:w
    for y=1:h
        if IIB2(x,y)~=0
            p1(n)=x;
            p2(n)=y;
            n=n+1;
        end
    end
end

%Compute the value of superpixels resuls in these foreground pixels
p3=zeros(1,ForegroundPixelNumber);

for j=1:ForegroundPixelNumber
    p3(j)=lc(p1(j),p2(j));
end


%Remove redundancy and take out non-repeating elements
p4=unique(p3);

[n1,m1]=size(p4);

%-----------------------------------------------------
% calculate how many pixels are foreground pixels in each cluster
countF=tabulate(p3);

delateindex=find(countF(:,2)==0);
countF(delateindex,:)=[];

%Calculate how many pixels are in each cluster of the segmemtation image
countBMP=tabulate(lc(:));

% calculate the proportion of each foreground pixel cluster in the BMP
[n2,m2]=size(countF);
[n3,m3]=size(countBMP);
percentage=zeros(n2,2);
percentage(:,1)=countF(:,1);
for j2=1:n2
    for j3=1:n3
        if(countF(j2,1)==countBMP(j3,1))
            percentage(j2,2)=countF(j2,2)/countBMP(j3,2);
        end
    end
end

%Mask the motion in background and save result
for j1=1:m1
    for x1=1:w
        for y1=1:h
            if IIB2(x1,y1)~=0 %|| maskim_dbscan(x1,y1)==1
                MASK2(x1,y1)=1;
            end
            if lc(x1,y1)==p4(j1) && percentage(j1,2)>0.3
                MASK2(x1,y1)=1;
            end%if
        end%for
    end%for
end%for

% morphological operation
se2=strel('square',3);
MASK2=imerode(MASK2,se2);
se1=strel('square',5);     
MASK2=imdilate(MASK2,se1);

save MASK2 MASK2
s=strcat('./subpre/',TestFileName(test_t).name,'mask.bmp');
imwrite(MASK2,s);

subplot(1,2,1); imshow(IIB2);title('foregroud detection')
subplot(1,2,2); imshow(MASK2);title('mask result')
