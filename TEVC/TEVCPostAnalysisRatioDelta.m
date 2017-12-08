% 20171101 SF
% script for post Analysis of RatioDelta Data from TEVCAnalyzeLoopSTFX
% 

%%
clear all; close all; clc;

loadFileMode = 1; %0 opens dialpg window to choose file; 1 loads file with specific name
%change here,  if you want to select a file or load always the same
if loadFileMode  == 0; % 
[filename,pathname] = uigetfile('*.*', 'Load file', 'MultiSelect', 'on'); 
[numbers, text, raw] = xlsread([pathname, filename]);
elseif loadFileMode == 1
[numbers, text, raw] = xlsread('AllDataLX.xlsx'); % folder in which saved must me open in Matalb. 
end

%%
headers = raw(1,:);
Data = raw(2:end,:);

%get rating/quality of recording (subjective)
ColindInjection = find(strcmpi(headers, 'Injection')); 
%Injection = raw(i,ColindInjection);

InjectionMixes = unique(Data(:,ColindInjection));
 
%CHANGE analysis to have everthiny in a struct
%DataStruc = cell2struct(Data,'ALLdATA')

SeparateByInj = {};
for i = 1:length(InjectionMixes)
SeparateByInj{1,i}(1,:) = headers;
 for j = 1:length(Data)
  if  strcmp(Data(j,ColindInjection),InjectionMixes(i)) == 1
     SeparateByInj{1,i}(j+1,:) = Data(j,:);
    else
   %  SeparateByInj{1,i}(j+1,:) = {NaN};
     continue
  end
end
end



%work in progress; stupidly hardcoded. way to simplify it? 
%separate cell

x = length(SeparateByInj);

SheetsByInj = struct; % make struct to include one spreadsheet per injection mix

if 1 > x
    display 'not enough groups'
else
 Mix1 = SeparateByInj{1,1};
 nameMix1 = cell2mat(InjectionMixes(1));
[SheetsByInj(:).(nameMix1)] = Mix1;
end

if 2 > x
    display 'not enough groups'
else
Mix2 = SeparateByInj{1,2};
 nameMix2 = cell2mat(InjectionMixes(2));
[SheetsByInj(:).(nameMix2)] = Mix2;
end

if 3 > x
    display 'not enough groups'
else
Mix3 = SeparateByInj{1,3};
 nameMix3 = cell2mat(InjectionMixes(3));
[SheetsByInj(:).(nameMix3)] = Mix3;
end

if 4 > x
    display 'not enough groups'
else
Mix4 = SeparateByInj{1,4};
 nameMix4 = cell2mat(InjectionMixes(4));
[SheetsByInj(:).(nameMix4)] = Mix4;
end

if 5 > x
    display 'not enough groups'
else
Mix5 = SeparateByInj{1,5};
 nameMix5 = cell2mat(InjectionMixes(5));
[SheetsByInj(:).(nameMix5)] = Mix5;
end

if 6 > x
    display 'not enough groups'
else
Mix6 = SeparateByInj{1,6}
 nameMix6 = cell2mat(InjectionMixes(6))
[SheetsByInj(:).(nameMix6)] = Mix6
end

if 7 > x
    display 'not enough groups'
else
Mix7 = SeparateByInj{1,7};
 nameMix7 = cell2mat(InjectionMixes(7));
[SheetsByInj(:).(nameMix7)] = Mix7;
end

if 8 > x
    display 'not enough groups'
else
Mix8 = SeparateByInj{1,8};
 nameMix8 = cell2mat(InjectionMixes(8));
[SheetsByInj(:).(nameMix8)] = Mix8;
end

if 9 > x
    display 'not enough groups'
else
Mix9 = SeparateByInj{1,9};
 nameMix9 = cell2mat(InjectionMixes(9));
[SheetsByInj(:).(nameMix9)] = Mix9;
end

if 10 > x
    display 'not enough groups'
