function detectAxis()
I = imread('exemplo1.jpg');
I2 = rgb2gray(I);
BW = edge(I2,'canny', 0.45);

%find the rotation to align with a axis
[H,theta,~] = hough(BW);
P = houghpeaks(H,2,'threshold',ceil(0.3*max(H(:))));
thetaPeak = theta(P(2,2));
% Fix the image
BW = imrotate(BW,thetaPeak);
%calculate new lines
[H,theta,rho] = hough(BW);
P = houghpeaks(H,2,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',100,'MinLength',10);
figure, imshow(imrotate(I, thetaPeak)), hold on

%find intersection of x and y axis
int = linlinintersect([lines(1).point1;lines(1).point2;lines(2).point1;lines(2).point2]);
x = [lines(2).point1(1) , lines(2).point2(1)];
y = [lines(2).point1(2)-100 , lines(2).point2(2)+500];  
plot(x,y,'LineWidth',2,'Color','green');
%draw a 90 degrees line
int2 = [int(1)+500,int(2)];
x = [int(1)-200 , int2(1)];
y = [int(2) , int2(2)];    
plot(x,y,'LineWidth',2,'Color','yellow');

