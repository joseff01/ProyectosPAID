import cv2
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as patches

I1 = cv2.imread('imagen1.png', cv2.IMREAD_GRAYSCALE)
I2 = cv2.imread('imagen2.png', cv2.IMREAD_GRAYSCALE)
I3 = cv2.imread('imagen3.png', cv2.IMREAD_GRAYSCALE)

IT = cv2.imread('linea2.jpg', cv2.IMREAD_GRAYSCALE)
_, IT = cv2.threshold(IT, 127, 255, cv2.THRESH_BINARY)

#Obtener tamaños

n1, m1 = I1.shape
n2, m2 = I2.shape
n3, m3 = I3.shape

nt, mt = IT.shape

fig, axs = plt.subplots(4, 3)

ax = axs[0, 0]
ax.imshow(I1, cmap='gray')
ax.set_title('Imagen 1')
ax.axis('off')

ax = axs[0, 1]
ax.imshow(I2, cmap='gray')
ax.set_title('Imagen 2')
ax.axis('off')

ax = axs[0, 2]
ax.imshow(I3, cmap='gray')
ax.set_title('Imagen 3')
ax.axis('off')

#Filtro Gaussiano
I1_GaussBlur = cv2.GaussianBlur(I1, (5, 5), 0)
I2_GaussBlur = cv2.GaussianBlur(I2, (3, 3), 0)
I3_GaussBlur = cv2.GaussianBlur(I3, (7, 7), 0)

ax = axs[1, 0]
ax.imshow(I1_GaussBlur, cmap='gray')
ax.set_title('I1 Blur')
ax.axis('off')

ax = axs[1, 1]
ax.imshow(I2_GaussBlur, cmap='gray')
ax.set_title('I2 Blur')
ax.axis('off')

ax = axs[1, 2]
ax.imshow(I3_GaussBlur, cmap='gray')
ax.set_title('I3 Blur')
ax.axis('off')

I1_Canny = cv2.Canny(I1_GaussBlur, 150, 250)
I2_Canny = cv2.Canny(I2_GaussBlur, 150, 250)
I3_Canny = cv2.Canny(I3_GaussBlur, 150, 300)

ax = axs[2, 0]
ax.imshow(I1_Canny, cmap='gray')
ax.set_title('I1 Canny')
ax.axis('off')

ax = axs[2, 1]
ax.imshow(I2_Canny, cmap='gray')
ax.set_title('I2 Canny')
ax.axis('off')

ax = axs[2, 2]
ax.imshow(I3_Canny, cmap='gray')
ax.set_title('I3 Canny')
ax.axis('off')


#Crear la matriz de acumulacion/discretización
def Hough_Transform_Circles(m,n,I,circ_num,thresh,radius_thresh, ax):
    
    P = np.zeros((m, n, (int(np.round(np.sqrt(m**2+n**2))))))

    y_b, x_b = np.where(I > 0)

    numCirculos = circ_num
    
    for i in range(len(x_b)):
        for a in range(m):
            for b in range(n):
                r = np.sqrt((x_b[i]-a)**2 + (y_b[i]-b)**2)
                if r != 0:
                    P[a, b, int(np.round(r))] += 1/(2*np.pi*r)

    ax.imshow(I, cmap='gray')
    ax.set_title('Resultado')
    ax.axis('off')

    while numCirculos > 0:
        maxA = np.max(P)
        xp, yp, rp = np.where(P == maxA) 
        
        #Si hay múltiples, agarrar solo el primero
        if isinstance(xp, np.ndarray):
            xp, yp, rp = xp[0], yp[0], rp[0]
        
        #Threshold de 0.5 (De la que se habla en el paper) y de radio (sin el threshold de radio se generan muchos FP de radio 1,
        #que por alguna razón están por encima del threshold de 0.5 y toman prioridad sobre los más grandes)
        if P[xp, yp, rp] >= thresh and rp > radius_thresh:
            #Dibujar Círculo si pasa el threshold
            circle = plt.Circle((xp, yp), rp, color=(0, 0, 1), fill=False)
            ax.add_patch(circle)
            print(xp, yp, rp, P[xp, yp, rp])
            numCirculos -= 1
        
        #Eliminar de lista ese máximo, sea que cumpla el threshold o no
        P[xp, yp, rp] = 0

    print(" ")
#NOTA: El algoritmo del paper dura bastante ya que se debe iterar por cada uno de todos los pixeles
#      de la imagen, con cada uno de los posibles radios que se puede tomar (hasta la diagonal máxima)
#      Si quiere probar y ver cada una individualmente, basta con comentar los que no quiere que se ejecuten
#      Se tiene un screenshot de los resultados finales en la imagen Resultados.png

Hough_Transform_Circles(m1,n1,I1_Canny,20,0.5,5,axs[3, 0])
Hough_Transform_Circles(m2,n2,I2_Canny,15,0.5,5,axs[3, 1])
Hough_Transform_Circles(m3,n3,I3_Canny,6,0.5,5,axs[3, 2])

plt.show()