else
Mix10 = SeparateByInj{1,10};
 nameMix10 = cell2mat(InjectionMixes(10));
[SheetsByInj(:).(nameMix10)] = Mix10;
end

if 11 <= x
    display 'add more fields'
end

ColindTestSol = find(strcmpi(headers, 'TestSol'));
TestSolutionsUsed = unique(Data(:,ColindTestSol));
ColAmil =  find(strcmpi(TestSolutionsUsed, 'NaGluAmil(300)')); % struct can't work with paranthesis
ColIbu =  find(strcmpi(TestSolutionsUsed, 'NaGluIbu(300)'));


fns = fieldnames(SheetsByInj);
%SheetsByInj.(fns{3});

% Test1 = struct;
% %SeparateByTestSolMix1 = {};
% for i = 1:length(TestSolutionsUsed)
%     Test1. = headers;
% %     for j = 1:length(SheetsByInj.(fns{1}))-1
% %          if  strcmp(SheetsByInj.(fns{1})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
% %              SeparateByTestSolMix1{1,i}(j+1,:) = SheetsByInj.(fns{1})(j+1,:);  % can i add it here to a struct?
% %            % SheetsByInj.(fns{1}).TestSolutionsUsed = SheetsByInj.(fns{1})(j+1,:);
% %          else
% %               continue
% %          end
% %     end
% end

%for Mix1
if 1 <= x
SeparateByTestSolMix1 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix1{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{1}))-1
         if  strcmp(SheetsByInj.(fns{1})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix1{1,i}(j+1,:) = SheetsByInj.(fns{1})(j+1,:);  % can i add it here to a struct?
           % SheetsByInj.(fns{1}).TestSolutionsUsed = SheetsByInj.(fns{1})(j+1,:);
         else
              continue
         end
    end
end
else
    continue
end

%for Mix2
if 2 <= x
SeparateByTestSolMix2 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix2{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{2}))-1
         if  strcmp(SheetsByInj.(fns{2})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix2{1,i}(j+1,:) = SheetsByInj.(fns{2})(j+1,:);  
           % SheetsByInj.(fns{1}).TestSolutionsUsed = SheetsByInj.(fns{1})(j+1,:);
         else
              continue
         end
    end
end
else
    continue
end

%for Mix3
if 3 <= x
SeparateByTestSolMix3 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix3{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{3}))-1
         if  strcmp(SheetsByInj.(fns{3})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix3{1,i}(j+1,:) = SheetsByInj.(fns{3})(j+1,:);  
           % SheetsByInj.(fns{1}).TestSolutionsUsed = SheetsByInj.(fns{1})(j+1,:);
         else
              continue
         end
    end
end
else
    continue
end

%for Mix4
if 4 <= x
SeparateByTestSolMix4 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix4{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{4}))-1
         if  strcmp(SheetsByInj.(fns{4})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix4{1,i}(j+1,:) = SheetsByInj.(fns{4})(j+1,:);  
                    else
              continue
         end
    end
end
else
    continue
end

 %for Mix5
if 5 <= x
SeparateByTestSolMix5 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix5{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{5}))-1
         if  strcmp(SheetsByInj.(fns{5})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix5{1,i}(j+1,:) = SheetsByInj.(fns{5})(j+1,:);  
                    else
              continue
         end
    end
end
else
    continue
end


 %for Mix6
if 6 <= x
SeparateByTestSolMix6 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix6{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{6}))-1
         if  strcmp(SheetsByInj.(fns{6})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix6{1,i}(j+1,:) = SheetsByInj.(fns{6})(j+1,:);  
                    else
              continue
         end
    end
end
else
    continue
end

 %for Mix7
if 7 <= x
SeparateByTestSolMix7 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix7{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{7}))-1
         if  strcmp(SheetsByInj.(fns{7})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix7{1,i}(j+1,:) = SheetsByInj.(fns{7})(j+1,:);  
                    else
              continue
         end
    end
end
else
    continue
end

 %for Mix8
if 8 <= x
SeparateByTestSolMix8 = {};
for i = 1:length(TestSolutionsUsed)
    SeparateByTestSolMix8{1,i}(1,:) = headers;
    for j = 1:length(SheetsByInj.(fns{8}))-1
         if  strcmp(SheetsByInj.(fns{8})(j+1,ColindTestSol),TestSolutionsUsed(i)) == 1
             SeparateByTestSolMix8{1,i}(j+1,:) = SheetsByInj.(fns{8})(j+1,:);  
                    else
              continue
         end
    end
end
else
    continue
end
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
TestSolutionsUsed{ColAmil} = 'NaGluAmil300';
TestSolutionsUsed{ColIbu} = 'NaGluIbu300';

if 1 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{1}).(TestSolutionsUsed{i})] = SeparateByTestSolMix1{1,i}(:,:)
 end
 else
    continue
