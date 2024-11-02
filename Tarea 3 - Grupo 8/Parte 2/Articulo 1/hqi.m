function c = hqi(A, B)

  %Entradas : (1) A: la imagen a escala de gris original
  %           (2) B: la imagen a escala de gris modificada
  %
  %Salida: (1) c: el resultado del indice
  %
  %Nota: A y B deben ser del mismo tamaño

  % Cargar el paquete de procesamiento de imágenes
  pkg load image

  % Calcular el histograma de la imagen A con 256 niveles de gris
  hx = imhist(A, 256);
  % Calcular el histograma de la imagen B con 256 niveles de gris
  hy = imhist(B, 256);

  % Calcular el vector de diferencias delta entre los histogramas hx y hy
  delta = abs(hx - hy);

  % Calcular ∆TC como la suma de las diferencias absolutas en el vector delta
  delta_TC = sum(delta);

  % Obtener las dimensiones de la imagen A (asumimos que A y B tienen las mismas dimensiones)
  [M, N] = size(A);

  % Calcular el factor de cambio total (delta_TCFactor)
  % Este factor se normaliza dividiendo por el valor máximo posible (2 * M * N)
  delta_TCFactor = 1 - (delta_TC / (2 * M * N));

  % Calcular el numerador de HD (Histogram Distortion)
  % Es la suma de los productos de las frecuencias correspondientes en hx y hy
  HD_numerator = sum(hx .* hy);

  % Calcular el denominador de HD
  % Es la suma de los cuadrados de las frecuencias en hx
  HD_denominator = sum(hx .^ 2);

  % Calcular HD dividiendo el numerador por el denominador
  HD = HD_numerator / HD_denominator;

  % Calcular el HQI final multiplicando ∆TCFactor por HD
  c = delta_TCFactor * HD;

endfunction

