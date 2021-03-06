clear all
close all

syms t1 t2 dt1 dt2 d2t1 d2t2 real
syms l1 l2 lc1 lc2 real
syms g
syms m1 m2 real
syms I1z I2z real

%Dynamic parameters
I1 = [0 0 0; 0 0 0; 0 0 I1z];
I2 = [0 0 0; 0 0 0; 0 0 I2z];
m = [m1; m2];

%Kinmeatic parameters
r1c = [lc1; 0; 0];
r2c = [lc2; 0; 0];
r10 = [l1 ; 0; 0];
r20 = [l2 ; 0; 0];
r0  = [r10,  r20];
rc  = [r1c,  r2c];

%Initial conditions (forces and torques)
f3x=0; f3y=0; f3z=0;
u3x=0; u3y=0; u3z=0;

f3 = [f3x; f3y; f3z];
u3 = [u3x; u3y; u3z];

g0 = [0; g; 0];
z0 = [0; 0; 1];

f = [g0 g0 f3];
u = [g0 g0 u3];

%Initial conditions (linear and angular accelerations)
o0x=0; o0y=0; o0z=0;
p0x=0; p0y=g; p0z=0;
do0x=0; do0y=0; do0z=0;
p0 = [p0x; p0y; p0z];
o0 = [o0x; o0y; o0z];
do0 = [do0x; do0y; do0z];

%Useful definitions
c1 = cos(t1);  c2 = cos(t2);
s1 = sin(t1);  s2 = sin(t2);

R1 = [c1 -s1 0;
      s1  c1 0;
      0    0 1];

R2 = [c2 -s2 0;
      s2  c2 0;
      0    0 1];

R3 = [1 0 0;
      0 1 0;
      0 0 1];  
  
dt  = [dt1,  dt2];
d2t = [d2t1, d2t2];

%Kinematic recursion
for i = 1:2
    if i==1
        Ri=R1;
    else
        Ri=R2;
    end
    if i==1
        o_prev = o0;
        p_prev = p0;
        do_prev = do0;
    else
        p_prev = p(:,i-1);
        o_prev = o(:,i-1);
        do_prev = do(:,i-1);
    end
    o(:,i)  = Ri'*(o_prev+dt(i)*z0);
    do(:,i) = Ri'*(do_prev+d2t(i)*z0+dt(i)*cross(o_prev,z0));
    p(:,i)  = Ri'*p_prev+cross(do(:,i),r0(:,i))+cross(o(:,i),cross(o(:,i),r0(:,i)));
    c(:,i)  = p(:,i) + cross(do(:,i), rc(:,i)) +cross(o(:,i),cross(o(:,i),rc(:,i)));
end

%Dynamic recursion
for i = 2:-1:1
    if i==2
        Ri=R3;
        Ii = I2;
    else
        Ri=R2;
        Ii = I1;
    end
    f(:,i)  = Ri*f(:,i+1) + m(i,1).*c(:,i);
    u(:,i)  = -cross(f(:,i), rc(:,i)+r0(:,i)) + Ri*u(:,i+1)+ ...
        cross(Ri*f(:,i+1), rc(:,i)) + Ii*do(:,i) + cross(o(:,i), Ii*o(:,i));
end

f = simple(f);
u = simple(u);
p = simple(p);
o = simple(o);
c = simple(c);
do = simple(do);


