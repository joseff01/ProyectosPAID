import numpy as np

J_real = np.array([
    [0, -1, 0, 0],
    [1, 0, 0, 0],
    [0, 0, 0, -1],
    [0, 0, 1, 0]
])

J_complex = np.array([
    [0, -1j, 0, 0],
    [1j, 0, 0, 0],
    [0, 0, 0, -1j],
    [0, 0, 1j, 0]
])


J_real_squared = np.dot(J_real, J_real)
I_4 = -np.eye(4)
print("J_real^2 =")
print(J_real_squared)
print("¿J_real^2 es igual a -I_4? ", np.allclose(J_real_squared, I_4))

J_complex_squared = np.dot(J_complex, J_complex)
print("\nJ_complex^2 =")
print(J_complex_squared)
print("¿J_complex^2 es igual a -I_4? ", np.allclose(J_complex_squared, I_4))
