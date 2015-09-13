% программа для расчета стандартного 
% параболического кравнения
% дата создания 10.09.2015 21:09
% Михайлов Михаил

% ближайшие правки:
% 1) затуханиее от дальности Done
% 2) начальное условие реальной антенны
% 3) влияние атмосферы 
% а) волноводный эффект Done
% б) затухание
% 4) импедансное граничное услови
% 5) широкоугловое приближение Done

% для вертикальной поляризации - Ну
% для горизонтальной - Еу

% началное условия вычисляется методом ГО

% Пусть дельта функция на высоте h
% h = 10;
% dh= 1;

% Шаг по высоте и дальности
dx = 0.01;
dz = 0.00001;

% Максимальная высота
% Xmax = 100;
logHeight = 11;
discretXmax = 2^logHeight;
Xmax = (discretXmax-1) * dx;
x = linspace(0, Xmax, discretXmax);

% По высоте
% x = 0 : dx : Xmax;

% Начальная напряженность
% u = x==h; % dst
% u = abs (  ( x > (h - dh) ) & ( x < (h + dh) )  ); 
% u = ones( size(x) ); % dct
z = 500; Hprd = 4;
lamda=3e-2;
k0=2*pi/lamda;
DDNprd = 5;
NDNprd = 0;
    Lprd=51/DDNprd*lamda/cosd(NDNprd); 
    theta1=atan2(z,(x-Hprd));
    theta2=atan2(z,(x+Hprd));
    theta0=pi/180*(114*lamda/Lprd/cosd(NDNprd));
    epsilon=sind(NDNprd);
    DN1=sin(k0*Lprd/2*(cos(theta1)-epsilon))./(k0*Lprd/2*(cos(theta1)-epsilon));
    DN2=sin(k0*Lprd/2*(cos(theta2)+epsilon))./(k0*Lprd/2*(cos(theta2)+epsilon));
    % только главный луч
    DN1=DN1.*(theta1>pi/2-theta0/2-NDNprd*pi/180).*(theta1<pi/2+theta0/2-NDNprd*pi/180);
    DN2=DN2.*(theta2>pi/2-theta0/2+NDNprd*pi/180).*(theta2<pi/2+theta0/2+NDNprd*pi/180);
    R1=sqrt(z.^2+(x-Hprd).^2);
    R2=sqrt(z.^2+(x+Hprd).^2);
    E=(DN1.*exp(-1i*k0*R1)./R1-DN2.*exp(-1i*k0*R2)./R2).*exp(1i*k0*z);
    
    u=E;



% тропосфера
Hw = 0; Ns = 315;
 zv=1.5e-4;
    N = Ns+0.13*(x-Hw*log((zv+x)/zv));
    
n2 =  (1+N/1e6).^2-1 ;

% factor
%  factorFFT=1./sqrt(r);

KX=linspace(0, pi/dx, discretXmax); 
p=1i*KX.^2./(k0*(1+(sqrt(1-KX.^2./k0^2))));
K = exp(-1i*pi^2*p.^2*dz/2/k0);

figure(1)
hold off
grid on
IImax =500;
AllColor = jet(IImax);
 for ii = 1: IImax;
% Синус-Фурье преобразование
U = dst(u);
% Косинус:
% U = dct(u);

% Передаточная функция слоя
% lamda = 3e-2;
% k = 2*pi/lamda;


U1 = U.*K;

% обратный Фурье
 u1 = idst (U1);
%  u1 = idct (U1);
 alfa = -1e-0;
 Hgu = 0.8 * Xmax;
 
 REFR= (-1i*k0*n2 + k0*alfa*(x-Hgu).^2.*(x>=Hgu) )/2;
% REFR = 0;
 u = u1 .* exp(dz*REFR);
 u(1)=0;
 if ~mod(ii,10)
 plot ( x,( abs(u)./sqrt(dz*ii) ),'color',AllColor(ii,:));%sqrt(dz*ii) ) %20*log10
% ylim([-100 -20])
 grid on
drawnow
 end
 end

disp('end')


