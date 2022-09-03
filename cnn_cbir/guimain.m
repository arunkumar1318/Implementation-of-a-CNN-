function varargout = guimain(varargin)
% GUIMAIN M-file for guimain.fig
%      GUIMAIN, by itself, creates a new GUIMAIN or raises the existing
%      singleton*.
%
%      H = GUIMAIN returns the handle to a new GUIMAIN or the handle to
%      the existing singleton*.
%
%      GUIMAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIMAIN.M with the given input arguments.
%
%      GUIMAIN('Property','Value',...) creates a new GUIMAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guimain_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guimain_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guimain

% Last Modified by GUIDE v2.5 09-Aug-2010 16:45:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guimain_OpeningFcn, ...
                   'gui_OutputFcn',  @guimain_OutputFcn, ...
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

% --- Executes just before guimain is made visible.
function guimain_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guimain (see VARARGIN)
a=dir('query');
cd query
axes(handles.axes1);imshow(a(3).name);
axes(handles.axes6);imshow(a(4).name);
axes(handles.axes7);imshow(a(5).name);
axes(handles.axes8);imshow(a(6).name);
axes(handles.axes9);imshow(a(7).name);
cd ..
axes(handles.axes2);imshow('matlab.jpg');
axes(handles.axes3);imshow('matlab.jpg');
axes(handles.axes4);imshow('matlab.jpg');
axes(handles.axes5);imshow('matlab.jpg');
axes(handles.axes10);imshow('matlab.jpg');
handles.current_data='1.jpg';
% Choose default command line output for guimain
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guimain wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guimain_OutputFcn(hObject, eventdata, handles) 
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

addpath('support')
cd query
% I=uigetfile('.jpg','select the quiery image');
I=imread(handles.current_data);
alp=0.01;
cd ..
axes(handles.axes10)
 imshow(I);
I=imresize(I,[128 128]);
c1=IRCTF(I);
tes=c1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd train
delete('*.db');
cd ..
clc;
FileNames = dir('train');
FileNames = char(FileNames.name);

  
for i=1:length(FileNames)-2
  cd train
    j=imread(strcat(num2str(i),'.jpg'));
    j=imresize(j,[128 128]);
  cd ..
    c2=IRCTF(j);
    
     res=c2;
     pera(i)=min(min(dist(tes,res')));
     hiddenSize1 = 100;
 autoenc1 = trainAutoencoder(tes,hiddenSize1, ...
     'MaxEpochs',10, ...
     'L2WeightRegularization',0.004, ...
     'SparsityRegularization',4, ...
     'SparsityProportion',0.25, ...
     'ScaleData', false);
%  view(autoenc1)
%  figure,plotWeights(autoenc1);

feat1 = encode(autoenc1,tes);
hiddenSize2 = 50;
autoenc2 = trainAutoencoder(feat1,hiddenSize2, ...
    'MaxEpochs',10, ...
    'L2WeightRegularization',0.002, ...
    'SparsityRegularization',4, ...
    'SparsityProportion',0.2, ...
    'ScaleData', false);

feat2 = encode(autoenc2,feat1);
softnet = trainSoftmaxLayer(feat2,tes,'MaxEpochs',10);
% view(softnet)

% create  a stack deep auto encoder
deepnet = stack(autoenc1,autoenc2,softnet);

%=== For Retrival=======


  xTest=res;
% % with a deep neural netwrok 
%        y = deepnet(numel(tes));
      d(i)=(deeptest(deepnet,tes,res));
      p(i)=pera(i)+(d(i)*alp);
      
      %y = deepnet(numel(res));
      %im = imresize(im,[128 128]);
      %axes(handles.axes2);imshow('2.jpg');
end

r=0;
 k=sort(p);
 for i=1:length(k)
  g=find(k(i)==p);
      r(i)=g(1);
 end
  cd train
 j=imread(strcat(num2str(r(1)),'.jpg'));
 axes(handles.axes2)
 imshow(imresize(j,[128 128]));
 j=imread(strcat(num2str(r(2)),'.jpg'));
 axes(handles.axes3)
 imshow(imresize(j,[128 128]));
 j=imread(strcat(num2str(r(3)),'.jpg'));
 axes(handles.axes4)
 imshow(imresize(j,[128 128]));
 j=imread(strcat(num2str(r(4)),'.jpg'));
 axes(handles.axes5)
 imshow(imresize(j,[128 128]));
 cd ..
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all;

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

axes(handles.axes2);imshow('matlab.jpg');
axes(handles.axes3);imshow('matlab.jpg');
axes(handles.axes4);imshow('matlab.jpg');
axes(handles.axes5);imshow('matlab.jpg');
axes(handles.axes10);imshow('matlab.jpg');

% --------------------------------------------------------------------
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

switch get(hObject,'Tag')   % Get Tag of selected object
    case 'radiobutton1'
        handles.current_data='1.jpg';
    case 'radiobutton2'
        handles.current_data='2.jpg';
    case 'radiobutton3'
        handles.current_data='3.jpg';
    case 'radiobutton4'
        handles.current_data='4.jpg';
    case 'radiobutton5'
        handles.current_data='5.jpg';
end

guidata(hObject,handles);

