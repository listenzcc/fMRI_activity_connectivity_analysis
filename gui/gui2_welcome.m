function varargout = gui2_welcome(varargin)
% GUI2_WELCOME MATLAB code for gui2_welcome.fig
%      GUI2_WELCOME, by itself, creates a new GUI2_WELCOME or raises the existing
%      singleton*.
%
%      H = GUI2_WELCOME returns the handle to a new GUI2_WELCOME or the handle to
%      the existing singleton*.
%
%      GUI2_WELCOME('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2_WELCOME.M with the given input arguments.
%
%      GUI2_WELCOME('Property','Value',...) creates a new GUI2_WELCOME or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui2_welcome_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui2_welcome_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui2_welcome

% Last Modified by GUIDE v2.5 30-Nov-2018 22:09:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui2_welcome_OpeningFcn, ...
                   'gui_OutputFcn',  @gui2_welcome_OutputFcn, ...
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


% --- Executes just before gui2_welcome is made visible.
function gui2_welcome_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui2_welcome (see VARARGIN)

% Choose default command line output for gui2_welcome
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui2_welcome wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui2_welcome_OutputFcn(hObject, eventdata, handles) 
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
ud = files_selection;
set(hObject, 'UserData', ud)
set(handles.pushbutton2, 'String', '¿ªÊ¼¼ÆËã')
set(handles.pushbutton2, 'Enable', 'On')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(handles.pushbutton1, 'UserData');
set(hObject, 'Enable', 'Off')
fun_preprocess_1(ud.pathname, ud.filenames, hObject)
fun_preprocess_2(ud.pathname, hObject)
fun_preprocess_3(ud.pathname, hObject)
fun_preprocess_4(ud.pathname, hObject)
fun_GLM(ud.pathname, hObject)
set(hObject, 'Enable', 'On')

hm_max = fun_plot_artificial(ud.pathname, handles.axes1, handles.axes2)
fun_findmax_amy(ud.pathname, handles.axes3)

set(handles.pushbutton3, 'Enable', 'On')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(handles.pushbutton1, 'UserData')

% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes during object creation, after setting all properties.
function uipanel1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

set(hObject, 'UserData', 'handles.axes3')


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
set(hObject, 'Box', 'off')
set(get(hObject, 'Title'), 'String', '1')
set(hObject, 'UserData', 'handles.axes1')


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
set(hObject, 'Box', 'off')
set(get(hObject, 'Title'), 'String', '2')
set(hObject, 'UserData', 'handles.axes2')


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
set(hObject, 'Box', 'off')
set(get(hObject, 'Title'), 'String', '3')
set(hObject, 'UserData', 'handles.axes3')


% --- Executes during object creation, after setting all properties.
function radiobutton1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', 0)


% --- Executes during object creation, after setting all properties.
function radiobutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% --- Executes during object creation, after setting all properties.
set(hObject, 'Value', 0)


function radiobutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
set(hObject, 'Value', 1)


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
if get(hObject, 'Value')
    this = handles.axes1;
    a = get(handles.uipanel1, 'UserData');
    a = eval(a);
    p = get(a, 'Position');
    set(a, 'Position', get(this, 'Position'))
    set(this, 'Position', p);
    set(handles.uipanel1, 'UserData', 'handles.axes1')
end


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
if get(hObject, 'Value')
    this = handles.axes2;
    a = get(handles.uipanel1, 'UserData');
    a = eval(a);
    p = get(a, 'Position');
    set(a, 'Position', get(this, 'Position'))
    set(this, 'Position', p);
    set(handles.uipanel1, 'UserData', 'handles.axes2')
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
if get(hObject, 'Value')
    this = handles.axes3;
    a = get(handles.uipanel1, 'UserData');
    a = eval(a);
    p = get(a, 'Position');
    set(a, 'Position', get(this, 'Position'))
    set(this, 'Position', p);
    set(handles.uipanel1, 'UserData', 'handles.axes3')
end
