pkg load image
image_names = {'imMod1', 'imMod2', 'imMod3', 'imMod4', 'imMod5', 'imMod6', 'imMod7'};
original = imread('imOrig.jpg');


if size(original, 3) == 3
    original = rgb2gray(original);
endif

block_size = 8;
[m, n] = size(original);


ssim_results = [];
hqi_results = [];

for k = 1:length(image_names)

    modified = imread([image_names{k}, '.jpg']);

    if size(modified, 3) == 3
        modified = rgb2gray(modified);
    endif

    distortion_map = zeros(m / block_size, n / block_size);

    for i = 1:block_size:m
        for j = 1:block_size:n

            block_orig = double(original(i:i+block_size-1, j:j+block_size-1));
            block_mod = double(modified(i:i+block_size-1, j:j+block_size-1));

            [~, S_orig, ~] = svd(block_orig);
            [~, S_mod, ~] = svd(block_mod);

            distortion_map((i-1)/block_size+1, (j-1)/block_size+1) = norm(S_orig - S_mod, 'fro');
        endfor
    endfor


    % Calcular SSIM
    ssim_value = ssim(original, modified);
    ssim_results = [ssim_results; ssim_value];
    disp(['SSIM entre imOrig y ', image_names{k}, ': ', num2str(ssim_value)]);

    % Calcular HQI basado en histogramas
    hqi_value = hqi(original, modified);
    hqi_results = [hqi_results; hqi_value];
    disp(['HQI entre imOrig y ', image_names{k}, ': ', num2str(hqi_value)]);
endfor


disp('Resultados de SSIM para cada imagen modificada:');
disp(ssim_results);

disp('Resultados de HQI para cada imagen modificada:');
disp(hqi_results);

