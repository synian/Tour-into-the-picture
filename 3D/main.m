function varargout = main(varargin)
% MAIN MATLAB code for main.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the MAIN before main_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to main_OpeningFcn via varargin.
%
%      *See MAIN Options on GUIDE's Tools menu.  Choose "MAIN allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help main

% Last Modified by GUIDE v2.5 16-Jul-2022 00:49:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @main_OpeningFcn, ...
                   'gui_OutputFcn',  @main_OutputFcn, ...
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


% --- Executes just before main is made visible.
function main_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to main (see VARARGIN)

% Choose default command line output for main
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes main wait for user response (see UIRESUME)
% uiwait(handles.figure1);

clc
hold off
addpath lib

global I;
global pointNum;
global img_background;
global img_target;
img_target = [];
img_background = [];
pointNum = 0;
hold off
[fn,pn] = uigetfile({'*.jpg;*.jpeg;*.png'});
%initialization
if ~(isequal(fn, 0) || isequal(pn, 0))
I = imread([pn,fn]);
size(I);
imshow(I);
hold on
else 
    hold off
    warndlg('no picture', 'warning')
end
%check if there is a picture

% --- Outputs from this function are returned to the command line.
function varargout = main_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in addPoint.
function [x,y] = addPoint_Callback(hObject, eventdata, handles)
% hObject    handle to addPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pointNum;
global I;
global non_control_pts;
global control_pts;

[height_img,width_img,~] = size(I);
if pointNum < 4
    [x,y] = ginput(1);
    if x<0||y>height_img||y<0||x>width_img
        x = nan;
        y = nan;
    warndlg('Please do not select points outside the picture.','warning');
    else
    pointNum = pointNum + 1;
    scatter(x,y,'s','filled','red','ButtonDownFcn',@pointCallback);
    end     

elseif pointNum == 4
[x,y] = ginput(1);
    if x<0||y>height_img||y<0||x>width_img
        x = nan;
        y = nan;
    warndlg('Please do not select points outside the picture.','warning');
    else
    pointNum = pointNum + 1;
    scatter(x,y,'s','filled','red','ButtonDownFcn',@pointCallback);
    end
handles.h = findobj('Type','Scatter');
for i = 1:5
x(i) = handles.h(i).XData;
y(i) = handles.h(i).YData;
end
pointPosition = [x;y];
[~,ind] = sort(x);
if y(ind(1)) < y(ind(2))
    control_pts(:,1) = pointPosition(:,ind(1));
    control_pts(:,4) = pointPosition(:,ind(2));
else
    control_pts(:,1) = pointPosition(:,ind(2));
    control_pts(:,4) = pointPosition(:,ind(1));
end 

if y(ind(4)) < y(ind(5))
    control_pts(:,2) = pointPosition(:,ind(4));
    control_pts(:,3) = pointPosition(:,ind(5));
else
    control_pts(:,2) = pointPosition(:,ind(5));
    control_pts(:,3) = pointPosition(:,ind(4));
end 
%get all the 5 points from the user 
%determind the points' positions

control_pts(:,5) = [median(x) median(y)];

text(control_pts(1,1), control_pts(2,1),'top left');
text(control_pts(1,2), control_pts(2,2),'top right');
text(control_pts(1,3), control_pts(2,3),'bottom right');
text(control_pts(1,4), control_pts(2,4),'bottom left');
text(control_pts(1,5), control_pts(2,5),'Vanishing Point');

line([control_pts(1,1), control_pts(1,2)],[control_pts(2,1), control_pts(2,2)],'Color','b','LineWidth',1);   
line([control_pts(1,2), control_pts(1,3)],[control_pts(2,2), control_pts(2,3)],'Color','b','LineWidth',1);
line([control_pts(1,3), control_pts(1,4)],[control_pts(2,3), control_pts(2,4)],'Color','b','LineWidth',1);
line([control_pts(1,4), control_pts(1,1)],[control_pts(2,4), control_pts(2,1)],'Color','b','LineWidth',1);

% ncpt_1: non-control point on top left, whose y_coordinate is zero
% ncpt_2: non-control point on top right, whose y_coordinate is zero
% ncpt_3: non-control point on bottom right, whose y_coordinate is max
% ncpt_4: non-control point on bottom left, whose y_coordinate is max
non_control_pts = CalculatePointCoordinates(I, control_pts);
line([control_pts(1,5), non_control_pts(1,1)],[control_pts(2,5), non_control_pts(2,1)],'Color','b','LineWidth',1)
line([control_pts(1,5), non_control_pts(1,2)],[control_pts(2,5), non_control_pts(2,2)],'Color','b','LineWidth',1);
line([control_pts(1,5), non_control_pts(1,3)],[control_pts(2,5), non_control_pts(2,3)],'Color','b','LineWidth',1);
line([control_pts(1,5), non_control_pts(1,4)],[control_pts(2,5), non_control_pts(2,4)],'Color','b','LineWidth',1);
%draw the spidry mesh
end


