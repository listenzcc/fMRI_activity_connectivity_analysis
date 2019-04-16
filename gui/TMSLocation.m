close all
clear
clc

appPath = fileparts(which('TMSLocation'));
addpath(fullfile(appPath, 'TMSL_guis'))
addpath(fullfile(appPath, 'TMSL_tools'))
addpath(fullfile(appPath, 'TMSL_tools'))
addpath(genpath(fullfile(appPath, 'TMSL_tools', 'spm12')))
% gui2_welcome
TMSL_gui