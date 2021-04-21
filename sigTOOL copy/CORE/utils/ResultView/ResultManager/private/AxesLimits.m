function tp=AxesLimits(tp)
Foreground=java.awt.Color(64/255,64/255,122/255);
Background=java.awt.Color(1,1,0.9);

p=uipanel('Parent', tp.Panel.uipanel,...
    'Units', 'normalized',...
    'Position',[0.05 0.425 0.85 0.2],...
    'Tag', 'sigTOOLResultManagerAxesLimits');

tp.AxesLimits.Panel=jcontrol(p, 'javax.swing.JPanel',...
    'Units', 'normalized',...
    'Position',[0 0 1 1],...
    'Foreground', Foreground,...
    'Background', Background,...
    'Border',javax.swing.BorderFactory.createTitledBorder('Axes Limits'));

tp.AxesLimits.XLabel=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JLabel',...
    'Units', 'normalized',...
    'Position',[0.05 0.7 0.1 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'Text', 'X:');

tp.AxesLimits.XMin=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.15 0.7 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.XMax=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.55 0.7 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.YText=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JLabel',...
    'Units', 'normalized',...
    'Position',[0.05 0.55 0.1 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'Text', 'Y:');

tp.AxesLimits.YMin=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.15 0.55 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.YMax=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.55 0.55 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.ZText=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JLabel',...
    'Units', 'normalized',...
    'Position',[0.05 0.45 0.1 0.1],...
    'Foreground', Foreground,...
    'Background', Background,...
    'Text', 'Z:');

tp.AxesLimits.ZMin=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.15 0.4 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.ZMax=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JTextField',...
    'Units', 'normalized',...
    'Position',[0.55 0.4 0.4 0.15],...
    'Foreground', Foreground,...
    'Background', Background,...
    'ActionPerformedCallback', @LocalApply);

tp.AxesLimits.Apply=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JButton',...
    'Units', 'normalized',...
    'Position',[0.2 0.25 0.6 0.125],...
    'MouseClickedCallback', @LocalApply,...
    'Text', 'Apply');

tp.AxesLimits.ApplyToAll=jcontrol(tp.AxesLimits.Panel, 'javax.swing.JButton',...
    'Units', 'normalized',...
    'Position',[0.05 0.1 0.9 0.125],...
    'MouseClickedCallback', {@LocalApply, true},...
    'Text', 'Apply To All');

return
end

function LocalApply(hObject, EventData, applytoallflag)
fhandle=ancestor(hObject.hghandle,'figure');
if nargin==2 || applytoallflag==false
    ax=findall(fhandle, 'Type', 'axes', 'Selected', 'on');
else
    ax=findall(fhandle, 'Type', 'axes');
end
if isempty(ax)
    return
else
    tp=getappdata(fhandle, 'ResultManager');
    if isempty(tp)
        return
    end
    s=tp.AxesLimits;
    
    x=zeros(1,2);
    y=zeros(1,2);
    z=zeros(1,2);
    
    for k=1:length(ax)
        x(1)=str2double(s.XMin.getText());
        x(2)=str2double(s.XMax.getText());
        XLim=get(ax(k), 'XLim');
        x(isnan(x))=XLim(isnan(x));
        set(ax(k), 'XLim', x);
        y(1)=str2double(s.YMin.getText());
        y(2)=str2double(s.YMax.getText());
        YLim=get(ax(k), 'YLim');
        y(isnan(y))=YLim(isnan(y));
        set(ax(k), 'YLim', y);
        if ~is2D(ax)
            z(1)=str2double(s.ZMin.getText());
            z(2)=str2double(s.ZMax.getText());
            ZLim=get(ax(k), 'ZLim');
            z(isnan(z))=ZLim(isnan(z));
            set(ax(k), 'ZLim', z);
        end
    end
end

scUpdateAxisControls(fhandle, 'ResultManager', ax)
return
end

