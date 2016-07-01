#            ____    _      _    ____         
#           (  _ \  / ) /\ ( \  (  _ \        
#            )   /  \ \/  \/ /   ) __/        
#           (__\_)   \__/\__/   (__)          
#                                             
function go
  close all % закрыть все открытые графики
  tic
  
  % Начальные установки
  is_draw_E = 0; % нужно ли рисовать напряженность
  is_draw_PPM = 1; % -//- ППМ
  is_draw_contour = 1;
  is_draw_surf = 1;
  is_ref = 1; % 1 - отражение от земли. 0 - отсутствие откражения
  is_ru = 0; % язык надписей
%  is_subplot = 0 % 1 - на одном рисунке. как???


  % электродинамические установки
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
  
  % геометрические установки
  select_plane_calc = [2,1,3]; % выбор плоскости расчета
    % 1 - x=const
    % 2 - y=const
    % 3 - z=const
       
    % плоскость сечения
    plane_x0 = 2; % 2 метра над землей
    plane_y0 = 0; 
    plane_z0 = 10;
    
    plane_d = 1; % шаг дискрета поверхности 
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
      var = select_plane_calc(i_plane);
      number_figure = var*10;
      % вычисление двумерных массивов плоскостей
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
      
      % параметры прямоугольной антенной решетки:
      dipole_h = 5; % высота цнтра
      dipole_n = 5; % количество излучателей в вертикальной линейке
      dipole_m = 8; % количество вертикальных линеек
      dipole_d = lambda/2; % шаг м-у излучателями по вертикали и горизонтали
      % В локальной системе координат
      dipole_dn = dipole_d;
      dipole_dm = dipole_d;
      dipole_x_local = ( (1:dipole_n) - (dipole_n+1)/2 ) * dipole_dn; % вектор высот излучателей
      dipole_y_local = ( (1:dipole_m) - (dipole_m+1)/2 ) * dipole_dm; % вектор координат по ширине
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
        PPM_0 = 25;%25; % [мкВт/см^2] граница СЗЗ, 0 дБ
      PPM_min = -41; % граница минимального значения для отображения на графики, 
      PPM_max = 0; % граница по максимальному значению
  if 1   
      %решение
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
        
        % проекция нормированного поля (без учета энергетики): 
        E = E + DN.*exp(-1i*k*R)./R.*r./R;
        
        if is_ref % отражение от земли
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
      
       
      PPM = 10*log10( dipole_PG/4/pi ) + 20*log10( abs(E+(E==0)*eps) ) - ...
        10*log10( PPM_0 ); % плотность потока мощности (ППМ)
      %PPM = PPM.*(PPM >= PPM_min) + PPM_min.*(PPM < PPM_min) ; % ограничения:
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
          figure(number_figure+1,'menubar','none');
          contour(figure_X, figure_Y, abs(E),'ShowText','off')
          title(title_fig)
          xlabel(xlab_fig)
          ylabel(ylab_fig)
          grid on
          colorbar
        end  
        if is_draw_surf
          figure(number_figure+2,'menubar','none')
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
          figure(number_figure+3,'menubar','none')
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
          figure(number_figure+4,'menubar','none')
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
    toc; tic;
  end
    
  
  % окно навигации по рисункам
    h_fig1 = figure(1);
    set(h_fig1,'menubar','none');
    set(h_fig1,'name','navigation');
    h_fig1_position = get(h_fig1,'position');
    h_screen_position = get(0,'screensize');
    h_h = 30; % высота подписи 
    h_fig1_position_new = [ h_fig1_position(1),...
      h_fig1_position(2)+h_fig1_position(4)+1*h_h,...
      h_fig1_position(3),...
      h_screen_position(4)-h_fig1_position(2)-h_fig1_position(4)-2*h_h];
    set(h_fig1,'position',h_fig1_position_new);
      
    height_button = 35;
    weigth_button = 85;
    step_button = 5;
    h_button_position0 = [0, h_fig1_position_new(4)-height_button,weigth_button,height_button];
    h_button_position = h_button_position0 ;
    h_fig1_rb1 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','draw_E', 'value', 0, 'tag','tag_rb_draw_E');
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig1_rb2 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','draw_PPM', 'value', 0, 'tag','tag_rb_draw_PPM');
      
    h_button_position = h_button_position0 - [0, step_button + height_button ,0 ,0];;
    h_fig1_rb3 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','X = const', 'value', 0, 'tag','tag_rb_draw_X');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig1_rb4 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','Y = const', 'value', 0, 'tag','tag_rb_draw_Y');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig1_rb5 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','Z = const', 'value', 0, 'tag','tag_rb_draw_Z');  
      
    h_button_position = h_button_position0 - [0, 2*(step_button + height_button) ,0 ,0];;
    h_fig1_rb6 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','contour', 'value', 0, 'tag','tag_rb_draw_contour');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig1_rb7 = uicontrol(h_fig1,'style','radiobutton','position',h_button_position,...
      'string','surface', 'value', 0, 'tag','tag_rb_draw_surf');
      
    set(guihandles.tag_rb_draw_E,'value',1)
    set(guihandles.tag_rb_draw_PPM,'value',0)
    if ~is_draw_E
      set(guihandles.tag_rb_draw_E,'value',0,'enable','off')
      set(guihandles.tag_rb_draw_PPM,'value',1)
    end
    if ~is_draw_PPM
      set(guihandles.tag_rb_draw_PPM,'value',0,'enable','off')
      set(guihandles.tag_rb_draw_E,'value',1)
    end
    %if is_draw_E && is_draw_PPW
    %  set(guihandles.tag_rb_draw_E,'value',1)
    %  set(guihandles.tag_rb_draw_PPM,'value',0)
    %end
    
    set(guihandles.tag_rb_draw_X,'value',1);
    set(guihandles.tag_rb_draw_Y,'value',0);
    set(guihandles.tag_rb_draw_Z,'value',0);
      
    if ~sum(select_plane_calc == 1)% X
      set(guihandles.tag_rb_draw_X,'value',0,'enable','off');
      set(guihandles.tag_rb_draw_Y,'value',1);
    end
    if ~sum(select_plane_calc == 2)% Y
      set(guihandles.tag_rb_draw_Y,'value',0,'enable','off');
      set(guihandles.tag_rb_draw_Z,'value',1);
    end
    if ~sum(select_plane_calc == 3)% Z
      set(guihandles.tag_rb_draw_Z,'value',0,'enable','off');
      set(guihandles.tag_rb_draw_X,'value',1);
    end
    
    set(guihandles.tag_rb_draw_contour,'value',1)
    set(guihandles.tag_rb_draw_surf,'value',0)
    if ~is_draw_contour
      set(guihandles.tag_rb_draw_contour,'value',0,'enable','off')
      set(guihandles.tag_rb_draw_surf,'value',1)
    end
    if ~is_draw_surf
      set(guihandles.tag_rb_draw_surf,'value',0,'enable','off')
      set(guihandles.tag_rb_draw_contour,'value',1)
    end
      
    % callbacks  
    set(guihandles.tag_rb_draw_E,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_PPM,[]});
    set(guihandles.tag_rb_draw_PPM,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_E,[]});
    
    set(guihandles.tag_rb_draw_X,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_Y,guihandles.tag_rb_draw_Z})
    set(guihandles.tag_rb_draw_Y,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_X,guihandles.tag_rb_draw_Z})
    set(guihandles.tag_rb_draw_Z,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_Y,guihandles.tag_rb_draw_X})
      
    set(guihandles.tag_rb_draw_contour,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_surf,[]});
    set(guihandles.tag_rb_draw_surf,'callback',{@func_push_rb,guihandles,...
      guihandles.tag_rb_draw_contour,[]});
      
