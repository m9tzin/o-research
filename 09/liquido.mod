set DC;
set PLANO;

param preco      {PLANO} >= 0;
param kw         {PLANO} >= 0;
param dem_max    {PLANO} >= 0;
param dep_gpu    {PLANO} >= 0;
param custo_op   {PLANO} >= 0;
param cap_inst   {DC}    >= 0;
param cap_kw     {DC}    >= 0;
param preco_kwh  {DC}    >= 0;
param wue        {DC}    >= 0;
param preco_agua {DC}    >= 0;
param H                  >= 0;
param tol_balanc         >= 0;
param frac_max           >= 0, <= 1;

var x {DC, PLANO} >= 0;
var y {i in DC} = sum {j in PLANO} x[i,j];
var carga {j in PLANO} = sum {i in DC} x[i,j];
var kwh {i in DC} = H * sum {j in PLANO} kw[j]*x[i,j];

maximize Margem_Liquida:
    sum {i in DC, j in PLANO} preco[j] * x[i,j]
  - sum {i in DC} preco_kwh[i] * kwh[i]
  - sum {i in DC} preco_agua[i] * wue[i] * kwh[i] / 1000
  - sum {i in DC, j in PLANO} dep_gpu[j] * x[i,j]
  - sum {i in DC, j in PLANO} custo_op[j] * x[i,j];

s.t. Capac    {i in DC}: y[i] <= cap_inst[i];
s.t. Potencia {i in DC}: sum {j in PLANO} kw[j]*x[i,j] <= cap_kw[i];
s.t. Demanda  {j in PLANO}: carga[j] <= dem_max[j];
s.t. BalSup: y["DC1"] - y["DC3"] <= tol_balanc;
s.t. BalInf: y["DC3"] - y["DC1"] <= tol_balanc;
s.t. TolFalhas {i in DC, j in PLANO}: x[i,j] <= frac_max * carga[j];
