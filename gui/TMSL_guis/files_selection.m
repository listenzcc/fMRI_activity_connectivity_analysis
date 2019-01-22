function varargout = files_selection(varargin)
% FILES_SELECTION MATLAB code for files_selection.fig
%      FILES_SELECTION, by itself, creates a new FILES_SELECTION or raises the existing
%      singleton*.
%
%      H = FILES_SELECTION returns the handle to a new FILES_SELECTION or the handle to
%      the existing singleton*.
%
%      FILES_SELECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILES_SELECTION.M with the given input arguments.
%
%      FILES_SELECTION('Property','Value',...) creates a new FILES_SELECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before files_selection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to files_selection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help files_selection

% Last Modified by GUIDE v2.5 29-Nov-2018 14:42:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @files_selection_OpeningFcn, ...
                   'gui_OutputFcn',  @files_selection_OutputFcn, ...
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


function update_contents(handles)
% update listbox1
contents = cellstr(get(handles.popupmenu1, 'String'));
pre = contents{get(handles.popupmenu1,'Value')};
nopre = strcmp(pre, '*');
contents = cellstr(get(handles.popupmenu2, 'String'));
ext = contents{get(handles.popupmenu2,'Value')};
noext = strcmp(ext, '.*');
ext = ext(end:-1:1);
fname_map = get(handles.listbox1, 'UserData');
keys_fname = keys(fname_map);
cell_goodfnames = {};
i = 0;
for e = keys_fname
    s = e{1};
    if fun_startwith(s, pre) || nopre
        if fun_startwith(s(end:-1:1), ext) || noext
            i = i + 1;
            cell_goodfnames{i, 1} = s;
        end
    end
end
set(handles.listbox1, 'String', cell_goodfnames)

set(handles.text6, 'String',...
    sprintf('%d files selected, listed below:', length(cell_goodfnames)))


% --- Executes just before files_selection is made visible.
function files_selection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to files_selection (see VARARGIN)

% Choose default command line output for files_selection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes files_selection wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = files_selection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;

delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pathname = uigetdir();
set(handles.uipanel1, 'Title', pathname)

[fname_map, pre_map, ext_map] = fun_parse_files_in_path(pathname);
set(handles.listbox1, 'UserData', fname_map)
set(handles.popupmenu1, 'String', keys(pre_map))
set(handles.popupmenu2, 'String', keys(ext_map))
update_contents(handles)

set(handles.pushbutton3, 'Enable', 'on')


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
update_contents(handles)


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
mapset = containers.Map;
mapset('*') = 0;
set(hObject, 'UserData', mapset)
set(hObject, 'String', '*')


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
update_contents(handles)


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
mapset = containers.Map;
mapset('.*') = 0;
set(hObject, 'UserData', mapset)
set(hObject, 'String', '.*')


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1
contents = cellstr(get(hObject,'String'));
disp(contents{get(hObject,'Value')})


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
set(hObject, 'UserData', containers.Map)
set(hObject, 'String', '')


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ud = struct;
ud.pathname = get(handles.uipanel1, 'Title');
ud.filenames = get(handles.listbox1, 'String');
if isempty(ud.filenames)
    errordlg('Empty folder selected. please check!')
else
    handles.output = ud;
    guidata(hObject, handles)
    uiresume(handles.figure1)
end


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject);
else
    % The GUI is no longer waiting, just close it
    delete(hObject);
end
