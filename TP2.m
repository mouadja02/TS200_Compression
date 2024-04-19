clc; close all;

% Charger ou générer deux images I1 et I2
I1 = double(imread("football\gray\football001.ras"));
I2 = double(imread("football\gray\football002.ras"));

% Convertir en niveaux de gris si ce ne sont pas des images en niveaux de gris
if size(I1, 3) == 3
    I1 = rgb2gray(I1);
end
if size(I2, 3) == 3
    I2 = rgb2gray(I2);
end

% Calcul des vecteurs de mouvement
[Vx,Vy] = blockmatching(I1, I2, 4, 4, 15, 15);

bw = 4;



% Calcul de l'amplitude et de la direction
Amplitude = sqrt(Vx.^2 + Vy.^2);
Direction = atan2d(Vy, Vx);

% Affichage des résultats
figure, imshow(uint8(I1)), title('Image I1');
figure, imshow(uint8(I2)), title('Image I2');
figure, imshow(uint8(I1)), hold on;
[hV,wV] = size(Vx);
[X, Y] = meshgrid(1:wV, 1:hV);
X = (1+bw)/2 + (X-1)*bw;
Y= (1+bw)/2 + (Y-1)*bw;
quiver(X, Y, Vx, Vy, 'c'), title('Vecteurs sur I1');
hold off;
