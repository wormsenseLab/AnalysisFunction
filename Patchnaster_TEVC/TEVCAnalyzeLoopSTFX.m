
% Load MetaDataFile either hardcoded (1) or by openeing a dialog box (0)
    % see template here...
    % script is asking for some headers specifically. You can include
    % headers, but don't delete or change them (except for solution headers).
    % All used solutions must be in the col AllSolutions. The order does
    % not matter (you can change the header of solutions, if you change it in the AllSolutions col as well)
    % col Rating 1-4, with 4 being best; 0 means not assigned, Don't use NaN. Output Table is not working then
    % Make sure, path with all functions is enabled
%ToDO
% include comments in table
%%  load dat.files 
clear all; close all; clc;
ephysData=ImportPatchData();

% Import Function from Samata Katta
%% Load Meta Data TEVC
% load notes to get several values automatically needed for the conversion of the signals
loadFileMode = 0; %0 opens dialpg window to choose file; 1 loads file with specific name
%change here,  if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('TEVCMetadataSTFX022.xlsx'); % folder in which saved must me open in Matalb. 
end

%% Analysis Individual Recording-Day (frog) 
close all; clc

%%% hardcoding part: %%%%%%%
stimuli = 'ContRamp1550'; % stimuli used to be analyzed. so far only one protocol
%Ramp80COnt
makePlots = 0; % if 1 than make plot, if 0 then skip
a1 =2; %first file to be analyzed: (start with 2, because 1 is col header)
a2 = LastFile; %for last File script must run once LastFile ; %(last file to be analyzed; either number or variable LastFile;
%%%%%%%%
% to make a before (x1), drug (x2) and wash up (x3) trace plot, put number
% of last sries when drug used here
x1 = 3;
x2 = 4;
x3 = 5;
%%%%%%11
AllCol = []; headers = [];indCellID = [];
headers = raw(1,:); % saw 1st row of raw data as headers
indCellID = find(strcmpi(headers, 'CellID')); % find col where the CellID is stored
AllCol = raw(:,indCellID); %make a variable with all used CellIds from Metadatasheet
%remove isnan from cell array AllCol; 
%AllCol(cellfun(@isnan, AllCol)) = [] %does not work
findIsNanVal = @(x) all(isnan(x(:)));
AllCol(cellfun(findIsNanVal, AllCol)) = [];
LastFile = length(AllCol); %Determines the lenth of the column, so th elast file to analyze
%DetermineLengthCol = length(AllCol);


%get AnimalID from col 2; hardcoded,because I need the value to save file
%first and "name" of row appears only in the for loop.
indAnimalID = find(strcmpi(headers, 'Animal ID')); 
AnimalID = raw(2,indAnimalID); 
AnimalID = cell2mat(AnimalID); %convert to char to use it as string
%variable to save data according to Injection%
%AnimalID = 'STFX019'
% Make table, where I can add all analyzed cells
StartSol = {};% ToDO, try to include %s here
TestSol = {};
DELTA = {};
RATIO ={};
MeanSTART = {};
MeanTEST = {}; 
DELTAVrev = {};
VrevSTART = {};
VrevTEST = {}; 
Injection = {};
Rating = {};
CultivationSol = {};
DaysPostInj = {};
CellIDRec = {};
Date = {}; 

T = table(Date, CellIDRec,Injection,CultivationSol,DaysPostInj,Rating,StartSol,TestSol,MeanSTART,MeanTEST, DELTA,RATIO,VrevSTART, VrevTEST,DELTAVrev);%
filename = sprintf('RatioDeltaTEVC-%s.txt',AnimalID); %define table
%filename = sprintf('TEVCRatioDelta-%s.txt',name);
writetable(T,filename,'WriteVar', true)


% For loop to analyze all cells loaded from MetaData sheet.
% a1 and a2 can be changed at the beginning or here.
for i=a1:a2%1:LastFile;% %start with 2, because 1st value is header; shorten here, if you want to analyze less
try
callCellID = {}; name = [];
display(i)
callCellID = raw(i,indCellID);
name = callCellID{1};
headers = raw(1,:);
 FindRowIndCellId = strcmpi(raw,name); % name = recorded cell
[RowCellId,col] = find(FindRowIndCellId,1);
RowCellId = i;
FindRowIndCellId = i;
Duplicates = find(strcmpi(headers, 'CellDuplicates'));
CellID = raw(i,Duplicates);

%name = cell2mat(CellID);
%CellID = raw(RowCellId,indCellID); % get Cell ID to include into output table

% protocol names:
isContRamp1550  = strcmp('ContRamp1550',stimuli); 
%%%%%

%get Group/Injection Mix
indInjectionMix = find(strcmpi(headers, 'InjectionMix')); 
InjectionMix = raw(RowCellId,indInjectionMix); 
%InjectionMix = cell2mat(InjectionMix); leave it out here, because I save
%the table as cells

%get rating/quality of recording (subjective)
indRating = find(strcmpi(headers, 'Rating')); 
Rating = raw(RowCellId,indRating); 

%get date of recording (subjective)
indDate = find(strcmpi(headers, 'Recording Date')); 
Date = raw(RowCellId,indDate);

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

% load all data from all protocols 
A=[]; % to get an empty array, if I analyzed different files before
V=[];
% A = Current; V = Voltage

if isContRamp1550 == 1
indContRamp1550  = find(strcmpi(headers, 'ContRamp1550')); 
% get value and convert to number
SeriesContRamp1550 = raw(RowCellId,indContRamp1550); 
SeriesContRamp1550  = cell2mat(SeriesContRamp1550);
A = ephysData.(name).data{1, SeriesContRamp1550}; %Current
V = ephysData.(name).data{2, SeriesContRamp1550}; %Current
else
 display 'has to be changed'
end
%Filenumber = 1; % wil be used to extract sampling freuqnecy; first file loaded, maybe change (ToDO: check if I did it)
%Files = 1:length(ephysData.(name).protocols);% load all protocols  


% showing in command prompt: AllStimuli = patchmaster Filenumber;
AllStimuliBlocks = (find(strcmpi(ephysData.(name).protocols, stimuli)));

Aall = A;
Vall = V;

%toDo: test this
      SlopeVall = [];
  for j = 1:size(Vall,2);
        for i = 1:length(Vall)-1;
        SlopeVall(i,j) = Vall(i+1,j) - Vall(i,j);
        end
  end
    
% figure()
% plot(SlopeVall(:,392))
%
%current at -85 mv, get beginning and end of stimulus
% TODO: make control plot that STart and End are correct

StartMinus85 = [];
EndeMinus85 = [];
EndeRamp = [];
for i=1:size(Vall,2)
StartMinus85(i) = find([SlopeVall(:,i)] < -0.003,1,'first'); %-0.002
EndeMinus85(i) = find([SlopeVall(1:StartMinus85(i)*6,i)] < -0.003,1,'last');
EndeRamp(i) = find([SlopeVall(:,i)] < -0.002,1,'last');
end

% figure()
% plot(StartMinus85)
% hold on
% plot(EndeMinus85)
%print
%reminder = 'calculate Average from Start Minus85 for noit hardcoding'
% ToDO: calculate Average Start Minus and if StartMinus85(EndValSolutions) < Avg
% break

VallRamp = []; AallRamp = [];
VallRamp = Vall(EndeMinus85(1)+250:EndeRamp(1),:);
AallRamp = Aall(EndeMinus85(1)+250:EndeRamp(1),:);
CalVrevStart = [];
CalVrevEnde = [];
VallRampShort = [];

%figure()
%plot(AallRamp)

Vrev=[];
for i=1:size(Vall,2);
% if AallRamp(:,i) < 0.120-6 == 0% > 120E-9 == 0 
%     CalVrevEnde(i) = NaN;
%     CalVrevStart(i) = NaN;
%     Vrev(i) = NaN;
% elseif AallRamp(:,i) >  -300E-9 == 0%< -100E-9 == 0
%     CalVrevEnde(i) = NaN;
%     CalVrevStart(i) = NaN;
%     Vrev(i) = NaN;
% else
CalVrevEnde(i) = find([AallRamp(:,i)] >  120E-9,1,'first');
CalVrevStart(i) = find([AallRamp(:,i)] > -100E-9,1,'first');
VallRampShort = VallRamp(CalVrevStart(i):CalVrevEnde(i),i); % cannot save, because different length
AallRampShort = AallRamp(CalVrevStart(i):CalVrevEnde(i),i);
p = polyfit(VallRampShort,AallRampShort,1);
%Vrev = Current 0
%0 = x*m+b
%Vrev = -b/m
% b = p(2)
% m = p(1)
Vrev(i) = -p(2)/p(1);
end

%end



%toDo: delete certain sweeps, because cell got leaky?
% or, if error, skip, but write error message

%get indices for different solutions
[AllSolutions, EndValSolutions, MeanAllSolutions,MeanVrev] = TEVCSolutionsLoopSTFX(raw,name,StartMinus85,EndeMinus85,Aall,Vrev,headers,FindRowIndCellId,RowCellId,col);
MeanAllSolutions = MeanAllSolutions';
MeanVrev = MeanVrev';

% convert into a double 
EndValSolutionsNUM = []; % convert into a double
AllSolutionsNUM = {}; % remove solutions which were not used during this recording
MeanAllSolutionsNUM = [];
MeanVrevNUM = []; 

for i=1:numel(EndValSolutions)
    if ischar(EndValSolutions{i,1}) == 1;
        EndValSolutionsNUM(i,1) = NaN;
        AllSolutionsNUM{i,1} = NaN;  
        MeanAllSolutionsNUM(i,1) = NaN;
        MeanVrevNUM(i,1) = NaN;
    else
     EndValSolutionsNUM(i,1) = (EndValSolutions{i,1});
     AllSolutionsNUM{i,1} = (AllSolutions{i,1});
     MeanAllSolutionsNUM(i,1) = (MeanAllSolutions{i,1});
     MeanVrevNUM(i,1) = (MeanVrev{i,1});
    end
end
     
% SortData & do Ration and Delta Sort End of solution to be able to divide/take the delta value of each test solution with the solution beforehand

SortEndOfSolution = []; TransMeanAllSolutions=[]; SortMeanOfSolutions = [];TransAllSolutionsNUM = []; AllSolutionsNUM'; SortAllSolutions =[];SortMeanOfSolutions = [];
TransMeanVrevNUM = [];SortMeanVrevNUM =[];

[SortEndOfSolution sorted_index] = sort(EndValSolutionsNUM);
TransMeanAllSolutions= MeanAllSolutionsNUM';
TransAllSolutionsNUM =  AllSolutionsNUM';
TransMeanVrevNUM = MeanVrevNUM';

SortMeanOfSolutions = TransMeanAllSolutions(sorted_index);
SortMeanOfSolutions = SortMeanOfSolutions';

SortAllSolutions = TransAllSolutionsNUM(sorted_index);
SortAllSolutions = SortAllSolutions';

SortMeanVrev = TransMeanVrevNUM(sorted_index);
SortMeanVrev = SortMeanVrev';

%Remove additional NAN values from array
SortAllSolutions(cellfun(@(SortAllSolutions) any(isnan(SortAllSolutions)),SortAllSolutions)) = [];
SortMeanOfSolutions(isnan(SortMeanOfSolutions)) = [];
SortEndOfSolution(isnan(SortEndOfSolution)) = [];
SortMeanVrev(isnan(SortMeanVrev)) = []; %ToDo: can be a problem,if allSolutions longer 

%calculate Mean & Ration of TestSolution (Solution 2) from StartSolution (Solution 1)
RationMean = []; DeltaMean = []; StartSolution ={};TestSolution ={};MeanStart = [];MeanTest = [];
%InjectionMixCell = cellstr(InjectionMix);
VrevStart = []; VrevTest = []; DeltaVrev = [];
InjectionMixExp = {}; RatingExp ={}; CultivationExp = {}; DPIExp ={}; CellIDExp = {};
DateExp = {};

%change ratio; 1- test/start
for i = 2:length(SortEndOfSolution) % starts at 2, so i-1 to get the first value
    MeanStart(i-1,1)= SortMeanOfSolutions(i-1); 
    MeanTest(i-1,1) = SortMeanOfSolutions(i);  
  % RationMean(i-1,1) =  (SortMeanOfSolutions(i-1)-SortMeanOfSolutions(i))/SortMeanOfSolutions(i-1);
     RationMean(i-1,1) =  (SortMeanOfSolutions(i)/SortMeanOfSolutions(i-1));
     DeltaMean(i-1,1) =  SortMeanOfSolutions(i)-SortMeanOfSolutions(i-1);
  StartSolution(i-1,1) = SortAllSolutions(i-1); % divide test solution with previous solution (start solution)
   TestSolution(i-1,1) =  SortAllSolutions(i); % TestSolution
   InjectionMixExp(i-1,1) = InjectionMix(1);
   RatingExp(i-1,1) = Rating(1);
   DateExp(i-1,1) = Date(1);
   CultivationExp(i-1,1) = Cultivation(1);
   DPIExp(i-1,1) = DPI(1);
    CellIDExp(i-1,1) = CellID(1);
    if numel(SortMeanVrev) == length(SortEndOfSolution)
    VrevStart(i-1,1)= SortMeanVrev(i-1); 
    VrevTest(i-1,1) = SortMeanVrev(i);
    DeltaVrev(i-1,1) =  SortMeanVrev(i)-SortMeanVrev(i-1);
    else
         VrevStart(i-1,1)= NaN;
         VrevTest(i-1,1) = NaN;
         DeltaVrev(i-1,1) = NaN;
    end
end

RatingExp = cell2mat(RatingExp);
%DateExp = cell2mat(DateExp);
DPIExp = cell2mat(DPIExp);
      
%convert into cell to export in table function together with other cell
%data that contain char
  DeltaMean = num2cell(DeltaMean); 
  RationMean = num2cell(RationMean);
  MeanStart = num2cell(MeanStart);
  MeanTest = num2cell(MeanTest);
  DeltaVrev = num2cell(DeltaVrev);
  VrevStart = num2cell(VrevStart);
  VrevTest = num2cell(VrevTest);
  
%make a figure of the current @-85 over number of sweeps; calculate time
% calculate sampling frequency
%TODO: Calulcate the time; how it is right now introduces an error
%  interval = [];
%  fs = {};
%  fs = ephysData.(name).samplingFreq;  
%  fs = cell2mat(fs);
%    interval = 1/fs;   %%% get time interval to display x axis in seconds 
%   ENDTime = length(Aall)/fs; %%% don't remember why I complicated it
%   Time = (0:interval:ENDTime-interval)'; 
%   PointsMean = [];
% PointsMean = [1:1:size(Aall,2)];
% TimeMean = ENDTime * PointsMean;

MeanAll = [];
MeanAll = mean(Aall(StartMinus85+10:EndeMinus85-10,:));
MeanAll = MeanAll';
MeanAlluA = [];
MeanAlluA=MeanAll*(1*10^6);
VrevmV = [];
VrevmV = Vrev * 1000;
AalluA = [];
AalluA = Aall*(1*10^6);
LegendInj = InjectionMixExp(1);
LegendInj = cell2mat(LegendInj);
name2 = cell2mat(CellID)

MeanCurNaGlu = [];
MeanCurAmil = [];
MeanVolNaGlu = [];
MeanVolAmil = [];

% MeanCurNaGlu = (A(:,179:181));
% MeanCurAmil = mean(A(:,202:204));
% 


if makePlots == 1
%figure()
%plot(MeanAll,'o')
%legend(name)
figure()
plot(MeanAlluA,'o')
 legend(name2)
ylabel('Current at -85mV (uA)')
xlabel('Points')
figure()
plot(VrevmV,'o')
 legend(name2)
ylabel('Reversal Potential (mV)')
xlabel('Points')

%  figure()
%  hold on
% for i = 1:length(SortEndOfSolution)
%  plot(AalluA(:,SortEndOfSolution(i)-2:SortEndOfSolution(i)))
%  % legend(EndValSolutionsNUM(i))
%  hold on
% end

% 
%  figure()
%  plot(AalluA(:,x1-2:x1),'b')
%  % legend(EndValSolutionsNUM(i))
%  hold on
%  plot(AalluA(:,x2-2:x2), 'r')
%  legend(name2)
%   hold on
% plot(AalluA(:,x3-2:x3), 'c')
% 
% 
%  Meanx1 = []; MeanVolx1 = [];
%  Meanx1 = mean(A(:,x1-2:x1),2);
%  MeanVolx1 = mean(V(:,x1-2:x1),2);
%  
%  Meanx2 = []; MeanVolx2 = [];
%  Meanx2 = mean(A(:,x2-2:x2),2);
%  MeanVolx2 = mean(V(:,x2-2:x2),2);
%  
%  Meanx3 = []; MeanVolx3 = [];
%  Meanx3 = mean(A(:,x3-2:x3),2);
%  MeanVolx3 = mean(V(:,x3-2:x3),2);
%  

 
%  figure()
% plot(AalluA(:,1:3))
% hold on
% plot(AalluA(:,end-2:end20
% legend(name2,LegendInj)
 ylabel('Current (uA)')
 xlabel('Sweep length (ms) - (interval 4 s)')

end
%TODO: add a line to each solutions for a quick overview what was performed
% figure()
% for i=1:length(SortEndOfSolution);
% plot(MeanAll,'or')%(SortEndOfSolution(i)-SortEndOfSolution(i)+1:SortEndOfSolution(i),1),'o')
% %line(SortEndOfSolution(i)-SortEndOfSolution(i)+1:SortEndOfSolution(i),1)
% legend(name)
% hold on
% end
% hold on
%hline = refline([0 1]);
%hline.Color = 'r';

StartSol = StartSolution;% ToDO, try to include %s here
TestSol = TestSolution;
DELTA = DeltaMean;
RATIO = RationMean;
MeanSTART = MeanStart;
MeanTEST = MeanTest; 
DELTAVrev = DeltaVrev;
VrevSTART = VrevStart;
VrevTEST = VrevTest; 
Injection = InjectionMixExp;
Rating = RatingExp;
CultivationSol = CultivationExp;
DaysPostInj = DPIExp;
CellIDRec = CellIDExp;
Date = DateExp;


T = table(Date, CellIDRec,Injection,CultivationSol,DaysPostInj,Rating,StartSol,TestSol,MeanSTART,MeanTEST, DELTA,RATIO,VrevSTART, VrevTEST,DELTAVrev);
%display(CellIDRec);

fid = fopen(filename,'a');
fmt = varfun(@(x) class(x),T,'OutputFormat','cell');
 fmt(strcmp(fmt,'double'))={'%g'};
fmt(strcmp(fmt,'cell'))={'%s'};
fmt=[strjoin(fmt,',') '\n'];
 for r=1:size(T,1)
   x=table2cell(T(r,:));
   fprintf(fid,fmt,x{:});
 end

 fclose(fid);

    catch
        display 'there were an error; This file will be skipped for analysis.'
        display 'Debugging: type "name" in the command window below to figure our the file name.'
        display 'typical error: 1) check if the file exist in the data structure ephysData on the right in Workspace.'
        display '2) Verify that the name in MetaData Sheet is correct.'
        display 'Check if you entered the correct series'
        continue
    end
    

end





