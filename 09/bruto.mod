# ---- NeuralCloud: modelo bruto (receita bruta) ----
set DC;    # datacenters (DC1, DC2, DC3)
set PLANO; # planos GPU  (Basic, Pro, Ultra)

param receita {PLANO} >= 0;   # receita bruta por slot/dia ($)
param gpu_pw  {PLANO} >= 0;   # consumo de energia (kW/slot)
param capac   {DC}    >= 0;   # capacidade de slots por DC
param pot     {DC}    >= 0;   # capacidade de potência por DC (kW)
param dem_max {PLANO} >= 0;   # demanda máxima por plano (total, todos DCs)

var x {DC, PLANO} >= 0;

maximize z: sum {i in DC, j in PLANO} receita[j] * x[i,j];

s.t. Capac    {i in DC}:    sum {j in PLANO} x[i,j]           <= capac[i];
s.t. Potencia {i in DC}:    sum {j in PLANO} gpu_pw[j]*x[i,j] <= pot[i];
s.t. Demanda  {j in PLANO}: sum {i in DC} x[i,j]              <= dem_max[j];
