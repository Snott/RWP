function kod
%% -----------------------------------------------------------------
% P u r p o s e : A c c u r a t e s o u r c e m o d e l i n g
% P l o t F i e l d v s . R a n g e f o r T E z c a s e
% f o r L i n e s o u r c e a n d t i l t e d D i r e c t i v e An t e n n a
% C omp a r e 2 Ra y , S S P E a n d M o M me t h o d s
% % -----------------------------------------------------------------
% clear all ; clc ; close all ;
% % I n i t i a l p a r ame t e r s
% Zmax = 1000 ; Nz = 1000 ; Dz =Zmax / Nz ; Xmax = 2000 ; Nx= 401 ;
% lam= 10 * Dz ; k0 = 2 * pi / lam ; ht = 200 ; elv= -15 ; bw= 30 ; Xo = ht ;
% %% ---------------------- MoM -----------------------
% Zt = ( O . 5 : N z - O . 5 ) * D z ; X t = z e r o s ( l , N z ) ; % f o r F l a t - E a r t h
% Wt h = @ ( t h ) e xp ( - ( s i n ( t h ) - s i n d ( e l v ) ) . A 2 * l o g ( 2 ) / ( 2 * s i n d ( bw / 2 ) A 2 ) ) ;
% c t h= l / s qr t ( s um ( c h e b f u n ( @ ( t ) W t h ( t ) . A 2 , [ - p i / 2 , p i / 2 ] + e l v / 1 8 0 * p i ) ) ) ;
% % S e gm e n t Vo l t a g e s f r om S o u r c e - t o - S e gm e n t
% d s = s q r t ( ( X t - h t ) . A 2 +Zt . A 2 ) ; r a ya n g = a t a n ( ( X t - h t ) . / Zt ) ;
% V_i n c = - c t h * W t h ( r a y a n g ) . * e xp ( - l i * k O * d s ) . / s q r t ( d s ) ;
% % - - - - - - - - - - - - - - - - F o rm I mp e d a n c e Ma t r i x -------------------imp_
% ma t = - O . 2 5 * D z * 1 2 0 * p i * k O * ( 1 - l i * 2 / p i * . . .
% l o g ( e xp ( O . 5 772 1 5 66 5 ) * k O * D z / ( 4 * e xp ( 1 ) ) ) ) * o n e s ( N z , l ) ;
% f o r m= l : N z - l ,
% dd= D z * m ; v a l = - O . 2 5 * D z * 1 2 0 * p i * k O * b e s s e l h ( O , 2 , k O * dd ) ;
% imp_ma t = [ v a l * o n e s ( N z , l ) imp_m a t v a l * o n e s ( N z , l ) ] ;
% e n d
% imp_m a t = s p dia g s ( imp_ma t , - ( Nz- l ) :Nz- l , Nz , Nz ) ;
% I = f u l l ( imp_m a t ) \t r a n s p o s e ( V_i n c ) ; % F i n d S e gm e n t C u r r e n t s
% % - - - - - - - - - - - - - - - - - R a n g e P r ofi l e - - - - - - - - - - - - - - - - - - -
% E s c = z e r o s ( l , N z ) ; E i n c = z e r o s ( l , N z ) ; E t o t = z e r o s ( l , N z ) ;
% f o r n = l : N z
% E s c ( n ) = O ; Zo =Zt ( n ) ;
% f o r m= l : N z
% dd= s q r t ( ( X o - X t ( m ) ) A 2 + ( Zo - Zt ( m ) ) A 2 ) ;
% E s c ( n ) = E s c ( n ) + I ( m ) * b e s s e l h ( O , 2 , k O * dd ) ;
% e n d
% E_ s c ( n ) = - O . 2 5 * D z * k O * 1 2 0 * p i * E_ s c ( n ) ;
% d O = s qr t ( ( XO- h t ) A 2 +Zo A 2 ) ; r a ya n g = a t a n ( ( X o - h t ) / Z o ) ;
% E i n c ( n ) = c t h * W t h ( r a y a n g ) . * e xp ( - l i * k O * d O ) . / s q r t ( d O ) ;
% E t o t ( n ) = E i n c ( n ) + E s c ( n ) ;
% e n d
% % -----------------End o f MoM ---------------------
%%-----------Two Ray Model--------  
Zmax=1000; Nz=1000; Dz=Zmax/Nz; Xmax=2000; Nx=401;
lam=10*Dz; k0=2*pi/lam; ht=200; elv=0; bw=30; X0=100;
Zt=(0.5:Nz-0.5)*Dz; Xt=zeros(1,Nz);
Wth=@(th) exp( -(sin(th)-sind(elv) ).^2*log(2)/( 2*sind(bw/2)^2 ));
cth=1/sqrt( sum(chebfun( @(t) Wth(t).^2,[-pi/2,pi/2]+elv/180*pi )) );
E_2Ray=RAY2(Zt, X0, ht, Wth, k0, cth); 
%%------------SSPE------------  
 dx=Xmax/(Nx-1); X=0:dx:2*Xmax; N=length(X); 
fr = [1.5 2]; % filter is applied to (r1 r2)*Xmax 
FILFUN = @(x) (x<=fr(1)*Xmax)+(x>fr(1)*Xmax).*... 
   (1+cos(pi*(x-fr(1)*Xmax)/((fr(2)-fr(1))*Xmax)))/2; 
u=zeros(N,Nz+1);
 ww=sqrt(2*log(2))/(k0*sind(bw/2)); % beamwidth 
cx=1/sqrt(sqrt(pi/2)*ww); % normalization tanstant 
ufs=@(xx) cx*exp(-1i*k0*sind(elv)*xx).*exp(-((xx-ht)/ww).^2) ; 
Field=ufs(X); Field(1)=0; u(:,1)=Field; kX=linspace(0,pi/dx,N).'; 
CC1=exp(1i*Dz*kX.^2./(k0*(1+sqrt(1-kX.^2/k0^2)))).'; 
for n=1:Nz, % SSPE Range Loop starts 
   Field(2:N-1)=idst(CC1 (2:N-1).*dst(Field(2:N-1))); 
   Field=Field.*FILFUN(X);
   u(:,n+1)=Field;
 end % SSPE Range Loop ends 
Z=(0:Dz:Zmax); E_pe=exp(-1i*k0*Z).*u(round(X0/dx)+1,:); 
%%----------Show 2D fields------   
% plot(Zt,abs(E_tot),Zt,abs(E_2Ray),'r--',Z,abs(E_pe),'k:');
figure(1);
plot(Zt,abs(E_2Ray),'r',Z,abs(E_pe),'k','linewidth',1);
grid on
 xlabel('Distance [m]','Fontweight','bold');
 ylabel('|Fieldlr|','Fontweight','bold');% legend('MoM','2Ray','PE'); 
  legend('2Ray','PE'); 
% title('Field over Flat-Earth: 2Ray / MoM / PEM','Fontweight','bold');
title('Field over Flat-Earth: 2Ray / PEM','Fontweight','bold');
%%--------FMnetion for 2Ray modal--------   
function E_2Ray = RAY2 (Z, X, ht, Wth, k0, cth ) 
R1=sqrt(Z.^2+(ht-X).^2); rayang1=atan((X-ht)./Z); 
E_i=cth*Wth(rayang1).*exp(-1i*k0*R1)./sqrt(R1); 
R2=sqrt(Z.^2+(ht+X).^2); rayang2=-atan((X+ht)./Z); 
E_r=cth*Wth(rayang2).*exp(-1i*k0*R2)./sqrt(R2); 
E_2Ray=E_i-E_r; 
%%------END----