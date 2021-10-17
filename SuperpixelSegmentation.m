%%-------------------------------step3 superpixel segmentation------------------------------------------------%%
load IItest
load IIB2

%SLIC super pixel segmentation
N=700; % set the number of divided blocks to be large enough to make the result over-segmented
[l, Am, Sp] = slic2(IItest, N, 1, 1, 'median');
[SLIC_result,maskim_SLIC]=drawregionboundaries(l, IItest, [255 255 255]);


%DBSCAN
lc = spdbscan(l, Sp, Am, 5);
[DBSCAN_result,maskim_dbscan]=drawregionboundaries(lc, IItest, [255 255 255]);


%save the result
s1=strcat('./subpre/',TestFileNamestr,'SLIC_result.bmp');
imwrite(uint8(SLIC_result),s1);
s2=strcat('./subpre/',TestFileNamestr,'DBSCAN_result.bmp');
imwrite(uint8(DBSCAN_result),s2);

% show the result
subplot(1,3,1);imshow(IItest);title('test frame');
subplot(1,3,2);imshow(SLIC_result);title('SLIC result');
subplot(1,3,3);imshow(DBSCAN_result);title('DBSCAN result');

save lc lc
save maskim_dbscan maskim_dbscan
