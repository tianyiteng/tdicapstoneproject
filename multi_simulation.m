load('mydata.mat');
figure('position', [0, 0, 700/2, 1200/2]);axis([-74.02,-73.95,40.7,40.82]);hold on;
figure(1);plot_google_map;hold on;
filename='multirun.gif';

for n=1:1447
    for i=1:200
        buff=cell2mat(direction_lib(i));
        if n<length(buff)
            plot(buff(n,2),buff(n,1),'r.')
        end
    end
    pause(0.01)
%     drawnow
%       frame = getframe(1);
%       im = frame2im(frame);
%       [imind,cm] = rgb2ind(im,256);
%       if n == 1;
%           imwrite(imind,cm,filename,'gif', 'Loopcount',inf);
%       else
%           imwrite(imind,cm,filename,'gif','WriteMode','append');
%       end

end