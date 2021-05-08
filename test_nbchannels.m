A = [0.0356;0.0387;0.0397;0.0406;0;0.0387;0.0420;0.0442;0.0453;0.0497;0.0526;0.0535;0.0548;0.0556;0;0.0526;0.0535;0.0548;0];%TimeIn
B = [0.0351;0.0381;0.0397;0.0419;0;0.0447;0.0497;0.0520;0.0525;0.0534;0.0565;0.0573;0.0588;0;0.0565;0.0573;0.0588;0];%TimeOut

l = size(A);
threshold = 0.0011; % 
nb_min_same_pics = 2; % nombre minimum de fois qu'un pic doit être détecté pour être accepté


already_modified_index = [];
already_modified_index_length = 0;

disp("before")
disp(A)
i = 1;
while i <= l(1)-1 %on compare chaque élément avec ceux qui le suivent et donc le dernier n'est pas nécessaire
    % on fait cette comparaison que si l'élément est non nul
    % et que l'élément n'appartient pas déjà à un groupe
    if A(i) ~= 0 && ~ismember(i,already_modified_index) 
        nb_same_pics = 1; % le nombre de pics appartenant au groupe
        same_pics_indexes = [i]; % les index des éléments qui appartiennent au groupe
        
        % on va regarder tous les éléments qui le suivent pour voir s'il
        % peut appartenir au groupe
        for j=i+1:l(1)
            % Pour pouvoir appartenir au groupe, il faut être non nul, que
            % les pics soit détectés dans la même fenêtre de temps et que
            % l'élément n'appartienne pas déjà à un groupe
        
            if A(j) ~= 0 && is_same(A, i, j, threshold) && ~ismember(j,already_modified_index)
                % ajout de pic : on ajoute l'élément au groupe
                nb_same_pics = nb_same_pics + 1;
                same_pics_indexes(nb_same_pics) = j;
            end
        end
        
        % Il faut maintenant voir s'il y a assez d'éléments dans le groupe
        % S'il y en a assez, 
        % S'il n'y en a pas assez, on peut supprimer l'élément i qui a  
        % généré le groupe. Les autres éléments du groupe ne sont pas
        % supprimés car ils pourraient potentiellement appartenir à un
        % autre groupe.
        if nb_same_pics >= nb_min_same_pics % si le pic est suffisamment détecté
            % assigner toutes les valeurs du groupe à la moyenne du
            % groupe.
            % Il faut aussie ajouter tous les index dans les éléments déjà 
            % modifiés dans la liste des éléments déjà modifiés.
            mean_val = mean(A(same_pics_indexes));
            %fprintf("pic détecté : i = %i , mean val = %f\n", mean_val);
            %disp("index du pic");
            %disp(same_pics_indexes);
            for k=1:nb_same_pics
                %fprintf("index = %i:  %f -> %f\n", same_pics_indexes(k), A(same_pics_indexes(k)), mean_val);
                A(same_pics_indexes(k)) = mean_val;
                already_modified_index(already_modified_index_length+1) = same_pics_indexes(k);
                already_modified_index_length = already_modified_index_length + 1; 
            end            
            
        else % sinon : effacer le pic car il n'est pas suffisamment détecté
            A(i) = []; %suppression
            l = size(A); % mise à jour de la taille du tableau
            i = i - 1; % mise à jour de l'index courant
            % mise à jour du tableau des valeurs déjà modifiées
            for k=1:already_modified_index_length
                already_modified_index(k) = already_modified_index(k) - 1;
            end
        end
    end
    i = i + 1;
end

disp("after")
disp(A)


function res = is_same(A,i,j, threshold)
    res = false;
    if abs(A(i) - A(j)) < threshold
        res = true;
    end
end



