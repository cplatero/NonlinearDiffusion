%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%
%%% FUNCI�N DE DIFUSI�N HIPERB�LICA MODIFICADA PARA DIMENSI�N 2 
%%% SE CONSTRUYE A PARTIR DE LA FUNCI�N Difusion2D_HiperM, PERO 
%%% SE MODIFICA PARA TENER COMO ARGUMENTO DE ENTRADA 'p' y 'ro'
%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% function [g,Dg] = Difusion_HM(GradU2, p, ro)
function g = Difusion_HM(GradU2, p, ro)

%
%% IDENTIFICACI�N DE VARIABLES:
%     Entrada: 
%          GradU2 :  Norma_2 al cuadrado del gradiente de U
%     Salida:
%               g :  Funci�n de difusividad
%               Dg:  Derivada de la funci�n de difusividad.
%
%% ENTRADA DE DATOS
%
%
% mu = 0;   % Valor entre [0, p];  Si mu = 0 => valor m�ximo: 1
          %                      Si mu = p  => valor m�ximo: ro^(-p)
%
%
%% C�LCULO DE LA FUNCI�N DE DIFUSI�N
%
g = ones(size(GradU2));
%
% alfa = p - mu;
%
if(length(ro(:))~=1)
    ro2D=g;
    ro2D(:,:,1)=ro;
    ro2D(:,:,2)=ro;
    maskRo = GradU2 > ro2D;
    g(maskRo) =  (ro2D(maskRo)./( GradU2(maskRo))) .^ (p/2) ;
else
    maskRo = GradU2 > ro;
    g(maskRo) =  (ro./( GradU2(maskRo))) .^ (p/2) ;
end


% g(GradU2 < ro) =  ro^(alfa - p);
%
% Derivada
%
% Dg(GradU2 < ro) = 0; 
% Dg(GradU2 >= ro) = -(p/2) * ro^(alfa - p/2) ./( GradU2(GradU2 >= ro) .^ (p/2 + 1) );
%
end
%
%
% FIN