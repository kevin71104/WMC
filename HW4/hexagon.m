
function [vectorX,vectorY] = hexagon(side,x0,y0,num_MS,draw)
   %side = side size;,(x0,y0) exagon center coordinates;
   L = linspace(0, 2*pi, 7);
   edgeX = side * cos(L)+x0;
   edgeY = side * sin(L)+y0;
   if draw
       plot(edgeX,edgeY,'r','Linewidth',1);
       scatter(x0,y0,'filled','g');
   end
   
   if num_MS >= 1
       ISD = side*sqrt(3);
       ai = [side,0.0];
       aj = [-side/2, ISD/2];
       ak = [-side/2, -ISD/2];
  
       temp  = randi(3,1,num_MS);
       tempx = rand(1,num_MS);
       tempy = rand(1,num_MS);
       for a =1:num_MS
           if temp(a) == 1
               x(a) = tempx(a)*ai(1) + tempy(a)*aj(1);
               y(a) = tempy(a)*aj(2);
           elseif temp(a) == 2
               x(a) = tempx(a)*ai(1) + tempy(a)*ak(1);
               y(a) = tempy(a)*ak(2) ;
           elseif temp(a) == 3
               x(a) = tempx(a)*aj(1) + tempy(a)*ak(1);
               y(a) = tempx(a)*aj(2) + tempy(a)*ak(2);
           end
       end
       vectorX = x+x0;
       vectorY = y+y0;
       if draw
           scatter(vectorX,vectorY,10,'b','filled');
       end
   end
   

   
