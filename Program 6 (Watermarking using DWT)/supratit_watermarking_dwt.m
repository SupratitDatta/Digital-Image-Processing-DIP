% Watermarking using DWT
% Created on: 19/03/25
% By Author: Supratit Datta, BT22ECE127

clc;
clear;
close all;

% Read and preprocess image
img = imread('input.jpeg');
if size(img,3)==3
    img = rgb2gray(img);
end
img = double(img);

% Create watermark
watermark = zeros(size(img));
figure('visible','off');
imshow(watermark, []);
hold on;
text(size(img,2)/2, size(img,1)/2, 'SUPRATIT', ...
    'FontSize', 50, 'Color', 'white', 'FontWeight', 'bold', ...
    'HorizontalAlignment', 'center');
frame = getframe(gca);
watermark = rgb2gray(frame2im(frame));
close;

watermark_resized = imresize(watermark, [size(img,1)/2, size(img,2)/2]);

% Manual DWT
L = (img(:,1:2:end) + img(:,2:2:end))/2;
H = (img(:,1:2:end) - img(:,2:2:end))/2;
LL = (L(1:2:end,:) + L(2:2:end,:))/2;
LH = (L(1:2:end,:) - L(2:2:end,:))/2;
HL = (H(1:2:end,:) + H(2:2:end,:))/2;
HH = (H(1:2:end,:) - H(2:2:end,:))/2;

% Embed Watermark
alpha = 0.6;
HH_watermarked = HH + alpha * double(watermark_resized);

% Manual IDWT to get watermarked image
L_rec = zeros(size(LL,1)*2, size(LL,2));
H_rec = zeros(size(LL,1)*2, size(LL,2));
L_rec(1:2:end,:) = LL + LH;
L_rec(2:2:end,:) = LL - LH;
H_rec(1:2:end,:) = HL + HH_watermarked;
H_rec(2:2:end,:) = HL - HH_watermarked;
img_watermarked = zeros(size(L_rec,1), size(L_rec,2)*2);
img_watermarked(:,1:2:end) = L_rec + H_rec;
img_watermarked(:,2:2:end) = L_rec - H_rec;
img_watermarked = uint8(img_watermarked);

% To Remove watermark

% Re-do DWT on watermarked image
img_wm_double = double(img_watermarked);
L2 = (img_wm_double(:,1:2:end) + img_wm_double(:,2:2:end))/2;
H2 = (img_wm_double(:,1:2:end) - img_wm_double(:,2:2:end))/2;
LL2 = (L2(1:2:end,:) + L2(2:2:end,:))/2;
LH2 = (L2(1:2:end,:) - L2(2:2:end,:))/2;
HL2 = (H2(1:2:end,:) + H2(2:2:end,:))/2;
HH2 = (H2(1:2:end,:) - H2(2:2:end,:))/2;

% Remove watermark
HH2_cleaned = HH2 - alpha * double(watermark_resized);

% Reconstruct cleaned image
L_clean = zeros(size(LL2,1)*2, size(LL2,2));
H_clean = zeros(size(LL2,1)*2, size(LL2,2));
L_clean(1:2:end,:) = LL2 + LH2;
L_clean(2:2:end,:) = LL2 - LH2;
H_clean(1:2:end,:) = HL2 + HH2_cleaned;
H_clean(2:2:end,:) = HL2 - HH2_cleaned;
img_cleaned = zeros(size(L_clean,1), size(L_clean,2)*2);
img_cleaned(:,1:2:end) = L_clean + H_clean;
img_cleaned(:,2:2:end) = L_clean - H_clean;
img_cleaned = uint8(img_cleaned);

% Display results
figure;
subplot(3,1,1); imshow(uint8(img)); title('Original Image');
subplot(3,1,2); imshow(watermark, []); title('Watermark');
subplot(3,1,3); imshow(uint8(img_watermarked)); title('Watermarked Image');

figure;
subplot(1,2,1); imshow(HH2_cleaned, []); title('HH after Removal');
subplot(1,2,2); imshow(uint8(img_cleaned)); title('Watermark Removed');