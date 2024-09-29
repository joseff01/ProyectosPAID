clear;clc; close all
pkg load image

%Imagenes Originales:
I1=imread('I1.jpg');
subplot(2,3,1)
imshow(I1)
title('I1.jpg','FontSize',16)

I2=imread('I2.jpg');
subplot(2,3,2)
imshow(I2)
title('I2.jpg','FontSize',16)

I3=imread('I3.jpg');
subplot(2,3,3)
imshow(I3)
title('I3.jpg','FontSize',16)

%Máscaras:
I1M=imread('I1Mask.jpg');
I2M=imread('I2Mask.jpg');
I3M=imread('I3Mask.jpg');



%Convolución 2D
function result = my_conv2(matrix, kernel)

  %1) Obtener tamaños de entradas
  [input_rows, input_cols] = size(matrix);
  [kernel_rows, kernel_cols] = size(kernel);

  %2) Hacer el padding de la matriz

    %Crear matriz vacía de ceros con el tamaño del resultado de la conv (M+K-1)
  padded_input = zeros(input_rows + kernel_rows - 1, input_cols + kernel_cols - 1);

    %Tamaño de Padding de cada lado
  pad_1side= floor(kernel_rows / 2);

    %Meter matriz en el centro de la matriz vacía
  padded_input(pad_1side+1:pad_1side+input_rows, pad_1side+1:pad_1side+input_cols) = matrix;


  %3) Crear todos los posibles patches y hacerlos planos, para que queden en una
  %   sola matriz 2d
  input_patches = im2col(padded_input, [kernel_rows kernel_cols], 'sliding');

  %4) Darle la vuelta el kernel para la convolución
  kernel = rot90(kernel, 2);

  %5) Aplastar el kernel, para que funcione con la matriz creada en el paso 3
  kernel_flat = kernel(:);

  %6) Hacer multiplicación de kernel con la matriz de los patches
  result_flat = kernel_flat' * input_patches;

  %7) Hacer un reshape para que sea una matriz de nuevo, en vez de un array
  result = reshape(result_flat, input_rows, input_cols);
 end

%Hacer que laS máscaras sean 100% blanco o negro
I1Mask = im2bw(I1M, 0.5);
I2Mask = im2bw(I2M, 0.5);
I3Mask = im2bw(I3M, 0.5);

%Usar la marca como el mask y quitarselo a la imagen con la marca
I1_sin_masks = I1;
I2_sin_masks = I2;
I3_sin_masks = I3;

I1_sin_masks(:,:,1) = I1(:,:,1) .* uint8(I1Mask);
I1_sin_masks(:,:,2) = I1(:,:,2) .* uint8(I1Mask);
I1_sin_masks(:,:,3) = I1(:,:,3) .* uint8(I1Mask);
I2_sin_masks(:,:,1) = I2(:,:,1) .* uint8(I2Mask);
I2_sin_masks(:,:,2) = I2(:,:,2) .* uint8(I2Mask);
I2_sin_masks(:,:,3) = I2(:,:,3) .* uint8(I2Mask);
I3_sin_masks(:,:,1) = I3(:,:,1) .* uint8(I3Mask);
I3_sin_masks(:,:,2) = I3(:,:,2) .* uint8(I3Mask);
I3_sin_masks(:,:,3) = I3(:,:,3) .* uint8(I3Mask);

%Kernel del pdf dado
kernel = [0.073235, 0.176765, 0.073235;
          0.176765, 0,        0.176765;
          0.073235, 0.176765, 0.073235];


num_i = 2500;
% Create a copy of the image for inpainting
I1_iter = I1_sin_masks;
I2_iter = I2_sin_masks;
I3_iter = I3_sin_masks;

% for para aplicar la convolución múltiples veces
for i = 1:num_i
    % Convolución
    I1_temp(:,:,1) = my_conv2(I1_iter(:,:,1), kernel);
    I1_temp(:,:,2) = my_conv2(I1_iter(:,:,2), kernel);
    I1_temp(:,:,3) = my_conv2(I1_iter(:,:,3), kernel);
    I2_temp(:,:,1) = my_conv2(I2_iter(:,:,1), kernel);
    I2_temp(:,:,2) = my_conv2(I2_iter(:,:,2), kernel);
    I2_temp(:,:,3) = my_conv2(I2_iter(:,:,3), kernel);
    I3_temp(:,:,1) = my_conv2(I3_iter(:,:,1), kernel);
    I3_temp(:,:,2) = my_conv2(I3_iter(:,:,2), kernel);
    I3_temp(:,:,3) = my_conv2(I3_iter(:,:,3), kernel);

    % Hacerle update solo a los pixeles que están dentro del mask
    for c = 1:3
      channel_iter = I1_iter(:,:,c);
      channel_temp = I1_temp(:,:,c);
      channel_iter(I1Mask == 0) = channel_temp(I1Mask == 0);
      I1_iter(:,:,c) = channel_iter;
      channel_iter = I2_iter(:,:,c);
      channel_temp = I2_temp(:,:,c);
      channel_iter(I2Mask == 0) = channel_temp(I2Mask == 0);
      I2_iter(:,:,c) = channel_iter;
      channel_iter = I3_iter(:,:,c);
      channel_temp = I3_temp(:,:,c);
      channel_iter(I3Mask == 0) = channel_temp(I3Mask == 0);
      I3_iter(:,:,c) = channel_iter;
    end

end


subplot(2,3,4)
imshow(I1_iter);
title('I1 Restaurada','FontSize',16)
subplot(2,3,5)
imshow(I2_iter);
title('I2 Restaurada','FontSize',16)
subplot(2,3,6)
imshow(I3_iter);
title('I3 Restaurada','FontSize',16)




