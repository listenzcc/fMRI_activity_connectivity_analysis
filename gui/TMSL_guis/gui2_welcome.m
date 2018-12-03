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

% Last Modified by GUIDE v2.5 03-Dec-2018 10:36:27

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
try
    ud = files_selection;
catch
    return
end
firstfile = fullfile(ud.pathname, ud.filenames{1});

di = dicominfo(firstfile);
str = sprintf('Name: %s  %s',...
    di.PatientName.FamilyName, di.PatientName.GivenName);
str = sprintf('%s\nSex:  %s', str, di.PatientSex);
str = sprintf('%s\nAge:  %s', str, di.PatientAge);
str = sprintf('%s\nScan: %s', str, di.FileModDate);
set(handles.text3, 'String', str)

set(hObject, 'UserData', ud)

reset_analysis(handles)


function reset_analysis(handles)

set(handles.uipanel7, 'ShadowColor', [0.7, 0.7, 0.7])
set(handles.uipanel1, 'ShadowColor', [0.7, 0.7, 0.7])
set(handles.uipanel8, 'ShadowColor', [0.64, 0.08, 0.18])

% p = get(handles.figure1, 'Position');
% p(3) = 600;
% set(handles.figure1, 'Position', p)

set(handles.pushbutton2, 'ForegroundColor', [0.64, 0.08, 0.18])
set(handles.pushbutton2, 'String', '开 始 预 处 理')
set(handles.pushbutton2, 'Enable', 'On')

set(handles.pushbutton7, 'ForegroundColor', 'Black')
set(handles.pushbutton7, 'String', '激 活 点 分 析')
set(handles.pushbutton7, 'Enable', 'Off')
set(handles.checkbox1, 'Enable', 'Off')

set(handles.pushbutton8, 'ForegroundColor', 'Black')
set(handles.pushbutton8, 'String', 'TMS 个 体 靶 点 分 析')
set(handles.pushbutton8, 'Enable', 'Off')
set(handles.checkbox3, 'Enable', 'Off')

set(handles.uipanel9, 'Visible', 'Off')
set(handles.uipanel5, 'Visible', 'Off')
set(handles.uipanel6, 'Visible', 'Off')


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ud = get(handles.pushbutton1, 'UserData');
firstfile = fullfile(ud.pathname, ud.filenames{1});
DicomInfo = dicominfo(firstfile);
TR = DicomInfo.RepetitionTime / 1000;
s = md5(firstfile);
appPath = fileparts(which('TMSLocation'));
new_pathname = fullfile(appPath, 'subjects', s);
[a, b, c] = mkdir(new_pathname);
save(fullfile(new_pathname, 'TR'), 'TR')
save(fullfile(new_pathname, 'DicomInfo'), 'DicomInfo')
save(fullfile(new_pathname, 'ud'), 'ud')

set(hObject, 'String', '(1/7) 数 据 读 取 中 ...')
pause(1)
fun_preprocess_1(appPath, new_pathname, ud.pathname, ud.filenames, hObject)

set(hObject, 'String', '(2/7) 功 能 像 对 齐 中 ...')
pause(1)
fun_preprocess_2(appPath, new_pathname, hObject)

set(hObject, 'String', '(3/7) 功 能 结 构 配 准 中 ...')
pause(1)
fun_preprocess_3(appPath, new_pathname, hObject)

set(hObject, 'String', '(4/7) 功 能 像 平 滑 中 ...')
pause(1)
fun_preprocess_4(appPath, new_pathname, hObject)

set(hObject, 'String', '(5/7) 头 动 误 差 统 计 ...')
pause(1)
hm_max = fun_plot_artificial(appPath,...
    new_pathname, handles.axes1, handles.axes2)
if (sum(hm_max(1:3) < 3) == 3) && (sum(hm_max(4:6) < 1) == 3)
    set(handles.text10, 'String', sprintf('头动小于阈值\n\n合格'))
