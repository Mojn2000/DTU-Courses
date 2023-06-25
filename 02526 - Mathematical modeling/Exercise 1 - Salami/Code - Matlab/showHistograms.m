function h = showHistograms(multiIm, pixId, band, showOn)
% Extracting a histogram from an 8 bit multispectral image (values ranging from 0
% to 255)
% 
% function h = showHistograms(multiIm, pixId, band, showOn)
% 
% Input
%   multiIm - multispectral image
%   pixId - pixels that should be included in the histogram. Either a list of row
%       and column indices of size n x 2, or a binary image of size r x c x m 
%       with regions that should be part of the histogram. m is the number
%       of histograms that should be extracted.
%   band - spectral band where the histogram should be extracted
%   showOn (optional) - boolean that tells if the histogram should be
%       plotted. Default is not to plot the histogram. 
% 
% Output
%   h - multispectral image
% 
% Anders Lindbjerg Dahl - DTU, January 2013
% 

if ( nargin == 3 )
    showOn = false;
end


if ( size(pixId,1) == size(multiIm,1) && size(pixId,2) == size(multiIm,2) )
    n = size(pixId,3);
    h = zeros(256,n);
    for i = 1:n
        for j = 1:size(pixId,1)
            for k = 1:size(pixId,2)
                if ( pixId(j,k,i) == 1 )
                    h(multiIm(j,k,band)+1,i) = h(multiIm(j,k,band)+1,i) + 1;
                end
            end
        end
    end
else
    h = zeros(256,1);
    for i = 1:size(pixId,1)
        h(multiIm(pixId(i,1),pixId(i,2),band)+1) = h(multiIm(pixId(i,1),pixId(i,2),band)+1) + 1;
    end
end

if ( showOn )
    hId = find(sum(h,2) > 0);
    fId = max(min(hId)-3,1);
    tId = min(max(hId)+3,255);
    figure
    plot(fId:tId,h(fId:tId,:))
end


