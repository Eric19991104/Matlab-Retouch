function varargout = cutecat(varargin)
% CUTECAT MATLAB code for cutecat.fig
%      CUTECAT, by itself, creates a new CUTECAT or raises the existing
%      singleton*.
%
%      H = CUTECAT returns the handle to a new CUTECAT or the handle to
%      the existing singleton*.
%
%      CUTECAT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CUTECAT.M with the given input arguments.
%
%      CUTECAT('Property','Value',...) creates a new CUTECAT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cutecat_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cutecat_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cutecat

% Last Modified by GUIDE v2.5 13-Jun-2019 00:00:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cutecat_OpeningFcn, ...
                   'gui_OutputFcn',  @cutecat_OutputFcn, ...
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


% --- Executes just before cutecat is made visible.
function cutecat_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cutecat (see VARARGIN)

% Choose default command line output for cutecat
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes cutecat wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cutecat_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btn_openfile.
function btn_openfile_Callback(hObject, eventdata, handles)
% hObject    handle to btn_openfile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename pathname] = uigetfile({'*.jpg';'*.png'});
if pathname==0
    display('User cancelled');
else
    image_path = strcat(pathname, filename);    
    handles.ori_rgb = imread(image_path);
    handles.processed_rgb=handles.ori_rgb;
    guidata(hObject,handles);
    abc(handles);
end
function abc(handles)
    axes(handles.axes_original);    
    imshow(handles.ori_rgb);    
    axes(handles.axes_processed);    
    imshow(handles.processed_rgb);
    axes(handles.axes7);
    imhist(handles.ori_rgb);
    axes(handles.axes8);
    imhist(handles.processed_rgb);

% --- Executes during object creation, after setting all properties.
function axes_processed_CreateFcn(~, eventdata, handles)
% hObject    handle to axes_processed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_processed
   


% --- Executes during object creation, after setting all properties.
function axes_original_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_original (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_original


% --- Executes on slider movement.
function sldGamma_Callback(hObject, eventdata, handles)
% hObject    handle to sldGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
newGamma=get(hObject,'Value');
handles.processed_rgb=luma_adjusted_rgb(handles.ori_rgb,newGamma);
guidata(hObject,handles);
abc(handles);

% --- Executes during object creation, after setting all properties.
function sldGamma_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sldGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
function process_image(handles)
    if get(handles.chkAutoBright, 'Value') == 1
        [Y, U, V] = rgb2yuv(handles.ori_rgb(:,:,1), handles.ori_rgb(:,:,2), handles.ori_rgb(:,:,3));
        Y = histeq(Y);
        handles.processed_rgb = yuv2rgb(Y, U, V);
        abc(handles);
    else
        newGamma = get(handles.sldGamma,'Value');
        display(newGamma);
        handles.processed_rgb = luma_adjusted_rgb(handles.ori_rgb, newGamma); 
        abc(handles);
    end

% --- Executes on button press in chkAutoBright.
function chkAutoBright_Callback(hObject, eventdata, handles)
% hObject    handle to chkAutoBright (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of chkAutoBright
display(get(hObject,'Value'));
    if get(hObject,'Value') == 1
        set(handles.sldGamma, 'Enable', 'off');
    else
        set(handles.sldGamma, 'Enable', 'on');
    end
    process_image(handles);


% --- Executes during object creation, after setting all properties.
function axes7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes7
