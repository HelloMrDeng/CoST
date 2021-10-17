%%-----------------------------------step5, background initialization--------------------%%
load MASK2
load DBLKr
load DBLKg
load DBLKb
load re_blockr
load re_blockg
load re_blockb
load TestFileName
load test_t
load IItest
%---------------------------------------------

B=IItest;
B=imresize(B,[240 320]);

[w,h,Bands]=size(B); % RGB channel 
Subtractresult=zeros(w,h,3,20);% store the estimated background initialization value calculated from each relevant block
Total_coe=zeros(w,h,3);
flagblock=zeros(w,h,20,3);% determine whether the k-th relevant block contribute to the background restoration


% For each correlation block of the target pixel, traverse the pixels in the block and count the number of 
%foreground pixels to determine whether the block contributes to the background initialization
for x=1:w
    for y=1:h
        if MASK2(x,y)==1
            for k=1:20 
                %------------------------------------------------------
               
                xQr=DBLKr(x,y,k,1);
                yQr=DBLKr(x,y,k,2);
                flagzeror=0;
                for i=(8*xQr-7):8*xQr
                    for j=(8*yQr-7):8*yQr
                        if(MASK2(i,j))==1
                            flagzeror=flagzeror+1;% count the number of foreground pixels 
                        end
                    end
                end
                if(flagzeror==0 && ~(isnan(DBLKr(x,y,k,5))))
                    flagblock(x,y,k,1)=1;%Most of pixel in this block are not foreground
                end
                %--------------------------------------------------
                xQg=DBLKg(x,y,k,1);
                yQg=DBLKg(x,y,k,2);
                flagzerog=0;
                for i=(8*xQg-7):8*xQg
                    for j=(8*yQg-7):8*yQg
                        if(MASK2(i,j))==1
                            flagzerog=flagzerog+1;
                        end
                    end
                end
                if(flagzerog==0 && ~(isnan(DBLKg(x,y,k,5))))
                    flagblock(x,y,k,2)=1;
                end
                %-----------------------------------------------------
                xQb=DBLKb(x,y,k,1);
                yQb=DBLKb(x,y,k,2);
                flagzerob=0;
                for i=(8*xQb-7):8*xQb
                    for j=(8*yQb-7):8*yQb
                        if(MASK2(i,j))==1
                            flagzerob=flagzerob+1;
                        end
                    end
                end
                if(flagzerob==0 && ~(isnan(DBLKb(x,y,k,5))))
                    flagblock(x,y,k,3)=1;
                end
                %---------------------------------------------------------
            end%for
        end%if
    end%y
end%x 


for x=1:w
    for y=1:h
        if MASK2(x,y)==1
            for k=1:20                               
                Discrepancyr = DBLKr(x,y,k,3);%The result of subtracting the pixel sequence from the block mean sequence
                Discrepancyg = DBLKg(x,y,k,3);
                Discrepancyb = DBLKb(x,y,k,3);
                
                % result of background initialization estimated by the correlation block 
                Subtractresult(x,y,1,k)=re_blockr(x,y,k)-Discrepancyr;
                Subtractresult(x,y,2,k)=re_blockg(x,y,k)-Discrepancyg;
                Subtractresult(x,y,3,k)=re_blockb(x,y,k)-Discrepancyb;
                
                if(flagblock(x,y,k,1)==1)
                    Total_coe(x,y,1)=Total_coe(x,y,1)+DBLKr(x,y,k,5);% count the weight
                end
                
                if(flagblock(x,y,k,2)==1)
                    Total_coe(x,y,2)=Total_coe(x,y,2)+DBLKg(x,y,k,5);
                end
                
                if(flagblock(x,y,k,3)==1)
                    Total_coe(x,y,3)=Total_coe(x,y,3)+DBLKb(x,y,k,5);
                end
            end%for
        end%if
    end%y
end%x

for x=1:w
    for y=1:h
        if MASK2(x,y)==1
            medianumberr=0;
            medianumberg=0;
            medianumberb=0;
            for k=1:20
                if(flagblock(x,y,k,1)==1) % flagblock == 0 then do not contribute to background initialization
                    medianumberr=medianumberr+Subtractresult(x,y,1,k)*(DBLKr(x,y,k,5)/Total_coe(x,y,1));
                end
                if(flagblock(x,y,k,2)==1)
                    medianumberg=medianumberg+Subtractresult(x,y,2,k)*(DBLKg(x,y,k,5)/Total_coe(x,y,2));
                end
                if(flagblock(x,y,k,3)==1)
                    medianumberb=medianumberb+Subtractresult(x,y,3,k)*(DBLKb(x,y,k,5)/Total_coe(x,y,3));
                end
                
            end%for
            B(x,y,1)=round(medianumberr);
            B(x,y,2)=round(medianumberg);
            B(x,y,3)=round(medianumberb);
        end%if
    end%y
end%x


figure
imshow(B);% show the result 


save B B % save the result
TestFileNamestr=num2str(test_t);
s1=strcat('./subpre/',TestFileNamestr,'result2.bmp');
imwrite(B,s1);
