function [Is, SADmin] = blockmatch(Image1, Image2, N, search_window)
    I1 = double(Image1);
    I2 = double(Image2);

    [h, w] = size(I1);
    fen = floor(search_window / 2);
    Is = zeros(h, w, 2); % Initialisation de la matrice de déplacement
    SADmin = inf(h, w); % Initialisation de la matrice SAD minimale

    for i = 1:N:h-N+1
        for j = 1:N:w-N+1
            localSADmin = inf; % Initialisation locale du SAD minimum pour ce bloc
            bestMatch = [0, 0]; % Position relative du meilleur match

            for u = -fen:fen
                for v = -fen:fen
                    if ((i+u > 0) && (i+u+N-1 <= h) && (j+v > 0) && (j+v+N-1 <= w))
                        SAD = sum(sum(abs(I2(i:i+N-1, j:j+N-1) - I1(i+u:i+u+N-1, j+v:j+v+N-1))));
                        if SAD < localSADmin
                            localSADmin = SAD;
                            bestMatch = [v, u];
                        end
                    end
                end
            end
            Is(i:i+N-1, j:j+N-1, 1) = bestMatch(1);
            Is(i:i+N-1, j:j+N-1, 2) = bestMatch(2);
            SADmin(i:i+N-1, j:j+N-1) = localSADmin;
        end
    end
end