% --- Executes on button press in openPicture.
function openPicture_Callback(hObject, eventdata, handles)
% hObject    handle to openPicture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global pointNum;
global img_background;
global img_target;

[fn,pn] = uigetfile({'*.jpg;*.jpeg;*.png'});

if ~(isequal(fn, 0) || isequal(pn, 0))
img_target = [];
img_background = [];
pointNum = 0;
hold off
I = imread([pn,fn]);
size(I);
imshow(I);
hold on
end
%check if there is a picture.

% --- Executes on button press in resetPoint.
function resetPoint_Callback(hObject, eventdata, handles)
% hObject    handle to resetPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global pointNum;
global img_background;
global img_target;
img_target = [];
img_background = [];
pointNum = 0;
hold off
imshow(I);
hold on


% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pointNum;
global I;
global non_control_pts;
global control_pts; %control_pts =  [cpt_1,cpt_2,cpt_3,cpt_4,vp];
global point2;
global img_background;
global img_target;

%caculate the f(camera's position)
if pointNum == 5
    c = norm(control_pts(:, 2)'- control_pts(:, 3)');
    n1 = norm(non_control_pts(:, 2)'- non_control_pts(:, 3)');
    n2 = norm(non_control_pts(:, 6)'- non_control_pts(:, 7)');
    if n1 > n2
        f = 320 * n1/c;
    else
        f = 320 * n2/c;
    end

poly_front = [control_pts(:, 1), control_pts(:, 2), control_pts(:, 3), control_pts(:, 4)];
poly_left = [control_pts(:, 1), control_pts(:, 4), non_control_pts(:, 8), non_control_pts(:, 5)];
poly_right = [control_pts(:, 2), control_pts(:, 3), non_control_pts(:, 7), non_control_pts(:, 6)];
poly_top = [control_pts(:, 1), control_pts(:, 2), non_control_pts(:, 2), non_control_pts(:, 1)];
poly_bottom = [control_pts(:, 4), control_pts(:, 3), non_control_pts(:, 3), non_control_pts(:, 4)];


if isempty(img_target)                               % check if there is a foreground
    img_front = ImageCropping(I, poly_front);
    img_left = ImageCropping(I, poly_left);
    img_right = ImageCropping(I, poly_right);
    img_top = ImageCropping(I, poly_top);
    img_bottom = ImageCropping(I, poly_bottom);
    X = NaN;
    Y = NaN;
else
    img_front = ImageCropping(img_background, poly_front);
    img_left = ImageCropping(img_background, poly_left);
    img_right = ImageCropping(img_background, poly_right);
    img_top = ImageCropping(img_background, poly_top);
    img_bottom = ImageCropping(img_background, poly_bottom);
end
[img_front_rectified, img_left_rectified, img_right_rectified,...
    img_top_rectified, img_bottom_rectified,geo] = ProjectiveRectification( ...
     control_pts, non_control_pts, img_front, img_left, img_right, img_top, img_bottom,f);

if ~isempty(img_target)
[X,Y,horizontal_length,vertical_length] = ForegroundCalculation(I,control_pts,non_control_pts,point2,geo); %foreground
height = geo(2);
width = geo(3);
[height_target,width_target,~] = size(img_target);
numcols = abs(floor(width_target*width/horizontal_length));
numrows = abs(floor(height_target*height/vertical_length));
img_target = imresize(img_target, [numrows numcols]);
end
Transform3D(X,Y, img_target,img_front_rectified, img_left_rectified,img_right_rectified, img_top_rectified, img_bottom_rectified);
else
warndlg('not enough points', 'warning')
end

% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over addPoint.
function addPoint_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to addPoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function pointCallback (src,~)
global pointNum;
pointNum = pointNum-1;
src.delete;
if pointNum == 4
    lines = findobj('Type','Line');
    texts = findobj('Type','Text');
lines.delete;
texts.delete;
end


% --- Executes on button press in frontGround.
function frontGround_Callback(hObject, eventdata, handles)
% hObject    handle to frontGround (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global I;
global img_background;
global img_target;
global point2;

if isempty(img_target)
[img_background, img_target,point2,check] = CutForeground(I);
else
    check = 0;
    warndlg('can only choose one foreground.','warning');
end

if check == 1
    warndlg('Please do not select foreground outside the picture.Please reselect the foreground.','warning');
end
