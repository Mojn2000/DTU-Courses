% This script exemplifies the use of the various functions supplied for the
% first exercise
% Anders Nymark Christensen
% 20180130
% Adapted from work by Anders Bjorholm Dahl

% Folder where your data files are placed
dirIn = 'path/to/my/data/folder/';


%% Example of loading a multi spectral image

[multiIm, annotationIm] = loadMulti('multispectral_day20.mat' , 'annotation_day20.png', dirIn);

% multiIm is a multi spectral image - the dimensions can be seen by
size(multiIm)

%% Show image óf spectral band 7

figure
imagesc(multiIm(:,:,7))

%% annotationIm is a binary image with 3 layers

size(annotationIm)

%% In each layer we have a binary image:
% 1 - background with salami
% 2 fat annotation
% 3 meat annotation

% Here we show the meat annotation

figure
imagesc(annotationIm(:,:,3))

%% The function getPixUK extracts the multi spectral pixels from the annotation

% Here is an example with meat- and fat annotation
[fatPix, fatR, fatC] = getPix(multiIm, annotationIm(:,:,2));
[meatPix, meatR, meatC] = getPix(multiIm, annotationIm(:,:,3));

% Here we plot the mean values for pixels with meat and fat respectively
figure
plot(mean(meatPix), 'b');
hold on
plot(mean(fatPix), 'r');


%% The function showHistogramUK makes a histogram that is returned as a vector

% Here is an example - last argument tells the function to plot the histogram for meat and fat
h = showHistograms(multiIm, annotationIm(:,:,2:3), 3, 1);
axis square

%% The histogram is also in h
% But not truncated like in the plot. If we wnat to avoid plotting all 256 dimensions, 
% we can do like below, and only plot the first 50 values

figure
plot(h(1:50,:))

%% The function setImagePixUK produces a colour image
% where the pixel coordinates are given as input

% Load RGB image
imRGB = imread([dirIn 'color_day20.png']);

% Pixel coordinates for the fat annotation
[fatPix, fatR, fatC] = getPix(multiIm, annotationIm(:,:,2));

% Concatenate the pixel coordinates to a matrix
pixId = [fatR, fatC];

% Make the new images
rgbOut = setImagePix(imRGB, pixId);
figure
imagesc(rgbOut)


