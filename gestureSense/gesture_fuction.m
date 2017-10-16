function out=gesture_fuction(fs,timeLength)
% t0=cputime;
tic
wavePlay(18000,0,0.4);
y_get=voice_get(fs,timeLength);
signalLength=length(y_get);
y_get=y_get(fix(0.72*signalLength)+1:signalLength);

    signalLength=even(length(y_get));
    fftY=fft(y_get);
    z=abs(fftY(1:signalLength/2));
    z=20*log10(z);
    z=z*2;
    
    fftX=(1:signalLength/2)*fs/(length(y_get)); % 确定频谱图频率刻度，f/N是分辨率。
    figure(1)
    plot(fftX,z);
    axis([8800,9200,15,75]);
    xlabel('F/Hz');
    ylabel('strength');
    title('反射信号频域');
    
    trans=length(y_get)/fs;   %横坐标转换比例
    flagx=fix(9010*trans);     %中间点数
    flagy=z(flagx);            
    if(flagy>30)              %中间值判断是否有声波
    flagx=fix(300*trans);     %中间点数
    zJudgment=z(fix(8700*trans):fix(9300*trans));
    zJudgment(zJudgment<20)=0;  %将小于20的点破零，消除干扰。
    Nonzero=find(zJudgment~=0); %求非零数组下标
    x1=flagx-Nonzero(1)
    x2=Nonzero(end)-flagx
        if(x1>0)
            out=1;
        elseif(x2>3)
            out=2;
        else
            out=0;
        end
    else
             out=0;
    end
    toc
%     out=[out,t1];
    end