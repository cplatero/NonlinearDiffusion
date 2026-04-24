%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% FUNCIÓN GRADIENTE AL CUADRADO  DE  U (INTESIDAD) PARA 2D   
%%% CON CONDICIONES DE NEUMANN. Segundo método 
%%%                                                                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function GradU2 = GradU2_2D(U)
%
%% IDENTIFICACIÓN DE VARIABLES
%     Entrada:
%              U : Imagen 
%     Salida:
%         GradU2 : Norma_2 al cuadrado del gradiente de U
%
%% VALORES INICIALES
dx = 1;     %% Incrementos espaciales
dy = 1;     %% en cada componente 
%
% Cuadrados
%
dx2 = dx * dx;
dy2 = dy * dy;
%
%% DIMENSIONES
%
Lx = size(U,1); %%% Número de filas 
Ly = size(U,2); %%% Número de columnas
%
%% DIFERENCIAS EN LA COMPONENTE X
%
Udif_x(1:Lx-1, :, 1) = U(2:Lx, :) - U(1:Lx-1, :);  
%
Udif_y(:, 2:Ly-1, 1) = U(:, 3:Ly) - U(:, 1:Ly-2);  
%
%% DIFERENCIAS EN LA COMPONENTE Y
%
Udif_x(2:Lx-1, :, 2) = U(3:Lx, :) - U(1:Lx-2, :); 
%
Udif_y(:, 1:Ly-1, 2) = U(:, 2:Ly) - U(:, 1:Ly-1);  
%
%% COMPONENTES DEL GRADIENTE EN LA VARIABLE X: DxU2, DyU2
%
%  %%%%%% Componente en X %%%%%%
%
DxU2(1:Lx-1, :, 1) = (1/dx2) * Udif_x(1:Lx-1, :, 1) .* Udif_x(1:Lx-1, :, 1);
DxU2(Lx, :, 1) = DxU2(Lx-1, :, 1); %%%% Se completa el vector (Esto NO es necesario)
%
%   %%%%%% Componente en Y  %%%%%%
%
DyU2(1:Lx-1, 2:Ly-1, 1) = 0.0625 * (1/dy2) * ( ( Udif_y(2:Lx, 2:Ly-1, 1) + Udif_y(1:Lx-1, 2:Ly-1, 1) ) .* ...
                                               ( Udif_y(2:Lx, 2:Ly-1, 1) + Udif_y(1:Lx-1, 2:Ly-1, 1) ) );
%
%  %%%%% CC (Neuman) para Y  %%%%%
%
DyU2(1:Lx-1, 1, 1) = 0.0625 * (1/dy2) * ( ( Udif_y(2:Lx, 1, 2) +  Udif_y(1:Lx-1, 1, 2) ) .*...
                                          ( Udif_y(2:Lx, 1, 2) +  Udif_y(1:Lx-1, 1, 2) ) );
                        
%
DyU2(1:Lx-1, Ly, 1) = 0.0625 * (1/dy2) * ( ( Udif_y(2:Lx, Ly-1, 2) + Udif_y(1:Lx-1, Ly-1, 2) ) .* ...
                                           ( Udif_y(2:Lx, Ly-1, 2) + Udif_y(1:Lx-1, Ly-1, 2) ) );    
%
DyU2(Lx, 1:Ly, 1) = DyU2(Lx-1, 1:Ly, 1); %%% Se completa el vector (Aunque NO es necesario)
%
%
% Cálculo del cuadrado de la norma del gradiente en la componente (X)
%
GradU2(:, :, 1) = DxU2(:, :, 1) + DyU2(:, :, 1);
%
% Dimensión de Grad2(:,:,1): Lx * Ly. Realmente sólo se necesita
% (Lx-1)*Ly
%
%% COMPONENTES DEL GRADIENTE EN LA VARIABLE Y: DxU2, DyU2
%
%    %%%%%%%%%%%% Componente en X %%%%%%%%%%%
%
DxU2(2:Lx-1, 1:Ly-1, 2) = 0.0625 * (1/dx2) * ( ( Udif_x(2:Lx-1, 2:Ly,  2) + Udif_x(2:Lx-1, 1:Ly-1, 2) ) .*...
                                               ( Udif_x(2:Lx-1, 2:Ly, 2) + Udif_x(2:Lx-1, 1:Ly-1, 2) ) );
%
%    %%%%%%% CC (Neumann) en X *******
%
DxU2(1, 1:Ly-1, 2) = 0.0625 * (1/dx2) * ( ( Udif_x(1, 2:Ly, 1) +  Udif_x(1, 1:Ly-1, 1) ) .* ...
                                          ( Udif_x(1, 2:Ly, 1) + Udif_x(1, 1:Ly-1, 1) ) );  
%                                      
DxU2(Lx, 1:Ly-1, 2) = 0.0625 * (1/dx2) * ( ( Udif_x(Lx-1, 2:Ly, 1) + Udif_x(Lx-1, 1:Ly-1, 1) ) .* ...
                                           ( Udif_x(Lx-1, 2:Ly, 1) + Udif_x(Lx-1, 1:Ly-1, 1) ) );  
%
DxU2(1:Lx, Ly, 2) = DxU2(1:Lx, Ly-1, 2);
%
%     %%%%%%%%%%% Componente en Y %%%%%%%
%
DyU2(:, 1:Ly-1, 2) = (1/dy2) * ( Udif_y(:, 1:Ly-1, 2) .* Udif_y(:, 1:Ly-1, 2) );
DyU2(:, Ly, 2) = DyU2(:, Ly-1, 2);
%
% Cálculo del cuadrado de la norma del gradiente en (Y)
%
GradU2(:, :, 2) = DxU2(:, :, 2) + DyU2(:, :, 2);
%
end
