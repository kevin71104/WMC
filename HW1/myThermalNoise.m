
% My Thermal Noise: N = kTB
function N_T = myThermalNoise(Temperature,Bandwidth)
k = physconst('Boltzmann');
N_T = k*Temperature*Bandwidth;
end