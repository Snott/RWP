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
%% <--- кнопки боковой панели
namePB = 'new';
    MW = NewPB(MW,namePB);
    MW = CreatePanelNomber1(MW,MW.CounterPB);
namePB = 'new2';
    MW = NewPB(MW,namePB);
namePB = 'new3';
    MW = NewPB(MW,namePB);
%%   
SetActivePG(0,0,MW, 1)
ButtonDownCallback(MW);    

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
MW.sizePB.height = 20;
MW.sizePB.width = 150;
MW.panelPB.backgroundcolor = [4,5,6]/10;
MW.panel.backgroundcolor    = [8,7.5,7]/10;

function MW = PanelPB(MW)
MW.panelPB.position = [MW.panelPB.d, MW.panelPB.d, ...
    MW.panelPB.width, MW.win.height-2*MW.panelPB.d];
MW.panelPB.handle = uipanel(MW.handle, 'Units', 'pixels', ...
    'Position',  MW.panelPB.position, 'BorderType', 'none', ...
	'BackgroundColor', MW.panelPB.backgroundcolor);

function MW = NewPB(MW, name) 
MW.CounterPB = MW.CounterPB + 1;
MW.PG{MW.CounterPB}.handle = uipanel(MW.handle, 'Title', name, ... 
                'BackgroundColor', MW.panel.backgroundcolor );
set(MW.PG{MW.CounterPB}.handle, 'Units', 'pixels');
set(MW.PG{MW.CounterPB}.handle, 'Position', MW.panelPosition);   
MW.PB{MW.CounterPB}.handle = uicontrol(MW.panelPB.handle...
    , 'Style', 'radiobutton', 'Units', 'pixels');
set(MW.PB{MW.CounterPB}.handle, ...
       'Position', [MW.panelPB.d, ...
       MW.panelPB.height-round((MW.CounterPB)* ...
       (MW.sizePB.height+MW.panelPB.d))-MW.panelPB.d, ...
       MW.sizePB.width-MW.panelPB.d*2, ...
       MW.sizePB.height], ...
       'String', ['<html><b>',name,'']);
%    'String', ['<html><b>',name,' &#9658;</html>']);
MW.PB{MW.CounterPB}.num = MW.CounterPB;   
SetActivePG(0,0,MW,MW.CounterPB); 

function SetActivePG(~,~,MW, num)
    for ii = 1:MW.CounterPB
        if ii ~= num
            set(MW.PG{ii}.handle, 'Visible', 'Off');
            set(MW.PB{ii}.handle, 'Value', 0);
        else
          	set(MW.PG{ii}.handle, 'Visible', 'On');
            set(MW.PB{ii}.handle, 'Value', 1);
        end     
    end
  	drawnow;

function ButtonDownCallback(MW)    
for ii = 1:MW.CounterPB
    set(MW.PB{ii}.handle,'Callback', {@SetActivePG,MW,ii});  
end

function closeSPE(name)
nh = get(0,'children');
for ii = 1 : length(nh)
    if strcmp ( get(nh(ii),'name' ), name )
        close(nh(ii))
    end
end

function MW = CreatePanelNomber1(MW, CounterPB)
% много повторов нужен метод
CounterUic = 0;
CounterUic = CounterUic + 1;
 MW.PG{CounterPB}.text1 = ...
     uicontrol( MW.PG{CounterPB}.handle,...
     'style','text',...
     'String','Входные параметры',...
     'Position',[MW.panelPB.d, ...
     MW.panelPB.height-round( CounterUic* ...
     (MW.sizePB.height+MW.panelPB.d))-2*MW.panelPB.d, ...
     MW.sizePB.width-MW.panelPB.d*2, ...
     MW.sizePB.height] );
 CounterUic = CounterUic + 1;
 MW.PG{CounterUic}.text2 =   ...
     uicontrol( MW.PG{CounterPB}.handle,...
     'style','text',...
     'String','Высота антенны, м',...
     'Position',[MW.panelPB.d, ...
     MW.panelPB.height-round( CounterUic* ...
     (MW.sizePB.height+MW.panelPB.d))-2*MW.panelPB.d, ...
     MW.sizePB.width-MW.panelPB.d*2, ...
     MW.sizePB.height] );
 MW.PG{CounterUic}.edit2 =   ...
     uicontrol( MW.PG{CounterPB}.handle,...
     'style','edit',...
     'String','10',...
     'Position',[ MW.sizePB.width, ...
     MW.panelPB.height-round( CounterUic* ...
     (MW.sizePB.height+MW.panelPB.d))-2*MW.panelPB.d, ...
     MW.sizePB.width-MW.panelPB.d*2, ...
     MW.sizePB.height] );






















