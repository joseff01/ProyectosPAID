from parte2_p1 import J_real
import numpy as np
import cv2
import matplotlib.pyplot as plt


image = cv2.imread('lena.jpg', cv2.IMREAD_GRAYSCALE)
m, n = image.shape

def dft2d_hypercomplex(image, J_real):
    m, n = image.shape
    F_hypercomplex = np.zeros((m, n, 4, 4), dtype=complex)
    
    for u in range(m):
        for v in range(n):
            summation = np.zeros((4, 4), dtype=complex)
            for x in range(m):
                for y in range(n):
                    
                    A = np.array([
                        [0, -image[x, y], 0, 0],
                        [image[x, y], 0, 0, 0],
                        [0, 0, 0, -image[x, y]],
                        [0, 0, image[x, y], 0]
                    ])
                    
                    exp_real = np.cos(2 * np.pi * ((u * x / m) + (v * y / n))) * np.eye(4)
                    exp_imag = np.sin(2 * np.pi * ((u * x / m) + (v * y / n))) * J_real
                    E = exp_real + exp_imag
                    
                    # Acumular la suma
                    summation += A @ E
            F_hypercomplex[u, v] = summation / np.sqrt(m * n)
    return F_hypercomplex


def fftshift_manual(dft):
    m, n = dft.shape[:2]
    shifted_dft = np.zeros_like(dft, dtype=complex)
    half_m, half_n = m // 2, n // 2


    shifted_dft[:half_m, :half_n] = dft[half_m:, half_n:]
    shifted_dft[:half_m, half_n:] = dft[half_m:, :half_n]
    shifted_dft[half_m:, :half_n] = dft[:half_m, half_n:]
    shifted_dft[half_m:, half_n:] = dft[:half_m, :half_n]

    return shifted_dft

F_hypercomplex = dft2d_hypercomplex(image, J_real)
F_hypercomplex_shifted = fftshift_manual(F_hypercomplex)

magnitude_spectrum = np.log(1 + np.linalg.norm(F_hypercomplex_shifted, axis=(2, 3)))

plt.figure(figsize=(10, 5))

plt.subplot(1, 2, 1)
plt.title('Imagen Original')
plt.imshow(image, cmap='gray')

plt.subplot(1, 2, 2)
plt.title('Espectro Logarítmico')
plt.imshow(magnitude_spectrum, cmap='gray')

plt.show()
