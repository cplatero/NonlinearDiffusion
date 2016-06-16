function demoPiecewiseImageFilter
% demoPiecewiseImageFilter
%
% Usage:
% demoPiecewiseImageFilter
%
% Input:
%
% Output: 
%
%
% Carlos Platero,   06/2016
%
%% List of image training set
pathImages = './data/';
pathManualSeg = './ManualSegm/';
im_size=128;
listFiles=getListFiles(im_size,pathImages,pathManualSeg);
numImages=numel(listFiles);

u=[];
edges_canny=[];

%% Parameters
iter_max = 1000;
dt=200;
P_list=[2.5;20;2.5;5.5;6;13;5.5];
lambda_TV=0.25;

%% Image processing batch
for i=1:numImages
    u0=listFiles(i).image;
    manSegm=listFiles(i).label;
    %% Proposed approach
    [~,niter_s]= get_ts(u0,dt,iter_max);  
    fprintf('For image %d -> dt = %.1f     niter_s = %d\n',i,dt,niter_s);
    u1 = proposedFilter(u0,dt,niter_s,P_list(i));
    %% NLD
    u2 = nldif(u0*255,4,1,12,dt,niter_s,'aos');
    %% TV
    u3 = RegularizationTV(u0,lambda_TV);
    u=[u,[u0;u3;u2/255;u1]];
    fprintf('F: %.3f %.3f %.3f %.3f\n',proc_features(u0,manSegm),...
        proc_features(u3/255,manSegm),proc_features(u2,manSegm),...
        proc_features(u1,manSegm));
    edges_canny=[edges_canny,[imerode(bwperim(manSegm)==0,strel('disk',1));...
        edgeImage(u3);edgeImage(u2);edgeImage(u1)]];
    
end
figure(1);imshow(u);
figure(2);imshow(edges_canny);




end

function listFiles=getListFiles(n,pathImages,pathManualSeg)

listImFich = dir ( strcat(pathImages,'*.jpg') );
listlbFich = dir ( strcat(pathManualSeg,'*.bmp') );
listFiles(1,numel(listImFich))=struct('image',[],'label',[],'name',[]);
for i=1:numel(listImFich)
    listFiles(i).image = imresize(im2double(rgb2gray(imread(strcat...
        (pathImages,listImFich(i).name)))),[n n]);
    listFiles(i).label = imresize(logical(imread(strcat...
        (pathManualSeg,listlbFich(i).name))),[n,n]);
    listFiles(i).name = listImFich(i).name;
end
end

function u = proposedFilter(u,dt,niter_s,P_list)

%% Gamma
rho = globalGamma(u);
    
for j=1:niter_s   
    GradU2 = GradU2_2D(u);  
    g = Difusion_HM(GradU2, P_list, rho);
    u = (1/2) * Resolv_2Dv000(u, g, dt);  
end

end

function rho = globalGamma(u0)
GradU2 = GradU2_2D(u0);
MadGradU0 = mad(GradU2(:).^.5,1);
rho=(1.4826*MadGradU0)^2; 
end

function F=proc_features(u,bwManSeg2D)
sigmaGauss = 1;
bwEdges = bwperim(bwManSeg2D,8);
DilBwEdges = imdilate(bwEdges,strel('disk',1));
bwCanny=edge(u,'canny',[],sigmaGauss);
TP = bwCanny & DilBwEdges;
sumTP = sum( TP(:));
sumFN = sum(bwEdges(:)) - sumTP;
FP = bwCanny & DilBwEdges==0 & bwManSeg2D;
SENS = sumTP/(sumTP+sumFN+eps);
PPV = sumTP/(sumTP+sum(FP(:))+eps);
F=harmmean([SENS,PPV],2);

end

function bwCanny=edgeImage(u)
sigmaGauss=1;
bwCanny=imerode(edge(u,'canny',[],sigmaGauss)==0,strel('disk',1));
end
