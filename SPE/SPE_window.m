function SPE_window
name = 'SPE v0.1.0018';
%% <--- ���� ��������� ������� � ����������� ����:
% ������, ���� � ��.
% tic
OpenMW(name);
% toc
% SaveTemp(MW);

function closeSPE(name)
nh = get(0,'children');
for ii = 1 : length(nh)
    if strcmp ( get(nh(ii),'name' ), name )
        close(nh(ii))
    end
end

function OpenMW(name)
global MW  % ���������� ��� ����������� CallBack
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
MW.CounterUicPB = 0;
%% <--- ������ ������� ������
namePB = '������� ������';
    NewPB(namePB);
        CreatePanelNomber1;
    NewPB('��������� �����');
    NewPB('������');
namePB = '���� ���������';
    NewPB(namePB);
namePB = '�������';
    NewPB(namePB);
%% ������ ������ ������
newUicPBs;    
%%   
SetActivePG(0,0,1)
ButtonDownCallback;    

function SizeMW % ������ � ���� ���������
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
MW.sizePB.height = 20;
MW.panelPB.height = MW.win.height-1*MW.panelPB.d;
MW.panel.height =  MW.panelPB.height-4*MW.panelPB.d - MW.sizePB.height;
MW.panelPosition = ...
    [MW.panelPB.width+2*MW.panelPB.d, ...
    4*MW.panelPB.d + MW.sizePB.height, ...
    MW.win.width-MW.panelPB.width-3*MW.panelPB.d,...
    MW.panel.height];
MW.sizePB.width = 155;
MW.sizePB.widthK = 0.65;
MW.panelPB.backgroundcolor = [4,5,6]/10;
MW.panel.backgroundcolor    = [8,7.5,7]/10;
MW.panel.radiobackgroundcolor = [8 5 8]/10;
MW.panel.checkbackgroundcolor = [5 5 8]/10;
MW.panel.pushbackgroundcolor = [5 8 8]/10;
MW.panel.radio1backgroundcolor = [8 9 8]/10;
MW.panel.radio0backgroundcolor = [94 94 94]/100;

function PanelPB
global MW
MW.panelPB.position = [MW.panelPB.d, MW.panelPB.d, ...
    MW.panelPB.width, MW.win.height-2*MW.panelPB.d];
MW.panelPB.handle = uipanel(MW.handle, 'Units', 'pixels', ...
    'Position',  MW.panelPB.position, 'BorderType', 'none', ...
	'BackgroundColor', MW.panelPB.backgroundcolor);
% RTF
positionRis =  [175/2-140/2, MW.panelPB.d + MW.sizePB.height*2.1, ...
    140,  140];
pbRTF =  uicontrol(MW.panelPB.handle,'style','radiobutton'...
        ,'position', positionRis, 'enable','on');
        load('cdata.mat')
% pbRTF.ForegroundColor = MW.panelPB.backgroundcolor;      
pbRTF.BackgroundColor = MW.panelPB.backgroundcolor;
        set(pbRTF ,'CData', cdata);
% ���������� �� ������� ��������� ���������� �� ������:
positionBugs = [MW.panelPB.d, MW.panelPB.d, ...
    MW.panelPB.width - 2*MW.panelPB.d,  MW.sizePB.height*2.1];
uicontrol(MW.panelPB.handle, 'style','text'...
        ,'position' , positionBugs, ...%[20, 5, 135, 14+30]
        'BackgroundColor', MW.panelPB.backgroundcolor, 'string',...
        ' ���������� �� ������� ���������� �� ������ mihailovms@mail.ru');
    
MW.panelPB2.position = [MW.panelPosition(1), MW.panelPB.d, ...
    MW.panelPosition(3), MW.panelPB.d*2 + MW.sizePB.height];    
MW.panelPB2.handle = uipanel(MW.handle, 'Units', 'pixels', ...
    'Position',  MW.panelPB2.position, 'BorderType', 'none', ...
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
       MW.panelPB.width-MW.panelPB.d*2, ...
       MW.sizePB.height], ...
       'String', ['<html><b>',name,'</html>']);
