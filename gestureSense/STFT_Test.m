%% example1
exmaple1
t=0:0.01:20;
fs=100;
a=sin(2*pi*5*t);
figure();plot(t,a);
T=length(a);
[tfr,t,f] = tfrstft(a',1:T,T,hamming(501),0);  %a只能有一列
figure();
%contour(t/fs,2*f(1:length(f)/2)*fs,abs(tfr(1:length(f)/2,:)));
mesh(t/fs,2*f(1:length(f)/2)*fs,abs(tfr(1:length(f)/2,:)));

%% example2
y_get=audioread('周杰伦 - 七里香.mp3');
y_get=y_get(:,1);
spectrogram(y_get);

%% example3
fs=44100;
time=0.5;
while(1)
  y=gesture_fuction(fs,time)
end
%% example4
t = 0:0.001:6;
x = chirp(t,100,1,200,'quadratic');
tic
% s=spectrogram(x);
s=spectrogram(x,hamming(2048));
for i=1:4
s1=s(:,i);
z=abs(s1);
plot(10*log10(z))
pause(0.5)
end
toc
% spectrogram(x,128,120,128,1e3)

%% example5
load splat
% To hear, type soundsc(y,Fs)
sg = 400;
ov = 300;
spectrogram(y,sg,ov,[],Fs,'yaxis')
colormap bone
[s,f,t,p] = spectrogram(y,sg,ov,[],Fs);
f1 = f > 100;
t1 = t < 0.75;
m1 = medfreq(p(f1,t1),f(f1));
f2 = f > 2500;
t2 = t > 0.3 & t < 0.65;

m2 = medfreq(p(f2,t2),f(f2));


hold on
plot(t(t1),m1/1000,'linewidth',4)
plot(t(t2),m2/1000,'linewidth',4)
hold off

