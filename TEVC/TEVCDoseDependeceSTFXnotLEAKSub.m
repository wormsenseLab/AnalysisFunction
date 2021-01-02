% Load MetaDataFile either hardcoded (1) or by openeing a dialog box (0)
    % see template here...
    % script is asking for some headers specifically. You can include
    % headers, but don't delete or change them (except for solution headers).
    % All used solutions must be in the col AllSolutions. The order does
    % not matter (you can change the header of solutions, if you change it in the AllSolutions col as well)
    % col Rating 1-4, with 4 being best; 0 means not assigned, Don't use NaN. Output Table is not working then
    % Make sure, path with all functions is enabled
    % one col Before; one col after (?)
%ToD9O
% analze dose-response curves
% include comments in table

%
%%  load dat.files 
clear all; close all; clc;
ephysData=ImportPatchData();
% is in the patchfunction folder ephys

%% Load Meta Data TEVC
% load notes to get several values automatically needed for the conversion of the signals
loadFileMode = 0; %0 opens dialpg window to choose file; 1 loads file with specific name
%change here, if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('TEVCMetadataSTFX022.xlsx'); % folder in which saved must me open in Matalb. 
end

%% Analysis Individual Recording 
close all; clc

%%% hardcoding part: %%%%%%%
%makelots = 1; % if 1 than make plots, if 0 then skip
a1 = 3; %first file to be analyzed: (start with 2, because 1 is col header)
a2 = LastFile; %for last File script must run o8ce LastFile ; %(last file to be analyzed; either number or variable LastFile;)
%LeakFile = 'NaGlu(300EIPA)';
LeakFile = 'NaGluBefore';
stimuli = 'STEPSens';
%%%%% !!!!!!!!!
DimRefill = 4; %change if File8 was not a Step : maybe, find first step protocol...
%this needs to be changed, because stupidly hardcoded
%DimOfA = cell2mat(A(8)); %TODO: needs to be a file with Step protocol.
% needs to replace other protocols than StepSens with NaN values; shorting
% the input does not work, because the series are hardcoded in the metadata
% sheet


%%%%%%%%%%
AllCol = []; headers = []; indCellID = [];
headers = raw(1,:); % saw 1st row of raw data as headers
indCellID = find(strcmpi(headers, 'CellID')); % find col where the CellID is stored
AllCol = raw(:,indCellID); %make a variable with all used CellIds from Metadatasheet
%remove isnan from cell arraz AllCol; 
%stimuli = 'ContRamp1550'; % stimuli used to be analyzed. so far only one protocol
%AllCol(cellfun(@isnan, AllCol)) = [] %does not work
fh = @(x) all(isnan(x(:)));
findIsNanVal = @(x) all(isnan(x(:)));
AllCol(cellfun(findIsNanVal, AllCol)) = [];
LastFile = length(AllCol); %Determines the lenth of the column, so the last file to analyze
%DetermineLengthCol = length(AllCol);

%get AnimalID from col 2; hardcoded,because I need the value to save file
%first and "name" of row appears only in the for loop.
indAnimalID = find(strcmpi(headers, 'Animal ID')); 
AnimalID = raw(2,indAnimalID); 
AnimalID = cell2mat(AnimalID);

%ToDO: include output table here
% Make table, where I can add all analyzed cells
TestSol = {};
Injection = {};
Rating ={};
CultivationSol = {};
DaysPostInj = {};
CellIDRec = {};
Voltage = {};
MeanSTEPs = {};
CurMinus85 = {};
LEAKMinus85 = {};

T = table(CellIDRec,Injection,CultivationSol,DaysPostInj,Rating,Voltage,CurMinus85,MeanSTEPs,LEAKMinus85,TestSol);%
%TODO: including all in one table from one "frog" does not work yet
% filename = sprintf('DoseDependence-%s.txt',AnimalID); %define table
% writetable(T,filename,'Delimiter','\t','WriteRowNames',true)


