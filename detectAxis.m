function detectAxis(image, numPeaks, rotatePeak, nLines)
%image = 'examplo1.jpg' , numpeaks = 2 , rotatePeak = 1 , nLines = 3
I = imread(image);
I2 = rgb2gray(I);
ed = edge(I2,'canny', 0.45);
%find the rotation to align with a axis
[H,theta,~] = hough(ed);
P = houghpeaks(H ,numPeaks);

thetaPeak = theta(P(rotatePeak, 2));
% Fix the image
BW = imrotate(ed,thetaPeak);
%calculate new lines
[H,theta,rho] = hough(BW);
P = houghpeaks(H,numPeaks,'threshold',ceil(0.3*max(H(:))));

lines = houghlines(BW,theta,rho,P,'FillGap',300,'MinLength',10);

imshow(imrotate(I, thetaPeak)), hold on
%{
for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','c');
end
%}

%find intersection of x and y axis
int = linlinintersect([lines(1).point1;lines(1).point2;lines(2).point1;lines(2).point2]);
yAxis1 = [lines(1).point1(1) , lines(1).point2(1)];
yAxis2 = [lines(1).point1(2) , lines(1).point2(2)];  
%draw a 90 degrees line
xAxis1 = [int(1)-200 , int(1) + 700];
xAxis2 = [int(2), int(2)];    

% get all white points
[y, x] = find(BW == 1);
%plot(x, y, '.')
for k = 1:length(lines)
    r = zeros(size(x));
    for i = 1:length(y)
        r(i) = isPointOnLine(lines(k).point1, lines(k).point2, [x(i), y(i)]);
    end
    %discard
    x = x(~r);
    y = y(~r);
end
%plot(x, y, '.')


% draw axis
plot(xAxis1,xAxis2,'LineWidth',2,'Color','b');
plot(yAxis1,yAxis2,'LineWidth',2,'Color','b');



% use mls and ransac to find the seconde degree polynomial (parable)
N=2;
maxDistance = 50;
[P, inlierIdx] = fitPolynomialRANSAC([x, y],N,maxDistance, 'MaxNumTrials', 5000, 'MaxSamplingAttempts', 500, 'Confidence', 99.999999);
xn = [300:800];
yRecoveredCurve = polyval(P,xn);
%plot(x(inlierIdx),y(inlierIdx),'.', 'Color', 'blue')
%plot(x(~inlierIdx),y(~inlierIdx),'ro','Color','red')

plot(xn, yRecoveredCurve,'-g','LineWidth',2)

