function [edgeX,edgeY] = hexagonborder(side,x0,y0, draw)
   %side = side size;,(x0,y0) exagon center coordinates;
   % draw(true) : draw the BS scatter and the subcell
   L = linspace(0, 2*pi,7);
   edgeX = side * cos(L)+x0;
   edgeY = side * sin(L)+y0;
   if draw == 1  
       plot(edgeX,edgeY,'r','Linewidth',1);
       scatter(x0,y0,'filled','g');
   end