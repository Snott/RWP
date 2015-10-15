function SPE_window
name = 'SPE v0.1.0016';
%% <--- сюда отдельную функцию с параметрами окна:
% размер, цвет и пр.
tic
OpenMW(name);
toc
% SaveTemp(MW);

function closeSPE(name)
nh = get(0,'children');
for ii = 1 : length(nh)
    if strcmp ( get(nh(ii),'name' ), name )
        close(nh(ii))
    end
end

function OpenMW(name)
global MW  % необходимо для корректного CallBack
closeSPE(name)
MW.handle = figure(...
    'Name', name,...
    'Units', 'pixels',...
    'Resize', 'off',...
    'NumberTitle', 'off',...
    'MenuBar', 'none');
SizeMW;
PanelPB;
MW.CounterPB = 0;
MW.CounterUicEdit = 0;
%% <--- кнопки боковой панели
namePB = 'Входные данные';
    NewPB(namePB);
    CreatePanelNomber1;
namePB = 'Пост обработка';
    NewPB(namePB);
namePB = 'Рисунки';
    NewPB(namePB);
%%   
SetActivePG(0,0,1)
ButtonDownCallback;    

function SizeMW
global MW
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
MW.panel.h = 0;
MW.panel.w = 0;

function PanelPB
global MW
MW.panelPB.position = [MW.panelPB.d, MW.panelPB.d, ...
    MW.panelPB.width, MW.win.height-2*MW.panelPB.d];
MW.panelPB.handle = uipanel(MW.handle, 'Units', 'pixels', ...
    'Position',  MW.panelPB.position, 'BorderType', 'none', ...
	'BackgroundColor', MW.panelPB.backgroundcolor);

function NewPB(name) 
global MW
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
       'String', ['<html><b>',name,'</html>']);
%    'String', ['<html><b>',name,' &#9658;</html>']);
MW.PB{MW.CounterPB}.num = MW.CounterPB;   
SetActivePG(0,0,MW.CounterPB); 

function SetActivePG(~,~, num)
global MW
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

function ButtonDownCallback
global MW
for ii = 1:MW.CounterPB
    set(MW.PB{ii}.handle,'Callback', {@SetActivePG,ii});  
end

function CreatePanelNomber1
% мб п
    newUicCol
    newUicText( 'Параметры антенны');
    newUicText( 'Высота антенны, м');
    newUicEdit( '10', 'heightAntenna');
    newUicRadio( 'антенна с заданной ДН','typeAntenna',1);
    newUicText( 'вид ДН антенны');
    newUicPopup(  {'<html>sin(x)/x','<html>sin(&theta)'},'beamTypeAntenna',1);    
    newUicText(  'ширина ДН, градусов');
    newUicEdit(  '5', 'beamWithAntenna');
    newUicText( 'наклон ДН, градусов');
    newUicEdit(  '0', 'beamTitlAntenna');
    newUicRadio( 'АФАР','typeAntenna',0);
    newUicText( 'количество элементов')
    newUicText( 'по вертикали');
    newUicEdit(  '100', 'Nx');
    newUicText( 'по горизонтали');
    newUicEdit( '100', 'Ny');
    
    newUicRadio( 'Зеркальная антенна','typeAntenna',0);
    newUicCol
    newUicText( 'Выбор задачи');
    newUicText( 'Размерность' );
    newUicPopup( {'2D','3D'} , 'dimProblem',1);
    newUicCol
    newUicText( 'Выбор чего-то');
    newUicText( 'параметр чего-то' );
    newUicEdit( '0','test' );
    
function newUicCol
global MW
    MW.panel.h = 0;
    MW.panel.w = MW.panel.w + 1;
 
function newUicText( string )
global MW
    MW.panel.h = MW.panel.h + 1;
    position = newUicPosition;
    uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','text',...
        'String',string,...
        'Position',position);
    
function newUicEdit( string, name)
global MW
    MW.CounterUicEdit = MW.CounterUicEdit + 1;
    position = newUicPosition2;
    MW.Edit{MW.CounterUicEdit}.handle = ...
        uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','edit',...
        'String',string,...
        'Position',position);    
    MW.Edit{MW.CounterUicEdit}.name = name;
    
function newUicPopup( string, name, value)
global MW
    MW.CounterUicEdit = MW.CounterUicEdit + 1;
    position = newUicPosition2;
    MW.Edit{MW.CounterUicEdit}.handle = ...
        uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','popupmenu',...
        'String',string,...
        'Position',position,...
        'value', value);    
    MW.Edit{MW.CounterUicEdit}.name = name;
    
function newUicRadio( string,name,value)
global MW
    MW.panel.h = MW.panel.h + 1;
    MW.CounterUicEdit = MW.CounterUicEdit + 1;
    position = newUicPosition;
    MW.Edit{MW.CounterUicEdit}.handle = ...
        uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','radiobutton',...
        'String',string,...
        'Position',position,...
        'value', value,...
        'backgroundcolor',[8 5 8]/10 ...
        );
    number = 1;
    for ii = 1 : (MW.CounterUicEdit-1)
        if isequal( MW.Edit{ii}.name, name)
            number = MW.Edit{ii}.number;     
        end
    end
    MW.Edit{MW.CounterUicEdit}.name = name;
    MW.Edit{MW.CounterUicEdit}.number = number;
    set(MW.Edit{MW.CounterUicEdit}.handle,...
        'callback',{@CallRadiobutton,MW.CounterUicEdit})
    
function CallRadiobutton(a,b,count)
global MW    
    name = MW.Edit{count}.name;
    for ii = 1 : MW.CounterUicEdit 
        if isequal( MW.Edit{ii}.name, name)
            set(MW.Edit{ii}.handle,...
                'value',0);
        end
    end  
    set(MW.Edit{count}.handle,...
    'value',1);
 
function position = newUicPosition
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*2 + MW.sizePB.width*(2*w-2)- ...
        MW.sizePB.width*0.15*(w-1), ...
        MW.panelPB.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width-MW.panelPB.d*2, ...
        MW.sizePB.height] ;
    
function position = newUicPosition2
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*2 + MW.sizePB.width*(2*w-1)-...
        MW.sizePB.width*0.15*(w-1), ...
        MW.panelPB.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width*0.7-MW.panelPB.d*2, ...
        MW.sizePB.height] ;    
 








%  function SaveTemp(MW)
%      size(MW);














