function dC_dx = dC_dx(in1,in2,in3)
%DC_DX
%    DC_DX = DC_DX(IN1,IN2,IN3)

%    This function was generated by the Symbolic Math Toolbox version 5.6.
%    08-Jan-2014 09:35:18

d_theta1 = in1(7,:);
d_theta2 = in1(8,:);
dox2 = in2(22,:);
dox3 = in2(25,:);
doy2 = in2(23,:);
doy3 = in2(26,:);
fbbx = in2(77,:);
fbby = in2(78,:);
feex = in2(83,:);
feey = in2(84,:);
fx3 = in2(37,:);
fx4 = in2(40,:);
fy3 = in2(38,:);
fy4 = in2(41,:);
l1 = in3(:,1);
l2 = in3(:,2);
ox2 = in2(92,:);
ox3 = in2(95,:);
oy2 = in2(93,:);
oy3 = in2(96,:);
px2 = in2(10,:);
px3 = in2(13,:);
py2 = in2(11,:);
py3 = in2(14,:);
r1 = in3(:,5);
r2 = in3(:,6);
theta1 = in1(3,:);
theta2 = in1(4,:);
ubbx = in2(80,:);
ubby = in2(81,:);
ueex = in2(86,:);
ueey = in2(87,:);
ux3 = in2(52,:);
ux4 = in2(55,:);
uy3 = in2(53,:);
uy4 = in2(56,:);
t22 = cos(theta1);
t23 = sin(theta1);
t24 = cos(theta2);
t25 = sin(theta2);
t26 = d_theta1+d_theta2;
t27 = l2-r2;
t28 = t26.*t27.*2.0;
t29 = theta1+theta2;
t30 = cos(t29);
t31 = sin(t29);
t32 = feex.*t31;
t33 = t32-feey.*t30;
t34 = feex.*t30;
t35 = feey.*t31;
t36 = t34+t35;
t37 = t31.*ueex;
t38 = t37-t30.*ueey;
t39 = t30.*ueex;
t40 = t31.*ueey;
t41 = t39+t40;
t42 = l1-r1;
dC_dx = reshape([0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,ox2.*t22+oy2.*t23,-ox2.*t23+oy2.*t22,0.0,dox2.*t22+doy2.*t23,-dox2.*t23+doy2.*t22,0.0,px2.*t22+py2.*t23,-px2.*t23+py2.*t22,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,t33,t36,0.0,t38,t41,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-fbby.*t22+fbbx.*t23,fbbx.*t22+fbby.*t23,0.0,-t22.*ubby+t23.*ubbx,t22.*ubbx+t23.*ubby,-fbbx.*r1.*t22-fbby.*r1.*t23,fx3.*t22-fy3.*t23,fx3.*t23+fy3.*t22,0.0,t22.*ux3-t23.*uy3,t23.*ux3+t22.*uy3,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-ox3.*t25+oy3.*t24,-ox3.*t24-oy3.*t25,0.0,-dox3.*t25+doy3.*t24,-dox3.*t24-doy3.*t25,0.0,-px3.*t25+py3.*t24,-px3.*t24-py3.*t25,0.0,0.0,0.0,0.0,t33,t36,0.0,t38,t41,0.0,0.0,0.0,0.0,0.0,0.0,0.0,-fx4.*t25-fy4.*t24,fx4.*t24-fy4.*t25,0.0,-t25.*ux4-t24.*uy4,t24.*ux4-t25.*uy4,fx4.*t24.*t42-fy4.*t25.*t42,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,d_theta1.*l1.*-2.0,0.0,0.0,d_theta1.*t42.*2.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,l2.*t26.*-2.0,0.0,0.0,t28,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,1.0,0.0,0.0,0.0,l2.*t26.*-2.0,0.0,0.0,t28,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0],[78, 8]);