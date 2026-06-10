# ---- NeuralCloud: modelo líquido (receita - custos reais) ----
set DC;
set PLANO;

param receita    {PLANO} >= 0;
param gpu_pw     {PLANO} >= 0;
param capac      {DC}    >= 0;
param pot        {DC}    >= 0;
param dem_max    {PLANO} >= 0;
param elec_custo {DC}    >= 0;  # custo de energia ($/kW/dia) - varia por DC
param opex               >= 0;  # OPEX fixo por slot/dia (água + depreciação)

var x {DC, PLANO} >= 0;

maximize z: sum {i in DC, j in PLANO}
    (receita[j] - gpu_pw[j] * elec_custo[i] - opex) * x[i,j];

s.t. Capac    {i in DC}:    sum {j in PLANO} x[i,j]           <= capac[i];
s.t. Potencia {i in DC}:    sum {j in PLANO} gpu_pw[j]*x[i,j] <= pot[i];
s.t. Demanda  {j in PLANO}: sum {i in DC} x[i,j]              <= dem_max[j];
