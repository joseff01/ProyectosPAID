import cv2
import numpy as np

def mediana(I):
    Iheight, Iwidth, Ichannels = I.shape
    
    #crear iamgen llena de ceros
    Y = np.zeros((Iheight, Iwidth, Ichannels), dtype=np.uint8)
    
    #Solo con 5 se lograba quitar todos los pixeles negros por completo, 
    #pero se puede cambiar a culaquier valor impar mayor a 3, aumentando 
    #el tamaño del a ventana con la que se encuentra la mediana
    #NOTA: Si se aumenta mucho el valor, puede durar mucho, 
    #debido a que se tienen que ordenar y procesar más valores exponencialmente

    size_filter = 5
    
    #iterar pixeles
    for x in range(Iwidth - 1):
        for y in range(Iheight - 1):
            
            neighborhoodR = []
            neighborhoodG = []
            neighborhoodB = []
            
            #Encontrar neighborhood del pixel de referencia
            
            offset = size_filter // 2
            for ox in range(-offset,offset+1):
                for oy in range(-offset,offset+1):
                    nx = x + ox
                    ny = y + oy
                    
                    #ver que no se salga del borde de la imagen
                    if (0 <= nx < Iwidth) and (0 <= ny < Iheight):
                        npixel = I[ny,nx]
                        neighborhoodB.append(npixel[0])
                        neighborhoodG.append(npixel[1])
                        neighborhoodR.append(npixel[2])
            #ordenar las listas
            neighborhoodR.sort()
            neighborhoodG.sort()
            neighborhoodB.sort()
            #encontrar mediana de cada lista
            med_pos = len(neighborhoodR)//2
            medianR = neighborhoodR[med_pos]
            medianG = neighborhoodG[med_pos]
            medianB = neighborhoodB[med_pos]
            
            new_value = [medianB,medianG,medianR]
            
            Y[y,x] = new_value

    return Y


#Test de funcionamiento
#-----NOTA------: Correr desde la carpeta Parte 1 para que funcione correctamente

I = cv2.imread('Images//imagen1.jpg')
if I is None:
    print("Error: Image not found or unable to load.")
else:
    Y = mediana(I)
    cv2.imshow("Filtro de la mediana", Y)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
