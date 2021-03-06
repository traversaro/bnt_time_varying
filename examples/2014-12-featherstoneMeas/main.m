clc
close all
clear all

global sModel sMeas sUknown
sModel  = 1e1;
sMeas   = 1e-5;
sUknown = 1e3;

nbVals = logspace(log10(1), log10(20), 10);
nbVals = round(nbVals);
nbVals = unique(nbVals','rows')';

for nb = nbVals
  NB = nb;
  model = autoTree(NB, 1+rand(1)*ceil(NB/4));
  NB = NB + 5;
  n  = NB;
  model = floatbase(model);
  fx = cell(NB);
  for i = 1 : NB
    fx{i} = rand(6,1);
  end
  q   = rand(NB,1);
  dq  = rand(NB,1);
  d2q = rand(NB,1);
  
  % build the measurements
  Npass = 2;

  t_rne = zeros(Npass, 1);
  t_mat = zeros(Npass, 1);
  t_cho = zeros(Npass, 1);
  t_net = zeros(Npass, 1);
  t_sol = zeros(Npass, 1);
  

  for t = 1: Npass
    ny = 0;
    ry = randfixedsum(NB, 1, 4*NB, 2, 6);
    ry = round(ry);
    for i = 1 : NB
      if ry(i) >= 6
        ny = ny + 1;
        y.sizes{ny,1} = 6;
        y.labels{ny,1} = ['a' num2str(i)];
      end
      if ry(i) >= 5
        ny = ny + 1;
        y.sizes{ny,1} = 6;
        y.labels{ny,1} = ['fB' num2str(i)];
      end
      if ry(i) >= 4
        ny = ny + 1;
        y.sizes{ny,1} = 6;
        y.labels{ny,1} = ['f' num2str(i)];
      end
      if ry(i) >= 3
        ny = ny + 1;
        y.sizes{ny,1} = 1;
        y.labels{ny,1} = ['tau' num2str(i)];
      end
      if ry(i) >= 2
        ny = ny + 1;
        y.sizes{ny,1} = 6;
        y.labels{ny,1} = ['fx'  num2str(i)];
      end
      if ry(i) >= 1
        ny = ny + 1;
        y.sizes{ny,1} = 1;
        y.labels{ny,1} = ['d2q' num2str(i)];
      end
    end
    
    % solve ID with the RNEA
    [tau_rne, a_rne, fB_rne, f_rne]        =  ID(model, q, dq, d2q, fx);
    
    % solve redundant ID with matrix inversion
    [y, Y]    = calcMeas (y, a_rne, fB_rne, f_rne, d2q, fx, ny, tau_rne, NB);
    [tau_mat, a_mat, fB_mat, f_mat]        = mID(model, q, dq, Y, y);
    
    % solve redundant ID with Cholesky
    [ys, Ys, ym, Yx, Yy]    = cholMeas (y, a_rne, fB_rne, f_rne, d2q, fx, ny, tau_rne, NB);
    tic;
    [Sf_cho, S]  = cID(model, q, dq, Ys, ys);
    t_chl(nb) = toc;
    
    % solve redundant ID without matrix inversion
    sparseModel                     = calcSparse(model);
    [tau_sol, a_sol, fB_sol, f_sol] = sID(model, q, dq, Yx, Yy, ym, S, sparseModel);

    % solve ID with a Bayesian network
    [bnet , y] = buildBnet(model, y);
    tic;
    [tau_net, a_net, fB_net, f_net, bnet, Sf_net]  = nID(model, q, dq, d2q, fx, y, bnet);
    t_pth(nb) = toc;
    
    
    % norm(cell2mat(a_rne)-a_mat')
    % norm(cell2mat(fB_rne)-fB_mat')
    % norm(cell2mat(f_rne)-f_mat')
    
    % norm(cell2mat(a_rne)-a_net')
    % norm(cell2mat(fB_rne)-fB_net')
    % norm(cell2mat(f_rne)-f_net')
    % norm(tau_sol-tau_net)
    % norm(cell2mat(Sf_cho) - cell2mat(Sf_net))
    
    
    %%%% MUTIPLE PASS %%%%%
    
    for i = 1 : NB
      fx{i} = rand(6,1);
    end
    d2q = rand(NB,1);
    dq  = rand(NB,1);
    q   = rand(NB,1);
    
    % solve ID with the RNEA
    tic;
    [tau_rne, a_rne, fB_rne, f_rne]        =  ID(model, q, dq, d2q, fx);
    t_rne(t) = toc*1000;
    
    % solve redundant ID with matrix inversion
    [y, Y]    = calcMeas (y, a_rne, fB_rne, f_rne, d2q, fx, ny, tau_rne, NB);
    tic;
    [tau_mat, a_mat, fB_mat, f_mat, Sf_mat] = mID(model, q, dq, Y, y);
    t_mat(t) = toc*1000;    
    
    % solve redundant ID without matrix inversion
    sparseModel                     = calcSparse(model);
    tic;
    [tau_sol, a_sol, fB_sol, f_sol] = sID(model, q, dq, Yx, Yy, ym, S, sparseModel);
    t_sol(t) = toc*1000;    

    % solve redundant ID without exploiting sparsity
    tic;
    [tau_red, a_red, fB_red, f_red] = rID(model, q, dq, Yx, Yy, ym, sparseModel);
    t_red(t) = toc*1000;

    % solve redundant ID with sparse Cholesky
    [ys, Ys, ym, Yx, Yy]  = cholMeas (y, a_rne, fB_rne, f_rne, d2q, fx, ny, tau_rne, NB);
    tic;
    Sf_cho = cID(model, q, dq, Ys, ys, S);
    t_cho(t) = toc*1000 + t_red(t);
    
    % solve ID with a Bayesian network
    tic;
    [tau_net, a_net, fB_net, f_net, bnet, Sf_net]  = nID(model, q, dq, d2q, fx, y, bnet);
    t_net(t) = toc*1000;
    
    % fprintf(1, 'total time is (rne, mat, net): %.4f[ms], %.4f[ms], %.4f[ms] \r',...
    %  t_rne(t)*1000, t_mat(t)*1000, t_net(t)*1000);
    % norm(cell2mat(Sf_cho) - cell2mat(Sf_net))
  end
  mu_rne(nb) = mean(t_rne);    mu_red(nb) = mean(t_red);    mu_sol(nb) = mean(t_sol);
  var_net(nb) = var(t_net);    var_red(nb) = var(t_red);    var_sol(nb) = var(t_sol);
  mu_mat(nb) = mean(t_mat);    mu_cho(nb) = mean(t_cho);    mu_net(nb) = mean(t_net);    
  var_rne(nb) = var(t_rne);    var_mat(nb) = var(t_mat);    var_cho(nb) = var(t_cho);    
  
  fprintf(1, ...
    '[%d] total time is (mat, cho, net): %.4f[ms]+-%.4f, %.4f[ms]+-%.4f, %.4f+-%.4f[ms] \r',...
    nb, ...
    mu_mat(nb), 2*sqrt(var_mat(nb)), ...
    mu_cho(nb), 2*sqrt(var_cho(nb)), ...
    mu_net(nb), 2*sqrt(var_net(nb)));
  fprintf(1, ...
    '[%d] total time is (rne, red, sol): %.4f[ms]+-%.4f, %.4f[ms]+-%.4f, %.4f+-%.4f[ms] \r',...
    nb, ...
    mu_rne(nb), 2*sqrt(var_rne(nb)), ...
    mu_red(nb), 2*sqrt(var_red(nb)), ...
    mu_sol(nb), 2*sqrt(var_sol(nb)));  
  save res.mat t_pth t_chl ...
    mu_rne  mu_mat  mu_cho mu_net ...
    var_rne var_mat var_cho var_net
end

indeces = find(mu_cho~=0);

hh = figure;
hm = shadedErrorBar(indeces,mu_mat(indeces)/1000,sqrt(var_mat(indeces))/1000, {'r-o','markerfacecolor','r'});
hold on
hc = shadedErrorBar(indeces,mu_cho(indeces)/1000,sqrt(var_cho(indeces))/1000, {'b-o','markerfacecolor','b'});
hn = shadedErrorBar(indeces,mu_net(indeces)/1000,sqrt(var_net(indeces))/1000, {'g-o','markerfacecolor','g'});
% h = legend([hm.mainLine hc.mainLine], 'Direct inversion', 'Sparse Cholesky','Location', 'Northwest');
h = legend([hm.mainLine hc.mainLine hn.mainLine], 'Direct inversion', 'Sparse Cholesky', 'Junction tree', 'Location', 'Northwest');
set(h, 'FontSize', 20)
grid
set(gca,'FontSize',20)
xlabel('N_B', 'FontSize', 20)
ylabel('Computational time [s]', 'FontSize', 20)
print(hh, '-dpdf', 'calcTime1to20.pdf')

indeces = find(mu_rne~=0);

hh = figure;
hf = shadedErrorBar(indeces,mu_rne(indeces)/1000,sqrt(var_rne(indeces))/1000, {'b-o','markerfacecolor','b'});
hold on
hr = shadedErrorBar(indeces,mu_red(indeces)/1000,sqrt(var_red(indeces))/1000, {'r-o','markerfacecolor','r'});
hs = shadedErrorBar(indeces,mu_sol(indeces)/1000,sqrt(var_sol(indeces))/1000, {'g-o','markerfacecolor','g'});
% h = legend([hm.mainLine hc.mainLine], 'Direct inversion', 'Sparse Cholesky','Location', 'Northwest');
h = legend([hf.mainLine hr.mainLine hs.mainLine], 'Recursive Newton-Euler', 'Redundant Newton-Euler', 'Sparse redundant Newton-Euler', 'Location', 'Northwest');
set(h, 'FontSize', 20)
grid
set(gca,'FontSize',20)
xlabel('N_B', 'FontSize', 20)
ylabel('Computational time [s]', 'FontSize', 20)
print(hh, '-dpdf', 'solTime1to20.pdf')

