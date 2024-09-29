clear;clc; close all
pkg load image

%Imagen Original: I1
I1=imread('paisaje.jpg');
subplot(2,2,1)
imshow(I1)
title('(a) paisaje.jpg','FontSize',16)

%Texto: I2
I2=imread('marca.jpg');
I2(I2<50)=0; I2(I2>=50)=255; %Convertir imagen a Binaria. Parte Blanca = Texto. Parte Negra = Valor de 0
subplot(2,2,2)
imshow(I2)
title('(b) marca.jpg','FontSize',16)

%Imagen a Restaurar: I3
I3=I1+I2;
%subplot(2,2,3)
%imshow(I3)
%title('(c) Imagen a Restaurar','FontSize',16)

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

%Hacer que la marca sea 100% blanco o negro
mask = im2bw(I2, 0.5);

%Usar la marca como el mask y quitarselo a la imagen con la marca
img_sin_masks = I3;
img_sin_masks(mask == 1) = 0;

subplot(2,2,3)
imshow(img_sin_masks)
title('(c) Imagen con mask aplicado','FontSize',16)

%Kernel del pdf dado
kernel = [0.073235, 0.176765, 0.073235;
          0.176765, 0,        0.176765;
          0.073235, 0.176765, 0.073235];


num_i = 100;

imagen_iter = img_sin_masks;

% for para aplicar la convolución múltiples veces
for i = 1:num_i
    % Convolución
    img_temp = my_conv2(imagen_iter, kernel);

    % Hacerle update solo a los pixeles que están dentro del mask
    imagen_iter(mask == 1) = img_temp(mask == 1);

end

ssim_imagen_rest = ssim(im2uint8(I1),im2uint8(imagen_iter))
subplot(2,2,4)
imshow(imagen_iter);
title('Imagen Restaurada','FontSize',16)


