
% input is number
function SINR = mySINR(S, I, N)
SINR = 10*log10(S./(I+N));
end