function [X]=even(N)
if mod(N,2)==0;
    X=N; 
else
    X=N-1;
end;
