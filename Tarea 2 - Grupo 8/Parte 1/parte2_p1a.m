clc; clear
% parte2_p1a.m

% Definir la matriz A
A(:, :, 1) = [5 10 15 20; 4 8 12 16; 3 6 9 12; 2 4 6 8];
A(:, :, 2) = [1 2 3 4; 1 3 5 7; 2 4 6 8; 1 4 7 10];
A(:, :, 3) = [0 0 0 0; 5 5 5 5; 10 10 10 10; 15 15 15 15];

% Utilizar condiciones vectorizadas para generar la matriz B
B = (A(:, :, 1) > 5) & (A(:, :, 2) < 5) & (A(:, :, 3) >= 10);

% Mostrar la matriz B
disp('La matriz resultante B es:')
disp(B)

