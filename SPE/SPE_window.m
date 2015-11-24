function SPE_window
%% ������� ��������� �������� SPE
name = 'SPE v0.1.0028';
%% ������ ������� ����������
 addpath C:\Git\PuMa3d_mix2
%% <--- ���� ��������� ������� � ����������� ����:
% ������, ���� � ��.
% tic
OpenMW(name);
global SPEEDofLIGHT % �������� �����
% SPEEDofLIGHT = 299792458;
SPEEDofLIGHT = 3e8;
% toc
% SaveTemp(MW);

function closeSPE(name)
nh = allchild(0);
for ii = 1 : length(nh)
    if strcmp ( get(nh(ii),'name' ), name )
        close(nh(ii))
    end
end
% + close ���� ������ ����, �-�: "������" ��� '���������� ����'

function OpenMW(name)
% ��� ���� ������ ����� ����������� �� global
global MW  % ���������� ��� ����������� CallBack
closeSPE(name)
MW.handle = figure(100);
set(MW.handle,...
    'Name', name,...
    'Units', 'pixels',...
    'Resize', 'off',...
    'NumberTitle', 'off',...
    'MenuBar', 'none',...
    'DockControls' , 'off', ...
     'HandleVisibility','on' ...
    ... % ��� ������ �����???
    ); 
SizeMW;
PanelPB;
MW.CounterPB = 0;
MW.CounterUicEdit = 0;
MW.CounterUicPB = 0;
MW.CounterAxes = 0;
%% <--- ������ ������� ������
namePB = '������� ������';
    NewPB(namePB);
        CreatePanelNomber1;
    NewPB('��������� �����');
        CreatePanelNomber2;
    NewPB('������');
    CreatePanelNomber3;
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
MW.sizePB.width = 165;
MW.sizePB.widthK = 0.6;
MW.sizePB.widthD = 0.3; %( <=(1-K) )
MW.panelPB.backgroundcolor = [4 5 6]/10;
MW.panel.textbackgroundcolor = [8 7 6]/10;
MW.panel.backgroundcolor    = [7 6 5]/10;
MW.panel.radiobackgroundcolor = [8 5 8]/10;
MW.panel.checkbackgroundcolor = [8 9 8]/10;
MW.panel.pushbackgroundcolor = [6 8 8]/10;
MW.panel.radio1backgroundcolor = [8 9 8]/10;
MW.panel.radio0backgroundcolor = [7.5 8 8.5]/10;
MW.panel.backgroundcolornotenable = [3 3 3]/10;

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
     'FontWeight','bold' , 'BackgroundColor', MW.panel.backgroundcolor );
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
%Problem
function CreatePanelNomber1
    newUic
    newUicCol
    newUicMainText( '��������� ������');
        newUicText( '�����������' );
    newUicPopup( {'������������','��������������','������ ��������','������ ��������'} , 'polarization', 1);
    addCallBack('@NotSet')
    newUicText( '�������, ��');
    newUicEdit( '1.0e+10', 'frequency');
        addCallBack('{@frec2lamda MW.CounterUicEdit+1}');
    newUicText( '����� �����, �');
    newUicEdit( '3.0e-2','lambda');
        addCallBack('{@frec2lamda MW.CounterUicEdit-1}');
    newUicText( '������ ������ �������, �');
    newUicEdit( '10', 'heightAntenna');
    
