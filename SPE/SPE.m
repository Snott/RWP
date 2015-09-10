% ��������� ��� ������� ������������ 
% ��������������� ���������
% ���� �������� 10.09.2015 21:09

% ��� ������������ ����������� - ��
% ��� �������������� - ��

% �������� ������� ����������� ������� ��

% ����� ������ ������� �� ������ h
h = 10;
dh=1;

% ��� �� ������ � ���������
dx = 0.1;
dz = 1000;

% ������������ ������
% Xmax = 100;
logHeight = 12;
discretXmax = 2^logHeight;
Xmax = (discretXmax-1) * dx;
x = linspace(0, Xmax, discretXmax);

% �� ������
% x = 0 : dx : Xmax;

% ��������� �������������
% u = x==h; % dst
u = abs (  ( x > (h - dh) ) & ( x < (h + dh) )  ); 
% u = ones( size(x) ); % dct
figure(1)
hold off
grid on
 for ii = 1: 1000;
% �����-����� ��������������
U = dst(u);
% U = dct(u);

% ������������ ������� ����
lamda = 3e-2;
k = 2*pi/lamda;

    KX=linspace(0, pi/dx, discretXmax); 
    p=1i*KX.^2./(k*(1+(sqrt(1-KX.^2./k^2))));
K = exp(-1i*pi^2*p.^2*dz/2/k);

U1 = U.*K;

% �������� �����
 u1 = idst (U1);
%  u1 = idct (U1);
 alfa = -1e-7;
 Hgu = 0.8 * Xmax;
 REFR= k*alfa*(x-Hgu).^2.*(x>=Hgu)/2;
% REFR = 0;
 u = u1 .* exp(dz*REFR);
 plot ( abs(u) )
 grid on
drawnow
 end

disp('end')


