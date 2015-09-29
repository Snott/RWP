function SPE_window
name = 'SPE v0.1';
MW = OpenMW(name);

function MW = OpenMW(name)
closeSPE(name)
MW.handle = figure(...
    'Name', name,...
    'Units', 'pixels',...
    'Resize', 'off',...
    'NumberTitle', 'off',...
    'MenuBar', 'none');
MW = SizeMW(MW);
MW = PanelPB(MW);
MW.CounterPB = 0;
namePB = 'new';
MW = NewPB(MW,namePB);

function MW = SizeMW(MW)
scrSize = get(0,'ScreenSize');
xy = 0.1;
wh = 0.8;
MW.win.width = scrSize(3)*wh;
MW.win.height = scrSize(4)*wh;
% MW.win.X = scrSize(3)/2 - MW.win.Width/2;
% MW.win.Y = scrSize(4)/2 - MW.win.Height/2;
MW.win.x = scrSize(3)*xy;
MW.win.y = scrSize(4)*xy;
set(MW.handle, 'Position', [MW.win.x MW.win.y ...
    MW.win.width MW.win.height]);
MW.panelPB.d = 5;
MW.panelPB.width = 175;
MW.panelPB.height = MW.win.height-MW.panelPB.d;
MW.panelPosition = ...
    [MW.panelPB.width+2*MW.panelPB.d, MW.panelPB.d, ...
    MW.win.width-MW.panelPB.width-3*MW.panelPB.d,...
    MW.panelPB.height];

function MW = PanelPB(MW)
MW.panelPB.position = [MW.panelPB.d, MW.panelPB.d, ...
    MW.panelPB.width, MW.win.height-2*MW.panelPB.d];
MW.panelPB.backgroundcolor = [4,5,6]/10;
MW.panelPB.handle = uipanel(MW.handle, 'Units', 'pixels', ...
    'Position',  MW.panelPB.position, 'BorderType', 'none', ...
	'BackgroundColor', MW.panelPB.backgroundcolor);

function MW = NewPB(MW, name) 
MW.CounterPB = MW.CounterPB + 1;
MW.panel.backgroundcolor = [8,7.5,7]/10;
MW.PG{MW.CounterPB}.handle = uipanel(MW.handle, 'Title', name, ... 
                'BackgroundColor', MW.panel.backgroundcolor );
set(MW.PG{MW.CounterPB}.handle, 'Units', 'pixels');
set(MW.PG{MW.CounterPB}.handle, 'Position', MW.panelPosition);   
MW.PB{MW.CounterPB}.handle = uicontrol(MW.panelPB.handle...
    , 'Style', 'radiobutton', 'Units', 'pixels');
set(MW.PB{MW.CounterPB}.handle, 'Position', [MW.panelPB.d, ...
       MW.panelPB.height-round((MW.CounterBP)*(MW.h1+MW.d))...
         , MW.w1-MW.d*2, MW.h1], ...
           'String', ['<html><b>',Name,' &#9658;</html>']);
MW.PB{MW.CounterBP}.num = MW.CounterPB;   
setActivePG(0,0,MW,MW.CounterPB); 

function setActivePG(~,~,MW, num)
    for ii = 1:MW.CounterPB
        if ii ~= num
            set(MW.PG{ii}.handle, 'Visible', 'Off');
        else
          	set(MW.PG{ii}.handle, 'Visible', 'On');
        end     
    end
  	drawnow;


function closeSPE(name)
nh = get(0,'children');
for ii = 1 : length(nh)
    if strcmp ( get(nh(ii),'name' ), name )
        close(nh(ii))
    end
end

