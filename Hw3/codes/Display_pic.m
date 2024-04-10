function Display_pic(img_meshed,H)
    %figure('name','the filter');
    subplot(2,3,3);
    title('the filter');
    imshow(im2double(mat2gray(abs(fftshift(H)))));
    % perform fft on the meshed picture.
    % Before display it, be aware of fftshift.
    fft_1=fft2(img_meshed);  % fft;
    fft_1_filt=H.*fft_1;     % filter;
    fft_1_shift=fftshift(fft_1); %shift the signal;
    fft_1_shift_abs=abs(fft_1_shift); %get abs;
    fft_1_shift_abs_gray=mat2gray(fft_1_shift_abs); %graying...
    fft_1_pic=im2double(fft_1_shift_abs_gray); %change to image double
        % fftshift, then normalize, then take its' absolute, then turn to
        % double image.
    fft_1_filt_pic=im2double(mat2gray(abs(fftshift(fft_1_filt))));
    %figure('name','Before filter');
    subplot(2,3,4);
    title('Before filter');
    imshow(5*fft_1_pic);
    %figure('name','After filter');
    subplot(2,3,5);
    title('After filter');
    imshow(5*fft_1_filt_pic);
    
    % we can find that when the first light passing wider band pass filter will
    % have better performance.
    % Continue for fft transform.
    fft_2_filt=fft2(fft_1_filt);
    fft_2_filt_pic=im2double(mat2gray(abs(fft_2_filt)));
    %figure('name','final result');
    subplot(2,3,6);
    title('final result');
    imshow(fft_2_filt_pic);