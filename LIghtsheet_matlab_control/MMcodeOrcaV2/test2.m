a=125.70547;
b=2637.28871;
c=94.97778;
d=6.37266;
maxium = b;
y=maxium/2;
x1=c+sqrt(-2*d^2*log((y-a)/(b-a)));
x2=c-sqrt(-2*d^2*log((y-a)/(b-a)));
d = abs(x1-x2)*0.65
% FWHM
% 34.5272,20.29166,11.0824,7.388,9.1904,16.399,25.424296

% voltage to angle 
x = [0,0.1,0.2,0.3,0.4,0.5];
angle = [0,-0.42,-1.43,-2.38,-2.96,-3.71];
plot(x,angle)
fit_x=fit(x',angle','linearinterp')

% figc galvox=-0.4074 glavoy=-0.169 
% figd galvox=-0.168 glavoy=-0.1848

a=22;
for i=1:5
   a=a+2;
end
a
%start pos is 9369.4
% end pos is 13649


