% read the image and generate the mesh.
img=imread("5.jpg");
img_gray=im2double(rgb2gray(img));

figure
subplot(2,3,1);
title('gray origin image');
imshow(img_gray);

M=size(img_gray,1);
N=size(img_gray,2);

type=input("Please input the type of mesh. Options: sine,rect ",'s');
mesh=mesh_gen(type,M,N); %Generalize the mesh.

% mesh the img.
mesh=mat2gray(mesh);
img_meshed=im2double(img_gray+2.*mesh);
%figure("Name",'meshed_pic');
subplot(2,3,2);
title('meshed_pic');
imshow(img_meshed);

% Warning: band-pass is now developing...
type1=input("Please choose the filter. Options: low_pass,band_pass ",'s');
type2=input("Please choose the filter type. Options: ideal,btw,gaussian ",'s');

%% bandwidth is advise 40 in sine.
%% D0 is adivised in 20 in low pass, 60 in band pass in sine.
%% D0 50 in rect.

switch type1
    case 'band_pass'
        w=input("Please input the band-width. Advise 40: ");
    otherwise
        w=0;
end

switch type2
    case 'ideal'
        D0=input("Please input the cutoff frequency D0: ");
        n=1;
    case 'btw'
        D0=input("Please input the cutoff frequency D0: ");
        n=input("Please input the factor n: ");
    case 'gaussian'
        D0=input("Please input the cutoff frequency D0: ");
        n=1;
end
%H is the filter that we generate.
H=myfilter(type1,type2,M,N,D0,n,w);
Display_pic(img_meshed,H);