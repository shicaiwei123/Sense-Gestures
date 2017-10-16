%a 是采样率
%b 是采样的的位数
%c 是采样的声道
function [Y]=voice_get(fs,sampleTime)
recObj = audiorecorder(fs,16,1);
% disp('Start speaking.')
recordblocking(recObj, sampleTime);
% disp('End of Recording.');

% Play back the recording.
% disp('play');
% play(recObj);

% Store data in double-precision array.
Y = getaudiodata(recObj);
% if doPlot
%     figure(2)
%     plot(Y);
end
% axis([0,25000,0,2]);
% file_name=filename;
% audiowrite(file_name,Y,fs);
