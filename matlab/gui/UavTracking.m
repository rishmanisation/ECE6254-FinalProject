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

% Last Modified by GUIDE v2.5 16-Apr-2017 21:08:44

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
addpath( strcat( fileparts(pwd), '\exampleKalman') );

handles.generateSynthetic = 0;
set(handles.pushbuttonStopTrack, 'UserData', 0);

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

% Instruct everyone that we've generated the background
handles.backgroundMade = 1;

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

% Instruct everyone that we've generated the background
handles.backgroundMade = 1;

% Update Handles
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbuttonStartTrack.
function pushbuttonStartTrack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStartTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% This is the data passed in through the handles structure. Its a
% convenient way of passing data to the functions locally. I'll try and
% label everything efficiently for ya.
% handles.trackingImage - Image with background and target
% handles.targetLocation - Actual target location
%   targetLocation.x     - x location (Array with each data point being a )
%   targetLocation.y     - y location (time slice.                        )
%                                       

% Throw error message if the proper handles data isn't present.
set(handles.textError, 'backgroundColor', [0.94 0.94 0.94]);

if ~isfield(handles, 'backgroundMade')
    set(handles.textError, 'String', 'Background Not Generated');
    error = 1;
elseif ~isfield(handles, 'targetMade')
    set(handles.textError, 'String', 'Target Not Generated');
    error = 1;
elseif ~isfield(handles, 'trackingImage')
    set(handles.textError, 'String', 'TrackingImage Not Generated');
    error = 1;
elseif ~isfield(handles, 'targetLocation')
    set(handles.textError, 'String', 'Target Movement Not Specified');
    error = 1;
else
    error = 0;
end
    
    
% Check for any errors
if error == 1
    % Will skip the normal operation
    set(handles.textError, 'backgroundColor', 'red');
else
    

    % Rish: This is an example of the kalman filter elemements you will need
    % and where to instantiate them for the running of the tracker.

    % When we have the proper handles structure setup, we can uncomment these
    % and remove the hard coded values.
    % centroid_x = handles.targetLocation.x(1);
    % centroid_y = handles.targetLocation.y(1);
    centroid_x = 128;
    centroid_y = 128;

    Z = [centroid_x;centroid_y;0;0];    % Initial Location.
    X = Z;                              % Set the Inital location to the current location.
    location_estimate = [];

    dt = 1;
    process_noise = 0.2;               % How fast the object is speeding/slowing (acceleration)
                                       % Increasing this variable improves
                                       % reaction to the object, but you
                                       % become more susceptable to noise.

    measurement_noise = [   1   0
                            0   1];     % Noise in the measurements
                                        % Increasing this variable reduces
                                        % your susceptability to noise in
                                        % the environment but increases lag
                                        % time.
                                        % TL = Noise in x, BR = noise in y

    P = [   dt^4/4  0       dt^3/2  0;  % Initial positions variance.
            0       dt^4/4  0       dt^3/2;
            dt^3/2  0       dt^2    0;
            0       dt^3/2  0       dt^2].*process_noise^2;

    process_noise = P;                  % Process noise matrix

    % State Transition Matrix
    % State prediciton of the position.
    A = [   1   0   dt  0   
            0   1   0   dt  
            0   0   1   0   
            0   0   0   1];

    % Predicted Motion
    B = [   dt^2/2
            dt^2/2
            dt
            dt]; 

    % Hyeon: This is the location where you will initialize you data elements
    % for the MLE.
    imageMLE = zeros(size(128,128));


    % Clear the intrrupt if it's already been pushed
    set(handles.pushbuttonStopTrack, 'UserData', 0);
    
    [ x, y, numFrames ] = size( handles.trackingImage );

    % This loop creates a "video" like representation
    for frameNumber = 1 : numFrames

        % Check to see if the user has clicked the 'Stop Tracking' button
        if get(handles.pushbuttonStopTrack, 'UserData') == 1
            % Clear the button
            set(handles.pushbuttonStopTrack, 'UserData', 0);
            % Break out of the loop
            break;
        end

        %% Target Analysis
        % Hyeon: This is where you will be adding your MLE code.
        % 1) Acquire the target and border region data
        % 2) Apply your thresholding with the MLE

        % It will look something like this...
        %[ topRegion, leftRegion, rightRegion, bottomRegion, targetRegion ] = ...
        %    MLE_AcquireRegions( finalImage, frameInfo, targetInfo, targetLocationInfo );
        %
        % Now threshold the image
        % imageMLE = ML();

        % With the image now binary, there will be some errors. These can
        % consitute erroneous pixels not in the target or pixels that were
        % supposed to be the target but arent. For now, we will apply the
        % simple methods to help fix those:
        % 1) Dilation and Erosion - Fill holes
        % 2) Noise Spike Removal
        % 3) Image Blurring
        %
        % Finally, we will find the centroid of the target
        %
        % centroid = centroidFunction( imageMLE );


        %% Future Target Location Estimation
        % Rish: This is where you will add your kalman filtering code.
        % 1) Kalman Filter - Find estimated location on next frame
        % 2) Produce Error Graph - Show user how well we are doing

        % Update location
        Z = [centroid_x;centroid_y;0;0];

        % Estimate the next location
        [X,P] = kalman_filter(X, P, Z, measurement_noise, process_noise, A, B);

        % Update the running estimations
        location_estimate = [location_estimate; X(1:2)];

        % Display the Image with a crosshair on the estimate location.
        % image = addCrosshairs( image );

        % Display an image with the error between the estimate location and the
        % actual location.
        % plot( error (red), actual (black) );

        % For Debugging pupose, I'm just displaying the image
        axes( handles.axesTracking );
        imshow( handles.trackingImage(:,:,frameNumber), [] );
        
        % Update the images.
        drawnow;

    end
    
