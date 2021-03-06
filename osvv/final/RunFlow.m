% MATLAB FUNCTION: RunFlow
%
% PURPOSE: computes SODA improvement on a bisection and returns an union of at most p matchings routed
%
% INPUTS: 
%    sparse matrix (double) G - instance graph
%    vector (int64) bisec - bisection on which to run SODA improvement
%    (double) minweirdrat_num - starting weirdrat numerator
%    (int64) minweirdrat_den - starting weirdrat denominator
%    (double) minweirdrat - starting weirdrat
%    (int64) p - precision, specifies degree of routed matching
%    

%
% OUTPUTS:
%    (double) weirdrat_num - final weirdrat numerator, i.e. best weirdrat encountered in this run
%    (int64) weirdrat_den - final weirdrat denominator
%    (double) weirdrat - final weirdrat  
%    (double) ex_num - final expansion numerator
%    (int64) ex_den - final expansion denominator
%    (double) ex - final expansion, i.e. best expansion seen in this run
%    vector (int64) bestcut - best cut found in this run
%    sparse matrix (double) matching - matching routed   
%     (double) matchrat - weirdratio certified by matching
%    (double) flownumber - number of maxflows run
%				
% VARIABLES: 
%     (int64) n - number of vertices in G
%     (int64) size_bisec - size of the bisection bisec
%     (int8) found_flag - flag to terminate current run of flows
%     (int64) flow - flow output by Pairing
%     vector (int64) cut - mincut found by Pairing
%     (double) newex_num -numerator of expansion of cut found by last call of Pairing
%     (int64) newex_den - denominator of expansion of cut found by last call of Pairing
%     (double) newex -  expansion of cut found by last call of Pairing
%     (int64) cap_add - a temporary variable
%
% ISSUES: can do mincut at precision p too?
%

function   [weirdrat_num, weirdrat_den, weirdrat, ex_num, ex_den, ex, bestcut, matching, matchrat, flownumber] = RunFlow(G, bisec, minweirdrat_num, minweirdrat_den, minweirdrat, p, nomatching_flag, matching_algorithm)

%%%%%%%%%%%%%%%%%%%%%%%%% INITIALIZATION  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INITIALIZATION OF OUTPUT VARIABLES
n = int64(size(G,1));
bestcut = int64([]);
matching = int64([]);
ex = Inf;
ex_num = Inf;
ex_den = int64(0);
weirdrat_num = minweirdrat_num;
weirdrat_den = int64(minweirdrat_den);
weirdrat = minweirdrat;

% PREPARE BISEC
bisec = int64(sort(bisec));
size_bisec = int64(size(bisec,1));


%%%%%%%%%%%%%%%%%%%%%%%%% SEARCH %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
found_flag = int8(1);
counter = 0;


while(found_flag) % WHILE BETTER WEIRDRAT CUT EXISTS
  

%%% [cap_add, cap_orig] = Farey(int64(cap_add), cap_orig, int64(100));
cap_add = int64(weirdrat_num);
cap_orig = weirdrat_den;


[flow, cut] = Pairing(G, bisec, cap_add, cap_orig); % DO FLOW, SHOULD OUTPUT SMALL SIZE OF CUT
   
  counter = counter + 1;

if(flow < double(size_bisec) * weirdrat_num) % IF BETTER CUT FOUND
  %CHANGES    
  found_flag = int8(1);
[weirdrat_num, weirdrat_den, weirdrat] =  cutweird(G, cut, bisec); % COMPUTE NEW WEIRDRAT
      
      % CHECK IF EXPANSION HAS IMPROVED - IF IT HAS RECORD NEW CUT
      [newex_num, newex_den, newex] = cutexp(G, cut);
      if(newex < ex)
        ex_num = newex_num;
        ex_den = int64(newex_den);
        ex = newex;  
        bestcut = cut;
      end
      % PLACE HERE CODE TO PRINT EXPANSION GRAPH

   else  % OTHERWISE STOP 
        found_flag = int8(0); 
   end
end
     
	fprintf(2, 'Number of maxflows: %d. ', counter + 1);
% ONCE STOPPED, CONSTRUCT ROUTED UNION OF MATCHINGS - DO THIS AT PRECISION P
if(nomatching_flag == 0)
   [match_num, match_den] = Farey(int64(weirdrat_num), weirdrat_den, p); % use Farey sequences to find best p-precision approximation to weirdrat
   double(weirdrat_num);

   [flow, cut, matching] = Pairing(G, bisec, match_num, match_den, matching_algorithm);

   % MATCHInG SCALING
   matching = matching/double(match_num);
   matchrat= double(match_num)/double(match_den);
else
   matching = sparse(1:double(n), 1:double(n), 0);
   matchrat = 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%% OUTPUT PREPARATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

flownumber = counter+1;

% ALL OUTPUTS ARE READY

end











