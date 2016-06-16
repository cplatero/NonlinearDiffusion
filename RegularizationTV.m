function fTV=RegularizationTV(y,lambda)
% RegularizationTV
%
% Usage:
% RegularizationTV
%
% Input:
% y: image
% lambda: regularization term 
%
% Output: 
%
%
% Carlos Platero,   06/2016
%
epsilon = 1e-2;
tau = 2 / ( 1 + lambda * 8 / epsilon);
fTV = y;

energy_new = inf;
next = true;
while(next)
    Gr = grad(fTV);
    d = sqrt(sum3(Gr.^2,3));
    G0 = -div( Gr ./ repmat( sqrt( epsilon^2 + d.^2 ) , [1 1 2]) );
    G = fTV-y+lambda*G0;
    fTV = fTV - tau*G;
    deps = sqrt( epsilon^2 + d.^2 );
    energy_old=energy_new;
    energy_new = 1/2*norm( y-fTV,'fro' )^2 + lambda*sum(deps(:));
    if((energy_old-energy_new)/energy_old < .001)
        next =false;
    end
    
end
