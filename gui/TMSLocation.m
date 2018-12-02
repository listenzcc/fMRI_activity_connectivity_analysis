close all
clear
clc

appPath = fileparts(which('TMSLocation'));
addpath(fullfile(appPath, 'TMSL_guis'))
addpath(fullfile(appPath, 'TMSL_tools'))

gui2_welcome