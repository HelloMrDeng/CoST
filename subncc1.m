%%--------------------------------------------function for "submatrix"--------------------------------------%%

function [IIB,re_block]=subncc1(II,DBLK,af,GammaSum)

[w,h]=size(II);

ws=ceil(w/8);% set supporting block size, in CPB we set block size as 8x8
hs=ceil(h/8);

BlockPixelNumber=8*8; % the number of pixels in each block
re_block=zeros(w,h,20); % for save the average value of eack blocks in test frame 

for x=1:w
    for y=1:h
        gammaSum=0; % gamma, the sum of the correlation coefficients in blocks which detect the target pixel as the foreground
        for k=1:20 % the number of K blocks
            countflag=0;
            xQ=DBLK(x,y,k,1); % the background model
            yQ=DBLK(x,y,k,2);
            mQr=DBLK(x,y,k,3);
            std1=DBLK(x,y,k,4);
            average=0;
            for i=(8*xQ-7):8*xQ
                for j=(8*yQ-7):8*yQ
                    if  abs((II(i,j)-II(x,y))-mQr)>=std1*af % foreground 
                        countflag=countflag+1;
                    end %if
                    average=average+II(i,j); 
                end %j
            end%i
            average=round(average/64); % the average value of eack blocks in test frame  
            re_block(x,y,k) = average;
            if(countflag==BlockPixelNumber)
                gammaSum=gammaSum+DBLK(x,y,k,5);
            end%if
        end%k
        if(gammaSum>GammaSum(x,y)*0.5) % determine the state of target pixel p, R>R_all*0.5
            IIB(x,y)=1; % foreground 
        else
            IIB(x,y)=0; % background 
        end
    end
end
