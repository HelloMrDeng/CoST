%%------------------------------------Function for "Martic.m"-----------------------------------------------%%
function [DBLK,GammaSum]=trainncc2(DB,refnum)

[w,h,t]=size(DB);

DBLK=zeros(w,h,refnum,5,'single'); % pre-allocate the space and used for storing the traing results
GammaSum=zeros(w,h,'single'); % Gamma, for each pixel sequence, calculate the sum of the correlation coefficients of its K blocks 

ws=round(w/8); % set supporting block size, in CPB we set block size as 8x8
hs=round(h/8);
wo=ones(1,ws)*8;
ho=ones(1,hs)*8;
DBL=zeros(ws,hs,t,'single');% store the average value of each blocks
ts=mat2cell(DB,wo,ho,t); % split the matrix up to 8 * 8 blocks

for x=1:ws
    for y=1:hs
        flag=median(ts{x,y});
        DBL(x,y,:)=median(flag); % calculate the average value of each blocks
    end
end


for x=1:w
    for y=1:h        
        substd=std(bsxfun(@minus,DBL,DB(x,y,:)),0,3);% for each pixel sequence, calculate the variance between it and the mean of all blocks
        substd(ceil(x/8),ceil(y/8))=10000; % avoiditself
        
        for k=1:refnum 
            [xx,yy]=find(substd==min(substd(:))); % get the bolck Q region which std is small enough
            DBLK(x,y,k,1)=xx(1); % the background model:u
            DBLK(x,y,k,2)=yy(1); % the background model:v
            qv=DBL(DBLK(x,y,k,1),DBLK(x,y,k,2),:);
            pv=DB(x,y,:);
            DBLK(x,y,k,3)=mean(DBL(DBLK(x,y,k,1),DBLK(x,y,k,2),:)-DB(x,y,:)); % the background model:b
            DBLK(x,y,k,4)=std(DBL(DBLK(x,y,k,1),DBLK(x,y,k,2),:)-DB(x,y,:)); % the background model:¦Ò
            r=corrcoef(qv,pv);
            DBLK(x,y,k,5)=r(1,2)/2+0.5; % the correlation coefficient r
            substd(xx(1),yy(1))=10000;
        end     
       GammaSum(x,y)=sum(DBLK(x,y,:,5)); % Gamma, for each pixel sequence, calculate the sum of the correlation coefficients of its K blocks 
    end
end







