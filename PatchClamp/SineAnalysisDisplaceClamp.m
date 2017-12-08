%%% Sylvia Fechner
%%% Stanford University, 
%%% 20171207
%%% Script to analyze data from FALCON-Sinus recordings in Displacement Clamp
%%% To commit to github
%%% go to my branch (patchmaster functions on dropbox)
%%% git add .
%%% git commit -m 'text'
%%% git push origin my branch


%%% ToDo 

%%  load dat.files 
clear all; close all; clc;
ephysData=ImportPatchData();
%load('ephysdata(20170130).mat')
%%
% load notes to get several values automatically needed for the conversion of the signals
loadFileMode = 1; % change here, if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('Ephys-Meta-Sylvia.xlsx'); % be careful in which Folder saved.
end


%% Analysis Individual Recording 
close all; clc

%%% hardcoding part:
name = 'STF118'; % name of recording. placed into varaibel fiels names%
stimuli = 'FiveSine'; 
OnlyMechano = 0; % if = 0, then FALCON, if 1, then ForceClamp Only 
ReadFromSheet = 0; % if = 0, then command promp to delete block, if 1, then read from MetaDataSheet 
% protocol names:
% Single protocols: Step and Ramp-Hold; 
% Five sweeps per protocol:FiveStep, FiveRampHold; does not work with alternative names
%%%%%

%Aall = current
%Ball = 
%Call = 
%Dall = 

[ActuSensor, fs,interval, Time, Aall, Ball, Call, Dall, Files, isFiveStep, isFiveRamp, isStep, isFiveSine, isFifteenStep, isIVStep] = SortFalconData(name,stimuli,ephysData, ReadFromSheet);

%
[SlopeActu,MaxZeroSlopeActu,StdZeroSlopeActu,MaxZeroActu,StdZeroActu,MaxActuSensorPlateau,StdActuSensorPlateau,CellMaxActuFirst] = SlopeThreshold(ActuSensor);  

figure()
plot()