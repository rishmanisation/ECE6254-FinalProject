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

% Last Modified by GUIDE v2.5 21-Apr-2017 10:25:49

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
uipanel1_SelectionChangeFcn(hObject, eventdata, handles);
OpeningMessage(hObject, eventdata, handles)



% UIWAIT makes UavTracking wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function out = OpeningMessage(hObject, eventdata, handles)
uipanel1_SelectionChangeFcn(hObject, eventdata, handles);
h = msgbox({'UAV Tracking program'...
            'Select desired radio options'...
            'Then click "Generate Scene"'...
            'Start tracking will begin running the test'...
            'If options are changed, Generate Scene Again'});

return

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
    centroid_x = handles.targetLocation.x(1);
    centroid_y = handles.targetLocation.y(1);

    Z = [centroid_x;centroid_y;0;0];    % Initial Location.
    X = Z;                              % Set the Inital location to the current location.
    
    location_estimateX = [];
    location_estimateY = [];
    location_actualX   = [];
    location_actualY   = [];
    location_diff      = [];
    
    dt            = 1;
    process_noise = 0.8;               % How fast the object is speeding/slowing (acceleration)
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
    
    % These are the state transition functions for extended Kalman filter
    f = @(x)[x(4);x(3);x(2);0.05*x(1)*(x(2)+x(3)+x(4))];  % nonlinear state equations
    h = @(x)x(1);                               % measurement equation
    
    % Hyeon: This is the location where you will initialize you data elements
    % for the MLE.
    [ frameInfo.vlin, frameInfo.vpix, numFrames ] = size( handles.trackingImage );
    targetInformation = handles.targetInfo;
    targetLoc.x = handles.targetLocation.x(1);
    targetLoc.y = handles.targetLocation.y(1);
    
    % Error Triggers
    meanAVGMLE = 0;
    meanAVGCLS = 0;


    % Clear the intrrupt if it's already been pushed
    set(handles.pushbuttonStopTrack, 'UserData', 0);
    
    
    % This loop creates a "video" like representation
    for frameNumber = 1 : numFrames
        
        input_image = handles.trackingImage(:,:,frameNumber);
       
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
        [ top, left, right, bottom, target ] = ...
            MLE_AcquireRegions_HK( input_image, frameInfo, targetInformation, targetLoc);
        
        % Now threshold the image
        [phat, image_thresh] = MLE_image( top, left, right, bottom, target);
        
        debug = 0;
        if debug == 1
            figure('Name','MLE Output');
            subplot(2,2,1); imshow( image_thresh(:,:,1), [] ); title('Top');
            subplot(2,2,2); imshow( image_thresh(:,:,2), [] ); title('Bottom');
            subplot(2,2,3); imshow( image_thresh(:,:,3), [] ); title('Left');
            subplot(2,2,4); imshow( image_thresh(:,:,4), [] ); title('Right');
        end
        
        %I would need to do something with this image_tresh which has four
        %things: probabilty comparison between the top region vs target,
        %bottom region vs target, right vs target, and left vs target 

        [ clusteredImage clusterID ] = clusteringKMeans( target );
        clusteredImage( clusteredImage ~= clusterID ) = 0; 
        clusteredImage( clusteredImage == clusterID ) = 1; 
        
        % With the image now binary, there will be some errors. These can
        % consitute erroneous pixels not in the target or pixels that were
        % supposed to be the target but arent. For now, we will apply the
        % simple methods to help fix those:
        % 1) Dilation and Erosion - Fill holes
        % 2) Noise Spike Removal
        % 3) Image Blurring
        
        % Perform Morphological - Closing to remove holes between target
        se = strel('square',3);
        image_thresh = imdilate(image_thresh, se);
        image_thresh = imerode(image_thresh,  se);
        
        clusteredImage = imdilate(clusteredImage, se);
        clusteredImage = imerode(clusteredImage,  se); 

        debug = 0;
        if debug == 1
            figure('Name','Closing Output');
            subplot(2,2,1); imshow( image_thresh(:,:,1), [] ); title('Top');
            subplot(2,2,2); imshow( image_thresh(:,:,2), [] ); title('Bottom');
            subplot(2,2,3); imshow( image_thresh(:,:,3), [] ); title('Left');
            subplot(2,2,4); imshow( image_thresh(:,:,4), [] ); title('Right');
        end
        
        % The thresholded image is simply a binary one or zero indicating
        % the probability that the pixel is part of the target. We will now
        % apply a weighting to the original image pixels based on how many
        % pixels were thresholded correctly.
        image_sum = image_thresh(:,:,1) + ...
                    image_thresh(:,:,2) + ...
                    image_thresh(:,:,3) + ...
                    image_thresh(:,:,4);
                
        image_centroid = target .* image_sum;
        
        imageCluster_centroid = target .* clusteredImage;
        
        % Stop Function for debugging
        if frameNumber >= 200 
            cow = 1;
        else
            cow = 0;
        end
        
        debug = 1;
        if debug == 1 && cow == 1
            figure('Name','Centroid Input');
            subplot(2,2,1); imshow( target,                [] ); title('Original Image');
            subplot(2,2,2); imshow( image_sum,             [] ); title('Summed Image');
            subplot(2,2,3); imshow( image_centroid,        [] ); title('Centroid Image');
            subplot(2,2,4); imshow( imageCluster_centroid, [] ); title('ClusteredImage');
        end
        
        % This is where we start combining the results from the
        % multiple algorithms to help make the design more robust.
        meanMLE = mean( image_centroid(:) );
        varMLE  = var(  image_centroid(:) );
        
        meanCLS = mean( imageCluster_centroid(:) );
        varCluster  = var(  imageCluster_centroid(:) );
        
        disp( [ 'Frame Number = ', num2str(frameNumber) ]);
        disp( ['MLE: mean =', num2str(meanMLE), ' var = ', num2str(varMLE) ] );
        disp( ['CLS: mean =', num2str(meanCLS), ' var = ', num2str(varCluster) ] );
        
        % This is a running average of the means. During areas where we
        % have large disparities between results, there have been large
        % changes in the mean. We will use this as a measure of when one
        % algorithm fails.
        alpha = 0.30; % Rate of change
        
        if frameNumber == 1 
            % Inital setting
            meanAVGMLE = meanMLE;
            meanAVGCLS = meanCLS;
        else
            meanAVGMLE = (1 - alpha)*meanAVGMLE - alpha*meanMLE;
            meanAVGCLS = (1 - alpha)*meanAVGCLS - alpha*meanCLS;
        end
        
        
        % Delta changes
        changeDetect = 0.60; % 40 Percent change
        if( abs(meanAVGMLE - meanMLE) > changeDetect )
            detectMLEtrigger = 1;
        else
            detectMLEtrigger = 0;
        end
        
        if( abs(meanAVGCLS - meanCLS) > changeDetect )
            detectCLStrigger = 1;
        else
            detectCLStrigger = 0;
        end
        
        % Use on algorith over the other if the detection change has been
        % triggered.
        if detectCLStrigger == 1
            [centroid_x, centroid_y] = centroid( image_centroid ); % MLE
        else
            [centroid_x, centroid_y] = centroid( imageCluster_centroid ); % Clustering
        end
        
        % Finally, we will find the centroid of the target
        %[centroid_x, centroid_y] = centroid( image_centroid ); % MLE
        
        %[centroid_x, centroid_y] = centroid( imageCluster_centroid ); % Clustering
        
        % An offset must be added to the centroid locations because the
        % centroid was found for only the target region. This is a smaller
        % bounding box, so we must translate this into the original large
        % image space.
        centroid_x = centroid_x + targetLoc.x;
        centroid_y = centroid_y + targetLoc.y;
        
        % These lines of code are used for detecting the error between the
        % tracking algorithms on a single frame basis. They only use the
        % actual location and not the kalman filter outputs.
        %centroid_x = centroid_x + handles.targetLocation.x(frameNumber);
        %centroid_y = centroid_y + handles.targetLocation.y(frameNumber);
        

        %% Future Target Location Estimation
        % Rish: This is where you will add your kalman filtering code.
        % 1) Kalman Filter - Find estimated location on next frame
        % 2) Produce Error Graph - Show user how well we are doing

        Z = [centroid_x;centroid_y; 0; 0];    % Updated Location
        
        if( get(handles.kalmanFiltSTD,'Value') == 1 )
            % Kalman filter
            [X,P] = kalman_filter(X, P, Z, measurement_noise, process_noise, A, B);
        else
            % Extended Kalman filter. Uncomment this and comment the above line
            % to use extended Kalman.
            [X,P] = ext_kalman_filter(X,P,Z,measurement_noise,process_noise,f,h);
        end
        
        % Now we save the location estimates so that we can have a
        % real-time plot of how our tracking algorithms are doing.
        location_estimateX = [ location_estimateX, X(1) ];
        location_estimateY = [ location_estimateY, X(2) ];
        location_actualX   = [ location_actualX,   handles.targetLocation.x(frameNumber) ];
        location_actualY   = [ location_actualY,   handles.targetLocation.y(frameNumber) ];
        
        locationEstimate  = X(1:2);
        locationActual    = [ handles.targetLocation.x(frameNumber); handles.targetLocation.y(frameNumber)];
        diff              = abs(locationEstimate - locationActual);
        location_diff     = [location_diff diff];     
        
        % These are simply handoffs to Hyeon's MLE function
        targetLoc.x = floor( locationEstimate(1) );
        targetLoc.y = floor( locationEstimate(2) );
        
        % Error Plot: We select the appropriate plot from the GUI to be
        % what we will be displaying upon
        axes( handles.axesTargetPerformance );
        cla;
        
        hold on;
        grid on;
            title('Actual vs. Estimated Target Positions','fontweight','bold','fontsize',12);
            xlabel('Pixel Location','fontweight','bold','fontsize',10);
            ylabel('Frame Number',  'fontweight','bold','fontsize',10);
            plot( location_estimateX, 'b'   ,'DisplayName','Estimate(x)')
            plot( location_estimateY, 'b--' ,'DisplayName','Estimate(y)')
            plot( location_actualX,   'k'   ,'DisplayName','Actual(x)')
            plot( location_actualY,   'k--' ,'DisplayName','Actual(y)')
            plot( location_diff(1,:), 'r'   ,'DisplayName','Difference(x)')
            plot( location_diff(2,:), 'r--' ,'DisplayName','Difference(y)')
            % legend('show');
        hold off;
        
        drawnow;

        % Display the Image with a crosshair on the estimate location. In
        % the future, we can add more detailed crosshairs which look a bit
        % better than a single dot on the image.
        image = addCrosshairs( handles.trackingImage(:,:,frameNumber), ...
                               handles.targetLocation.x(frameNumber),  ...
                               handles.targetLocation.y(frameNumber),  ...
                               X(1), ...
                               X(2) );

        % Display the image with the crosshairs overlayed to aid the user
        % in identifying the estimated location.
        axes( handles.axesTracking );
        imshow( image, [] );
        
        hold on
            % Actual Location
            plot( handles.targetLocation.x(frameNumber), ...
                  handles.targetLocation.y(frameNumber), ...
                  '-.*k');                          
            
            % Estimate Location
            plot(X(1),X(2), 'o');                   
        hold off
        
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

