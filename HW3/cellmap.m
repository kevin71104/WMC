function [borderX, borderY] = cellmap (side, X, Y, centralX, centralY, label, draw)
    % label(true) : label BS number
    % side :length of the hexagon
    % X : relative BS x-location to central
    % Y : relative BS y-location to central
    % [centralX, centralY] : the location of central BS
    % [borderX, borderY] : the border of cellmap
    % draw(true) : draw the BS scatter and the subcell

    BS_X = X + centralX;
    BS_Y = Y + centralY;
    hold on;
    for i = 1:size(BS_X,2)
        [edgeX{i},edgeY{i}] = hexagonborder(side, BS_X(i), BS_Y(i), draw);
        if label == 1
            text(BS_X(i), BS_Y(i), int2str(i));
        end
        %text(centralX, centralY, '*');
        if i == 1
           borderX = edgeX{i};
           borderY = edgeY{i};
        else
            [borderX, borderY] = polybool('union', borderX, borderY, edgeX{i}, edgeY{i});
        end
    end
    clear i;

