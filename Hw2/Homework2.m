%Read image.
img=imread("guest.jpg");
imgR=img(:,:,1);    % R pic
imgG=img(:,:,2);    % G pic
imgB=img(:,:,3);    % B pic

%Plot the graph.
figure(1);
tiledlayout(2,2);
nexttile;
imshow(img);
nexttile;
imshow(imgR);
nexttile;
imshow(imgG);
nexttile;
imshow(imgB);

%Linear combination of the plots.
imgRGB(:,:,1)=0.299*imgR;
imgRGB(:,:,2)=0.587*imgG;
imgRGB(:,:,3)=0.114*imgB;
figure(2);
imshow(imgRGB);

%hist the pic.
imgRGB_H=histeq(imgRGB);
figure(3);
subplot(221);
imshow(imgRGB);
subplot(222);
imshow(imgRGB_H);
subplot(223);
imhist(imgRGB,64);
subplot(224);
imhist(imgRGB_H,64);

%Gaussfilter.
imgfilt1=imgaussfilt3(imgRGB,0.1);
imgfilt2=imgaussfilt3(imgRGB,0.5);
imgfilt3=imgaussfilt3(imgRGB,1);
imgfilt4=imgaussfilt3(imgRGB,2);
figure(4);
tiledlayout(2,2);
nexttile;
imshow(imgfilt1);
nexttile;
imshow(imgfilt2);
nexttile;
imshow(imgfilt3);
nexttile;
imshow(imgfilt4);

%Filter2
imgfilt1_h=imgaussfilt3(imgRGB_H,0.1);
imgfilt2_h=imgaussfilt3(imgRGB_H,0.5);
imgfilt3_h=imgaussfilt3(imgRGB_H,1);
imgfilt4_h=imgaussfilt3(imgRGB_H,2);
figure(5);
tiledlayout(2,2);
nexttile;
imshow(imgfilt1_h);
nexttile;
imshow(imgfilt2_h);
nexttile;
imshow(imgfilt3_h);
nexttile;
imshow(imgfilt4_h);
