function varargout = GestureRecognition1(varargin)
% GESTURERECOGNITION1 MATLAB code for GestureRecognition1.fig
%      GESTURERECOGNITION1, by itself, creates a new GESTURERECOGNITION1 or raises the existing
%      singleton*.
%
%      H = GESTURERECOGNITION1 returns the handle to a new GESTURERECOGNITION1 or the handle to
%      the existing singleton*.
%
%      GESTURERECOGNITION1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GESTURERECOGNITION1.M with the given input arguments.
%
%      GESTURERECOGNITION1('Property','Value',...) creates a new GESTURERECOGNITION1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GestureRecognition1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GestureRecognition1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GestureRecognition1

% Last Modified by GUIDE v2.5 20-Oct-2017 18:47:33

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GestureRecognition1_OpeningFcn, ...
                   'gui_OutputFcn',  @GestureRecognition1_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GestureRecognition1 is made visible.
function GestureRecognition1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GestureRecognition1 (see VARARGIN)

% Choose default command line output for GestureRecognition1
global flag
flag=1;
handles.output = hObject;
MyStruct=struct('fs',44100,'time',0.5);
handles.MyStruct=MyStruct;
% handles.flag=flag;
% flag=0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GestureRecognition1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GestureRecognition1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.flag=1;
global flag
flag=1;
while(flag==1)
fs=handles.MyStruct.fs;
time=handles.MyStruct.time;
tic
wavePlay(18000,0,0.4);
y_get=voice_get(fs,time);
signalLength=length(y_get);
y_get=y_get(fix(0.72*signalLength)+1:signalLength);

    signalLength=even(length(y_get));
    fftY=fft(y_get);
    z=abs(fftY(1:signalLength/2));
    z=20*log10(z);
    z=z*2;
    
    fftX=(1:signalLength/2)*fs/(length(y_get)); % 确定频谱图频率刻度，f/N是分辨率。
    axes(handles.axes1);
    stem(fftX,z);
    axis([8800,9200,15,75]);
    xlabel('F/Hz');
    ylabel('strength');
    title('反射信号频域');
    
    trans=length(y_get)/fs;   %横坐标转换比例
    flagx=fix(9010*trans);     %中间点数
    flagy=z(flagx);            
    if(flagy>30)              %中间值判断是否有声波
%     flagx=fix(300*trans);     %中间点数
    flagx=44;
    zJudgment=z(fix(8700*trans):fix(9300*trans));
    zJudgment(zJudgment<20)=0;  %将小于20的点破零，消除干扰。
    Nonzero=find(zJudgment~=0); %求非零数组下标
    left=Nonzero;
    left(left>=flagx)=0;
    leftNum=length(find(left))%横坐标小于flagx的点数
    right=Nonzero;
    right(right<=flagx)=0;
    rightNum=length(find(right))%横坐标大于flagx的点数
    if(leftNum>rightNum)
        out=1;
    elseif(leftNum<rightNum)
        out=2;
    else
        out=0;
    end
%     x1=flagx-Nonzero(1)
%     x2=Nonzero(end)-flagx
%         if(x1>0)
%             out=1;
%         elseif(x2>3)
%             out=2;
%         else
%             out=0;
%         end
    else
             out=0;
             disp('无数据')
    end
    toc
    gesture=out;
if(gesture==1)
    set(handles.edit2,'string','远离')
    elseif(gesture==2)
    set(handles.edit2,'string','靠近')
    else
    set(handles.edit2,'string','静止')
end
end




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% handles.flag=0;
% guidata(hObject, handles);
global flag
flag=0;



% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
cla;
