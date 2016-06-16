function [f,n_ts]= get_ts(f,dt,niter)
% get_ts
%
% Usage:
% get_ts
%
% Input:
% f: image
% dt: time step
% niter: iteration max
% Output: 
%  f: mean image (linear diffusion)
%  n_ts: iterations for getting setting time
%
% Carlos Platero,   06/2016
%
%% Selección de los bordes
mean_inf = mean(f(:));
[nx,ny]=size(f);

g=ones(nx,ny,2);
i=1;
salir = false;
while ((i<=niter) && (salir == false))
    
     f = (1/2) * Resolv_2Dv000(f, g, dt);
    error_f = max(abs(f(:)-mean_inf));
    if(error_f<=.02*mean_inf)
        salir=true;
    end
    i=i+1;
    
end
n_ts = i-1;

    

