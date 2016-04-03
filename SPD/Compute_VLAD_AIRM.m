% Author:
% - Masoud Faraki (masoud.faraki@nicta.com.au)
%
% This file is provided without any warranty of
% fitness for any purpose. You can redistribute
% this file and/or modify it under the terms of
% the GNU General Public License (GPL) as published
% by the Free Software Foundation, either version 3
% of the License or (at your option) any later version.

% Please cite the following paper if your are using this code:
% "More About VLAD: A Leap from Euclidean to Riemannian Manifolds", 
% Masoud Faraki, Mehrtash Harandi, and Fatih Porikli, 
% In Proc. IEEE Conference on Computer Vision and Pattern Recognition
% (CVPR), Boston, USA, 2015.

%  BibTex
% @inproceedings{faraki2015more,
%   title={More About VLAD: A Leap from Euclidean to Riemannian Manifolds},
%   author={Faraki, Masoud and Harandi, Mehrtash T and Porikli, Fatih},
%   booktitle={In Proc. IEEE Conference on Computer Vision and Pattern Recognition (CVPR)},
%   pages={4951--4960},
%   year={2015},
%   organization={IEEE}
% }

function [RPower] = Compute_VLAD_AIRM(inCov, clusterCenters)
%inCov is a set of covariance matrices like (:,:,1),...,(:,:,N)
%clusterCenters are points like (:,:,1),(:,:,2),....,(:,:,K)
K = size(clusterCenters,3);
T = size(inCov,3);
d = size(clusterCenters,1);
V = zeros(d*(d+1)/2,K);
alfa = 0.5;
manifold = sympositivedefinitefactory(d);
D = AIRM(inCov,clusterCenters, manifold);

for t=1:T
    [~,b] = min(D(t,:));
    X = clusterCenters(:,:,b);
    Y = inCov(:,:,t)  ;    
 
    tmpV4 = X^-0.5 * RM_log(X,Y) * X^-0.5;    
    
    V(:,b) = V(:,b) + map2IDS_vectorize(tmpV4,0) ; 
end


R = V(:);
R = sign(R) .* abs(R).^ alfa;
R = R ./norm(R,2);
RPower = R;

