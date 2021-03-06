clc
clear all

N = 2;
x1 = 1;  x2 = 2;
nsamples = 300;

i_obs    = [x2];
i_hidden = setdiff(1:N, i_obs);

evidence = cell(1,N);
engine   = cell(1,nsamples);
bnet     = cell(1,nsamples);

bnet = buildGaussSum([10], [1 1], [1 5]);
%DO NOT CHANGE THIS WHEN DOING learn_params_em
engine = jtree_inf_engine(bnet);
[engine, ll] = enter_evidence(engine, evidence);

randn('seed',0);
% %sample the original network
for i=1:nsamples
  samples(:,i) = sample_bnet(bnet, 'evidence', evidence);
end
 
for j = 1 : length(i_hidden)
    for h = 1 : nsamples
        samples{i_hidden(j), h} = [];
    end
end

%normalize for numerical issues 
%samplesStd = (samples - muStd)/covStd
ns  = [1 1];
for j = 1 : length(i_obs)
    [dataStd, muStd{i_obs(j)}, covStd{i_obs(j)}] = standardize(cell2mat(samples(i_obs(j), :)));
    samplesStd(i_obs(j), :) = num2cell(dataStd, [1, nsamples]);
end
for j = 1 : length(i_hidden)
    muStd{i_hidden(j)} = zeros(ns(i_hidden(j)),1);
    covStd{i_hidden(j)} = eye(ns(i_hidden(j)));
    for h = 1 : nsamples
        samplesStd{i_hidden(j), h} = [];
    end
end
%samplesStd = S * samples + M
for j = 1 : N
    M{j} = -muStd{j}./covStd{j};
    S{j} = 1./covStd{j};
end

bnet0 = buildGaussSum(10, [1 1], [1 1]);
bnet0std = insertStandardization(bnet0, M, S, i_obs, 1e-4);
%DO NOT CHANGE THIS WHEN DOING learn_params_em
engine0std = jtree_inf_engine(bnet0std);
[engine0std, ll] = enter_evidence(engine0std, evidence);

%%%%%%%%%%%%%%%%%TMP%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loglik = 0;
% engine = jtree_inf_engine(bnet);
% for l=1:nsamples
%   evidence = samples(:,l);
%   [engine, ll] = enter_evidence(engine, evidence);
%   loglik = loglik + ll;
% end
% loglik
% 
% loglik = 0;
% engine0 = jtree_inf_engine(bnet0);
% for l=1:nsamples
%   evidence = samples(:,l);
%   [engine0, ll] = enter_evidence(engine0, evidence);
%   loglik = loglik + ll;
% end
% loglik
% 
% engine0 = jtree_inf_engine(bnet0);
% [engine0, ll] = enter_evidence(engine0, evidence);
% hat_bnetStd = learn_params_em(engine0, samples, 20, 1e-2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hat_bnetStd = learn_params_em(engine0std, samplesStd, 200, 1e-6);
hat_bnetStd = removeStandardization(hat_bnetStd, M, S, i_obs, 0.00001);

hat_x1 = struct(hat_bnetStd.CPD{1});
hat_x1.cov

hat_x2 = struct(hat_bnetStd.CPD{2});
hat_x2.cov

%Non STD version
% engine0 = jtree_inf_engine(bnet0);
% [engine0, ll] = enter_evidence(engine0, evidence);
% 
% hat_bnet = learn_params_em(engine0, samples);
% 
% hat_x1 = struct(hat_bnet.CPD{1});
% hat_x1.cov
% 
% hat_x2 = struct(hat_bnet.CPD{2});
% hat_x2.cov
% 
% hat_x3 = struct(hat_bnet.CPD{3});
% hat_x3.cov
