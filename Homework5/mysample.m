filename='chopin.mp3';
[y,fs]=audioread(filename);
figure('Name','original')
subplot(2,1,1)
t = seconds(0:1/fs:(size(y,1)-1)/fs);
plot(t,y(:,1));
subplot(2,1,2)
stft(y(:,1),fs);
% resample 5khz,10khz,15khz.
y_5khz=resample(y,5000,fs);
input=y_5khz(:,1);
figure('Name','sample 5khz')
subplot(2,1,1)
t = seconds(0:1/5000:(size(input,1)-1)/5000);
plot(t,input);
title("Time-Amplitude-graph");
xlabel("Time");
ylabel("amplitude");
subplot(2,1,2)
stft(input,5000);
% resample 5khz,10khz,15khz.
y_10khz=resample(y,10000,fs);
input=y_10khz(:,1);
figure('Name','sample 10khz')
subplot(2,1,1)
t = seconds(0:1/5000:(size(input,1)-1)/5000);
plot(t,input);
title("Time-Amplitude-graph");
xlabel("Time");
ylabel("amplitude");
subplot(2,1,2)
stft(input,5000);
% resample 5khz,10khz,15khz.
y_15khz=resample(y,15000,fs);
input=y_15khz(:,1);
figure('Name','sample 15khz')
subplot(2,1,1)
t = seconds(0:1/5000:(size(input,1)-1)/5000);
plot(t,input);
title("Time-Amplitude-graph");
xlabel("Time");
ylabel("amplitude");
subplot(2,1,2)
stft(input,5000);

% recover from sampling.
y_re_5khz=resample(y_5khz,fs,5000);
input=y_re_5khz(:,1);
figure('Name','resample 5khz')
subplot(2,1,1)
t = seconds(0:1/fs:(size(input,1)-1)/fs);
plot(t,input);
subplot(2,1,2)
stft(input,fs);
% recover
y_re_10khz=resample(y_10khz,fs,10000);
input=y_re_10khz(:,1);
figure('Name','resample 10khz')
subplot(2,1,1)
t = seconds(0:1/fs:(size(input,1)-1)/fs);
plot(t,input);
subplot(2,1,2)
stft(input,fs);
% recover
y_re_15khz=resample(y_15khz,fs,15000);
input=y_re_15khz(:,1);
figure('Name','sample 15khz')
subplot(2,1,1)
t = seconds(0:1/fs:(size(input,1)-1)/fs);
plot(t,input);
subplot(2,1,2)
stft(input,fs);