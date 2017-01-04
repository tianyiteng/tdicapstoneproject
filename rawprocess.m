data = csvread('trip_data_12.csv',1,8,[1 8 30000000 13]);

subplot(1,2,1);
plot(data(:,3),data(:,4),'.')
hold on;
axis([-74.05,-73.75,40.63,40.85])
subplot(1,2,2);
plot(data(:,3),data(:,4),'.')
hold on;
axis([-74.05,-73.75,40.63,40.85])
subplot(1,2,1);
for i=1:300000
if (data(i,2)/data(i,1)) >0.01
plot(data(i,3),data(i,4),'r.','MarkerSize',8);
end
end
subplot(1,2,1);
for i=1:300000
if (data(i,2)/data(i,1)) >0.01
plot(data(i,3),data(i,4),'r.','MarkerSize',8);
end
end
subplot(1,2,2);
for i=1:300000
if (data(i,2)/data(i,1)) >0.02
plot(data(i,3),data(i,4),'r.','MarkerSize',8);
end
end
subplot(1,2,1);
title('Red dots: Frequent Heavy Traffic','FontSize',20)
subplot(1,2,2);
title('Red dots: True Frequent Traffic Jam','FontSize',20)