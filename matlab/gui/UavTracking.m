function varargout = UavTracking(varargin)
% UAVTRACKING MATLAB code for UavTracking.fig
%      UAVTRACKING, by itself, creates a new UAVTRACKING or raises the existing
%      singleton*.
%
%      H = UAVTRACKING returns the handle to a new UAVTRACKING or the handle to
%      the existing singleton*.
%
%      UAVTRACKING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UAVTRACKING.M with the given input arguments.
%
%      UAVTRACKING('Property','Value',...) creates a new UAVTRACKING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before UavTracking_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to UavTracking_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help UavTracking

% Last Modified by GUIDE v2.5 03-Apr-2017 18:41:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @UavTracking_OpeningFcn, ...
                   'gui_OutputFcn',  @UavTracking_OutputFcn, ...
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


% --- Executes just before UavTracking is made visible.
function UavTracking_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to UavTracking (see VARARGIN)

% Choose default command line output for UavTracking
handles.output = hObject;

% Default Variable Setting
addpath( strcat( fileparts(pwd), '\gui') );
addpath( strcat( fileparts(pwd), '\code'  ) );
addpath( strcat( fileparts(pwd), '\images') );
handles.generateSynthetic = 0;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes UavTracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = UavTracking_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonBrowseImages.
function pushbuttonBrowseImages_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonBrowseImages (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Grab Selected Image
[ handles.selectedImage ] = loadImage();

% Decsion selection between generic background images and synthetic
% background images.
if handles.generateSynthetic == 0

    % Compute Image's PSD
    [nuImage,  PfImage]   = raPsd2d( handles.selectedImage, 1 );

    % Update Figure
    axes( handles.axesImagePSD );
    plotSinglePSD(nuImage, PfImage);
    
    % Update Background Image
    handles.backgroundImage = handles.selectedImage;

else
    
    % Update Figure
    axes( handles.axesImagePSD );
    
    % Plots the PSD figure within function
    [ handles.backgroundImage ] = computeSyntheticImage( handles.selectedImage );
    
end

% Update Figure
axes( handles.axesBackgroundImage );
imshow( handles.backgroundImage, [] );

% Update Handles
guidata(hObject, handles);

% --- Executes on button press in checkboxSynthetic.
function checkboxSynthetic_Callback(hObject, eventdata, handles)
% hObject    handle to checkboxSynthetic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkboxSynthetic
handles.generateSynthetic = get(hObject,'Value');

% Update Handles
guidata(hObject, handles);


% --- Executes when selected object is changed in uipanel1.
function uipanel1_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel1 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

% Image location
path = strcat( fileparts(pwd), '\images\');

% Benchmark Images
easy1Image   = strcat(path, 'cloud1.jpg');
easy2Image   = strcat(path, 'cloud2.jpg');
easy3Image   = strcat(path, 'cloud3.jpg');

medium1Image = strcat(path, 'hill1.jpg' );
medium2Image = strcat(path, 'hill2.jpg' );
medium3Image = strcat(path, 'hill3.jpg' );

hard1Image   = strcat(path, 'woods1.jpg');
hard2Image   = strcat(path, 'woods2.jpg');
hard3Image   = strcat(path, 'woods3.jpg');

% Determine which button was selected
if     ( get(handles.radiobuttonEasy1,'Value') == 1 )
    benchmarkImage = loadImage( easy1Image );
elseif ( get(handles.radiobuttonEasy2,'Value') == 1 )
    benchmarkImage = loadImage( easy2Image );
elseif ( get(handles.radiobuttonEasy3,'Value') == 1 )
    benchmarkImage = loadImage( easy3Image );
elseif ( get(handles.radiobuttonMedium1,'Value') == 1 )
    benchmarkImage = loadImage( medium1Image );
elseif ( get(handles.radiobuttonMedium2,'Value') == 1 )
    benchmarkImage = loadImage( medium2Image );
elseif ( get(handles.radiobuttonMedium3,'Value') == 1 )
    benchmarkImage = loadImage( medium3Image );
elseif ( get(handles.radiobuttonHard1,'Value') == 1 )
    benchmarkImage = loadImage( hard1Image );
elseif ( get(handles.radiobuttonHard2,'Value') == 1 )
    benchmarkImage = loadImage( hard2Image );
elseif ( get(handles.radiobuttonHard3,'Value') == 1 )
    benchmarkImage = loadImage( hard3Image );
else
    %n/a
end

% Set selected image
handles.selectedImage = benchmarkImage;

% Decsion selection between generic background images and synthetic
% background images.
if handles.generateSynthetic == 0

    % Compute Image's PSD
    [nuImage,  PfImage]   = raPsd2d( handles.selectedImage, 1 );

    % Update Figure
    axes( handles.axesImagePSD );
    plotSinglePSD(nuImage, PfImage);
    
    % Update Background Image
    handles.backgroundImage = handles.selectedImage;

else
    
    % Update Figure
    axes( handles.axesImagePSD );
    
    % Plots the PSD figure within function
    [ handles.backgroundImage ] = computeSyntheticImage( handles.selectedImage );
    
end

% Update Figure
axes( handles.axesBackgroundImage );
imshow( handles.backgroundImage, [] );

% Update Handles
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
