% Created on 09/01/25
% Created by Supratit Datta, BT22ECE127
% First Practical to convert Color image to Grayscale image.

clc;
clear;
close all;

% Load the image
img = imread("image.jpg");

% Get dimensions of the image
[rows, cols, channels] = size(img);
fprintf('Image dimensions: %d x %d\n', rows, cols);

% Safely retrieve and display pixel intensity
try
    disp(['Pixel value at (1010, 505): ', num2str(img(1010, 505))]);
catch
    disp('Pixel (1010, 505) out of bounds.');
    mid_row = round(rows / 2);
    mid_col = round(cols / 2);
    disp(['Center pixel value at (', num2str(mid_row), ', ', num2str(mid_col), '): ', num2str(img(mid_row, mid_col))]);
end

% Grayscale conversion methods
gray_red_only = img(:, :, 1); % Single-channel grayscale (red channel)
gray_weighted = uint8(0.3 * img(:, :, 1) + 0.6 * img(:, :, 2) + 0.1 * img(:, :, 3)); % Adjusted weights for luminosity
gray_max = max(img, [], 3); % Maximum intensity grayscale

% Highlight individual color channels
highlight_red = img;
highlight_red(:, :, 2:3) = 0;

highlight_green = img;
highlight_green(:, :, [1, 3]) = 0;

highlight_blue = img;
highlight_blue(:, :, 1:2) = 0;

% Display grayscale images
figure(1);
subplot(2, 2, 1), imshow(img); xlabel('Original Image');
subplot(2, 2, 2), imshow(gray_red_only); xlabel('Grayscale (Red Channel)');
subplot(2, 2, 3), imshow(gray_weighted); xlabel('Grayscale (Weighted Luminosity)');
subplot(2, 2, 4), imshow(gray_max, []); xlabel('Grayscale (Max Intensity)');

% Display filtered color images
figure(2);
subplot(2, 2, 1), imshow(img); xlabel('Original Image');
subplot(2, 2, 2), imshow(highlight_red); xlabel('Highlight Red');
subplot(2, 2, 3), imshow(highlight_green); xlabel('Highlight Green');
subplot(2, 2, 4), imshow(highlight_blue); xlabel('Highlight Blue');