%     newUicMainText( '����� ������');
    newUicText( '����������� ������' );
    newUicPopup( {'2D �� ���������','2D �� �����������','3D'} , 'dimProblem', 3);
     newUicMainText( '���������');
        newUicText( '��������� ���������, �' );
    newUicEdit( '20','firstRangeProblem' );
        newUicText( '�������� ���������, �' );
    newUicEdit( '200000','endRangeProblem' );
        newUicText( '��� �� ���������, �' );
    newUicEdit( '1','stepRangeProblem'  );
        newUicText( '��� ������ �� ���������, �' );
    newUicEdit( '10','stepOutRangeProblem'  );
    newUicMainText( '������');
        newUicText( '~ ������, �' );
    newUicEdit( '50','heightProblem' );
    addCallBack('{@height2log MW.CounterUicEdit+1, MW.CounterUicEdit+2}');
        newUicText( '��� �� ������, �' );
    newUicEdit( '0.1','stepHeightProblem'  );
     addCallBack('{@step2log MW.CounterUicEdit-1, MW.CounterUicEdit+1}');
        newUicText( '���-�� ���������, log_2' );
    newUicEdit( '9','log2HeightProblem'  );
    addCallBack('{@log2height MW.CounterUicEdit-1, MW.CounterUicEdit-2}');
    newUicMainText( '������');
        newUicText( '~ ������, �' );
    newUicEdit( '100','widthProblem' );
    addCallBack('{@height2log MW.CounterUicEdit+1, MW.CounterUicEdit+2}');
    newUicText( '��� �� ������, �' );
    newUicEdit( '0.1','stepWidthProblem'  );
     addCallBack('{@step2log MW.CounterUicEdit-1, MW.CounterUicEdit+1}');
        newUicText( '���-�� ���������, log_2' );
    newUicEdit( '10','log2WidthProblem'  );
    addCallBack('{@log2height MW.CounterUicEdit-1, MW.CounterUicEdit-2}');    
     newUicCheck( '���������� ���� �� ���������','isAdaptiveStepRange',0);
      notEnable;
     newUicText( '�� ����������, �' );
    newUicEdit( '100 200 500','adaptiveStepRanges'  );
  newUicCheck( '���������� ���� �� ������ � ������','isAdaptiveStepHeight',0);
   notEnable;
     newUicText( '�� ����������, �' );
    newUicEdit( '100 200 500','adaptiveStepRanges'  );
        
        newUicCol
    newUicMainText( '����� �������');
    newUicRadio( '������� �����','typeAntenna',0);
        notEnable;
    newUicRadio( '������-�������','typeAntenna',0);
        notEnable;
    newUicRadio( '������� � �������� ��','typeAntenna',1);
    newUicText( '��� �� �������');
    newUicPopup( {'<html>sin(x)/x','<html>sin(&theta)'},...
        'beamTypeAntenna',1); 
    addCallBack('@NotSet')
    newUicText(  '������. ������ ��, ����.');
    newUicEdit(  '5', 'beamWithAntennaX');
    newUicText( '������. ������ ��, ����.');
    newUicEdit(  '0', 'beamTitlAntennaX');
    newUicText(  '�����. ������ ��, ����.');
    newUicEdit(  '5', 'beamWithAntennaY');
    newUicText( '�����. ������ ��, ����.');
    newUicEdit(  '0', 'beamTitlAntennaY');
    newUicCheck( '������ ������� ���','onlyMainBeam',1);
    
    
    newUicRadio( '����','typeAntenna',0);
    
    newUicMainText( '���������� ��������� �������')
    newUicText( '�� ���������');
    newUicEdit(  '100', 'subNx');
        newUicText( '��� �� ���������, lambda');
    newUicEdit(  '0.5', 'subDx');
    newUicText( '�� �����������');
    newUicEdit( '100', 'subNy');
        newUicText( '��� �� �����������, lambda');
    newUicEdit(  '0.5', 'subDy');
    newUicText( '�� ��������');
    newUicPopup( {'<html>sin(&theta)','<html>sin(x)/x'},...
        'beamTypeSubAntenna',1); 
    addCallBack('@NotSet')
    
    newUicMainText( '����������� �������� ����')
    newUicText( '���� �����, ����.');
    newUicEdit(  '2', 'beamTitlUMAntenna');
    newUicText( '������, ����.');
    newUicEdit(  '0', 'beamTitlAZAntenna');
    
    newUicCol
    newUicMainText( '����� ������');
    newUicCheck( '����� �������������� ������','methodGO',0);
    newUicCheck( '����� ��������������� ��������� (3D)','methodPE',1);
    newUicCheck( '����� ��������������� ��������� (SUM)','methodSUM',0);
       notEnable;
    newUicCheck( '����� ������������� ������������ ���������','methodSIE',0);
        notEnable;
    newUicText( '�������� ����-��' );
    newUicEdit( '0','test' );
        notEnable; 
