function varargout = gui_operation(varargin)
% GUI_OPERATION MATLAB code for gui_operation.fig
%      GUI_OPERATION, by itself, creates a new GUI_OPERATION or raises the existing
%      singleton*.
%
%      H = GUI_OPERATION returns the handle to a new GUI_OPERATION or the handle to
%      the existing singleton*.
%
%      GUI_OPERATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_OPERATION.M with the given input arguments.
%
%      GUI_OPERATION('Property','Value',...) creates a new GUI_OPERATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_operation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_operation_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_operation

% Last Modified by GUIDE v2.5 29-Nov-2018 09:50:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_operation_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_operation_OutputFcn, ...
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


% --- Executes just before gui_operation is made visible.
function gui_operation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_operation (see VARARGIN)

% Choose default command line output for gui_operation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_operation wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_operation_OutputFcn(hObject, eventdata, handles) 
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

dirname = uigetdir();
% squeeze . and ..
dirname = dirname(3:end);

set(handles.uipanel1, 'Title', dirname)
[str_fnames, str_pres, str_exts] = parse_dir_filename(dirname);
set(handles.popupmenu1, 'String', str_pres)
set(handles.popupmenu1, 'Value', 1)
set(handles.popupmenu2, 'String', str_exts)
set(handles.popupmenu2, 'Value', 1)

set(handles.text2, 'UserData', str_fnames)
[numbered_str_fnames, len] = number_filenames(str_fnames);
set(handles.text2, 'String', numbered_str_fnames)
set(handles.slider2, 'Visible', 'On')
set(handles.slider2, 'Value', 1)

set(handles.text3, 'String', sprintf('(%d files selected.)', len))
disp('Lastest selected files:')
disp(numbered_str_fnames)

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
dirname = get(handles.uipanel1, 'Title');
pre_contents = cellstr(get(handles.popupmenu1, 'String'));
pre = pre_contents{get(handles.popupmenu1, 'Value')};
ext_contents = cellstr(get(handles.popupmenu2, 'String'));
ext = ext_contents{get(handles.popupmenu2, 'Value')};

str_fnames = select_dir_filename(dirname, pre, ext);
set(handles.text2, 'UserData', str_fnames)
[numbered_str_fnames, len] = number_filenames(str_fnames);
set(handles.text2, 'String', numbered_str_fnames)
set(handles.slider2, 'Value', 1)

set(handles.text3, 'String', sprintf('(%d files selected.)', len))
disp('Lastest selected files:')
disp(numbered_str_fnames)


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
dirname = get(handles.uipanel1, 'Title');
pre_contents = cellstr(get(handles.popupmenu1, 'String'));
pre = pre_contents{get(handles.popupmenu1, 'Value')};
ext_contents = cellstr(get(handles.popupmenu2, 'String'));
ext = ext_contents{get(handles.popupmenu2, 'Value')};

str_fnames = select_dir_filename(dirname, pre, ext);
set(handles.text2, 'UserData', str_fnames)
[numbered_str_fnames, len] = number_filenames(str_fnames);
set(handles.text2, 'String', numbered_str_fnames)
set(handles.slider2, 'Value', 1)

set(handles.text3, 'String', sprintf('(%d files selected.)', len))
disp('Lastest selected files:')
disp(numbered_str_fnames)


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
v = get(hObject, 'value');
str_fnames = get(handles.text2, 'UserData');
set(handles.text2, 'String', number_filenames(str_fnames, v))

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'UserData', containers.Map)


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
num1 = str2double(get(handles.edit1, 'String'));
if isnan(num1)
    return
end
num2 = str2double(get(handles.edit2, 'String'));
if isnan(num2)
    return
end

str_nums = sprintf('%d, %d', num1, num2);
set_map = get(handles.listbox2, 'UserData');
set_map(str_nums) = 1;
set(handles.listbox2, 'UserData', set_map)

update_block_design(handles)

function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
num = str2double(get(hObject, 'String'));
if isnan(num)
    num = 180;
    set(hObject, 'String', num2str(num))
