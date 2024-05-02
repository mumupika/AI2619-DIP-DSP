% 时域图
filename='chopin.mp3';
[y,fs]=audioread(filename);
n=length(y);
t = seconds(0:1/fs:(size(y,1)-1)/fs);
figure
plot(t,y);
title("Time-Amplitude-graph");
xlabel("Time");
ylabel("amplitude");
legend("Channel 1","Channel 2");
%频域图
figure
y2=abs(fft(y))/n*2;
y2=y2(1:n/2);
f=fs/n-1:fs/n:fs/2-1; 
plot(f,y2);
xlim([0 6000]);
% spectrogram
input=y(:,2);
figure
s=spectrogram(input);
spectrogram(input,'yaxis');
% stft gram
figure
stft(input,fs);
figure
stft(input,fs,Window=kaiser(128,5),OverlapLength=100,FFTLength=256);

