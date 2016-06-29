function go
  close all % закрыть все открытые графики
  tic
  select_plane_calc = [2,1,3]; % выбор плоскости расчета
    % 1 - x=const
    % 2 - y=const
    % 3 - z=const
  is_draw_E = 0; % нужно ли рисовать напряженность
  is_draw_PPM = 1; % -//- ППМ
  is_draw_contour = 1;
  is_draw_surf = 0;
  is_ref = 1; % 1 - отражение от земли. 0 - отсутствие откражения
  is_ru = 0; % язык надписей

  frequency = 0.6e9; % частота в Гц (н-р 600 МГц = 0.6e9)
    % знак «=» означает присвоить переменной конкретное значение
    % причем в GNU Octave/MATLAB инициализировать 
    % переменную заранее не обязательно
  SPEED_OF_LIGHT = 3e8; % константа, скорость света
    % для различия, константы, чаще всего, обозначаются прописными буквами
  lambda = SPEED_OF_LIGHT ./ frequency; % длина волны
    % имя переменных, для читаемости кода, должно содержать смысл.
  k = 2*pi./lambda; % волновое число
    % поскольку волновое число часто встречается в формулах, уменьшим длину имени переменой, с минимальной потерей смысла.
    % точка «.» перед знаком деления «/» означает почленное деление, в от-сутствии точки – матричное деление (деление одной матрицы на другую).

  % плоскость сечения
  plane_x0 = 2; % 2 метра над землей
  plane_y0 = 0; 
  plane_z0 = 10;

  plane_d = 0.1; % шаг дискрета поверхности 
  % границы расчета в плоскости сечения
  plane_x_min = 0;
  plane_x_max = 50;
  plane_x_d = plane_d;
  plane_x = plane_x_min : plane_x_d : plane_x_max;

  plane_z_min = 1; % начальная дальность
  plane_z_max = plane_z_min + 50; % конечная дальность
  plane_z_d = plane_d; % шаг по дальности
  plane_z = plane_z_min : plane_z_d : plane_z_max; % массив дальностей

  % ширина (поперечные координаты):
  plane_y_min = -50; 
  plane_y_max = 50;
  plane_y_d = plane_d;
  plane_y = plane_y_min : plane_y_d : plane_y_max; % массив поперечных координат

