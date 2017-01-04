filename='plot2.gif';
x1=p1.Longitude;
y1=p1.Latitude;
plot(x1,y1,'b','LineWidth',2);
hold on;
x2=p2.Longitude;
y2=p2.Latitude;
plot(x2,y2,'b','LineWidth',2);
axis([-74.05,-73.75,40.64,40.82])
plot_google_map
title('simulation of two example flow with traffic signal','FontSize',20)
hold on;


for n = 1:50:length(x2)
      plot(x1(n),y1(n),'.r','MarkerSize',30)
      plot(x2(n),y2(n),'.r','MarkerSize',30)
      drawnow
      frame = getframe(1);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,256);
      if n == 1;
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append');
      end
end
for n=length(x2):50:length(x1)
      plot(x1(n),y1(n),'.r','MarkerSize',30)
      drawnow
      frame = getframe(1);
      im = frame2im(frame);
      [imind,cm] = rgb2ind(im,256);
      if n == 1;
          imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
      else
          imwrite(imind,cm,filename,'gif','WriteMode','append');
      end
    
end