%    h_button_position0 = [0, h_fig1_position_new(4)-height_button,weigth_button,height_button];
    h_button_position = h_button_position0 + 3*[weigth_button+step_button,0 ,0 ,0]; ;
    uicontrol(h_fig1,'style','text','position',h_button_position,...
      'string','PPM_0', 'tag','tag_text_PPM_0');
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    uicontrol(h_fig1,'style','edit','position',h_button_position,...
      'string',num2str(PPM_0), 'tag','tag_edit_PPM_0');
      
    h_button_position = h_button_position0 + [3*(weigth_button+step_button),-1*(step_button + height_button) ,0 ,0]; ;
    uicontrol(h_fig1,'style','text','position',h_button_position,...
      'string','PPM_min', 'tag','tag_text_PPM_min');
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    uicontrol(h_fig1,'style','edit','position',h_button_position,...
      'string',num2str(PPM_min), 'tag','tag_edit_PPM_min');  
      
    h_button_position = h_button_position0 + [3*(weigth_button+step_button),-2*(step_button + height_button) ,0 ,0]; ;
    uicontrol(h_fig1,'style','text','position',h_button_position,...
      'string','PPM_max', 'tag','tag_text_PPM_max');
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    uicontrol(h_fig1,'style','edit','position',h_button_position,...
      'string',num2str(PPM_max), 'tag','tag_edit_PPM_max');    
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    uicontrol(h_fig1,'style','pushbutton','position',h_button_position,...
      'string','save as', 'tag','tag_pb_save_as');    
      
  % окно входных данных
    h_fig2 = figure(2,'menubar','none');
    set(h_fig2,'name','input data');
    h_fig2_position_new = [ 10,...
      h_fig1_position(2),...
      h_fig1_position(1)-20,...
      h_fig1_position(4)];
    set(h_fig2,'position',h_fig2_position_new);
    
    %  height_button = 30;
    %  weigth_button = 80;
    %  step_button = 5;
    h_button_position0 = [0, h_fig2_position_new(4)-height_button,weigth_button,height_button];
    num_str = 0;
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'frequency, Hz','lambda, m'}, 'value', 0, 'tag','tag_text_frequency');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed1 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(frequency), 'value', 0, 'tag','tag_edit_frequency');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];  
    h_fig2_ed1a = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(lambda), 'tag','tag_edit_lambda');
    
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'array antenna', 'height, m'}, 'tag','tag_text_frequency');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed2 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_h ), 'tag','tag_edit_frequency');
      
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'num of dipoles', 'vertic & horiz'}, 'tag','tag_text_frequency');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed3 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_n ), 'tag','tag_edit_dipole_dn');  
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];  
    h_fig2_ed4 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_m ), 'tag','tag_edit_dipole_dm');  
      
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'step between', 'vertic & horiz'}, 'tag','tag_text_frequency');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed3 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_dn), 'tag','tag_edit_dipole_n');  
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];  
    h_fig2_ed4 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_dm), 'tag','tag_edit_dipole_m');    
    
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'titl angle', 'array, degrees'}, 'tag','tag_text_dipole_gamma');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed5 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_gamma), 'tag','tag_edit_dipole_gamma');
      
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    uicontrol(h_fig2,'style','text','position',h_button_position,...
      'string',{'angle elevat,','azimuth, degr'}, 'tag','tag_text_dipole_gamma');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed5 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_alpha), 'tag','tag_edit_dipole_gamma');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_ed5 = uicontrol(h_fig2,'style','edit','position',h_button_position,...
      'string',num2str(dipole_beta), 'tag','tag_edit_dipole_gamma'); 
    
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0] ;
    h_fig2_cb1 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','draw_E', 'value', 0, 'tag','tag_cb_draw_E');
      
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_cb2 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','draw_PPM', 'value', 0, 'tag','tag_cb_draw_PPM');
  
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0];
    h_fig2_cb3 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','X = const', 'value', 0, 'tag','tag_cb_draw_X');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_cb4 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','Y = const', 'value', 0, 'tag','tag_cb_draw_Y');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_cb5 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','Z = const', 'value', 0, 'tag','tag_cb_draw_Z');  
      
    h_button_position = h_button_position0 - [0, num_str++*(step_button + height_button) ,0 ,0];;
    h_fig2_cb6 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','contour', 'value', 0, 'tag','tag_cb_draw_contour');
    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_cb7 = uicontrol(h_fig2,'style','checkbox','position',h_button_position,...
      'string','surface', 'value', 0, 'tag','tag_cb_draw_surf');
      
    set(guihandles.tag_cb_draw_E,'value',is_draw_E)
    set(guihandles.tag_cb_draw_PPM,'value',is_draw_PPM)
    set(guihandles.tag_cb_draw_X,'value',sum(select_plane_calc == 1));
    set(guihandles.tag_cb_draw_Y,'value',sum(select_plane_calc == 2));
    set(guihandles.tag_cb_draw_Z,'value',sum(select_plane_calc == 3));
    set(guihandles.tag_cb_draw_contour,'value',is_draw_contour)
    set(guihandles.tag_cb_draw_surf,'value',is_draw_surf)
    
    
    h_button_position = h_button_position0 - [-2*(weigth_button+step_button), num_str++*(step_button + height_button) ,0 ,0];
