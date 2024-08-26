import cv2
import numpy as np
from parte1_p1 import mediana

def rotacion(I,ang):
    Iheight, Iwidth, Ichannels = I.shape
    
    #crear iamgen llena de ceros
    Y = np.zeros((Iheight, Iwidth, Ichannels), dtype=np.uint8)
    
    #encontrar centro de la imagen
    x_center = Iwidth//2
    y_center = Iheight//2
    
    #calcular coeficientes de la transformada afín para una rotación
    a0 = np.cos(np.radians(ang))
    a1 = np.sin(np.radians(ang))
    b0=  -np.sin(np.radians(ang))
    b1 = np.cos(np.radians(ang))
    
    #iterar pixeles
    for x in range(Iwidth - 1):
        for y in range(Iheight - 1):
            
            #Usar coeficientes para encontrar las posiciones nuevas del x y y
            x_aux = round(a0 * (x - x_center) + a1 * (y - y_center) + x_center)
            y_aux = round(b0 * (x - x_center) + b1 * (y - y_center) + y_center)
            
            #verificar que no se salga del ancho y largo de la imagen original
            x_t = x_aux % Iwidth
            y_t = y_aux % Iheight
            if (x_t == x_aux) and (y_t == y_aux):
                Y[y_t,x_t] = I[y,x]
    
    return Y


#Reemplazar pixeles negros en la imagen rotada con la de la imagen con el filtro aplicado
def fill_black(I_rot, I_med):
    Iheight, Iwidth, Ichannels = I_rot.shape
    
    Y = np.zeros((Iheight, Iwidth, Ichannels), dtype=np.uint8)
    for x in range(Iwidth - 1):
        for y in range(Iheight - 1):
            #si es negro, introducir pixel de la imagen con filtro, si es cualquier otra cosa, dejarlo como en el rotado sin filtro
            if np.array_equal(I_rot[y, x], [0, 0, 0]):
                Y[y,x] = I_med[y,x] 
            else:   
                Y[y,x] = I_rot[y,x]
    
    return Y

I = cv2.imread('Images//barbara.jpg')
if I is None:
    print("Error: Image not found or unable to load.")
else:
    Y_1 = rotacion(I, 45)
    Y_2 = mediana(Y_1)
    Y_3 = fill_black(Y_1,Y_2)
    
    #Si también se quiere como en la figura 1 del enunciado:
    #row = np.hstack((I,Y_1,Y_3))
    
    row = np.hstack((Y_1, Y_2, Y_3))
    cv2.imshow("Imagen Rotada/Imagen con filtro aplicado/Imagen con solo el filtro aplicado en los pixeles negros", row)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
