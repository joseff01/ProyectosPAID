pkg load image  % Cargar el paquete de procesamiento de imágenes

% Ruta a las carpetas de imágenes
training_folder = 'training/';
compare_folder = 'compare/';

% Dimensiones de las imágenes
img_height = 112;
img_width = 92;
num_pixels = img_height * img_width;

% Cargar las imágenes de entrenamiento
training_images = [];
training_labels = [];

for i = 1:40
    for j = 1:9
        % Leer la imagen de entrenamiento
        img_path = sprintf('%ss%d/%d.jpg', training_folder, i, j);
        img = imread(img_path);
        img_vector = double(img(:));  % Convertir en un vector

        training_images = [training_images, img_vector];
        training_labels = [training_labels; i];
    end
end

% Calcular la imagen media
mean_image = mean(training_images, 2);

% Restar la imagen media
A = training_images - mean_image;

% Aplicar SVD
[U, S, V] = svd(A, 'econ');  % Solo calcular la parte económica de SVD
base_faces = U(:, 1:40);     % Seleccionar las primeras 40 "caras base"

% Proyectar las imágenes de entrenamiento en el "espacio de caras"
training_projections = base_faces' * A;

% Cargar y proyectar las imágenes de comparación
for i = 1:40
    % Leer la imagen de comparación
    img_path = sprintf('%sp%d.jpg', compare_folder, i);
    img = imread(img_path);
    img_vector = double(img(:)) - mean_image;  % Restar la imagen media

    % Proyectar la imagen de comparación en el "espacio de caras"
    compare_projection = base_faces' * img_vector;

    % Calcular la distancia a cada imagen de entrenamiento
    distances = vecnorm(training_projections - compare_projection, 2, 1);

    % Encontrar la imagen de entrenamiento más cercana
    [~, min_index] = min(distances);
    identified_label = training_labels(min_index);

    % Mostrar resultados
    fprintf('Imagen %d en compare se identifica como Persona %d en training\n', i, identified_label);
end

