clc; clear; close all
pkg load image

%Cargar Imágenes
imOrig = imread('imOrig.jpg');
i1 = imread('imMod1.jpg');
i2 = imread('imMod2.jpg');
i3 = imread('imMod3.jpg');
i4 = imread('imMod4.jpg');
i5 = imread('imMod5.jpg');
i6 = imread('imMod6.jpg');
i7 = imread('imMod7.jpg');

%MSE
mse_1 = immse(imOrig, i1)
mse_2 = immse(imOrig, i2)
mse_3 = immse(imOrig, i3)
mse_4 = immse(imOrig, i4)
mse_5 = immse(imOrig, i5)
mse_6 = immse(imOrig, i6)
mse_7 = immse(imOrig, i7)

%PSNR
psnr_1 = psnr(i1, imOrig)
psnr_2 = psnr(i2, imOrig)
psnr_3 = psnr(i3, imOrig)
psnr_4 = psnr(i4, imOrig)
psnr_5 = psnr(i5, imOrig)
psnr_6 = psnr(i6, imOrig)
psnr_7 = psnr(i7, imOrig)

%SSIM
ssim_1 = ssim(imOrig, i1)
ssim_2 = ssim(imOrig, i2)
ssim_3 = ssim(imOrig, i3)
ssim_4 = ssim(imOrig, i4)
ssim_5 = ssim(imOrig, i5)
ssim_6 = ssim(imOrig, i6)
ssim_7 = ssim(imOrig, i7)

%SNR
[~,snr_1] = psnr(i1, imOrig)
[~,snr_2] = psnr(i2, imOrig)
[~,snr_3] = psnr(i3, imOrig)
[~,snr_4] = psnr(i4, imOrig)
[~,snr_5] = psnr(i5, imOrig)
[~,snr_6] = psnr(i6, imOrig)
[~,snr_7] = psnr(i7, imOrig)

%HQI
hqi_1 = hqi(imOrig,i1)
hqi_2 = hqi(imOrig,i2)
hqi_3 = hqi(imOrig,i3)
hqi_4 = hqi(imOrig,i4)
hqi_5 = hqi(imOrig,i5)
hqi_6 = hqi(imOrig,i6)
hqi_7 = hqi(imOrig,i7)
