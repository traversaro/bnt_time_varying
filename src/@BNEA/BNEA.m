% BNEA solves inverse dynamics with redundant measurements.
%
% The class is instantiated with two additional classes to describe the
% articulated rigid body model, e.g.:
%            myModel = model(autoTree(NB))
% and to describe the sensor distribution, e.g.:
%            mySens  = sensors(autoSensStochastic(autoSensSNEA(myModel)))
% with the following instanatiation:
%             myBNEA = SNEA(myModel, mySens).
% Computations are then performed with the method d = myBNEA.solveID()
% which relies on the Bayesian Network Toolbox (BNT) by Kevin Murphy.
%
% Author: Francesco Nori
% Genova, Dec 2014

classdef BNEA < stochasticIDsolver
   
   properties
      bnt, evd, covPriorWeight, inf_engine;
   end
   methods
      function b = BNEA(m,y)
         if nargin == 0
            error(['You should provide a ' ...
               'model to instantiate SNEA'] )
         else
            if ~checkModel(m.modelParams)
               error(['You should provide a featherstone-like ' ...
                  'model to instantiate SNEA'] )
            end
         end
         b     = b@stochasticIDsolver(m,y);
         b.Sd  = zeros(b.IDmodel.modelParams.NB*26, b.IDmodel.modelParams.NB*26);
         b.bnt = b.initNetFromModel(b.IDmodel.modelParams, b.IDsens.sensorsParams);
         b.evd = cell(1,6*b.IDmodel.modelParams.NB+b.IDsens.sensorsParams.ny);
         
         b.covPriorWeight = 1e-5;
         b.inf_engine     = 'not_defined';
      end % BNEA
      
      function b = setEngine(b, str)
         if strcmp(str, 'gaussian_inf_engine') || strcmp(str, 'jtree_inf_engine')
            b.inf_engine = str;
         else
            disp('Not a valid inf_engine')
         end
      end % disp
      
      function disp(b)
         % Display BNEA object
         disp@deterministicIDsolver(b)
         fprintf('BNEA disp to be implemented! \n')
      end % disp
      
      function b = setY(b,y)
         if strcmp(b.inf_engine, 'not_defined')
            error('You should defined a inf_engine with myBNEA.setEngine() before using the BNEA class')
         end
         b = setY@deterministicIDsolver(b,y);
         b = updateEvd(b);
      end
      
      function [y, yc] = simY(b)
         if strcmp(b.inf_engine, 'not_defined')
            error('You should defined a inf_engine with myBNEA.setEngine() before using the BNEA class')
         end
         ys = sample_bnet(b.bnt.bnet);
         yc = cell(size(ys));
         y  = zeros(b.IDsens.sensorsParams.ny,1);
         NB = b.IDmodel.modelParams.NB;
         
         j  = 1;
         for i = 1 : b.IDsens.sensorsParams.ny
            y(j:j+b.bnt.nodes.sizes{NB+i}-1) = ys{b.bnt.nodes.index{NB+i}};
            yc{b.bnt.nodes.index{NB+i}} = ys{b.bnt.nodes.index{NB+i}};
            j = j+b.bnt.nodes.sizes{NB+i};
         end
      end
      
      function b = setState(b,q,dq)
         if strcmp(b.inf_engine, 'not_defined')
            error('You should defined a inf_engine with myBNEA.setEngine() before using the BNEA class')
         end
         b = setState@deterministicIDsolver(b,q,dq);
         b = updateNet(b);
      end
      
   end % methods
   
   methods(Static = true)
      bnt = initNetFromModel( dmodel , ymodel )
   end
   
   methods
      obj = updateNet( obj )
      obj = updateEvd( obj )
   end
end % classdef

