function varargout = CV_Project(varargin)
% CV_PROJECT MATLAB code for CV_Project.fig
%      CV_PROJECT, by itself, creates a new CV_PROJECT or raises the existing
%      singleton*.
%
%      H = CV_PROJECT returns the handle to a new CV_PROJECT or the handle to
%      the existing singleton*.
%
%      CV_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CV_PROJECT.M with the given input arguments.
%
%      CV_PROJECT('Property','Value',...) creates a new CV_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CV_Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CV_Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CV_Project

% Last Modified by GUIDE v2.5 03-Dec-2019 23:05:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CV_Project_OpeningFcn, ...
                   'gui_OutputFcn',  @CV_Project_OutputFcn, ...
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
end


% --- Executes just before CV_Project is made visible.
function CV_Project_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CV_Project (see VARARGIN)

% Choose default command line output for CV_Project
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CV_Project wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = CV_Project_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end


% --- Executes on button press in loadVideoBtn.
function loadVideoBtn_Callback(hObject, eventdata, handles)
% hObject    handle to loadVideoBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load the video
V = VideoReader('E:\BS(CS) Resources\Computer Vision\CV Project\video.mp4');

while hasFrame(V)
   A = readFrame(V);
   axes(handles.axes1);
   imshow(A, []);
end
end


% --- Executes on button press in calVelocity.
function calVelocity_Callback(hObject, eventdata, handles)
% hObject    handle to calVelocity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%-----------------------------------------------------------
%load the video
V = VideoReader('E:\BS(CS) Resources\Computer Vision\CV Project\video.mp4');

%get the first frame of the video
V.CurrentTime = 0;
startTime = 0; endTime = 0;
frame_1 = readFrame(V);
frameOne = rgb2gray(frame_1);

%perform thresholding and binarization on first image
T1 = graythresh(frameOne);
frameOne = imbinarize(frameOne,0.5);
frameOne = bwareaopen(frameOne,600);

axes(handles.axes2);
imshow(frameOne, []);

%get the last frame of the video
frame_L = 0;
while hasFrame(V)
   frame_L = readFrame(V);
   endTime = V.CurrentTime;
end
lastFrame = rgb2gray(frame_L);

%perform thresholding and binarization on last image
T2 = graythresh(lastFrame);
lastFrame = imbinarize(lastFrame,0.5);
lastFrame = bwareaopen(lastFrame,600);

axes(handles.axes3);
imshow(lastFrame, []);

%finding centroids of object in first and last frames
c1  = regionprops(frameOne, 'centroid');
firstCentroid = cat(1, c1.Centroid);

c2  = regionprops(lastFrame, 'centroid');
secondCentroid = cat(1, c2.Centroid);

%calculating distance moved in pixels across screen
PixelDistance = secondCentroid(:,1) - firstCentroid(:,1);

%various distances between object and camera
imageHeight = PixelDistance;
objDistance = 20; %in centimeters
objDistanceWithCamera = 30; %in centimeters

imgDistance = (imageHeight*objDistanceWithCamera)/objDistance;
imgDistanceWithCamera = (PixelDistance*objDistanceWithCamera)/imgDistance;

timeTaken = endTime;

%velocity is in cm/seconds
velocity = imgDistanceWithCamera / timeTaken;
set(handles.speedyText, 'String', num2str(velocity, 6));
%------------------------------------------------------------
end
