%Procedure 1: Pictures with different sampling frequency.
I=imread("original.png");
I1=rgb2gray(I);
imshow(I1); %I1 is original gray pic;

%procedure 2: Sampling and interpolation;
%Sampling with 2;
I2=I1(1:2:end,1:2:end);
I2=imresize(I2,[1410,1920],"nearest");
imshow(I2);
%Sampling with 4;
I3=I1(1:4:end,1:4:end);
I3=imresize(I3,[1410,1920],"nearest");
imshow(I3);
%Sampling with 8;
I4=I1(1:8:end,1:8:end);
I4=imresize(I4,[1410,1920],"nearest");
imshow(I4);

%Procedure 3: Try different interpolation;
%Execute on frequency=8.
%Original picture is I1, now dealing with I4.

intp1=I4;
imshow(intp1);%Using "nearest" interpolation.

intp2=I1(1:8:end,1:8:end);
intp2=imresize(intp2,[1410,1920],"bilinear");%Using "bilinear" interpolation 
imshow(intp2);

intp3=I1(1:8:end,1:8:end);
intp3=imresize(intp3,[1410,1920],"bicubic");%Using "bicubic" interpolation
imshow(intp3);

intp4=I1(1:8:end,1:8:end);
intp4=imresize(intp4,[1410,1920],"box");%Using "box" interpolation
imshow(intp4);

%Procedure 4:Filtering before sampling.
%Using imfilter to implement filter.
%implement Gaussian filter.

Iblur1=imgaussfilt(I1,4);
Iblur1=Iblur1(1:8:end,1:8:end);
Iblur1=imresize(Iblur1,[1410,1920],"bilinear");
imshow(Iblur1);

%implement PSF conv.
PSF=fspecial("average",10);
Iblur2=imfilter(I1,PSF,"symmetric","conv");
Iblur2=Iblur2(1:8:end,1:8:end);
Iblur2=imresize(Iblur2,[1410,1920],"bilinear");
imshow(Iblur2);