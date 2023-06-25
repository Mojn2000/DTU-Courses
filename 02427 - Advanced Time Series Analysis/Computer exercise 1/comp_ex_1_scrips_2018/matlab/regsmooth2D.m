function [x,y,zTilde,distMax] = regsmooth2D(data, points, order ,h, bound, conditional_on_y);
% Locally weighted polynomial regression
% Tri-cube weight-function
% 
% [x,y,zTilde] = smooth_localreg2D(data, points, order ,h)
% 
% Input:
% Data:   [x ; y ; z]
% ponits: Grid resolution on each axis
% order:  order of fitted polynomium
% h:      bandwidth 0<h<1
% bound:  [minX maxX minY maxY]
% conditional_on_y: if 0 the model is fitted with local polynomial regression, 
%                   and if 1 the the model is conditional parametric, i.e. globally linear in the y dimension
%
% Output can be used as: surf(x,y,zTilde)
%
% Stig B. Mortensen, 2004.

% number of nearest neighbors
NN = round(h*length(data));

% create grid of x,y for interpolation
% scale x and y axes to [-1,1]
if nargin == 4
    minX = min(data(:,1)); maxX = max(data(:,1)); 
    minY = min(data(:,2)); maxY = max(data(:,2)); 
else
    minX=bound(1);maxX=bound(2);minY=bound(3);maxY=bound(4);
end
scaleX = maxX-minX; scaleY = maxY-minY;
dataSc(:,1) = ((data(:,1)-minX)/scaleX)*2-1; %IMPORTANT: scale data to [-1,1]
dataSc(:,2) = ((data(:,2)-minY)/scaleY)*2-1; %IMPORTANT: scale data to [-1,1]

%create grid in scaled space
xVec = linspace(-1,1,points);
yVec = linspace(-1,1,points);
[x y] = meshgrid(xVec,yVec);
x = x(:); y = y(:);


for p = 1:points^2
    % find distance from current point x,y to data
    switch conditional_on_y
        case 0
            dist = sqrt((dataSc(:,1)-x(p)).^2 + (dataSc(:,2)-y(p)).^2);
        case 1
            % If conditional on y, weight only in the x dimension
            dist = sqrt((dataSc(:,1)-x(p)).^2);
    end
    [sortDist sortIdx] = sort(dist);
    
    %extract nearest neighbors points
    sortIdx = sortIdx(1:NN);
    distNN = dist(sortIdx); 
    distMax(p) = max(distNN); %store size of local neighborhood
    xNN = dataSc(sortIdx,1);
    yNN = dataSc(sortIdx,2);
    zNN = data(sortIdx,3);
    
    % designmatrice og eval punkt
    U = ones(NN,1);
    ep = 1;
    switch order
        case 1
            U = [U xNN yNN];
            ep = [ep x(p) y(p)];
        case 2
            switch conditional_on_y
                case 0
                    U = [U xNN yNN xNN.^2 yNN.^2 xNN.*yNN];
                    ep = [ep x(p) y(p) x(p)^2 y(p)^2 x(p)*y(p)];
                case 1
                    U = [U xNN yNN xNN.^2 ];
                    ep = [ep x(p) y(p) x(p)^2 ];
            end
    end
    
    % weights tri-cube
    distNN = distNN/max(distNN); %truncate distNN to [0,1] for proper wheights
    W = (1-distNN.^3).^3; 
    W = spdiags(W,0,length(W),length(W));
    
    % solve normal equation
    % theta = (U'*W*U)^(-1)*U'*W*zNN;
    theta = (U'*W*U)\(U'*W*zNN);
    
    % evaluate estimated locally wheighted polynomial
    zTilde(p) = ep*theta; %theta(1); %ep*theta;
end

% replace x and y by unscaled axes
x = linspace(minX,maxX,points); y = linspace(minY,maxY,points); 
[x y] = meshgrid(x,y);
zTilde = reshape(zTilde,points,points);
distMax = reshape(distMax,points,points);

