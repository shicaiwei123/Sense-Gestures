
%% ������ʼ��
%�ֱ���,7hz
%�ٶ�����10cm/s
clear all
timeLength=0.5;
ztemp=0;
rc=1;
fftTemp=[];
temp=[];
f=8000;
fs=44100;
time=100/f;
doPlotGet=false;
doPlotFFT=true;
doSTFT=false;
%% ��������
while(1)
tic
y=wavePlay(18000,0,0.4);
% % FFT����
% y=y(:,1);
% fftY=fft(y);
% signalLengthy=even(length(y));
% fftX=(0:signalLengthy/2)*fs/signalLengthy; % ȷ��Ƶ��ͼƵ�ʿ̶ȣ�f/N�Ƿֱ��ʡ�
% toc
% figure(1)
% subplot(2,1,1)
% plot(fftX,20*log10(abs(fftY(1:signalLengthy/2+1))));%db��Ƶ����
% axis([0,25000,-10,70]);
% figure(1)
% xlabel('F/Hz');
% ylabel('strength');
% title('�����ź�Ƶ��');
% subplot(2,1,2)
% t=0:1/fs:time;
% plot(t,y);

y_get=voice_get(fs,timeLength);
%ȥ����Ч����
signalLength=length(y_get);
ySqure=y_get(fix(0.6*signalLength)+1:signalLength);
y_get=y_get(fix(0.72*signalLength)+1:signalLength);
if ~doSTFT
    signalLength=even(length(y_get));
    fftY=fft(y_get);
    z=abs(fftY(1:signalLength/2));
    z=20*log10(z);
    z=z*2;
    fftX=(1:signalLength/2)*fs/(length(y_get)); % ȷ��Ƶ��ͼƵ�ʿ̶�
    figure(1)
    stem(fftX,z);
    axis([8700,9300,10,75]);
    xlabel('F/Hz');
    ylabel('strength');
    title('�����ź�Ƶ��');
    % z=z(6972)
else
    tic
    s=spectrogram(y_get,hamming(8192));
    for i=1:2
    s1=s(:,i);
    signalLength=even(length(s1));
    z1=abs(s1(1:signalLength/2));
    z1=20*log10(z1);
    fftX=(1:signalLength/2)*fs/(length(s1)); 
    plot(fftX,z1)
    axis([17500,19500,-25,40]);
    toc
%     pause(0.5)
    end
end
toc
% end
% toc
% end
%% 

%%����ʶ��
trans=length(y_get)/fs;   %������ת������
flagx=fix(9010*trans);     %�м����
flagy=z(flagx);            
if(flagy>30)              %�м�ֵ�ж��Ƿ�������
%     flagx=fix(300*trans);     %�м����
    flagx=44;
    zJudgment=z(fix(8700*trans):fix(9300*trans));
    zJudgment(zJudgment<20)=0;  %��С��20�ĵ����㣬�������š�
    Nonzero=find(zJudgment~=0); %����������±�
     left=Nonzero;
    left(left>=flagx)=0;
    leftNum=length(find(left))%������С��flagx�ĵ���
    right=Nonzero;
    right(right<=flagx)=0;
    rightNum=length(find(right))%���������flagx�ĵ���
    if(leftNum>rightNum)
        out=1;
    elseif(leftNum<rightNum)
        out=2;
    else
        out=0;
    end
%     x1=flagx-Nonzero(1)
%     x2=Nonzero(end)-flagx
%     if(x1>0)
%         disp('Զ��');
%     elseif(x2>5)
%          disp('����');
%     else
%          disp('��ֹ');
% 
%     end
else
    disp('������');
end
%     gesture=out;
%     fftSqure=fft(ySqure);
%     zSqure=abs(fftSqure(1:fix(length(ySqure)/2)));
%     zSqure=20*log10(zSqure);
%     zSqure=zSqure*2;
%     zSqure=zSqure(fix(8700*trans):fix(9300*trans));
%     zSqure(zSqure<20)=0;
%     sumSqure=sum(zSqure(45:85))
if(gesture==1)
    disp('Զ��')
    elseif(gesture==2)
    disp('����')
    else
   disp('��ֹ')
toc
end
end
%% ��ȡ�����������������ֵ��
initalFlag=100
while(initalFlag>0)
    y_get=voice_get(fs,timeLength,doPlotGet);
    signalLength=length(y_get);
    y_get=y_get(0.8*signalLength:signalLength);
    signalLength=even(length(y_get));
    fftY=fft(y_get);
    z=20*log10(abs(fftY(1:signalLength/2)));
    fftTemp=vertcat(fftTemp,z);
    initalFlag=initalFlag-1;
end
    m=signalLength;
    n=fix(length(fftTemp)/m);
    fftTemp=fftTemp(1:n*m);
    a=reshape(fftTemp,m,n);
    sumRow=sum(a,2);
    a=sumRow/n;
    
    %% zoomFFTʵ��
fs = 44100;  
T = 0.5;  
t = 0:1/fs:T;  
x = 30 * cos(2*pi*110.*t) + 30 * cos(2*pi*111.45.*t) + 25*cos(2*pi*112.3*t) + 48*cos(2*pi*113.8.*t)+50*cos(2*pi*114.5.*t);  
[f, y] = zfft(x, 109, 115, 200);  
stem(f, y);  
    