%         newUicText( '' );

        newEmpty
        newEmpty
        newEmpty
   newUicMainText( '����� �������');     
       newUicRadio( '���������� �������','typeAntenna',0);
        notEnable;
    newUicText( '�������, �^2');
    newUicEdit( '10', 'Sa');
        notEnable;
         newUicText( '���');
    newUicEdit( '1', 'KIP');
     notEnable;
    
    newUicMainText( '����������� �������� ����')
    newUicText( '���� �����, ����.');
    newUicEdit(  '2', 'beamTitlUMAntennaZ');
        notEnable;
    newUicText( '������, ����.');
    newUicEdit(  '0', 'beamTitlAZAntennaZ');
        notEnable; 
        
% environment        
function CreatePanelNomber2
    newUic
    newUicCol
    newUicMainText( '��������� �����������');
    newUicText( '�������� �����������' );
    newUicPopup( {'���������','�����','����'} , 'setMaterialOfSerfase', 1);
    addCallBack('@NotSet')
    newUicText( '��������. �������������' );
      newUicEdit( '-1', 'dielectricOfSerfase');
      notEnable;
   newUicMainText( '����� ����������');   %undulation
   newUicRadio( '������� �����������','typeSerf',1);
   newUicRadio( '��������� ����������','typeSerf',0);
   
   newUicCol
   newUicCheck('��������������� ����������','isNoiseSerfase',1)
   newUicText( '������ �������������, �');
    newUicEdit(  '0.02', 'sizeNoiseSerfase');
    
   
      
   
   function CreatePanelNomber3
       newUic
       newAxes       
       newAxes       
       newUicCol       
        newAxes        
        newAxes
        
        
    function newEmpty
        global MW
        MW.panel.h = MW.panel.h + 1;
    
% �������� ������ ���������, ��������, �� ���������, ���������, ��������� 
function newUicPBs
newUic
    newUicPB('���������', 'apply')
        notEnablePB
    newUicPB('��������', 'cancel')
        notEnablePB
    newUicPB('�� ���������', 'byDef')
        notEnablePB
    newUicPB('���������', 'save')
        notEnablePB
    newUicPB('���������', 'load')
        notEnablePB
newUicHalfCol
    newUicPB('����������', 'calc')
    setCallBack(@Callback_pb2)
    %     set(MW.PB2{MW.CounterUicPB}.handle,'callback',...
%         {@Callback_pb2,MW.CounterUicPB})

    newUicPB('�����', 'pause')
%      setCallBack(@Callback_pb2)
        notEnablePB
    newUicPB('����', 'stop')
     setCallBack(@Stop)
%         notEnablePB
    
function notEnablePB
        global MW
        MW.PB2{MW.CounterUicPB}.handle.Enable = 'off';    
        
function setCallBack(func)
     global MW
%      MW.PB2{MW.CounterUicPB}.handle.Enable = 'off'; 
     set(MW.PB2{MW.CounterUicPB}.handle,'callback',...
     {func,MW.CounterUicPB})
    
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
%     MW.Edit{MW.CounterUicEdit}.name = name;
    %callback ��� ������ ����, ����� eval
    %            ��� ����� � ���������� �� name ��� counter
