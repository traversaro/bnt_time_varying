function [ data ] = loadData( data )
%LOADDATA Summary of this function goes here
%   Detailed explanation goes here

for i = 1 : length(data.parts)
   file = [data.path '/icub/' data.parts{i} '/' data.type{i} '/data.log'];
   if strcmp(data.type{i}, 'stateExt:o');
      q    = ['q_' data.labels{i}];
      dq   = ['dq_' data.labels{i}];
      d2q  = ['d2q_' data.labels{i}];
      t    = ['time_' data.labels{i}];
      eval(['[' q ',' dq ',' d2q ',' t '] = readState(' num2str(data.ndof{i}) ',''' file ''');']);
   else
      y    = ['y_' data.labels{i}];
      t    = ['time_' data.labels{i}];
      eval(['[' y ',' t '] = readDataDumper(''' file ''');']);
      eval([t '=' t ''';']);
      eval([y '=' y ''';']);
   end
end

min_times = [];
max_times = [];
for i = 1 : length(data.labels)
   max_time  = ['max_time_', data.labels{i}];
   min_time  = ['min_time_', data.labels{i}];
   t         = ['time_' data.labels{i}];
   eval([max_time ' = max(' t ');']);
   eval([min_time ' = min(' t ');']);
   
   min_times = [min_times eval(min_time)];
   max_times = [max_times eval(max_time)];
end

time_i = max(min_times);
time_f = min(max_times);

for i = 1 : length(data.labels)
   tf  = eval(['max_time_', data.labels{i}]);
   ti  = eval(['min_time_', data.labels{i}]);
   
   if abs(tf - time_f) > 1 || abs(ti - time_i) > 1
      disp(['[WARNING] There is some lag in the ' data.parts{i} ' data'])
   end
   
end

time   = linspace(time_i+data.ini, time_i+data.end, data.nsamples);

%%
close all

dtime   = time(1);
for i = 1 : length(data.parts)
   
   if strcmp(data.type{i}, 'stateExt:o');
      q    = ['q_' data.labels{i}];
      dq   = ['dq_' data.labels{i}];
      d2q  = ['d2q_' data.labels{i}];
      t    = ['time_' data.labels{i}];
      
      qs   = ['qs_' data.labels{i}];
      dqs  = ['dqs_' data.labels{i}];
      d2qs = ['d2qs_' data.labels{i}];
      
      % [qs_la, dqs_la, d2qs_la] = resampleState(time, time_la, q_la, dq_la, d2q_la);
      eval(['[data.' qs ', data.' dqs ', data.' d2qs '] = resampleState(time,' t ',' q ',' dq ',' d2q ');']);
   else
      y    = ['y_'  data.labels{i}];
      t    = ['time_' data.labels{i}];
      ys   = ['ys_' data.labels{i}];
      eval(['data.' ys ' = interp1(' t ',' y ''', time)'';']);
   end
   % time_h  = time_h  - dtime;
   eval([t '=' t '- dtime;']);
end
data.time = time    - dtime;

for i = 1 : length(data.parts)
   if data.visualize{i} && strcmp(data.type{i}, 'stateExt:o')
      q    = ['q_' data.labels{i}];
      dq   = ['dq_' data.labels{i}];
      d2q  = ['d2q_' data.labels{i}];
      t    = ['time_' data.labels{i}];
      
      qs   = ['qs_' data.labels{i}];
      dqs  = ['dqs_' data.labels{i}];
      d2qs = ['d2qs_' data.labels{i}];
      
      figure
      subplot(311)
      eval(['plot(' t ',' q ')'])
      hold on
      eval(['plot(data.time,data.' qs ', ''--'' )' ]);
      title([' q_{' data.labels{i} '}'])
      subplot(312)
      eval(['plot(' t ',' dq ')'])
      hold on
      eval(['plot(data.time,data.' dqs ', ''--'' )' ]);
      title(['dq_{' data.labels{i} '}'])
      subplot(313)
      eval(['plot(' t ',' d2q ')'])
      hold on
      eval(['plot(data.time,data.' d2qs ', ''--'' )' ]);
      title(['d2q_{' data.labels{i} '}'])
   elseif data.visualize{i}
      y    = ['y_'  data.labels{i}];
      t    = ['time_' data.labels{i}];
      ys   = ['ys_' data.labels{i}];
      
      figure
      J = data.ndof{i};
      for j = 1 : J/3
         subplot([num2str(J/3) '1' num2str(j)])
         I = 1+(j-1)*3 : 3*j;
         eval(['plot(' t ',' y '(I,:))'])
         hold on
         eval(['plot(data.time,data.' ys '(I,:), ''--'' )' ]);
         title(['y_{' data.labels{i} '}'])
      end
   end
end

%   q = [torso_pitch, torso_roll, torso_yaw, 
%        l_leg_pitch, l_leg_roll, l_leg_yaw, l_leg_knee, l_ank_pitch, 
%        l_arm_pitch, l_arm_roll, l_arm_yaw, l_arm_elbw, l_wrs_roll,  l_ank_roll,
%        r_leg_pitch, r_leg_roll, r_leg_yaw, r_leg_knee, r_ank_pitch, 
%        r_arm_pitch, r_arm_roll, r_arm_yaw, r_arm_elbw, r_wrs_roll,  r_ank_roll]

data.q = [...
   data.qs_to(3:-1:1, :); ...
   data.qs_ll(1:5, :);
   data.qs_la(1:5, :); data.qs_ll(6, :); ...
   data.qs_rl(1:5, :); ... 
   data.qs_ra(1:5, :); data.qs_rl(6, :)].*pi/180;

data.dq = [...
   data.dqs_to(3:-1:1, :); ...
   data.dqs_ll(1:5, :);
   data.dqs_la(1:5, :); data.dqs_ll(6, :); ...
   data.dqs_rl(1:5, :); ... 
   data.dqs_ra(1:5, :); data.dqs_rl(6, :)].*pi/180;

data.d2q = [...
   data.d2qs_to(3:-1:1, :); ...
   data.d2qs_ll(1:5, :);
   data.d2qs_la(1:5, :); data.d2qs_ll(6, :); ...
   data.d2qs_rl(1:5, :); ... 
   data.d2qs_ra(1:5, :); data.d2qs_rl(6, :)].*pi/180;



end

