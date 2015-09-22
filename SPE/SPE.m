function SPE
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
    global lamda k0
    lamda=3e-2;
    k0=2*pi/lamda;

% Шаг по высоте и дальности
    dx = 0.02;
    dz = 1;

% высота
    logHeight = 12;
    discretXmax = 2^logHeight+1;
    Xmax = (discretXmax-1) * dx;
    x = linspace(0, Xmax, discretXmax);

% Напряженность в начальной дальности
    z = 100; 
    u = go(z,x);

% тропосфера: волновод и сферичность
    Hw = 0; Ns = 315;
    zv=1.5e-4;
    N = Ns+0.13*(x-Hw*log((zv+x)/zv));
    N = zeros(size (N)); % без учета сферичности
    n2 =  ( 1 + N/1e6 ) .^2 - 1 ;

% параметры для ПУ
    KX=linspace(0, pi/dx, discretXmax); 
    p=1i*KX.^2./(k0*(1+(sqrt(1-KX.^2./k0^2))));
%     p = 1i*KX.^2/k0;
%     K = exp(-1i*pi^2*p.^2*dz/2/k0);
    K = exp(p.*dz);

% рисунок
    figure(1)
    hold on
    grid on

% цикл
    IImax = 30000;
    dII = 500;
    AllColor = jet(IImax);
 for ii = 1: IImax;
    % Синус-Фурье преобразование
        U = dst(u(2:discretXmax));
    % Косинус:
        % U = dct(u);
    % Фурье
        % U = fft(u);

    % Передаточная функция слоя
    U1 = U.*K(2:discretXmax);

    % обратный Фурье
        u1(1)=0;
        u1(2:discretXmax) = idst (U1);
        %  u1 = idct (U1);
        %  u1 = ifft (U1);

    % затухание в поглощающем слое    
        alfa = -5e-3/ii/dz;
        Hgu = 0.8 * Xmax;
 
        REFR= ( -1i*k0*n2 + k0*alfa*(x-Hgu).^2.*(x>=Hgu) )/2;

    % окончательное поле ПУ (без учета sqrt(r) )
        
        u = u1 .* exp(dz*REFR);
        
    % вывод на рисунок каждой 10 итерации
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
        title([num2str(curZ),' м'])
        drawnow
    end
 end
% вывод информации об окончании расчета
disp('end')

% подпрограмма расчета поля по методу ГО
function E = go(z,x)
    global lamda k0
    % параметры антенны: 
    Hprd = 4; % высота передатчика
    DDNprd = 5; % ширина диаграммы направленности (по 0.5 Е или Р??)
    NDNprd = 0; % наклон диаграммы направленности
    Lprd=51/DDNprd*lamda/cosd(NDNprd); % эффективный размер антенны
    theta1=atan2(z,(x-Hprd)); % угол от антенны на цель
    theta2=atan2(z,(x+Hprd)); % угол мнимой антенны на цель
    theta0=pi/180*(114*lamda/Lprd/cosd(NDNprd)); % ширина главного луча
    epsilon=sind(NDNprd); % наклон
    DN1=sin(k0*Lprd/2*(cos(theta1)-epsilon))./(k0*Lprd/2*(cos(theta1)-epsilon)); % поле от антенны в точке расположения цели
    DN2=sin(k0*Lprd/2*(cos(theta2)+epsilon))./(k0*Lprd/2*(cos(theta2)+epsilon)); % поле от мнимой антенны в точке расположения цели
    % только главный луч
    DN1=DN1.*(theta1>pi/2-theta0/2-NDNprd*pi/180).*(theta1<pi/2+theta0/2-NDNprd*pi/180);
    DN2=DN2.*(theta2>pi/2-theta0/2+NDNprd*pi/180).*(theta2<pi/2+theta0/2+NDNprd*pi/180);
    R1=sqrt(z.^2+(x-Hprd).^2); % дальность от антенны до цели
    R2=sqrt(z.^2+(x+Hprd).^2); % дальность от антенны до мнимой цели
    E=(DN1.*exp(-1i*k0*R1)./R1-DN2.*exp(-1i*k0*R2)./R2).*exp(1i*k0*z); % суммарное поле.