for i=a1:a2%1:LastFile;% %start with 2, because 1st value is header; shorten here, if you want to analyze less
callCellID = {}; name = [];
callCellID = raw(i,indCellID);
name = callCellID{1};
headers = raw(1,:);
FindRowIndCellId = strcmpi(raw,name); % name = recorded cell
[RowCellId,col] = find(FindRowIndCellId,1);
CellID = raw(RowCellId,indCellID); % get Cell ID to include into output table

%get protocol used
%indProtokoll = find(strcmpi(headers, 'protocol')); 
%stimuli = raw(RowCellId,indProtokoll);
%stimuli = cell2mat(stimuli);

%ToDO: get all parameters from datasheet here
%get Group/Injection Mix
indInjectionMix = find(strcmpi(headers, 'InjectionMix')); 
InjectionMix = raw(RowCellId,indInjectionMix); 
%InjectionMix = cell2mat(InjectionMix); leave it out here, because I save
%the table as cells

%get rating/quality of recording (subjective)
indRating = find(strcmpi(headers, 'Rating')); 
Rating = raw(RowCellId,indRating); 

%get cultivation Solution
indCultivationSolution = find(strcmpi(headers, 'CultivationSolution')); 
Cultivation = raw(RowCellId,indCultivationSolution); 

%get recording day post injection (dpi)
indDPI = find(strcmpi(headers, 'Days Post-injection')); 
DPI = raw(RowCellId,indDPI); 

% %get AnimalID to save file per Injection
% indAnimalID = find(strcmpi(headers, 'Animal ID')); 
% AnimalID = raw(RowCellId,indAnimalID); 
% AnimalID = cell2mat(AnimalID); %convert to char to use it as string variable to save data according to Injection
% 

% ToDo:
Files = 1:length(ephysData.(name).protocols);
A=[]; V= [];  % to get an empty array, if I analyzed different files before
for i = Files(:,1):Files(:,end);
A{i} = ephysData.(name).data{1, i}; %Current
V{i} = ephysData.(name).data{2, i}; %Voltage
end

DimOfA = cell2mat(A(DimRefill));% hardcoded to get current dimension of step protocol
DimOfA2 = size(DimOfA);
% MAYBE DON'T INCLUDE, because then series order would change
%   find all files with certain protocol name: 
% ifelse statement: if not respective stimuli name (FiveStep or FiveRampHold), then empty array; 



for i = Files(:,1):Files(:,end);
   if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 1 & size(A{1, i},2) == size((DimOfA),2);%isequal(size(A{1, i},2),size((DimOfA),2))
%        if size(A{1, i},2)<max(DimOfA2(2))
%            A{1, i} = NaN(DimOfA2(1),DimOfA2(2)); ; V{1, i} = NaN(DimOfA2(1),DimOfA2(2));  % of protocl was interupted and fewer steps than the dimension, replace with NaN
         continue  
   else
     
 %          if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 0; % if other stimuli than step fil up with NaNs that sries in metadata sheet match
    A{1, i} = NaN(DimOfA2(1),DimOfA2(2)); ; V{1, i} = NaN(DimOfA2(1),DimOfA2(2));  
  %         else
   %            continue
    %       end 
     %  end
   end
end


% for i = Files(:,1):Files(:,end);
%    if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 1;
%        if size(A{1, i},2)<max(DimOfA2(2))
%            A{1, i} = NaN(DimOfA2(1),DimOfA2(2)); ; V{1, i} = NaN(DimOfA2(1),DimOfA2(2));  % of protocl was interupted and fewer steps than the dimension, replace with NaN
%        else
%            continue
%            if find(strcmpi(ephysData.(name).protocols{1,i}, stimuli)) == 0; % if other stimuli than step fil up with NaNs that sries in metadata sheet match
%     A{1, i} = NaN(DimOfA2(1),DimOfA2(2)); ; V{1, i} = NaN(DimOfA2(1),DimOfA2(2));  
%            else
%                continue
%            end 
%        end
%    end
% end


%Error using cat
%Dimensions of matrices being concatenated are not consistent.

%%%% TODO: Do I want to delete single series?
%%% TODO: delete stimuli which are less then 830x7, because I broke the
%%% step protocol

