%% Authors : Zineb Smine & Rania Charkaoui

%% The goal of this function is to reject as many fake positive spikes detected as possible. 
%% To achieve this, one can look into the number of channels that detect a spike at the same time.
%% If the number of channels is higher than a set threshold, the spike is saved. Otherwise, 
%% the spike is rejected since it is most likely a fake positive. 

function [A,B] = Check_Same_SpikeDetected(C,D,threshold, nb_min_same_spike)
    A = C;
    B = D;
    l = size(A);

    already_modified_index = [];
    already_modified_index_length = 0;

    i = 1;
    while i <= l(1)-1%each element is compared with those that follow it, so the last one is not necessary
        % this comparison is only made if the element is non-null
        % and the element does not already belong to a group
        if A(i) ~= 0 && ~ismember(i,already_modified_index) 
            nb_same_spike = 1; % the number of spikes belonging to the group
            next_channel_index = get_next_ch_index(A,i);
            nb_same_pics_diff_channels = 1; 
            same_pics_indexes = [i]; % index of elements belonging to the group 
            
            %We will look at all the elements that follow it to see if it
            % can belong to the group
            for j=i+1:l(1)
                % In order to belong to the group, it is necessary to be
                % non-null, necessary that
                % the spikes are detected in the same time window and
                % the element does not already belong to a group

                if A(j) ~= 0 && is_same(A, i, j, threshold) && ~ismember(j,already_modified_index)
                    % adding a spike : we add the element to the group 
                    nb_same_spike = nb_same_spike + 1;
                    same_pics_indexes(nb_same_spike) = j;
                    if j > next_channel_index
                        nb_same_pics_diff_channels = nb_same_pics_diff_channels + 1;
                    end 
                    
                end
            end
            
            
            % Now we have to see if there are enough elements in the group
            % If there are enough == minimal number given in argument ->ok, 
            % If there are not enough, we can delete the element i which has  
            % generated the group. The other elements in the group are not
            % deleted as they could potentially belong to another group.
            % other group.
            if nb_same_pics_diff_channels >= nb_min_same_spike % si le pic est suffisamment détecté
                % assign all values in the group to the average of the
                % group.
                % It is also necessary to add all the indexes in the elements already 
                % modified items in the list of already modified items.
                mean_val = mean(A(same_pics_indexes));
                %mean_val = max(A(same_pics_indexes));
                
                %fprintf("pic détecté : i = %i , mean val = %f\n", mean_val);
                %disp("index du pic");
                %disp(same_pics_indexes);
                for k=1:nb_same_spike
                    %fprintf("index = %i:  %f -> %f\n", same_pics_indexes(k), A(same_pics_indexes(k)), mean_val);
                    A(same_pics_indexes(k)) = mean_val;
                    already_modified_index(already_modified_index_length+1) = same_pics_indexes(k);
                    already_modified_index_length = already_modified_index_length + 1; 
                end            

            else % otherwise: delete the spike because it is not sufficiently detected
                A(i) = []; %suppression
                B(i) = [];
                l = size(A); % update of the table size
                i = i - 1; % update of the current index
                % update of the table of values already modified
                for k=1:already_modified_index_length
                    already_modified_index(k) = already_modified_index(k) - 1;
                end
            end
        end
        i = i + 1;
    end


end

function res = is_same(A,i,j, threshold)
    res = false;
    if abs(A(i) - A(j)) < threshold
        res = true;
    end
end

function res = get_next_ch_index(A,i)
    len = size(A);
    len = len(2);
    while A(i) ~= 0 && i <len
        i = i + 1;
    end 
    res = i;
    if res == len
        %disp("Last channel");
    end 
end 