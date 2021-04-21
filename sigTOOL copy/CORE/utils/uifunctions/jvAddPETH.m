function h=jvAddPETH(h)
% jvAddPETH addpanel function
% 
% Example:
% h=jvAddPETH(h)
%
% -------------------------------------------------------------------------
% Author: Malcolm Lidierth 11/07
% Copyright � The Author & King's College London 2007-
% -------------------------------------------------------------------------


Height=0.09;
Top=0.75;

h=jvAddPanel(h, 'Title', 'Details',...
    'dimension', 0.6);



h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top 0.8 Height],...
    'DisplayList', {'0.1' '0.2' '0.5' '1.0' '2.0'},...
    'Label', 'Duration(s)',...
    'ToolTipText', 'Duraion of average (s)');

h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(2*Height) 0.8 Height],...
    'DisplayList', {'0.001' '0.002' '0.005' '0.01' '0.02'},...
    'Label', 'Bin Width(s)',...
    'ToolTipText', 'PETH Bin Width (s)');

h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(4*Height) 0.8 Height],...
    'DisplayList', {'0' '10' '20' '50'},...
    'ReturnValues', {0 10 20 50},...
    'Label', 'PreTime(%)',...
    'ToolTipText', 'Pre-trigger time');


h=jvElement(h{end},'Component', 'javax.swing.JComboBox',...
    'Position',[0.1 Top-(6*Height) 0.8 Height],...
    'DisplayList', {'All' '10' '20' '50'},...
    'ReturnValues', {0 10 20 50},...
    'Label', 'Sweeps per average',...
    'ToolTipText', 'Overlap of successive data sections');


h=jvElement(h{end},'Component', 'javax.swing.JCheckBox',...
    'Position',[0.03 Top-(7*Height) 0.48 Height],...
    'Label', 'Retrigger',...
    'ToolTipText', 'Use triggers falling within a sweep');



return
end


