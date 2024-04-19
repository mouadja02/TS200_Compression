clc; close all;

% Charger ou générer deux images I1 et I2
I1 = imread("football\gray\football001.ras");
I2 = imread("football\gray\football002.ras");

% Convertir en niveaux de gris si ce ne sont pas des images en niveaux de gris
if size(I1, 3) == 3
    I1 = rgb2gray(I1);
end
if size(I2, 3) == 3
    I2 = rgb2gray(I2);
end

% Calcul des vecteurs de mouvement
[Is, SADmin] = blockmatch(I1, I2, 8, 15);

% Dimensions des blocs
blockSize = 8;

% Extraction des composantes horizontales et verticales
Vx = Is(:,:,1);
Vy = Is(:,:,2);

% Réduction de la taille de Vx et Vy à la grille
% Assurez-vous que Vx et Vy correspondent exactement aux intervalles de la grille
Vx = Vx(1:blockSize:end, 1:blockSize:end);
Vy = Vy(1:blockSize:end, 1:blockSize:end);

% Calcul de l'amplitude et de la direction
Amplitude = sqrt(Vx.^2 + Vy.^2);
Direction = atan2d(Vy, Vx);

% Affichage des résultats
figure;
subplot(2,3,1), imshow(I1), title('Image I1');
subplot(2,3,2), imshow(I2), title('Image I2');
subplot(2,3,3), imshow(mat2gray(Amplitude)), title('Amplitude du mouvement');
subplot(2,3,4), imshow(mat2gray(Direction)), title('Direction du mouvement');
subplot(2,3,5), quiver(Vx, Vy, 0), axis ij, axis tight, title('Vecteurs de mouvement');

% Affichage des vecteurs sur l'image
subplot(2,3,6), imshow(I1), hold on;
[xGrid, yGrid] = meshgrid(1:blockSize:size(I1,2), 1:blockSize:size(I1,1));
quiver(xGrid, yGrid, Vx, Vy, 'y'), title('Vecteurs sur I1');
hold off;


function [motionVect] = backwardBlockMatching(I1, I2)
    % Taille des blocs
    blockSize = 8;
    % Taille de la fenêtre de recherche
    searchWindow = 15;

    % Dimensions de l'image
    [rows, cols] = size(I1);
    
    % Initialisation du vecteur de mouvement
    motionVect = zeros(floor(rows/blockSize), floor(cols/blockSize), 2);
    
    % Parcours de chaque bloc de l'image I2
    for i = 1:blockSize:rows-blockSize+1
        for j = 1:blockSize:cols-blockSize+1
            % Bloc courant dans I2
            blockI2 = I2(i:i+blockSize-1, j:j+blockSize-1);
            
            % Initialisation de la meilleure correspondance
            minSAD = inf;
            dx = 0;
            dy = 0;
            
            % Limites de la fenêtre de recherche
            range = floor(searchWindow/2);
            rowMin = max(1, i-range);
            rowMax = min(rows-blockSize+1, i+range);
            colMin = max(1, j-range);
            colMax = min(cols-blockSize+1, j+range);
            
            % Recherche exhaustive dans la fenêtre autour du bloc
            for x = rowMin:rowMax
                for y = colMin:colMax
                    % Bloc courant dans I1
                    blockI1 = I1(x:x+blockSize-1, y:y+blockSize-1);
                    
                    % Calcul du SAD
                    SAD = sum(abs(blockI2(:) - blockI1(:)));
                    
                    % Mise à jour de la meilleure correspondance
                    if SAD < minSAD
                        minSAD = SAD;
                        dx = x - i;
                        dy = y - j;
                    end
                end
            end
            
            % Enregistrement du vecteur de mouvement pour ce bloc
            motionVect((i-1)/blockSize+1, (j-1)/blockSize+1, :) = [dx dy];
        end
    end
end
