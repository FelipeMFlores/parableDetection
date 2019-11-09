function detectAxis()
I = imread('exemplo1.jpg');
I2 = rgb2gray(I);
BW = edge(I2,'canny', 0.45);

%find the rotation to align with a axis
[H,theta,rho] = hough(BW);
P = houghpeaks(H,2,'threshold',ceil(0.3*max(H(:))));

thetaPeak = theta(P(2,2));
% Fix the image
BW = imrotate(BW,thetaPeak);
%calculate new lines
[H,theta,rho] = hough(BW);
P = houghpeaks(H,2,'threshold',ceil(0.3*max(H(:))));
lines = houghlines(BW,theta,rho,P,'FillGap',300,'MinLength',10);

%find intersection of x and y axis
int = linlinintersect([lines(1).point1;lines(1).point2;lines(2).point1;lines(2).point2]);
xAxis1 = [lines(2).point1(1) , lines(2).point2(1)];
xAxis2 = [lines(2).point1(2)-100 , lines(2).point2(2)+500];  
%draw a 90 degrees line
int2 = [int(1)+500,int(2)];
yAxis1 = [int(1)-200 , int2(1)];
yAxis2 = [int(2) , int2(2)];    

imshow(BW), hold on;
for k = 1:length(lines)
   x = [lines(k).point1(1); lines(k).point2(1)];
   y = [lines(k).point1(2); lines(k).point2(2)];
   plot(x,y,'LineWidth',7,'Color','black');
end

clf;

% get all white points
[y, x] = find(BW == 1);
imshow(imrotate(I, thetaPeak)), hold on
%plot(x, y, '.')

% draw axis
plot(xAxis1,xAxis2,'LineWidth',2,'Color','green');
plot(yAxis1,yAxis2,'LineWidth',2,'Color','yellow');


% Use mls with ransac two times, to find and discard the two axis

N = 1;           % first-degree polynomial
maxDistance = 20; % maximum allowed distance for a point to be inlier

[P, inlierIdx] = fitPolynomialRANSAC([y, x],N,maxDistance);
yRecoveredCurve = polyval(P,x);
%plot(yRecoveredCurve, x,'-g','LineWidth',2)
%plot(x(inlierIdx),y(inlierIdx),'.', 'Color', 'blue')
%plot(x(~inlierIdx),y(~inlierIdx),'ro','Color','red')

%discard
x = x(~inlierIdx);
y = y(~inlierIdx);

[P, inlierIdx] = fitPolynomialRANSAC([y, x],N,maxDistance);
yRecoveredCurve = polyval(P,x);
%plot(yRecoveredCurve, x,'-g','LineWidth',2)
%plot(x(inlierIdx),y(inlierIdx),'.', 'Color', 'blue')
%plot(x(~inlierIdx),y(~inlierIdx),'ro','Color','red')

% discard
x = x(~inlierIdx);
y = y(~inlierIdx);

% use mls and ransac to find the seconde degree polynomial (parable)
N=2;
[P, inlierIdx] = fitPolynomialRANSAC([y, x],N,maxDistance);
yRecoveredCurve = polyval(P,x);
plot(yRecoveredCurve, x,'-g','LineWidth',2)
%plot(x(inlierIdx),y(inlierIdx),'.', 'Color', 'blue')
%plot(x(~inlierIdx),y(~inlierIdx),'ro','Color','red')