else
    set(handles.text10, 'String', sprintf('头动大于阈值\n\n不合格'))
end

set(hObject, 'ForegroundColor', 'black')
set(hObject, 'String', '预 处 理 完 毕')
set(hObject, 'Enable', 'Off')
set(handles.uipanel8, 'ShadowColor', [0.7, 0.7, 0.7])

set_subjects = get(handles.popupmenu1, 'UserData');
if isempty(set_subjects)
    set_subjects = containers.Map;
end
subject_name = sprintf('%s %s',...
    DicomInfo.PatientName.FamilyName,...
    DicomInfo.PatientName.GivenName);
file_mod_date = DicomInfo.FileModDate;
subject_id = sprintf('%s, %s', subject_name, file_mod_date);
set(handles.popupmenu1, 'String', sprintf('%s\n%s',...
    get(handles.popupmenu1, 'String'), subject_id))
set_subjects(subject_id) = new_pathname;
set(handles.popupmenu1, 'UserData', set_subjects);

set(hObject, 'UserData', set_subjects)

set(handles.uipanel9, 'Visible', 'On')
set(handles.pushbutton7, 'ForegroundColor', [0.64, 0.08, 0.18])
set(handles.pushbutton7, 'String', '开 始 激 活 点 分 析')
set(handles.pushbutton7, 'Enable', 'On')
set(handles.checkbox1, 'Enable', 'On')
set(handles.uipanel1, 'ShadowColor', [0.64, 0.08, 0.18])


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ud = get(handles.pushbutton1, 'UserData');
firstfile = fullfile(ud.pathname, ud.filenames{1});
s = md5(firstfile);
appPath = fileparts(which('TMSLocation'));
new_pathname = fullfile(appPath, 'subjects', s);

set(hObject, 'String', '(6/7) 激 活 点 分 析 中 ...')
pause(1)
fun_GLM(appPath, new_pathname, hObject)
if get(handles.checkbox1, 'Value') == 1
    gg = 1;
else
    gg = 0;
end
if get(handles.checkbox2, 'Value') == 1
    hh = 1;
else
    hh = 0;
end
load(fullfile(appPath, 'resources', 'cm.mat'), 'cm')
[max_p, max_amy_mm] = fun_findmax_amy(appPath,...
    new_pathname, gg, hh, cm, handles.axes3, handles);
max_amy_mm
set(hObject, 'UserData', max_p)

set(hObject, 'ForegroundColor', 'black')
set(hObject, 'String', '激活点分析完毕')
set(hObject, 'Enable', 'Off')
set(handles.checkbox1, 'Enable', 'Off')

set(handles.uipanel5, 'Visible', 'On')

set(handles.text8, 'String',...
    sprintf('杏仁核激活点位置\n\n%dmm, %dmm, %dmm',...
    max_amy_mm(1), max_amy_mm(2), max_amy_mm(3)))
set(handles.pushbutton8, 'ForegroundColor', [0.64, 0.08, 0.18])
set(handles.pushbutton8, 'String', '开始TMS个体靶点分析')
set(handles.pushbutton8, 'Enable', 'On')
set(handles.checkbox3, 'Enable', 'On')


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ud = get(handles.pushbutton1, 'UserData');
firstfile = fullfile(ud.pathname, ud.filenames{1});
s = md5(firstfile);
appPath = fileparts(which('TMSLocation'));
new_pathname = fullfile(appPath, 'subjects', s);

set(hObject, 'String', '(7/7) TMS 靶 点 分 析 中 ...')
pause(1)
load(fullfile(appPath, 'resources', 'cm.mat'), 'cm')
max_p = get(handles.pushbutton7, 'UserData');
max_c_mm = fun_findmax_corr(appPath, new_pathname, max_p, cm, handles);
max_c_mm

set(handles.pushbutton8, 'ForegroundColor', [0.64, 0.08, 0.18])
set(hObject, 'String', '开始TMS个体靶点分析')

set(handles.uipanel6, 'Visible', 'On')

