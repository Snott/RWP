function SPE
% ��������� ��� ������� ������������ 
% ��������������� ���������
% ���� �������� 10.09.2015 21:09
% �������� ������

% ��������� ������:
% 1) ���������� �� ��������� Done
% 2) ��������� ������� �������� �������
% 3) ������� ��������� 
% �) ����������� ������ Done
% �) ���������
% 4) ����������� ��������� ������
% 5) ������������� ����������� Done

% ��� ������������ ����������� - ��
% ��� �������������� - ��

% �������� ������� ����������� ������� ��
    global lamda k0
    lamda=3e-2;
    k0=2*pi/lamda;

% ��� �� ������ � ���������
    dx = 0.02;
    dz = 1;

% ������
    logHeight = 12;
    discretXmax = 2^logHeight+1;
    Xmax = (discretXmax-1) * dx;
    x = linspace(0, Xmax, discretXmax);

% ������������� � ��������� ���������
    z = 100; 
    u = go(z,x);

% ����������: �������� � �����������
    Hw = 0; Ns = 315;
    zv=1.5e-4;
    N = Ns+0.13*(x-Hw*log((zv+x)/zv));
    N = zeros(size (N)); % ��� ����� �����������
    n2 =  ( 1 + N/1e6 ) .^2 - 1 ;

% ��������� ��� ��
    KX=linspace(0, pi/dx, discretXmax); 
    p=1i*KX.^2./(k0*(1+(sqrt(1-KX.^2./k0^2))));
%     p = 1i*KX.^2/k0;
%     K = exp(-1i*pi^2*p.^2*dz/2/k0);
    K = exp(p.*dz);

% �������
    figure(1)
    hold on
    grid on

% ����
    IImax = 30000;
    dII = 500;
    AllColor = jet(IImax);
 for ii = 1: IImax;
    % �����-����� ��������������
        U = dst(u(2:discretXmax));
    % �������:
        % U = dct(u);
    % �����
        % U = fft(u);

    % ������������ ������� ����
    U1 = U.*K(2:discretXmax);

    % �������� �����
        u1(1)=0;
        u1(2:discretXmax) = idst (U1);
        %  u1 = idct (U1);
        %  u1 = ifft (U1);

    % ��������� � ����������� ����    
%         alfa = -5e-3/ii/dz;
%         Hgu = 0.8 * Xmax;
        alfa = -5e-2/ii/dz;
        Hgu = 0.75 * Xmax;
 
        REFR= ( -1i*k0*n2 + k0*alfa*(x-Hgu).^2.*(x>=Hgu) )/2;

    % ������������� ���� �� (��� ����� sqrt(r) )
        
        u = u1 .* exp(dz*REFR); % �� ��������� �� cos 
        
    % ����� �� ������� ������ 10 ��������
    if ( ~mod(ii+(z/dz), dII) ) || (ii == IImax)  || (ii == 1)
        curZ = z+ii*dz;
        hold off
        %  plot ( x,( abs(u)./sqrt(dz*ii) ),'color',AllColor(ii,:));%sqrt(dz*ii) ) %20*log10
        dstE = u./sqrt(z+dz*ii)*sqrt(z);
        plot ( x, ( abs( dstE ) ),'color',AllColor(ii,:));%sqrt(dz*ii) ) %20*log10
        hold on
        goE =  (go(curZ,x));
        plot ( x,abs( goE ),'k--');%go
%         plot ( x, abs( goE - dstE) ,'k');%go
        grid on
        title([num2str(curZ),' �'])
        xlim([x(1),x(end)])
        drawnow
    end
 end
% ����� ���������� �� ��������� �������
disp('end')

% ������������ ������� ���� �� ������ ��
function E = go(z,x)
    global lamda k0
    % ��������� �������: 
    Hprd = 4; % ������ �����������
    DDNprd = 5; % ������ ��������� �������������� (�� 0.5 � ��� �??)
    NDNprd = 0; % ������ ��������� ��������������
    Lprd=51/DDNprd*lamda/cosd(NDNprd); % ����������� ������ �������
    theta1=atan2(z,(x-Hprd)); % ���� �� ������� �� ����
    theta2=atan2(z,(x+Hprd)); % ���� ������ ������� �� ����
    theta0=pi/180*(114*lamda/Lprd/cosd(NDNprd)); % ������ �������� ����
    epsilon=sind(NDNprd); % ������
    DN1=sin(k0*Lprd/2*(cos(theta1)-epsilon))./(k0*Lprd/2*(cos(theta1)-epsilon)); % ���� �� ������� � ����� ������������ ����
    DN2=sin(k0*Lprd/2*(cos(theta2)+epsilon))./(k0*Lprd/2*(cos(theta2)+epsilon)); % ���� �� ������ ������� � ����� ������������ ����
    % ������ ������� ���
    DN1=DN1.*(theta1>pi/2-theta0/2-NDNprd*pi/180).*(theta1<pi/2+theta0/2-NDNprd*pi/180);
    DN2=DN2.*(theta2>pi/2-theta0/2+NDNprd*pi/180).*(theta2<pi/2+theta0/2+NDNprd*pi/180);
    R1=sqrt(z.^2+(x-Hprd).^2); % ��������� �� ������� �� ����
    R2=sqrt(z.^2+(x+Hprd).^2); % ��������� �� ������� �� ������ ����
    E=(DN1.*exp(-1i*k0*R1)./R1-DN2.*exp(-1i*k0*R2)./R2).*exp(1i*k0*z); % ��������� ����.
