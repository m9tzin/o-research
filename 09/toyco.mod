# ---- Toyco: análise de sensibilidade (Taha §3.6) ----
set OP;       # operações  (Op1, Op2, Op3)
set PROD;     # produtos   (Trem, Caminhao, Carro)

param margem {PROD} >= 0;      # receita por unidade ($)
param tempo  {OP, PROD} >= 0;  # min de operação i por unidade do produto j
param cap    {OP} >= 0;        # capacidade diária de cada operação (min/dia)

var x {PROD} >= 0;

maximize z: sum {j in PROD} margem[j] * x[j];

s.t. Capacidade {i in OP}:
    sum {j in PROD} tempo[i,j] * x[j] <= cap[i];
