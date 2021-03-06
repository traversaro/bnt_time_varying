function [ IDnet, y ] = buildBnet( model , y )

NB        = model.NB;
sUkn      = 1e12;
[ny, ~]   = size(y.values);
N         = NB*6+ny;

for i = 1 : NB
  nodes.index{i}    = (i-1)*6 + 1 : i*6;
  nodes.sizes{i,1}  = [6 6 6 1 6 1]';
  nodes.labels{i,1} = ['a' num2str(i)];
  nodes.labels{i,2} = ['fB' num2str(i)];
  nodes.labels{i,3} = ['f' num2str(i)];
  nodes.labels{i,4} = ['tau' num2str(i)];
  nodes.labels{i,5} = ['fx' num2str(i)];
  nodes.labels{i,6} = ['d2q' num2str(i)];
end

for i = 1 : ny
  nodes.index{i+NB*6}    = i+NB*6;
  nodes.sizes{i+NB*6,1}  = y.sizes{i,1};
  nodes.labels{i+NB*6,1} = y.labels{i,1};
end

dag = zeros(N, N);
for i = 1 : NB
  % a{i} = ... + S{i}*qdd(i);
  dag(nodes.index{i}(6), nodes.index{i}(1)) = 1;
  % fB{i} = model.I{i}*a{i} + ... ;
  dag(nodes.index{i}(1), nodes.index{i}(2)) = 1;
  % f{i} = fB{i} - Xa{i}' \ f_ext{i};
  dag(nodes.index{i}(2), nodes.index{i}(3)) = 1;
  dag(nodes.index{i}(5), nodes.index{i}(3)) = 1;
  % tau(i,1) = S{i}' * f{i};
  dag(nodes.index{i}(3), nodes.index{i}(4)) = 1;
  
  
  if model.parent(i) ~= 0
    % a{i} = Xup{i}*a{model.parent(i)} + ...
    dag(nodes.index{model.parent(i)}(1), nodes.index{i}(1)) = 1;
  end
  
  ind_j = find(model.parent == i);
  for j = ind_j
    % f{model.parent(j)} = f{model.parent(j)} + Xup{j}'*f{j};
    dag(nodes.index{j}(3), nodes.index{i}(3)) = 1;
  end
  for j = 1 : ny
    if strcmp(y.labels{j,1}, ['a' num2str(i)])
      dag(nodes.index{i}(1), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(1);
      y.W{j,1}     = eye(6);
    end
    if strcmp(y.labels{j,1}, ['fB' num2str(i)])
      dag(nodes.index{i}(2), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(2);
      y.W{j,1}     = eye(6);
    end
    if strcmp(y.labels{j,1}, ['f' num2str(i)])
      dag(nodes.index{i}(3), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(3);
      y.W{j,1}     = eye(6);
    end
    if strcmp(y.labels{j,1}, ['tau' num2str(i)])
      dag(nodes.index{i}(4), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(4);
      y.W{j,1}     = eye(1);
    end
    if strcmp(y.labels{j,1}, ['fx' num2str(i)])
      dag(nodes.index{i}(5), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(5);
      y.W{j,1}     = eye(6);
    end
    if strcmp(y.labels{j,1}, ['d2q' num2str(i)])
      dag(nodes.index{i}(6), nodes.index{j+NB*6}) = 1;
      y.child{j,1} = nodes.index{i}(6);
      y.W{j,1}     = eye(1);
    end
  end
end

dnodes = [];  % no discrete nodes
ns     = cell2mat(nodes.sizes);
bnet   = mk_bnet(dag, ns, 'discrete', dnodes);

link = zeros(N,1);
for i = 1 : NB
  for h = 1 : 6
    nodes.index{i}(h) = find(bnet.order == nodes.index{i}(h));
    link(nodes.index{i}(h), 1) = i;
  end
end

for i = 1 : ny
  nodes.index{NB*6 + i} = find(bnet.order == nodes.index{NB*6 + i});
end

identity = eye(N);
new_dag = dag*identity(:,bnet.order);
new_dag = identity(bnet.order, :)*new_dag;
new_ns = ns(bnet.order);
bnet = mk_bnet(new_dag, new_ns, 'discrete', dnodes);

for i = 1 : ny
  vi   = nodes.index{i+NB*6};
  nvi  = nodes.sizes{i+NB*6,1};
  bnet.CPD{vi} = gaussian_CPD(bnet, vi, 'mean', zeros(nvi,1), 'cov', sUkn.*eye(nvi));
end

IDnet.bnet   = bnet;
IDnet.nodes  = nodes;
IDnet.link   = link;
IDnet.engine = [];
end

