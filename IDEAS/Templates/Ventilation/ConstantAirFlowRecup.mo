within IDEAS.Templates.Ventilation;
model ConstantAirFlowRecup
  "Idealised ventilation System with constant airflow rate and heat recovery unit with constant efficiency"

  extends IDEAS.Templates.Interfaces.BaseClasses.VentilationSystem(
    P = sum(n .* VZones/3600)*sysPres/fanEff/motEff / nLoads_min .*ones(nLoads_min),
    nLoads=1);

  parameter Real[nZones] n
    "Air change rate (Air changes per hour ACH)";
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(n .* VZones)/3600*
      1.204 "total ventilation mass flow rate";
  parameter Modelica.Units.SI.Time tau=30
    "time constant of the ventilation system";

  parameter Modelica.Units.SI.Efficiency recupEff(
    min=0,
    max=1) = 0.84 "Efficiency of heat recuperation";

  parameter Modelica.Units.SI.Pressure sysPres=150
    "Total static and dynamic pressure drop, Pa";
  parameter Modelica.Units.SI.Efficiency fanEff(
    min=0,
    max=1) = 0.85 "Fan efficiency";
  parameter Modelica.Units.SI.Efficiency motEff(
    min=0,
    max=1) = 0.80 "Motor efficiency";

  parameter Modelica.Units.SI.Pressure dp_nominal_sup=0
    "Nominal pressure drop in the heat exchanger at the supply side";
  parameter Modelica.Units.SI.Pressure dp_nominal_ret=0
    "Nominal pressure drop in the heat exchanger at the return side";
  IDEAS.Fluid.HeatExchangers.ConstantEffectiveness hex(
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp1_nominal=dp_nominal_ret,
    dp2_nominal=dp_nominal_sup,
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    eps=recupEff) "Heat exchanger for the recuperator"
    annotation (Placement(transformation(extent={{-140,4},{-120,24}})));
  IDEAS.Fluid.Sources.Boundary_pT sink(
    final nPorts=1,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-80,10},{-100,30}})));
  IDEAS.Fluid.Sources.Boundary_pT sou(
    final nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=true) "Ambient air"
    annotation (Placement(transformation(extent={{-80,-30},{-100,-10}})));
  IDEAS.Fluid.Movers.FlowControlled_m_flow fan[nZones](
    each use_riseTime=false,
    m_flow_nominal=n .* VZones ./ 3600.*1.204,
    redeclare each package Medium = Medium,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    each inputType=IDEAS.Fluid.Types.InputType.Constant)
    "Fan with constant flow rate"
    annotation (Placement(transformation(extent={{-160,-10},{-180,-30}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te)
    annotation (Placement(transformation(extent={{-40,-26},{-60,-6}})));

equation

  for i in 1:nZones loop
    connect(fan[i].port_a, hex.port_b2) annotation (Line(
        points={{-160,-20},{-150,-20},{-150,8},{-140,8}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(port_a[i], hex.port_a1) annotation (Line(
        points={{-200,20},{-140,20}},
        color={0,0,127},
        smooth=Smooth.None,
        pattern=LinePattern.Dash));
  end for;

  connect(hex.port_b1, sink.ports[1]) annotation (Line(
      points={{-120,20},{-100,20}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(fan.port_b, port_b) annotation (Line(
      points={{-180,-20},{-200,-20}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(sou.ports[1], hex.port_a2) annotation (Line(
      points={{-100,-20},{-110,-20},{-110,8},{-120,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(realExpression.y, sou.T_in) annotation (Line(
      points={{-61,-16},{-78,-16}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,
            -100},{200,100}}), graphics), Icon(coordinateSystem(extent={{-200,
            -100},{200,100}})),
    Documentation(revisions="<html>
<ul>
<li>
December 17, 2024, by Anna Dell'Isola:<br/>
Update calculation of ventilation mass flow rate and addition of nominal pressure drops in heat exchanger.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/1400\">#1400</a>
</li>
<li>
October 30, 2024, by Lucas Verleyen:<br/>
Updates according to <a href=\"https://github.com/ibpsa/modelica-ibpsa/tree/8ed71caee72b911a1d9b5a76e6cb7ed809875e1e\">IBPSA</a>.<br/>
See <a href=\"https://github.com/open-ideas/IDEAS/pull/1383\">#1383</a> 
(and <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1926\">IBPSA, #1926</a>).
</li>
<li>
June 5, 2018 by Filip Jorissen:<br/>
Cleaned up implementation for
<a href=\"https://github.com/open-ideas/IDEAS/issues/821\">#821</a>.
</li>
</ul>
</html>"));
end ConstantAirFlowRecup;
