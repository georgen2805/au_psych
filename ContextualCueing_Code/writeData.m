%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function writeData 
% 10/8/2009 - kms
%
% Takes a cell array and writes it to a data file.
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [completed] = writeData(fileHandle, dataArray, sep)

    sep = sprintf(sep);

    % get classes of elements in the Array
    nElements = size(dataArray);
    nElements = nElements(2);
    output = '';
    
    for e = 1:nElements
        dataClass = class(dataArray{e});
        switch dataClass
            case 'double'
                type = 'd';
            case 'float'
                type = 'f';
            case 'string'
                type = 's';
            case 'char'
                type = 's';
            otherwise
                completed = 'F';
                return;
        end
        if e == 1
            if type == 's'
                output = dataArray{e};
            else
                output = num2str(dataArray{e});
            end 
        else
            if type == 's'
                output = [output sep dataArray{e}];
            else
                output = [output sep num2str(dataArray{e})];
            end 
        end
    end

    % write to the file
    fprintf(fileHandle, '%s\n', output);


completed = 'T';