%    h_button_position = h_button_position + [weigth_button+step_button,0 ,0 ,0];
    h_fig2_pb1 = uicontrol(h_fig2,'style','pushbutton','position',h_button_position,...
      'string','calculation', 'value', 0, 'tag','tag_pb_calc'); 
      
      %  if 0
      %    % callbacks  
      %    set(guihandles.tag_cb_draw_E,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_PPM,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_X,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_Y,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_Z,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_contour,'callback',{@func_push_cb,guihandles});
      %    set(guihandles.tag_cb_draw_surf,'callback',{@func_push_cb,guihandles});
      %  end
  
%  figure('menubar','none')
  toc
endfunction

function func_push_rb(a,b,guihandles,c,d)
  set(a,'value',1)
  set(c,'value',0)
  if ~isempty(d)
    set(d,'value',0)
  end
  number_fig = 10*get(guihandles.tag_rb_draw_X,'value')+...
               20*get(guihandles.tag_rb_draw_Y,'value')+...  
               30*get(guihandles.tag_rb_draw_Z,'value')+... 
                2*get(guihandles.tag_rb_draw_PPM,'value')+... 
                2*get(guihandles.tag_rb_draw_surf,'value')+... 
                  get(guihandles.tag_rb_draw_contour,'value');
  get_children = get(0,'children');      
  is_there = 0;
  for ii = 1 : length(get(0,'children'))
    if get_children(ii) > 9
      set(figure(get_children(ii)),'visible','off');
    end
    if number_fig==get_children(ii)
      is_there++;
    end
  end
  if is_there
    set(figure(number_fig),'visible','on');
  end
endfunction

