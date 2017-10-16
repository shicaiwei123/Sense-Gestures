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
    
    fftX=(1:signalLength/2)*fs/(length(y_get)); % ȷ��Ƶ��ͼƵ�ʿ̶ȣ�f/N�Ƿֱ��ʡ�
    figure(1)
    plot(fftX,z);
    axis([8800,9200,15,75]);
    xlabel('F/Hz');
    ylabel('strength');
    title('�����ź�Ƶ��');
    
    trans=length(y_get)/fs;   %������ת������
    flagx=fix(9010*trans);     %�м����
    flagy=z(flagx);            
    if(flagy>30)              %�м�ֵ�ж��Ƿ�������
    flagx=fix(300*trans);     %�м����
    zJudgment=z(fix(8700*trans):fix(9300*trans));
    zJudgment(zJudgment<20)=0;  %��С��20�ĵ����㣬�������š�
    Nonzero=find(zJudgment~=0); %����������±�
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