%To remove empty cell arrays, if other protocols than the stimulus were
%used

%AShort = A(~cellfun('isempty',A)); VShort = V(~cellfun('isempty',V));
AShort = A; VShort = V;
%AShort = A(~cellfun('isempty',A, NaN));
Aall3D = cat(3, AShort{:});
AMeanMinus85 = []; AMeanMinus85Series = [];
AMeanMinus85 = mean(mean(Aall3D(100:200,:,:))); %ToDO: Not hardcode
AMeanMinus85Series = permute(AMeanMinus85,[1 3 2]); % reorder the dimensions
AMeanMinus85Series = reshape(AMeanMinus85Series,[],size(AMeanMinus85,2),1); %reduce from 3 dimensions to 2D; Averaging all -85 current over all 
Vall3D = cat(3, VShort{:});
figure()
plot(AMeanMinus85Series, 'o')
 legend(InjectionMix)
 title('if there is no data curve change number in DimRefill')
 
%TODO: pay attention with AShort, because Series then are maybe not  
AMean = mean(Aall3D(400:700,:,:)); %ToDo: Not hardcoded
VMean = mean(Vall3D(400:700,:,:)); 


AllSolutions = []; ;indSolutions = [];
CellIDSol = find(strcmpi(headers, 'AllSolutions'));
AllSolutions = raw(2:end,CellIDSol);
fh = @(x) all(isnan(x(:)));
AllSolutions(cellfun(fh, AllSolutions)) = [];

%ToDO: ERROR with NaN values. Include Sorting
Solutions = {}; indSolutions =[];%EndValSolutions =[];
for i = 1:length(AllSolutions)
    indSolutions(i,1) = find(strcmpi(headers, AllSolutions(i))); 
    Solutions{i,1} =  raw(RowCellId,indSolutions(i)); 
    %EndValSolutions{i} = cell2mat(Solutions{i}); problem, because length
    %does not fit % how to make a new variable in a loop
end


%fh = @(x) all(isnan(x(:)));
%Solutions(cellfun(fh, Solutions)) = [];


%TODO: % remove solutions which were not used during this recording
%TODO: sorting of data?
%TODO: calculate Vrev
%TODO: include concentrations


MEANConditions = []; MEANVoltageConditions = [];
for i = 1:length(AllSolutions);
CurSol = [];
CurSol = cell2mat(Solutions{i});
CurSol = str2num(CurSol) % converts char array to double
if isnan(CurSol)   
MEANConditions(i,:) = NaN;
MEANVoltageConditions(i,:) = NaN;
MEANMinus85Conditions(i) = NaN;
else
% ToDO: if only one step, than it is already a number, check PatchClamp
% SCript
%end
MEANConditions(i,:) = mean(AMean(:,:,CurSol(1):CurSol(end)),3);
MEANVoltageConditions(i,:) = mean(VMean(:,:,CurSol(1):CurSol(end)),3);
MEANMinus85Conditions(i) = mean(AMeanMinus85Series(CurSol(1):CurSol(end)));
end
end



%T0DO, what happens if one solution was not used; use same as in TEVC
%Solutions
VoltageMean = mean(MEANVoltageConditions);

%find index for Leak current were Solution is blocked with 300 uM Amiloride
% Leak = mean @ 300 uM Amiloride
Leak = []; XY = [];
for i = 1:length(AllSolutions);
    XY = cell2mat(AllSolutions(i));
%isLeak = strcmp('NaGlu(300Amil)',XY); 
isLeak = strcmp(LeakFile,XY); 
if isLeak == 1
    Leak = MEANConditions(i,:);
    LeakMinus85 =  MEANMinus85Conditions(i);
else 
    display 'Today is a great day'
end
end
 

% %Subtract Leak (@LeakFile Condition)
% SubMEANConditions = []; SubMEANMinus85Cond = [];
% for i = 1:length(AllSolutions);
% SubMEANConditions(i,:) = MEANConditions(i,:) - Leak;
% SubMEANMinus85Cond(i) = MEANMinus85Conditions(i) - LeakMinus85;
% end