for i_plane = 1 : length( select_plane_calc )
  number_figure = (i_plane-1)*10;
  var = select_plane_calc(i_plane);
  switch var
    case 1
      % двумерные массивы:
      [plane_Z, plane_Y] = meshgrid( plane_z, plane_y ); % двумерный массив координат точек
      plane_X = repmat( plane_x0, size(plane_Z) );
      figure_X = plane_Z;
      figure_Y = plane_Y;
    case 2
      % двумерные массивы:
      [plane_Z, plane_X] = meshgrid( plane_z, plane_x ); % двумерный массив координат точек
      plane_Y = repmat( plane_y0, size(plane_Z) );
      %Y = y0*ones( size( Z ) ); % поверхности
      % или то же самое % X = repmat( x0, size(Z) );
      figure_X = plane_Z;
      figure_Y = plane_X;
    case 3
      [plane_Y, plane_X] = meshgrid( plane_y, plane_x );
      plane_Z = repmat( plane_z0, size(plane_X) );
      figure_X = plane_Y;
      figure_Y = plane_X;
  end
  
  % параметры прямоугольной решетки:
  dipole_h = 5; % высота цнтра
  dipole_n = 5; % количество излучателей в вертикальной линейке
  dipole_m = 8; % количество вертикальных линеек
  dipole_d = lambda/2; % шаг м-у излучателями по вертикали и горизонтали
  % В локальной системе координат
  dipole_x_local = ( (1:dipole_n) - (dipole_n+1)/2 ) * dipole_d; % вектор высот излучателей
  dipole_y_local = ( (1:dipole_m) - (dipole_m+1)/2 ) * dipole_d; % вектор координат по ширине
  dipole_z_local = zeros( size(dipole_x_local) ); % по дальности
  
  dipole_gamma = 25; % угол наклона полотна
  % угол направления главного луча
  dipole_alpha = 5; % угол места
  dipole_beta = 10; % азимут
  % координаты излучателя в глобальной стистеме координат
  [dipole_x, dipole_y] = meshgrid(dipole_x_local,dipole_y_local);
  dipole_z = dipole_z_local - dipole_x*sind(dipole_gamma);
  dipole_x = dipole_h + dipole_x*cosd(dipole_gamma);
  % Начальная фаза каждого излучателя
  dipole_Faza = abs( ...
      dipole_x*sind(dipole_alpha) - ...
      dipole_y*cosd(dipole_alpha) * sind(dipole_beta) + ...
      dipole_z*cosd(dipole_alpha) * cosd(dipole_beta) ) ;
  dipole_PG = 200; % произведение мощности излучения на коэффициент усиления
  E = 0;
  for i_dipole = 1 : dipole_n*dipole_m 
    % display(i_dipole)
    % расстояние между антенной и точкой приема:
    R = sqrt( (plane_X-dipole_x(i_dipole)).^2 + ...
              (plane_Y-dipole_y(i_dipole)).^2 + ...
              (plane_Z-dipole_z(i_dipole)).^2 );
    % горизонтальное расстояние между антенной и точкой приема:
    r = sqrt( (plane_Y-dipole_y(i_dipole)).^2 + ...
              (plane_Z-dipole_z(i_dipole)).^2 );
    % Диаграмма направленности = sin(theta):
    cos_theta = ( (plane_X-dipole_x(i_dipole)).*cosd(dipole_gamma) - ...
                  (plane_Z-dipole_z(i_dipole)).*sind(dipole_gamma) )./R;
    DN = sqrt(1 - cos_theta.^2);

    % проекция нормированное поле (без учета энергетики): 
    E = E + DN.*exp(-1i*k*R)./R.*r./R;

    if is_ref
      % диэлектрическая проницаемость сухой земли:
      surface_epsilon = 4;
      surface_sigma = 1e-3;
      % морской воды
      % epsilon = 80;
      % sigma = 4;
      ep = surface_epsilon + 60i*surface_sigma*lambda; 
      % расстояние между мнимым диполем и точкой приема:
      R_imag = sqrt( (plane_X+dipole_x(i_dipole)).^2 + ...
                     (plane_Y-dipole_y(i_dipole)).^2 + ...
                     (plane_Z-dipole_z(i_dipole)).^2 );
      % горизонтальное расстояние:
      % r = sqrt( (Y-y_dip).^2 + (Z-z_dip).^2 );
      cos_theta_imag = ( (-plane_X-dipole_x(i_dipole)).*cosd(dipole_gamma) - ...
        (plane_Z-dipole_z(i_dipole)).*sind(dipole_gamma) )./R_imag;
      DN_imag = sqrt(1 - cos_theta_imag.^2);

      % sin_theta_imag = r./R_imag;
      % DN_imag = sin_theta_imag;
      % cos и квадрат sin’а угла отражения
      cos_psi = ( plane_X + dipole_x(i_dipole) )./R_imag;
      sin_psi2 = ( r./R_imag ).^2;
      % коэффициент отражения
      Rp = ( ep .* cos_psi - sqrt(ep - sin_psi2) ) ./ ...
           ( ep .* cos_psi + sqrt(ep - sin_psi2) );
      % нормированное поле мнимого диполя
      E = E + Rp.*DN_imag.*exp(-1i*k*R_imag)./R_imag.*r./R_imag;
    end
  end
  
  PPM_0 = 25;%25; % [мкВт/см^2] граница СЗЗ, 0 дБ
  PPM_min = -41; % граница минимального значения для отображения на гра-фики, аналогичным образом можно провести границу и по максимальному значению
  PPM_max = 0;
  PPM = 10*log10( dipole_PG/4/pi ) + 20*log10( abs(E+(E==0)*eps) ) - ...
    10*log10( PPM_0 ); % плотность потока мощности (ППМ)
  %PPM = PPM.*(PPM >= PPM_min) + PPM_min.*(PPM < PPM_min) ; % ограничения
   PPM = PPM.*( PPM >= PPM_min ).*( PPM <= PPM_max ) + ...
         PPM_min.*(PPM < PPM_min) + PPM_max.*(PPM > PPM_max);
     % +eps - прибавление самой малой величины к полю не даст погрешности
     % но обеспечит корректное вычисление log10(0)
     
  % надписи на рисунках   
  if is_ru
    z_fig = 'дальность, м'; 
    y_fig = {'поперечная координата', 'ширина, м'};
    x_fig = 'высота, м';
    temp_title  = 'распределение поля';
    temp_title3 = 'ППМ [дБ]';
    zlab_fig = 'нормированная напряженность поля';
    switch var(i_var)
      case 1
          temp_text = ['на высоте ',...
              num2str(plane_x0), ' м над земной поверхностью'];
      case 2
          temp_text = ['в сечении y = ',...
            num2str(plane_y0), ' м'];
      case 3
          temp_text = ['в сечении z = ',...
            num2str(plane_z0), ' м'];
    end
  else
      % английские надписи
    z_fig = 'range, m'; 
    y_fig = {'transverse coordinate','width, m'};
    x_fig = 'height, m';
    temp_title  = 'field distribution';
    temp_title3 = 'power flux density [dB]';
    zlab_fig = 'normalized field strength';
    switch var
      case 1
          temp_text = ['at a height of ',...
              num2str(plane_x0), ' m above the ground'];
      case 2
          temp_text = ['in section y = ',...
            num2str(plane_y0), ' m'];
      case 3
          temp_text = ['in section z = ',...
            num2str(plane_z0), ' m'];
    end
  end
    switch var
      case 1
          xlab_fig = z_fig; 
          ylab_fig = y_fig;
      case 2
          xlab_fig = z_fig; 
          ylab_fig = x_fig;
      case 3
          xlab_fig = y_fig;
          ylab_fig = x_fig;
    end
  title_fig  = [temp_title ,' ', temp_text];
  title_fig3 = [temp_title3,' ', temp_text];

  % отрисовка рисунков
  if is_draw_E
    if is_draw_contour
      figure(number_figure+1);
      contour(figure_X, figure_Y, abs(E),'ShowText','off')
      title(title_fig)
      xlabel(xlab_fig)
      ylabel(ylab_fig)
      grid on
      colorbar
    end  
    if is_draw_surf
      figure(number_figure+2)
      %mesh(abs(E))
      surf(figure_X,figure_Y,abs(E))
      shading interp
      view(2)
      title(title_fig);
      xlabel(xlab_fig);
      ylabel(ylab_fig);
      zlabel(zlab_fig);
      grid on
      colorbar
    end
  end
  if is_draw_PPM
    if is_draw_contour
      figure(number_figure+3)
      hold off
      contour(figure_X, figure_Y, PPM,'ShowText','off')
      hold on
      contour(figure_X, figure_Y, PPM,[PPM_0,PPM_0],'k','linewidth',2)
      title(title_fig3)
      xlabel(xlab_fig)
      ylabel(ylab_fig)
      grid on
      colorbar
    end
    if is_draw_surf
      figure(number_figure+4)
      hold off
      surf(figure_X, figure_Y, zeros(size(PPM)),PPM)
      shading interp
      view(2)
      hold on
      contour(figure_X, figure_Y, PPM,[PPM_0,PPM_0],'k','linewidth',2)
      title(title_fig3)
      xlabel(xlab_fig)
      ylabel(ylab_fig)
      grid on
      colorbar
    end
  end
end
  toc