end

if 2 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{2}).(TestSolutionsUsed{i})] = SeparateByTestSolMix2{1,i}(:,:)
 end
 else
    continue
end

if 3 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{3}).(TestSolutionsUsed{i})] = SeparateByTestSolMix3{1,i}(:,:)
 end
 else
    continue
end

if 4 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{4}).(TestSolutionsUsed{i})] = SeparateByTestSolMix4{1,i}(:,:)
 end
 else
    continue
end

if 5 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{5}).(TestSolutionsUsed{i})] = SeparateByTestSolMix5{1,i}(:,:)
 end
 else
    continue
end

if 6 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{6}).(TestSolutionsUsed{i})] = SeparateByTestSolMix6{1,i}(:,:)
 end
 else
    continue
end

if 7 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{7}).(TestSolutionsUsed{i})] = SeparateByTestSolMix7{1,i}(:,:)
 end
 else
    continue
end

if 8 <= x
 for i = 1:length(TestSolutionsUsed)    
%     SheetsByInj.(fns{1}).TestSolutionsUsed(i) = SeparateByTestSolMix1{1,i}(:,:)
[SheetsByInj.(fns{8}).(TestSolutionsUsed{i})] = SeparateByTestSolMix8{1,i}(:,:)
 end
 else
    continue
end

if 11 < x
    display 'add more fields'
end

%%%%%%%%

%%
% ToDo try to get rid of empty array

for j= 1:size(Drug1,2)
A = SheetsByInj.(fns{1}).(TestSolutionsUsed{1})
 AShort = A(~cellfun('isempty',A))
 AShort(:,j) = A(~cellfun('isempty',A))
end
A = SheetsByInj.(fns{1}).(TestSolutionsUsed{1})
SheetsByInj.(fns{1}).(TestSolutionsUsed{1}) = SheetsByInj.(fns{1}).(TestSolutionsUsed{1})

%%
%
% 
% if length(SeparateByInj(1,1) 1
% Mix1 = SeparateByInj(1,1)
% 
% for i = 1:10%length(SeparateByInj)
%     if SeparateByInj==1
% SeparateByInj{1,i}(1,:) = headers;
%  for j = 1:length(Data)
%   if  strcmp(Data(j,ColindInjection),InjectionMixes(i)) == 1
%      SeparateByInj{1,i}(j+1,:) = Data(j,:);
%     else
%      SeparateByInj{1,i}(j+1,:) = {NaN};
%   end
% end
% end


% StartSol = StartSolution;% ToDO, try to include %s here
% TestSol = TestSolution;
% DELTA = DeltaMean;
% RATIO = RationMean;
% MeanSTART = MeanStart;
% MeanTEST = MeanTest; 
% DELTAVrev = DeltaVrev;
% VrevSTART = VrevStart;
% VrevTEST = VrevTest; 
% Injection = InjectionMixExp;
% Rating = RatingExp;
% CultivationSol = CultivationExp;
% DaysPostInj = DPIExp;
% CellIDRec = CellIDExp;
