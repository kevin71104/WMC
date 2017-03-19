
% SINR in dB
function SINR = mySINR_dB(S, I, N)
SINR = 10*log10(S/(I+N));
end