end
update_block_design(handles)


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function update_block_design(handles)
set(handles.text11, 'String', '')

% update hrf
object = handles.axes2;
contents = cellstr(get(handles.popupmenu4, 'String'));
s = contents{get(handles.popupmenu4, 'Value')};
hrf = eval(s);
plot(object, hrf)
set(object, 'Box', 'off')
set(object, 'XTick', '')
set(object, 'YTick', '')
title(strrep(s, '_', '\_'))

% update block_design
object = handles.axes1;
num = str2double(get(handles.edit3, 'String'));
block_design = zeros(floor(num), 1);

set_map = get(handles.listbox2, 'UserData');
cell_map = keys(set_map);
for j = 1 : length(cell_map)
    nums = strsplit(cell_map{j}, ', ');
    num1 = str2double(nums{1});
    num2 = str2double(nums{2});
    if num1 < 0
        set(handles.text11, 'String', sprintf('（%s）非法，请检查！', cell_map{j}))
    end
    if num2 < 0
        set(handles.text11, 'String', sprintf('（%s）非法，请检查！', cell_map{j}))
    end
    if num1 + num2 > length(block_design)
        set(handles.text11, 'String', sprintf('（%s）非法，请检查！', cell_map{j}))
    end
    if sum(block_design(num1:(num1+num2))) > 0
        set(handles.text11, 'String', sprintf('（%s）处检测到冲突，请检查！', cell_map{j}))
    end
    block_design(num1:(num1+num2)) = 1;
end

plot(object, conv(block_design, hrf, 'same'))
set(object, 'Box', 'off')
set(object, 'YTick', '')
set(object, 'XLim', [1, num])
xtick = linspace(0, num, 5);
xtick(1) = 1;
set(object, 'XTick', xtick)

% update listbox2, block design listbox
object = handles.listbox2;
set_map = get(object, 'UserData');
set(object, 'String', keys(set_map))
contents = cellstr(get(object, 'String'));
if ~isempty(contents)
    try
        str = contents{get(object, 'Value')};
    catch
        set(object, 'Value', set_map.Count)
        str = contents{get(object, 'Value')};
    end
    nums = strsplit(str, ', ');
    num1 = str2double(nums{1});
    set(handles.edit1, 'String', num2str(num1))
    num2 = str2double(nums{2});
    set(handles.edit2, 'String', num2str(num2))
    axe1 = handles.axes1;
    yl = get(axe1, 'YLim');
    hold on
    line(axe1, [num1, num1], yl, 'color', 'black')
    line(axe1, [num1+num2, num1+num2], yl, 'color', 'black')
    rectangle(axe1, 'Position', [num1, yl(1), num2, yl(2)-yl(1)],...
        'facecolor', [0.5, 0.5, 0.5, 0.5],...
        'edgecolor', [0.5, 0.5, 0.5, 1])
    hold off
end

% update popupmenu4, hrf popupmenu
object = handles.popupmenu4;
set_map = get(object, 'UserData');
set(object, 'String', keys(set_map))


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
update_block_design(handles)


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set_map = containers.Map;
set_map('spm_hrf(2)') = 1;
set(hObject, 'UserData', set_map)


function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
set_map = get(handles.popupmenu4, 'UserData');
str = get(hObject, 'String');
try
    hrf = eval(str);
catch
    set(handles.text11, 'String', sprintf('%s 非法，请检查！', str))
    return
end
sum(hrf)
if abs(sum(hrf)-1) > 0.1
    warndlg(sprintf('%s 积分不为1，不符合HRF函数性质，请谨慎使用！', str))
end
set_map(str) = 1;
set(handles.popupmenu4, 'UserData', set_map)
update_block_design(handles)


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_map = get(handles.listbox2, 'UserData');
if set_map.Count == 0
    return
end
contents = cellstr(get(handles.listbox2, 'String'));
remove(set_map, contents{get(handles.listbox2, 'Value')})
set(handles.listbox2, 'UserData', set_map)
update_block_design(handles)

% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2

update_block_design(handles)
