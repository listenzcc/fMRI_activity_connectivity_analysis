function varargout = gui1_welcome(varargin)
% GUI1_WELCOME MATLAB code for gui1_welcome.fig
%      GUI1_WELCOME, by itself, creates a new GUI1_WELCOME or raises the existing
%      singleton*.
%
%      H = GUI1_WELCOME returns the handle to a new GUI1_WELCOME or the handle to
%      the existing singleton*.
%
%      GUI1_WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI1_WELCOME.M with the given input arguments.
%
%      GUI1_WELCOME('Property','Value',...) creates a new GUI1_WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui1_welcome_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui1_welcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui1_welcome

% Last Modified by GUIDE v2.5 29-Nov-2018 10:02:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui1_welcome_OpeningFcn, ...
                   'gui_OutputFcn',  @gui1_welcome_OutputFcn, ...
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


% --- Executes just before gui1_welcome is made visible.
function gui1_welcome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui1_welcome (see VARARGIN)

% Choose default command line output for gui1_welcome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui1_welcome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui1_welcome_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

pathname = uigetdir();
set(hObject, 'UserData', pathname)
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(pathname);
if isKey(ext_map, '.IMA')
    set(handles.pushbutton3, 'Enable', 'On')
end
if isKey(path_map, '_____preprocessed_4')
    set(handles.pushbutton4, 'Enable', 'On')
end
if isKey(path_map, '_____GLManalysis_12345')
    set(handles.pushbutton5, 'Enable', 'On')
end
set(handles.text2, 'String', pathname)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = get(handles.pushbutton2, 'UserData');
set(hObject, 'Enable', 'Off')
fun_preprocess_1(pathname, hObject)
fun_preprocess_2(pathname, hObject)
fun_preprocess_3(pathname, hObject)
fun_preprocess_4(pathname, hObject)
set(hObject, 'Enable', 'On')


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
