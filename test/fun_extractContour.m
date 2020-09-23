function [C, idxC] = fun_extractContour(I)

for n = 1:3
    J = I(:,:,n);
    maxJ = max(J(:));
    BW = J==maxJ;

    % contour
    B = bwboundaries(BW);

    pA = zeros(1, length(B));
    for nn = 1:length(B)
        pA(nn) = polyarea(B{nn}(:, 1), B{nn}(:, 2));
    end

    [polyA(n), idx] = max(pA);
    CC{n} = fliplr(B{idx});
end
[~, idxC] = max(polyA);
C = CC{idxC};