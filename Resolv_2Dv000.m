%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Programa que resuelve la ecuación en 2D
%%%
%%%  U^(nu+1) = [I-A_{x}(U^{nu})]^{-1}[Usg] + [I-A_{y}(U^{nu})]^{-1}[Usg]
%%%
%%% aplicando el Método de Thomas en cada componente
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
function U_XY = Resolv_2Dv000( Usg, g, dt)
%%
%%%%% Entrada de datos:
%
%%%%%           Usg     : Segundo miembro
%%%%%           U_iter  : Dato inicial de las sucesivas iteraciones
%%%%%           FDif    : Función de difusión, definida por un programa
%%%%%                        exterior.
%%%%%           dt      : Incremento de tiempo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% 
%%%%  Salida de datos:
%
%%%%            U_XY      : Solución de la iteración  'n+1'
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
DimF = size(Usg,1);    %% Número de filas
DimC = size(Usg,2);   %% Número de columnas
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Se construye la matriz de iteración I-dt*A_x(U)   %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%% Se construyen las matrices para el Algoritmo de Thomas
% 
% Se opera sobre las filas 
%
q(2:DimF-1, :) = g(1:DimF-2, :, 1) + g(2:DimF-1, :, 1);
%
q(1, :) = g(1, :, 1);                 %% Condiciones de
q(DimF, :) = g(DimF-1, :, 1);         %% contorno en X
%
% Coeficientes de I - dt*A(U)
%
a = 1 + dt*q;      
b = g(1:DimF-1, :, 1);    
b = -dt * b;
%
Usol_F = thomas(a, b, b, Usg) ; %%% Solución del sistema. 
%
% Difer_iter = Usol_F - U_iter;
% tol_iter = norm(Difer_iter, 1)/norm(U_iter,1);
% %
% fprintf(fid,'\t error en X : %f\n', tol_iter);
%
clear q a b;
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Se construye la matriz de iteración I-dt*A_y(U)     %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%%% Se construyen las matrices para el Algoritmo de Thomas
% 
% Se opera sobre las columnas
%
q(:, 2:DimC-1) = g(:, 1:DimC-2, 2) + g(:, 2:DimC-1, 2);
%
q(:, 1) = g(:, 1, 2);          % Condiciones de
q(:, DimC) = g(:, DimC-1, 2);  %  contorno en Y
%
a = 1 + dt * q';          % Traspuesta
b = g(:, 1:DimC-1, 2)';   % Traspuesta
b = - dt * b;    
%
Usol_C = thomas(a,b,b,Usg')' ; %%% Solución del sistema 
%                            %%% para las columnas (componente Y)
%
% Difer_iter = Usol_C - U_iter;
% tol_iter = norm(Difer_iter, 1)/norm(U_iter,1);
% %
% fprintf(fid,'\t error en Y : %f\n', tol_iter);
%
% Solución de la iteración
%
U_XY = Usol_F + Usol_C;
%
clear q a b;
%
end