%     set(MW.PB2{MW.CounterUicPB}.handle,'callback',...
%         {@Callback_pb2,MW.CounterUicPB})
    function newAxes
        global MW
        MW.panel.h = MW.panel.h + 1;
        MW.CounterAxes = MW.CounterAxes + 1;
        position = newAxesPosition;
        MW.Ax(MW.CounterAxes) =...
            axes('parent', MW.PG{MW.CounterPB}.handle,...
            'position', position);
        
        
    function position = newAxesPosition
        H = 2; W = 2;
        global MW
        h = MW.panel.h;
        w = MW.panel.w;
        x0 = 0.1;
        y0 = 0.1;
        x = x0 + w/W;
        y = y0 + (H-h)/H;
        X = 1/W - 2*x0;
        Y = 1/H - 2*y0;
        position = [x, y, X, Y];
        
        
        
        
        
        
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
        'Position',position,...
        'backgroundcolor', ...
        MW.panel.textbackgroundcolor,...
        'HorizontalAlignment', 'right',...
        'FontAngle',  'italic' ...
        );
    
function newUicMainText( string )
global MW
    MW.panel.h = MW.panel.h + 1;
    position = newUicPosition0;
    uicontrol( MW.PG{MW.CounterPB}.handle,...
        'style','text',...
        'String',string,...
        'FontWeight','bold',...
        'Position',position...
        );    
    
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
    
function addCallBack(func)
global MW
     MW.Edit{MW.CounterUicEdit}.handle.Callback = eval(func);
     
%      frec2lamda � lamda2frec ��������� ���������!)
function frec2lamda(a,b,num)
global MW SPEEDofLIGHT
MW.Edit{num}.handle.String = ...
    num2str( SPEEDofLIGHT/str2double(a.String) ,'%10.1e');
             
% function lamda2frec(a,b,num)
% global MW SPEEDofLIGHT
% MW.Edit{num}.handle.String = ...
%     num2str( SPEEDofLIGHT/str2double(a.String) ,'%10.3e');

function height2log(a,b,step,num)
    global MW
MW.Edit{num}.handle.String = ...
    num2str( ceil( log2( ...
    str2double(a.String)/str2double(MW.Edit{step}.handle.String) ...
    ) ),'%1.0f');

function log2height(a,b,step,num)
    global MW
MW.Edit{num}.handle.String = ...
    num2str( round(  ...
    2^str2double(a.String)*str2double(MW.Edit{step}.handle.String) ...
    ) ,'%1.0f');

function step2log(a,b,num,log)
    global MW
    MW.Edit{log}.handle.String = ...
    num2str( ceil( log2(  ...
    str2double(MW.Edit{num}.handle.String)/str2double(a.String) ...
    ) ) ,'%1.0f');
    
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
        'backgroundcolor', ...
        MW.panel.radio0backgroundcolor ...
        );
    if value
        MW.Edit{MW.CounterUicEdit}.handle.BackgroundColor ...
            = MW.panel.radio1backgroundcolor;
    else
        MW.Edit{MW.CounterUicEdit}.handle.BackgroundColor ...
            = MW.panel.radio0backgroundcolor;
    end
    number = 1;
    for ii = 1 : (MW.CounterUicEdit-1)
        if isequal( MW.Edit{ii}.name, name)
%             number = MW.Edit{ii}.number;  
            number = number + 1;
        end
    end
    MW.Edit{MW.CounterUicEdit}.name = name;
    MW.Edit{MW.CounterUicEdit}.number = number;
    set(MW.Edit{MW.CounterUicEdit}.handle,...
        'callback',{@CallRadiobutton,MW.CounterUicEdit})
    
    function notEnable
        global MW
        MW.Edit{MW.CounterUicEdit}.handle.Enable = 'off';
%         MW.Edit{MW.CounterUicEdit}.handle.BackgroundColor = ...
%             MW.panel.backgroundcolornotenable; 
        
    
function newUicCheck( string,name,value)
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
        'backgroundcolor',...
        MW.panel.checkbackgroundcolor ...
        );
    MW.Edit{MW.CounterUicEdit}.name = name;
     if value
        MW.Edit{MW.CounterUicEdit}.handle.BackgroundColor ...
            = MW.panel.radio1backgroundcolor;
    else
        MW.Edit{MW.CounterUicEdit}.handle.BackgroundColor ...
            = MW.panel.radio0backgroundcolor;
     end