end

fprintf('Im done fool. \n');

% Update Handles
guidata(hObject, handles);

% --- Executes on button press in pushbuttonStopTrack.
function pushbuttonStopTrack_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonStopTrack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We pass data to the push buttons local structure so that we can pass data
% in between the callbacks. We cannot use the handles because they are only
% local copies from when they were called and will not notice the change.
set(handles.pushbuttonStopTrack, 'UserData', 1);

% Update Handles
guidata(hObject, handles);



% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over genTargetButton.
function genTargetButton_Callback(hObject, eventdata, handles)
% hObject    handle to genTargetButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pos = str2num(get(handles.posText,'string'));
angle = str2double(get(handles.angleText, 'string'));
vel = [cosd(angle) sind(angle)];
spd = str2num(get(handles.speedText,'string'));
mass = str2num(get(handles.massText,'string'));


Ts = 1/1; %assuming 30fps?
Fmax = 30; %max frame number taken from above

% Determine which button was selected
if     ( get(handles.radiobuttonFigure8,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'f' , mass);
    
	% Eric: I rougly placed the target in the middle of the image to help 
    % the guys out dring their initial development.
    [ y, x ] = size( handles.backgroundImage );
    P(:,1) = P(:,1) + x/2;
    P(:,2) = P(:,2) + y/2;
    
elseif ( get(handles.radiobuttonBalistic,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'b', mass);
elseif ( get(handles.radiobuttonCircular,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'c', mass);
    
    % Eric: I rougly placed the target in the middle of the image to help 
    % the guys out dring their initial development.
    [ y, x ] = size( handles.backgroundImage );
    P(:,1) = P(:,1) + x/2;
    P(:,2) = P(:,2) + y/2;
    
elseif ( get(handles.radiobuttonLinear,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 's', mass);
elseif ( get(handles.radiobuttonHover,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'h', mass);
else
    %n/a
end

axes( handles.axesTargetMotion );
[Y,X] = size(handles.selectedImage);
plot(P(:,1),-P(:,2));
xlim([ 0, X ]);
ylim([ -Y, 0 ]);

UAVImage   = '..\images\UAV.jpg';
UFOImage   = '..\images\UFO.jpg';
HELImage   = '..\images\Helicopter.jpg';
targetSize = str2num(get(handles.targetSizeText,'string'));


if     ( get(handles.radiobuttonUFO,'Value') == 1 )
    [target_im,t_alpha] = loadTargetImage(UFOImage, targetSize);
elseif ( get(handles.radiobuttonHelicopter,'Value') == 1 )
    [target_im,t_alpha] = loadTargetImage(HELImage, targetSize);
elseif ( get(handles.radiobuttonUAV,'Value') == 1 )
    [target_im,t_alpha] = loadTargetImage(UAVImage, targetSize);
elseif ( get(handles.radiobuttonUAV,'Value') == 1 )
    set(handles.textError, 'String', 'Synthetic Not Implemented Yet');
    error = 1;
end

axes( handles.axesTarget );
imshow(cast(target_im,'uint8'));

% Eric: I added the following code for generating the image frames and also
% some of the handle structures for the guys.

% Need to generate the image sets which simulate a "video".
[ numFrames, numCoordinates ] = size(P);
ImageStack = zeros( [size(handles.backgroundImage), numFrames] );

for i = 1:numFrames
    
    ImageStack(:,:,i) = drawTarget( handles.backgroundImage, target_im, t_alpha, P(i,:) );
  
end

% Copy over the final tracking file
handles.trackingImage    = ImageStack;
handles.targetLocation.x = P(i,1);
handles.targetLocation.y = P(i,2);

% Instruct everyone that we've generated the background
handles.targetMade = 1;

% Display the first frame for the user
axes( handles.axesTracking );
imshow( handles.trackingImage(:,:,1), [] );

% Update Handles
guidata(hObject, handles);



% --- Executes on button press in posCheck.
function posCheck_Callback(hObject, eventdata, handles)
% hObject    handle to posCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of posCheck

if (get(handles.posCheck, 'Value') == 1)
    set(handles.posText,'Enable','off')
else
    set(handles.posText,'Enable','on')
end


% --- Executes on button press in massCheck.
function massCheck_Callback(hObject, eventdata, handles)
% hObject    handle to massCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of massCheck
if (get(handles.massCheck, 'Value') == 1)
    set(handles.massText,'Enable','off')
else
    set(handles.massText,'Enable','on')
end


% --- Executes on button press in angleCheck.
function angleCheck_Callback(hObject, eventdata, handles)
% hObject    handle to angleCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of angleCheck
if (get(handles.angleCheck, 'Value') == 1)
    set(handles.angleText,'Enable','off')
else
    set(handles.angleText,'Enable','on')
end


% --- Executes on button press in speedCheck.
function speedCheck_Callback(hObject, eventdata, handles)
% hObject    handle to speedCheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of speedCheck
if (get(handles.speedCheck, 'Value') == 1)
    set(handles.speedText,'Enable','off')
else
    set(handles.speedText,'Enable','on')
end


% --- Executes on button press in fillRandButton.
function fillRandButton_Callback(hObject, eventdata, handles)
% hObject    handle to fillRandButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isfield(handles, 'backgroundMade')
    set(handles.textError, 'String', 'Background Not Generated');
    error = 1;
end
    
if (get(handles.posCheck, 'Value') == 1)
    [Y,X] = size(handles.selectedImage);
    set(handles.posText,'string',num2str([randi(X) randi(Y)]));
end
if (get(handles.massCheck, 'Value') == 1)
    set(handles.massText,'string',num2str(100*rand(1)));
end
if (get(handles.angleCheck, 'Value') == 1)
    set(handles.angleText,'string',num2str(360*rand(1)))
end
if (get(handles.speedCheck, 'Value') == 1)
    set(handles.speedText,'string',num2str(400*rand(1)))
end

guidata(hObject, handles);


% --- Executes on button press in allRandButton.
function allRandButton_Callback(hObject, eventdata, handles)
% hObject    handle to allRandButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.posCheck, 'Value', 1);
set(handles.massCheck, 'Value', 1);
set(handles.angleCheck, 'Value', 1);
set(handles.speedCheck, 'Value', 1);

set(handles.posText,'Enable','off')
set(handles.massText,'Enable','off')
set(handles.angleText,'Enable','off')
set(handles.speedText,'Enable','off')
