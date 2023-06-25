function [multiIm, annotationIm] = loadMulti(imName, annotationName, dirPath)
% Loading multispectral image and an annotation
% 
% function [multiIm, annotationIm] = loadMulti(imName, annotationName)
% 
% Input
%   imName - name of multispectral image file - a *.mat file
%   annotationName - name of annotation image file - a *.png file
%   dirPath (optional) - path to data directory where the image files are
%       placed
% 
% Output
%   multiIm - multispectral image
%   annotationIm - image with annotation mask of size r x c x 3. Layer 1 is
%       the salami annotation (both fat and meat, layer 2 is the fat, and
%       layer 3 is the meat. The pixel value is 1 in the annotation and 0
%       elsewhere.
% 
% Anders Lindbjerg Dahl - DTU, January 2013
% 

% check if dirPath is given
if ( nargin == 2 )
    dirPath = '';
end

% load the multispectral image
load([dirPath imName]);
multiIm = immulti;

% make annotation image of zeros
annotationIm = zeros(size(multiIm,1), size(multiIm,2), 3);

% read the mask image
aIm = imread([dirPath annotationName]);

% set in ones
for i = 1:3
    annotationIm(:,:,i) = ( aIm(:,:,i) == 255 );
end