MW.Edit{MW.CounterUicEdit}.handle.Callback = {@CallCheckbox MW.CounterUicEdit};

function CallCheckbox(a,b,num)
        global MW
    if a.Value
        MW.Edit{num}.handle.BackgroundColor ...
            = MW.panel.radio1backgroundcolor;
    else
        MW.Edit{num}.handle.BackgroundColor ...
            = MW.panel.radio0backgroundcolor;
   end
    
    
function CallRadiobutton(a,b,count)
global MW    
    name = MW.Edit{count}.name;
    for ii = 1 : MW.CounterUicEdit 
        if isequal( MW.Edit{ii}.name, name)
            set(MW.Edit{ii}.handle,...
                'value',0,...
                'backgroundcolor',...
                MW.panel.radio0backgroundcolor);
        end
    end  
    set(MW.Edit{count}.handle,...
    'value',1, ...
    'backgroundcolor',MW.panel.radio1backgroundcolor);
 
function position = newUicPosition
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*2 + MW.sizePB.width*(2*w-2)- ...
        MW.sizePB.width*(MW.sizePB.widthD)*(w-1), ...
        MW.panel.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width-MW.panelPB.d*2, ...
        MW.sizePB.height] ;
    
function position = newUicPosition0
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*2 + MW.sizePB.width*(2*w-2)- ...
        MW.sizePB.width*(MW.sizePB.widthD)*(w-1), ...
        MW.panel.height-round( h* ...
        (MW.sizePB.height+MW.panelPB.d))-3*MW.panelPB.d, ...
        MW.sizePB.width*(1+MW.sizePB.widthK )-MW.panelPB.d*2, ...
        MW.sizePB.height] ;    
    
function position = newUicPosition2
global MW
w = MW.panel.w;
h = MW.panel.h;
    position = [MW.panelPB.d*1 + MW.sizePB.width*(2*w-1)-...
        MW.sizePB.width*(MW.sizePB.widthD)*(w-1), ...
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
 
    
function  Stop(a,b,CounterUicPB)
    global STOP
    STOP = 1;
    
    function NotSet(a,b)
        a.Value = 1;
    
    
function  Callback_pb2(a,b,CounterUicPB)
% disp(num2str(CounterUicPB))%
% ������� ��� ���������� �� ����
% ��� �� �����?:
 global MW SPEEDofLIGHT
 % "����"  ��� ���� � Edit. ��� ����� � ������ ������???
 for ii = 1 : length(MW.Edit)
%     disp(MW.Edit{ii}.name)
    if isequal(MW.Edit{ii}.handle.Style,'edit') 
        eval(['Var.',MW.Edit{ii}.name,' = [',MW.Edit{ii}.handle.String,'];'])
    end
    if isequal(MW.Edit{ii}.handle.Style,'popupmenu')
%         eval(['Var.',MW.Edit{ii}.name,' = ',' '' ',MW.Edit{ii}.handle.String{MW.Edit{ii}.handle.Value},' '' ',';'])
        eval(['Var.',MW.Edit{ii}.name,' = ',num2str(MW.Edit{ii}.handle.Value),';'])
    end
    if isequal(MW.Edit{ii}.handle.Style,'checkbox')
        eval(['Var.',MW.Edit{ii}.name,' = ',num2str(MW.Edit{ii}.handle.Value),';'])
    end
     if isequal(MW.Edit{ii}.handle.Style,'radiobutton')
         if MW.Edit{ii}.handle.Value
             eval(['Var.',MW.Edit{ii}.name,' = ',num2str(MW.Edit{ii}.number),';'])
         end
     end
%     MW.Edit{ii}.handle.Value
 end   
 Var.Ax(1) = MW.Ax(2);
 Var.Ax(2) = MW.Ax(3);
 Var.Ax(3) = MW.Ax(4);
 Var.SPEEDofLIGHT = SPEEDofLIGHT;
%  SPE(var)
SetActivePG(0, 0, 3)

 PuMa_3D_with_win(Var)






%  function SaveTemp(MW)
%      size(MW);














