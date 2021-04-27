function [AllSolutions, EndValSolutions, MeanAllSolutions,MeanVrev] = TEVCSolutionsLoopSTFX(raw,name,StartMinus85,EndeMinus85,Aall,Vrev,headers,FindRowIndCellId,RowCellId,col)


%those steps are redundant, because
%headers = raw(1,:);
% FindRowIndCellId = strcmpi(raw,name); % name = recorded cell
% [RowCellId,col] = find(FindRowIndCellId,1);

AllSolutions = []; AllSolutions = [];indSolutions = [];
SolID = find(strcmpi(headers, 'AllSolutions')); % in which col are the solutions written down
AllSolutions = raw(2:end,SolID); % lists all solutions written in METADataSheet
fh = @(x) all(isnan(x(:))); %find all NaN values
AllSolutions(cellfun(fh, AllSolutions)) = []; %replace NaNValues

Solutions = {}; EndValSolutions =[];indSolutions =[];EndValSolutions = {};
for i = 1:length(AllSolutions)
    indSolutions(i,1) = find(strcmpi(headers, AllSolutions{i})); %Index in which column solutions were used
    Solutions{i,1} =  raw(RowCellId,indSolutions(i));  %End Values in which sweep solution was used
    EndValSolutions{i,1} = cell2mat(Solutions{i}); % End Values of Soluton converted, still a cell, but numbers inside are numbers
end

MeanAllSolutions = {};
MeanVrev = {};

% the MetaData are mostly imported as chars, so beforehand, I converted the
% EndValues which contained numbers to a number, I define that all the other char are NaN values.

%loops through different solutions used
for i = 1:length(AllSolutions)
    if ischar(EndValSolutions{i})  %convert char into NaN
        MeanAllSolutions{i} = NaN;
        MeanVrev{i} = NaN;
     else
  MeanAllSolutions{i}  = mean(mean(Aall(StartMinus85+10:EndeMinus85-10,EndValSolutions{i}-2:EndValSolutions{i})));%ERROR: mostly, if max(EndValSolutionsNUM) is bigger than size(A,2); then error in METAData; calculate mean of three Values: Endvalue entered into the MetaDatasheet Minus 2. If value is 20, using rows 18:20
    MeanVrev{i}  = nanmean(Vrev(EndValSolutions{i}-2:EndValSolutions{i}));
    end  
end
%MeanAllSolutionsTEST = mean(mean(Aall(StartMinus85+10:EndeMinus85-10,end-2:end)));
% ToDO: include 'end', but I am asking for the ischar command... 

end


% figure()
% plot(Aall)
%Solutions    
%NaGlu:
    % 100 mM NaGlu
    % 2 mM KCl
    % 2 mM MgCl2
    % 1 mM CaCl2
    % 10 mM NaHEPES
    % pH 7.4 NaOH
