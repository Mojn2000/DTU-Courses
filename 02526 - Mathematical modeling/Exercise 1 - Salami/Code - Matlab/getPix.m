function [clPix, r, c] = getPix(multiIm, maskIm)
% Extracting pixels from multispectral image
% 
% function [clPix, row, col] = getPix(multiIm, maskIm) 
% 
% Input
%   multiIm - multispectral image of size r x c x l
%   maskIm - binary mask with ones at pixels that should be extracted (use
%       layers from annotationIm from the loadMulti function)
% 
% Output
%   clPix - pixels in n x l matrix
%   row - row pixels indicies
%   col - column pixels indicies
% 
% Anders Lindbjerg Dahl - DTU, January 2013
% 
nMask = sum(maskIm(:));

[r, c] = find(maskIm == 1);

clPix = zeros(nMask, size(multiIm,3));
for i = 1:size(multiIm,3)
    tmp = multiIm(:,:,i);
    clPix(:,i) = tmp(maskIm == 1);
end