%    'String', ['<html><b>',name,' &#9658;</html>']);
MW.PB{MW.CounterPB}.num = MW.CounterPB;   
% SetActivePG(0,0,MW.CounterPB); 

function SetActivePG(~,~, num)
global MW
    for ii = 1:MW.CounterPB
        if ii ~= num
            set(MW.PG{ii}.handle, 'Visible', 'Off');
            set(MW.PB{ii}.handle, 'Value', 0);
%             set(MW.PB{ii}.handle, 'Value', 0);
            MW.PB{ii}.handle.BackgroundColor =MW.panel.radio0backgroundcolor;
        else
          	set(MW.PG{ii}.handle, 'Visible', 'On');
            set(MW.PB{ii}.handle, 'Value', 1);
            MW.PB{ii}.handle.BackgroundColor = MW.panel.radio1backgroundcolor;
        end     
    end
  	drawnow;

function ButtonDownCallback
global MW
for ii = 1:MW.CounterPB
    set(MW.PB{ii}.handle,'Callback', {@SetActivePG,ii});  
end

function CreatePanelNomber1
    newUic
    newUicCol
    newUicMainText( '��������� �������');
    newUicText( '�������, ��');
    newUicEdit( '1e10', 'frequency');
    newUicText( '����� �����, �');
    newUicEdit( '0.03','lamda');
    newUicText( '������ ������ �������, �');
    newUicEdit( '10', 'heightAntenna');
    newUicRadio( '������� � �������� ��','typeAntenna',1);
    newUicText( '��� �� �������');
    newUicPopup( {'<html>sin(x)/x','<html>sin(&theta)'},...
        'beamTypeAntenna',1);    
    newUicText(  '������ ��, ��������');
    newUicEdit(  '5', 'beamWithAntenna');
    newUicText( '������ ��, ��������');
    newUicEdit(  '0', 'beamTitlAntenna');
    newUicRadio( '����','typeAntenna',0);
    newUicMainText( '���������� ��������� �������')
    newUicText( '�� ���������');
    newUicEdit(  '100', 'subNx');
    newUicText( '�� �����������');
    newUicEdit( '100', 'subNy');
    newUicText( '�� ��������');
    newUicPopup( {'<html>sin(x)/x','<html>sin(&theta)'},...
        'beamTypeSubAntenna',2); 
    newUicMainText( '����������� �������� ����')
    newUicText( '���� �����, ��������');
    newUicEdit(  '2', 'beamTitlUMAntenna');
    newUicText( '������, ��������');
    newUicEdit(  '0', 'beamTitlAZAntenna');
    
    newUicRadio( '���������� �������','typeAntenna',0);
    newUicCol
    newUicMainText( '����� ������');
    newUicText( '����������� ������' );
    newUicPopup( {'2D','3D'} , 'dimProblem',1);
        newUicText( '���������, �' );
    newUicEdit( '200000','rangeProblem' );
    newUicText( '��� �� ���������, �' );
    newUicEdit( '200','stepRangeProblem'  );
        newUicText( '������, �' );
    newUicEdit( '50','heightProblem' );
    newUicText( '~ ��� �� ������, �' );
    newUicEdit( '0.05','stepHeightProblem'  );
        newUicText( '������, �' );
    newUicEdit( '200','widthProblem' );
    newUicText( '~ ��� �� ������, �' );
    newUicEdit( '0.1','stepWidthProblem'  );
        newUicBox( '���������� ���','adaptiveStepProblem',1);
    
    newUicCol
    newUicMainText( '����� ����-��');
    newUicText( '�������� ����-��' );
    newUicEdit( '0','test' );
    
    
% �������� ������ ���������, ��������, �� ���������, ���������, ��������� 
function newUicPBs
newUic
    newUicPB('���������', 'apply')
    newUicPB('��������', 'cancel')
    newUicPB('�� ���������', 'byDef')
    newUicPB('���������', 'save')
    newUicPB('���������', 'load')
