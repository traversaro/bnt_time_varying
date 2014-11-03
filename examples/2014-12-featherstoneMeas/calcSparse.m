function sparseModel = calcSparse(model)

NB  = model.NB;

for i = 1:model.NB
  [ XJ, S{i} ] = jcalc( model.jtype{i}, 0);
  [~, jn{i}] = size(S{i});
end

sparseModel.nb = 0;
sparseModel.nD = zeros(NB, 1);
for i = 1 : NB
  % b1  = Xup{i}*(-a_grav); 
  % OR
  % b1 = crm(v{i})*vJ;
  sparseModel.nb = sparseModel.nb + 6;
  % b2 = crf(v{i})*model.I{i}*v{i};
  sparseModel.nb = sparseModel.nb + 6;
  
  % Dii = [-eye(6) zeros(6,6) zeros(6,6) zeros(6, jn{i}) zeros(6,6) S{i}];
  sparseModel.nD(i) = sparseModel.nD(i) + 6 + jn{i}*6;
  % Dii = [model.I{i} -eye(6) zeros(6,6) zeros(6, jn{i}) zeros(6,6) zeros(6, jn{i})];
  sparseModel.nD(i) = sparseModel.nD(i) + 36 + 6;
  % Dii = [zeros(6,6) eye(6) -eye(6) zeros(6, jn{i}) -inv(Xa{i}') zeros(6, jn{i})];
  sparseModel.nD(i) = sparseModel.nD(i) + 6 + 6 + 36; 
  % Dii = [zeros(jn{i}, 6) zeros(jn{i}, 6) S{i}' -eye(jn{i}) zeros(jn{i}, 6) zeros(jn{i}, jn{i})];
  sparseModel.nD(i) = sparseModel.nD(i) + 6*jn{i} + jn{i};   
  % Dij = [ Xup{i} zeros(6,6) zeros(6,6) zeros(6, jn{i}) zeros(6,6) zeros(6, jn{i}) zeros(12+jn{i}, 24+2*jn{i})];
  if model.parent(i) ~= 0
    sparseModel.nD(i) = sparseModel.nD(i) + 36;
  end
  
  ind_j  = find(model.parent == i);
  for j = ind_j
    % Dc{i,j} = [ zeros(12, 24+2*jn{i})
    %     zeros(6,6) zeros(6,6) Xup{j}' zeros(6, jn{i}) zeros(6,6) zeros(6, jn{i})
    %     zeros(jn{i}, 24+2*jn{i})];
    sparseModel.nD(i) = sparseModel.nD(i) + 36;
  end
end

for i = 1 : NB
  for j = 1 : NB
    isparseModel.nD = [(j-1)*19 (i-1)*19];

    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD11(1:36,i,j) = aa(:);   sparseModel.jD11(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+(7:12));
    aa = aa';   bb = bb';   sparseModel.iD12(1:36,i,j) = aa(:);   sparseModel.jD12(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+(13:18));
    aa = aa';   bb = bb';   sparseModel.iD13(1:36,i,j) = aa(:);   sparseModel.jD13(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+19);
    aa = aa';   bb = bb';   sparseModel.iD14(1: 6,i,j) = aa(:);   sparseModel.jD14(1: 6,i,j) = bb(:);
    
    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD21(1:36,i,j) = aa(:);   sparseModel.jD21(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+(7:12));
    aa = aa';   bb = bb';   sparseModel.iD22(1:36,i,j) = aa(:);   sparseModel.jD22(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+(13:18));
    aa = aa';   bb = bb';   sparseModel.iD23(1:36,i,j) = aa(:);   sparseModel.jD23(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+19);
    aa = aa';   bb = bb';   sparseModel.iD24(1: 6,i,j) = aa(:);   sparseModel.jD24(1: 6,i,j) = bb(:);
    
    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD31(1:36,i,j) = aa(:);   sparseModel.jD31(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+(7:12));
    aa = aa';   bb = bb';   sparseModel.iD32(1:36,i,j) = aa(:);   sparseModel.jD32(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+(13:18));
    aa = aa';   bb = bb';   sparseModel.iD33(1:36,i,j) = aa(:);   sparseModel.jD33(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+19);
    aa = aa';   bb = bb';   sparseModel.iD34(1: 6,i,j) = aa(:);   sparseModel.jD34(1: 6,i,j) = bb(:);
    
    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD41(1: 6,i,j) = aa(:);   sparseModel.jD41(1: 6,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+(7:12));
    aa = aa';   bb = bb';   sparseModel.iD42(1: 6,i,j) = aa(:);   sparseModel.jD42(1: 6,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+(13:18));
    aa = aa';   bb = bb';   sparseModel.iD43(1: 6,i,j) = aa(:);   sparseModel.jD43(1: 6,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+19);
    aa = aa';   bb = bb';   sparseModel.iD44(1: 1,i,j) = aa;      sparseModel.jD44(1: 1,i,j) = bb(:);

    isparseModel.nD = [(j-1)*19 19*NB+(i-1)*7];
    
    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD15(1:36,i,j) = aa(:);   sparseModel.jD15(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(1:6),isparseModel.nD(2)+7);
    aa = aa';   bb = bb';   sparseModel.iD16(1: 6,i,j) = aa(:);   sparseModel.jD16(1: 6,i,j) = bb(:);

    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD25(1:36,i,j) = aa(:);   sparseModel.jD25(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(7:12),isparseModel.nD(2)+7);
    aa = aa';   bb = bb';   sparseModel.iD26(1: 6,i,j) = aa(:);   sparseModel.jD26(1: 6,i,j) = bb(:);

    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD35(1:36,i,j) = aa(:);   sparseModel.jD35(1:36,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+(13:18),isparseModel.nD(2)+7);
    aa = aa';   bb = bb';   sparseModel.iD36(1: 6,i,j) = aa(:);   sparseModel.jD36(1: 6,i,j) = bb(:);

    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+(1:6));
    aa = aa';   bb = bb';   sparseModel.iD45(1: 6,i,j) = aa(:);   sparseModel.jD45(1: 6,i,j) = bb(:);
    [aa, bb] = meshgrid(isparseModel.nD(1)+19,isparseModel.nD(2)+7);
    aa = aa';   bb = bb';   sparseModel.iD46(1: 1,i,j) = aa(:);   sparseModel.jD46(1: 1,i,j) = bb(:);    
  end
end

for i = 1 : NB
  sparseModel.ind_j{i}  = find(model.parent == i);
end
