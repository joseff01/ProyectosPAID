pkg load image
pkg load signal

function B = dct2_custom(A)

    B = dct(dct(A').');
end

function A = idct2_custom(B)

    A = idct(idct(B').');
end


original_image = imread('imagen.jpg');
watermark_image = imread('marca.jpg');

if size(original_image, 3) == 3
    original_image = rgb2gray(original_image);
endif

if size(watermark_image, 3) == 3
    watermark_image = rgb2gray(watermark_image);
endif

watermark_image = imresize(watermark_image, [64, 64]);

block_size = 8;
alpha = 0.1;


[m, n] = size(original_image);
watermarked_image = original_image;

dc_matrix = zeros(m / block_size, n / block_size);

for i = 1:block_size:m
    for j = 1:block_size:n
        block = double(original_image(i:i+block_size-1, j:j+block_size-1));

        dct_block = dct2_custom(block);

        % Almacenar valor DC
        dc_matrix((i-1)/block_size+1, (j-1)/block_size+1) = dct_block(1, 1);
    end
end

[U, S, V] = svd(dc_matrix);

[Uw, Sw, Vw] = svd(double(watermark_image));
S_marked = S + alpha * Sw;

dc_marked = U * S_marked * V';

for i = 1:block_size:m
    for j = 1:block_size:n
        dct_block = dct2_custom(double(original_image(i:i+block_size-1, j:j+block_size-1)));

        dct_block(1, 1) = dc_marked((i-1)/block_size+1, (j-1)/block_size+1);

        watermarked_image(i:i+block_size-1, j:j+block_size-1) = idct2_custom(dct_block);
    end
end

figure; imshow(original_image, []); title('Imagen Original');
figure; imshow(watermark_image, []); title('Marca de Agua');
figure; imshow(watermarked_image, []); title('Imagen con Marca de Agua');

dc_extracted = zeros(m / block_size, n / block_size);

for i = 1:block_size:m
    for j = 1:block_size:n
        block_marked = double(watermarked_image(i:i+block_size-1, j:j+block_size-1));

        dct_block = dct2_custom(block_marked);

        dc_extracted((i-1)/block_size+1, (j-1)/block_size+1) = dct_block(1, 1);
    end
end

[Ue, Se, Ve] = svd(dc_extracted);

extracted_watermark = (Se - S) / alpha;


figure; imshow(uint8(extracted_watermark), []); title('Marca de Agua Extraída');
difference_image = abs(double(watermarked_image) - double(original_image));
figure; imshow(difference_image, []); title('Diferencia entre Imagen Original y Marcada');