set(handles.text5, 'String',...
    sprintf('TMS靶点坐标建议值\n\n%dmm, %dmm, %dmm',...
    max_c_mm(1), max_c_mm(2), max_c_mm(3)))
set(handles.text5, 'Visible', 'On')


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


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
contents = cellstr(get(hObject,'String'));
str = contents{get(hObject,'Value')};

reset_analysis(handles)

set(handles.uipanel8, 'ShadowColor', [0.7, 0.7, 0.7])
set(handles.uipanel7, 'ShadowColor', [0.64, 0.08, 0.18])
set(handles.pushbutton2, 'Enable', 'Off')
set(handles.text3, 'String', '--')

if strcmp(str, '--')
    return
end

set_subjects = get(hObject, 'UserData');
dir_subject = set_subjects(str);
load(fullfile(dir_subject, 'ud'), 'ud')

firstfile = fullfile(ud.pathname, ud.filenames{1});

if ~exist(firstfile, 'file')
    warndlg(sprintf('%s目录异常，请重新载入数据', ud.pathname))
    return
end

di = dicominfo(firstfile);
str = sprintf('Name: %s  %s',...
    di.PatientName.FamilyName, di.PatientName.GivenName);
str = sprintf('%s\nSex:  %s', str, di.PatientSex);
str = sprintf('%s\nAge:  %s', str, di.PatientAge);
str = sprintf('%s\nScan: %s', str, di.FileModDate);
set(handles.text3, 'String', str)

set(handles.pushbutton1, 'UserData', ud)

reset_analysis(handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

set(hObject, 'String', '--')

appPath = fileparts(which('TMSLocation'));
subject_dir = fullfile(appPath, 'subjects');
[fname_map, pre_map, ext_map, path_map] = fun_parse_files_in_path(subject_dir);

set_subjects = containers.Map;
for k = keys(path_map)
    str_MD5 = k{1}; % MD5 dirname
    [fname_map, pre_map, ext_map, path_map] =...
        fun_parse_files_in_path(fullfile(subject_dir, str_MD5));
    % if it has DicomInfo.mat means it is a dir we create
    if isKey(fname_map, 'DicomInfo.mat')
        load(fullfile(subject_dir, str_MD5, 'DicomInfo.mat'), 'DicomInfo')
        subject_name = sprintf('%s %s',...
            DicomInfo.PatientName.FamilyName,...
            DicomInfo.PatientName.GivenName);
        file_mod_date = DicomInfo.FileModDate;
        subject_id = sprintf('%s, %s', subject_name, file_mod_date);
        set(hObject, 'String', sprintf('%s\n%s',...
            get(hObject, 'String'), subject_id))
        set_subjects(subject_id) = fullfile(subject_dir, str_MD5);
    end
end
set(hObject, 'UserData', set_subjects)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
s = get(hObject, 'String');
p = get(handles.figure1, 'Position');

if strcmp(s, '>>')
    set(handles.figure1, 'Position', [p(1), p(2), 940, p(4)])
    set(hObject, 'String', '<<')
else
    set(handles.figure1, 'Position', [p(1), p(2), 600, p(4)])
    set(hObject, 'String', '>>')
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% p = get(hObject, 'Position');
% p(3) = 600;
% set(hObject, 'Position', p)


% --- Executes during object creation, after setting all properties.
function axes_logo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_logo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes_logo
appPath = fileparts(which('TMSLocation'));
img = imread(fullfile(appPath, 'resources', 'logo.tif'));
image(hObject, img)
set(hObject, 'Box', 'Off')
set(hObject, 'XTick', [])
set(hObject, 'YTick', [])


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2
% k = get(hObject, 'Value');
% if k == 0
%     set(handles.pushbutton1, 'Enable', 'Off')
%     set(handles.popupmenu1, 'Enable', 'On')
% else
%     set(handles.pushbutton1, 'Enable', 'On')
%     set(handles.popupmenu1, 'Enable', 'Off')
% end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3
