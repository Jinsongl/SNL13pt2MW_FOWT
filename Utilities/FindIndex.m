function [index] = FindIndex(value, A)
%   value & A are column vectors
%   find the index of value in A
    sz = size(value, 1);
    index = zeros(sz,1);
    for i = 1 : sz
        idx = find(A == value(i));
        if (idx)
            index(i) = idx;
        else
            printf('value cannot be found');
            break;
        end
    end
end