if ~isfield(handles, 'backgroundMade')
    set(handles.textError, 'String', 'Background Not Generated');
    error = 1;
    return
end


pos = str2num(get(handles.posText,'string'));
angle = str2double(get(handles.angleText, 'string'));
vel = [cosd(angle) sind(angle)];
spd = str2num(get(handles.speedText,'string'))/100 + 0.01;
mass = str2num(get(handles.massText,'string'));
Fmax = str2num(get(handles.numFrames,'string'));

Ts = 1; %assuming 30fps?

% Determine which button was selected
if     ( get(handles.radiobuttonFigure8,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'f' , mass);   
elseif ( get(handles.radiobuttonBalistic,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'b', mass);
elseif ( get(handles.radiobuttonCircular,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'c', mass);  
elseif ( get(handles.radiobuttonLinear,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 's', mass);
elseif ( get(handles.radiobuttonHover,'Value') == 1 )
    P = genPath(pos, vel, spd, Ts, Fmax, 'h', mass);
else
    %n/a
end
% Rougly placed the target in the middle of the image

[ y, x ] = size( handles.backgroundImage );
P(:,1) = P(:,1) + x/2;
P(:,2) = P(:,2) + y/2;


% Display the Target path
axes( handles.axesTargetMotion );
cla;

[Y,X] = size(handles.selectedImage);

hold on;
    title('Target Path',       'fontweight','bold','fontsize',12);
    xlabel('Pixel Location X', 'fontweight','bold','fontsize',10);
    ylabel('Pixel Location Y', 'fontweight','bold','fontsize',10);
    plot(P(:,1),-P(:,2));

hold off;

% These are the default images which are available to the user to select
% from.
SynthImage   = '..\images\gaussian.jpg';
UAVImage   = '..\images\UAV.jpg';
UFOImage   = '..\images\UFO.jpg';
HELImage   = '..\images\Helicopter.jpg';
targetSize = str2num(get(handles.targetSizeText,'string'));

% Determine which image is to be used based on the radio buttons
if     ( get(handles.radiobuttonUFO,'Value') == 1 )
    [target_im, t_alpha] = loadTargetImage(UFOImage, targetSize);
elseif ( get(handles.radiobuttonHelicopter,'Value') == 1 )
    [target_im, t_alpha] = loadTargetImage(HELImage, targetSize);
elseif ( get(handles.radiobuttonUAV,'Value') == 1 )
    [target_im, t_alpha] = loadTargetImage(UAVImage, targetSize);
else
    [target_im, t_alpha] = loadTargetImage(SynthImage, targetSize);   
end

% Load the image onto the GUI for the user to see.
axes( handles.axesTarget );
cla;

hold on;
    xlabel('Selected Target', 'fontweight','bold','fontsize',12);
    imshow(cast(target_im,'uint8'));
hold off;

% Eric: I added the following code for generating the image frames and also
% some of the handle structures for the guys.

% Need to generate the image sets which simulate a "video".
[ numFrames, numCoordinates ] = size(P);
ImageStack = zeros( [size(handles.backgroundImage), numFrames] );
Noise = str2num(get(handles.noiseText,'string'));


for i = 1:numFrames
    
    ImageStack(:,:,i) = drawTarget( handles.backgroundImage,...
                        target_im, t_alpha, P(i,:) )...
                        + Noise*rand(size(handles.backgroundImage)); 
  
end

% Copy over the final tracking file
handles.trackingImage    = ImageStack;
handles.targetLocation.x = P(:,1);
handles.targetLocation.y = P(:,2);
handles.targetInfo       = target_im;

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


% --- Executes when selected object is changed in uipanel5.
function uipanel5_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel5 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

[Y,X] = size(handles.selectedImage);

% Determine which button was selected
if     ( get(handles.radiobuttonFigure8,'Value') == 1 )    
    set(handles.posText,'string',num2str([0 0]));
    set(handles.massText,'string',num2str(80));
    set(handles.angleText,'string',num2str(0));
    set(handles.speedText,'string',num2str(1));
    set(handles.numFrames,'string',num2str(100));
    
elseif ( get(handles.radiobuttonBalistic,'Value') == 1 )
    set(handles.posText,'string',num2str([-85 -85]));
    set(handles.massText,'string',num2str(0.5));
    set(handles.angleText,'string',num2str(45));
    set(handles.speedText,'string',num2str(1000));
    set(handles.numFrames,'string',num2str(30));
    
elseif ( get(handles.radiobuttonCircular,'Value') == 1 )
    set(handles.posText,'string',num2str([0 0]));
    set(handles.massText,'string',num2str(50));
    set(handles.angleText,'string',num2str(0));
    set(handles.speedText,'string',num2str(5));
    set(handles.numFrames,'string',num2str(100));
    
elseif ( get(handles.radiobuttonLinear,'Value') == 1 )
    set(handles.posText,'string',num2str([-85 -85]));
    set(handles.massText,'string',num2str(1));
    set(handles.angleText,'string',num2str(-45));
    set(handles.speedText,'string',num2str(1000));
    set(handles.numFrames,'string',num2str(30));
    
elseif ( get(handles.radiobuttonHover,'Value') == 1 )
    set(handles.posText,'string',num2str([0 0]));
    set(handles.massText,'string',num2str(15));
    set(handles.angleText,'string',num2str(0));
    set(handles.speedText,'string',num2str(500));
    set(handles.numFrames,'string',num2str(100));
    
else
    %n/a
end






function noiseText_Callback(hObject, eventdata, handles)
% hObject    handle to noiseText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of noiseText as text
%        str2double(get(hObject,'String')) returns contents of noiseText as a double


% --- Executes during object creation, after setting all properties.
function noiseText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to noiseText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
    