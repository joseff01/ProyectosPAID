% parte2_p1b.m

% Definir la matriz A
A(:, :, 1) = [5 10 15 20; 4 8 12 16; 3 6 9 12; 2 4 6 8];
A(:, :, 2) = [1 2 3 4; 1 3 5 7; 2 4 6 8; 1 4 7 10];
A(:, :, 3) = [0 0 0 0; 5 5 5 5; 10 10 10 10; 15 15 15 15];

% Inicializar la matriz C con ceros de tamaño 4x4x3
C = zeros(4, 4, 3);

% Aplicar las condiciones para llenar la matriz C
C(A <= 10) = -30; % Asignar -30 a las posiciones donde A(i,j,k) <= 10
C(A > 10) = 30;   % Asignar 30 a las posiciones donde A(i,j,k) > 10

% Mostrar la matriz C
disp('La matriz resultante C es:')
disp(C)