newUicHalfCol
    newUicPB('���������', 'calc')
    newUicPB('�����', 'pause')
    newUicPB('����', 'stop')

    
function newUicPB(string, name)    
global MW
newUicCol
position = newUicPositionPB;
 MW.CounterUicPB = MW.CounterUicPB + 1;
 MW.PB2{MW.CounterUicPB}.handle = ...
        uicontrol( MW.panelPB2.handle,...
        'style','pushbutton',...
        'String',string,...
        'FontWeight','bold',...
        'backgroundcolor',MW.panel.pushbackgroundcolor, ...
        'Position', position);    
    MW.Edit{MW.CounterUicEdit}.name = name;
    %callback ��� ������ ����, ����� eval
    %            ��� ����� � ���������� �� name ��� counter
    set(MW.PB2{MW.CounterUicPB}.handle,'callback',...
        {@Callback_pb2,MW.CounterUicPB})

function newUic
global MW
    MW.panel.h = 0;
    MW.panel.w = 0;
    
function newUicCol
global MW
    MW.panel.h = 0;
    MW.panel.w = MW.panel.w + 1;

function newUicHalfCol
global MW
    MW.panel.h = 0;
    MW.panel.w = MW.panel.w + 0.25;    
 
function newUicText( string )
global MW
    MW.panel.h = MW.panel.h + 1;
    position = newUicPosition;
    uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','text',...
        'String',string,...
        'Position',position);
    
function newUicMainText( string )
global MW
    MW.panel.h = MW.panel.h + 1;
    position = newUicPosition0;
    uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','text',...
        'String',string,...
        'FontWeight','bold',...
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
    position = newUicPosition0;
    MW.Edit{MW.CounterUicEdit}.handle = ...
        uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','radiobutton',...
        'String',string,...
        'Position',position,...
        'value', value,...
        'backgroundcolor',MW.panel.radiobackgroundcolor ...
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
    
function newUicBox( string,name,value)
global MW
    MW.panel.h = MW.panel.h + 1;
    MW.CounterUicEdit = MW.CounterUicEdit + 1;
    position = newUicPosition0;
    MW.Edit{MW.CounterUicEdit}.handle = ...
        uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','checkbox',...
        'String',string,...
        'Position',position,...
        'value', value,...
        'backgroundcolor',MW.panel.checkbackgroundcolor ...
        );
    MW.Edit{MW.CounterUicEdit}.name = name;
    
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
        MW.sizePB.width*(1-MW.sizePB.widthK)/2*(w-1), ...
        MW.panel.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width-MW.panelPB.d*2, ...
        MW.sizePB.height] ;
    
function position = newUicPosition0
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*2 + MW.sizePB.width*(2*w-2)- ...
        MW.sizePB.width*(1-MW.sizePB.widthK)/2*(w-1), ...
        MW.panel.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width*(1+MW.sizePB.widthK )-MW.panelPB.d*2, ...
        MW.sizePB.height] ;    
    
function position = newUicPosition2
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*1 + MW.sizePB.width*(2*w-1)-...
        MW.sizePB.width*(1-MW.sizePB.widthK)/2*(w-1), ...
        MW.panel.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width*MW.sizePB.widthK-MW.panelPB.d*1, ...
        MW.sizePB.height] ;    
    
    
function position = newUicPositionPB
global MW
w = MW.panel.w;
    position = [MW.panelPB.d*1 + ...
        MW.sizePB.width*MW.sizePB.widthK*(w-1), ...
        MW.panelPB.d, ...
        MW.sizePB.width*MW.sizePB.widthK-MW.panelPB.d*1, ...
        MW.sizePB.height] ;      
 
function  Callback_pb2(a,b,CounterUicPB)
disp(num2str(CounterUicPB))






%  function SaveTemp(MW)
%      size(MW);














