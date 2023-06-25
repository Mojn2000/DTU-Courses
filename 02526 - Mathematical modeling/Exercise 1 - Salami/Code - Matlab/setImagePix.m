function rgbOut = setImagePix(rgbIm, pixId)
% Building a RGB image containing color pixels in regions and white
%   elsewhere
% 
% function rgbOut = setImagePix(rgbIm, pixId) 
% 
% Input
%   rgbIm - color image of size r x c x 3
%   pixId - pixels that should contain color values. Either a list of row
%       and column indices of size n x 2, or a binary image of size r x c 
%       with regions that should contain color values.
% 
% Output
%   rgbOut - output rgb image
% 
% Anders Lindbjerg Dahl - DTU, January 2013
% 

rgbOut = rgbIm;

if ( size(pixId,1) == size(rgbIm,1) && size(pixId,2) == size(rgbIm,2) )
    for i = 1:size(rgbIm,3)
        rgbOut(:,:,i) = rgbIm(:,:,i).*pixId + 255*(1-pixId);
    end
else
    rgbOut = rgbOut*0 + 255;
    for i = 1:size(pixId,1)
        rgbOut(pixId(i,1), pixId(i,2),:) = rgbIm(pixId(i,1), pixId(i,2),:);
    end
end

rgbOut = uint8(rgbOut);