%Don't Subtract Leak (@LeakFile Condition)
SubMEANConditions = []; SubMEANMinus85Cond = [];
for i = 1:length(AllSolutions);
SubMEANConditions(i,:) = MEANConditions(i,:);
SubMEANMinus85Cond(i) = MEANMinus85Conditions(i);
end


TestSolution = {}; InjectionMixExp = {}; RatingExp ={}; CultivationExp = {}; DPIExp ={}; CellIDExp = {};
LEAKMinus85 = [];
for i = 1:length(AllSolutions) % starts at 2, so i-1 to get the first value
       TestSolution(i)   = AllSolutions(i);
   InjectionMixExp(i,1) = InjectionMix(1);
   RatingExp(i,1) = Rating(1);
   CultivationExp(i,1) = Cultivation(1);
 DPIExp(i,1) = DPI(1);
    CellIDExp(i,1) = CellID(1); 
    LEAKMinus85(i,1) = LeakMinus85(1);
end

% 
RatingExp = cell2mat(RatingExp);
DPIExp = cell2mat(DPIExp);
% 
%convert into cell to export in table function together with other cell
%data that contain char

 SubMEANConditions = num2cell(SubMEANConditions); 
  SubMEANMinus85Cond = num2cell(SubMEANMinus85Cond)';
  MEANVoltageConditions = num2cell(MEANVoltageConditions);
LEAKMinus85 = num2cell(LEAKMinus85);
  TestSolution = TestSolution';
  
DrugSensitiveCurrent = {};
DrugSensitiveCurrent = SubMEANConditions;
DrugSensitiveCurrent = DrugSensitiveCurrent(1,:)';

%ToDO: same length as other columns in table to export. first fill with NaN
%values. or fill up with nan value afterwards...
%VoltageMeanDrugSensCur = NaN(1,length(AllSolutions))
%VoltageMeanDrugSensCur = num2cell(VoltageMeanDrugSensCur)
% VoltageMeanDrugSensCur = {};
 VoltageMeanDrugSensCur = MEANVoltageConditions(1,:)';

%multiply data with -1 for demonstration
%SubMEANConditions =  cellfun(@(x) x*-1,SubMEANConditions,'un',0);
SubMEANConditionsAbs ={};
SubMEANConditionsAbs =  cellfun(@(x) abs(x),SubMEANConditions,'un',0);
SubMEANMinus85Cond = cellfun(@(x) x*-1,SubMEANMinus85Cond,'un',0);

%figure()
%plot(SubMEANConditionsAbs)

%table variables
% ToDO, try to include %s here
TestSol = TestSolution; 
Injection = InjectionMixExp;
Rating = RatingExp;
CultivationSol = CultivationExp;
DaysPostInj = DPIExp;
CellIDRec = CellIDExp;
Voltage = MEANVoltageConditions;
MeanSTEPs = SubMEANConditionsAbs; 
CurMinus85 = SubMEANMinus85Cond;
LEAKMinus85 = LEAKMinus85;

% % 
T = table(CellIDRec,Injection,CultivationSol,DaysPostInj,Rating,Voltage,CurMinus85,MeanSTEPs,LEAKMinus85,TestSol);%
filename = sprintf('DoseDependenceTEVC-%s.txt',name); %define table
writetable(T,filename,'Delimiter','\t','WriteRowNames',true)


% 
% % fid = fopen(filename,'a');
% % fmt = varfun(@(x) class(x),T,'OutputFormat','cell');
% %  fmt(strcmp(fmt,'double'))={'%g'};
% % fmt(strcmp(fmt,'cell'))={'%s'};
% % fmt=[strjoin(fmt,',') '\n'];
% %  for r=1:size(T,1)
% %    x=table2cell(T(r,:));
% %    fprintf(fid,fmt,x{:});
% %  end
% %  fclose(fid);
end
%% 
%reload MeataData or something
%normalize dose response curves
%NormMeanCondSub = []; %Imax-Imin/I-Imin normalize from fit?

