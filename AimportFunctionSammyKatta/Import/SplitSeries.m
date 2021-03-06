% SplitSeries.m
% This function takes the collapsed data set (dCollapse) and splits it by
% group and series, assigning these as fields into the struct.
% 
% EXAMPLE:
%   [structA] = SplitSeries(tree, data, saveName, structA)
% 
% INPUTS:
%   tree        struct          The metadata tree, from importing a HEKA
%                               Patchmaster .dat file.
% 
%   data        cell            A 1xm cell containing all series and traces
%                               from all channels, as output by 
%                               ImportHEKAtoMat() and collapsed by
%                               ImportPatchData().
% 
%   saveName    char            The name of the file from which the data
%                               was imported, the date by default.
% 
%   structA     struct          The output data structure to which new
%                               fields will be appended. May be empty.
% 
% OUTPUTS:
%   structA     struct          Output data structure in same format, with
%                               newly appended fields representing groups.
%                               Each group is a struct, containing the
%                               original filename, the list of pgfs, and
%                               the data in a cell of dimensions (series,
%                               channel) for that group.
% 
% Created by Sammy Katta on 27 May 2014.

function [structA] = SplitSeries(tree, data, structA, saveName)

% Find which rows in tree contain group, series, and sweep metadata
grLoc = find(~cellfun('isempty',tree(:,2)));
seLoc = find(~cellfun('isempty',tree(:,3)));
% swLoc = find(~cellfun('isempty',tree(:,4)));

% Figure out how many series are in each group/biological cell by pulling
% the SeSeriesCount field for the last series in the group, and initialize
% a cell array of that length to hold data from that group
serTot = 1;
traceTot = 1;
for iGr = 1:length(grLoc)
    % Strip hyphens/other characters that are invalid in field names
    currGr = regexprep(tree{grLoc(iGr),2}.GrLabel,'[-/\s\0]','');
    
    % Find number of series in each group but don't get tripped up by the 
    % last group.
    if iGr<length(grLoc)
        nSer = length([tree{grLoc(iGr):grLoc(iGr+1),3}]);
%         nSer = tree{seLoc(find(seLoc<grLoc(iGr+1),1,'last')),3}.SeSeriesCount;
    else
        nSer = length([tree{grLoc(iGr):end,3}]);
%         nSer = tree{seLoc(end),3}.SeSeriesCount;
    end
    
    % Initialize cell array with space for 6 channels worth of data from a 
    % given series. For series where fewer than 6 channels are recorded, 
    % the cells in the last few rows will remain empty.
    grpData = cell(6,nSer);
    grpProt = cell(1,nSer);
    grpType = cell(6,nSer);
    grpUnit = cell(6,nSer);
    grpFs = cell(1,nSer);
    grpTimes = cell(1,nSer);
    grpHolds = cell(1,nSer);
    
    % Now let's figure out how many channels each series has and move the
    % corresponding data into our cell array.
    for iSer = 1:nSer
        
        % Name of pgf stim file used in each series
        grpProt{iSer} = tree{seLoc(serTot),3}.SeLabel;
        grpTimes{1,iSer} = tree{seLoc(serTot),3}.SeTime;
%         grpTimes{2,iSer} = tree{seLoc(serTot),3}.SeTimeMATLAB;
        grpFs{iSer} = 1/tree{seLoc(serTot)+2,5}.TrXInterval;
        grpHolds{iSer} = tree{seLoc(serTot),3}.SeAmplifierState.E9CCIHold;
        
        % Start at first trace in a series and move down until you hit a
        % blank to count number of channels/traces (this is not recorded in
        % either sweep or trace metadata, and is necessary for prying apart
        % multiple channels in one series)
        isTrace = 1;
        nChan = 0;
        chanType = cell(6,1);
        chanUnit = cell(6,1);

        
        while isTrace == 1
            if seLoc(serTot)+2+nChan > size(tree,1) ||...
                    isempty(tree{seLoc(serTot)+2+nChan,5})
                isTrace = 0;
            else
                nChan = nChan + 1;
                chanType{nChan} = tree{seLoc(serTot)+1+nChan,5}.TrLabel;
                chanUnit{nChan} = tree{seLoc(serTot)+1+nChan,5}.TrYUnit;
            end
        end
        
        
        % Assign data to proper location in cell array for that group. 
        % If there are multiple channels/traces per sweep for a given
        % series, Patchmaster stores them as separate series, one after
        % another, i.e., if the real series 5 recorded both current and
        % voltage, data(5) will contain the current and data(6) will 
        % contain the voltage.
        for iChan = 1:nChan
            grpData(iChan,iSer) = data(traceTot);
            grpType(:,iSer) = chanType;
            grpUnit(:,iSer) = chanUnit;
            traceTot = traceTot+1;
        end
        
        serTot = serTot+1;
    end
    
    % Save data to the appropriate group in the nested output struct.
    structA.(currGr).file = saveName;
    structA.(currGr).data = grpData;
    structA.(currGr).protocols = grpProt;
    structA.(currGr).channel = grpType;
    structA.(currGr).dataunit = grpUnit;
    structA.(currGr).samplingFreq = grpFs;
    structA.(currGr).startTimes = grpTimes;
    structA.(currGr).ccHold = grpHolds;

end

end
