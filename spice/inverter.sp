* ============================================================================
* CMOS Inverter SPICE Simulation Deck (90nm CMOS)
* Author: Nikunj Malik
* Compatible with: ngspice / HSPICE / Cadence Spectre
* ============================================================================

.title CMOS Inverter Transient and DC Transfer Analysis (90nm)

* ----------------------------------------------------------------------------
* BSIM4 Predictive Technology Model (PTM 90nm Generic Parameters)
* ----------------------------------------------------------------------------
.model nmos_90n nmos (
+ level = 54
+ version = 4.5
+ tox = 1.6e-9
+ vth0 = 0.25
+ u0 = 450
+ vsat = 1.2e5
+ lint = 1.0e-8
+ wint = 1.0e-8
+ pclm = 1.0
+ pdiblc1 = 0.02
+ pdiblc2 = 0.005
+ cj = 1.0e-3
+ cjsw = 2.0e-10
)

.model pmos_90n pmos (
+ level = 54
+ version = 4.5
+ tox = 1.6e-9
+ vth0 = -0.25
+ u0 = 180
+ vsat = 8.5e4
+ lint = 1.0e-8
+ wint = 1.0e-8
+ pclm = 1.2
+ pdiblc1 = 0.03
+ pdiblc2 = 0.006
+ cj = 1.1e-3
+ cjsw = 2.2e-10
)

* ----------------------------------------------------------------------------
* Inverter Subcircuit
* Sizing: PMOS W=240nm L=100nm, NMOS W=120nm L=100nm (Ratio Wp/Wn = 2.0)
* ----------------------------------------------------------------------------
.subckt inverter vin vout vdd vss
M_PM0 vout vin vdd vdd pmos_90n W=240n L=100n
M_NM0 vout vin vss vss nmos_90n W=120n L=100n
.ends inverter

* ----------------------------------------------------------------------------
* Testbench Circuit
* ----------------------------------------------------------------------------
X1 vin vout vdd 0 inverter

* Power Supply: VDD = 1.0V
Vdd vdd 0 DC 1.0

* Input Signal: Pulse for transient analysis (0V to 1V, period=10ns, width=5ns, tr=20ps, tf=20ps)
Vin vin 0 PULSE(0.0 1.0 0 20p 20p 5n 10n)

* ----------------------------------------------------------------------------
* Analysis Directives
* ----------------------------------------------------------------------------
* Transient Simulation (0 to 20ns, step=10ps)
.tran 10p 20n

* DC Transfer Characteristic (Sweep Vin from 0V to 1.0V)
.dc Vin 0 1.0 0.005

.control
run
* DC Plot
set color0=white
set color1=black
plot v(vout) v(vin) title "CMOS Inverter DC Transfer Characteristic (VTC)" xlabel "Vin (V)" ylabel "Vout (V)"
* Transient Plot
plot v(vin) v(vout) title "CMOS Inverter Transient Response" xlabel "Time (s)" ylabel "Voltage (V)"
.endc

.end
