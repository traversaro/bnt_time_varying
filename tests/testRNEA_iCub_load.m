clear all
close all
clc

% edit next line to the install path of drake
path_to_drake_distro = '/Users/iron/Code/drake-distro/';
addpath(path_to_drake_distro);
addpath(strcat(path_to_drake_distro,'drake'));
addpath(strcat(path_to_drake_distro,'build/matlab'));

addpath_drake;

% Now works with robot_models with stl meshes and collisions
robotPath = '../robot_models/icub';
robotName = 'icubGazeboSim_fixedHeadWrist';

%urdfPath = [robotPath,filesep,robotName,filesep,robotName];
%addpath(urdfPath);


%NB = 2;

R = RigidBodyManipulator([robotPath,filesep,robotName,'.urdf']);
dmodel = R.featherstone;

NB = dmodel.NB;
for i = 1 : NB
   dmodel.jtype{i}      = 'R';
   dmodel.appearance{i} = '1';
   dmodel.linkname{i}   = R.body(i+1).linkname;
   dmodel.jointname{i}  = R.body(i+1).jointname;
end

ymodel = autoSensRNEA(dmodel);

rmpath_drake;

rmpath(path_to_drake_distro);
rmpath(strcat(path_to_drake_distro,'drake'));
rmpath(strcat(path_to_drake_distro,'build/matlab'));



q         = rand(dmodel.NB,1);
dq        = rand(dmodel.NB,1);
y         = rand(ymodel.m,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myModel = model(dmodel);
mySens  = sensors(ymodel);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
myRNEA    = RNEA(myModel, mySens);
myRNEA    = myRNEA.setState(q,dq);
myRNEA    = myRNEA.setY(y);

if (sum(q-myRNEA.IDstate.q))
   error('Something wrong with the setQ method');
end

if (sum(dq-myRNEA.IDstate.dq))
   error('Something wrong with the setDq method');
end

if (sum(y-myRNEA.IDmeas.y))
   error('Something wrong with the setY method');
end

myRNEA = myRNEA.solveID();
myRNEA.d;

for i = 1 : NB
   fx{i}    = y((1:6)+(i-1)*7,1);
   d2q(i,1) = y(7*i);
end

[tau, a, fB, f] = ID( dmodel, q, dq, d2q, fx);

d = zeros(26*NB, 1);
for i = 1 : NB
   d((1:26)+(i-1)*26, 1) = [a{i}; fB{i}; f{i}; tau(i,1); fx{i}; d2q(i,1)];
end

if (sum(d-myRNEA.d))
   error('Something wrong with the solveID method');
end
