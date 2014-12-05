within IDEAS.Fluid.Production.Examples;
model BoilerComparison
  import IDEAS;

  //Extensions
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1300/3600;

  package Medium = IDEAS.Media.Water.Simple;

  IDEAS.Fluid.Production.Boiler                    polynomialProduction(
    use_onOffSignal=true,
    avoidEvents=avoidEvents.k,
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare
      IDEAS.Fluid.Production.BaseClasses.HeatSources.PolynomialHeatSource
      heatSource,
    redeclare IDEAS.Fluid.Production.Data.Polynomials.Boiler4thDegree data)
    annotation (Placement(transformation(extent={{-44,56},{-24,78}})));

  IDEAS.Fluid.Production.Boiler                    performanceMapProduction(
      avoidEvents=avoidEvents.k, redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_onOffSignal=true)
    annotation (Placement(transformation(extent={{-44,-4},{-24,18}})));

  Modelica.Blocks.Sources.Constant TSet(k=273 + 80)
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  inner SimInfoManager sim
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Fluid.Movers.Pump pump(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{-24,28},{-4,48}})));
  Fluid.Movers.Pump pump1(redeclare package Medium = Medium, m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{-24,-26},{-4,-6}})));
  Fluid.FixedResistances.Pipe_Insulated pipe(
    UA=10,
    redeclare package Medium = Medium,
    m=1,
    dp_nominal=20,
    m_flow_nominal=m_flow_nominal)
                   annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=270,
        origin={58,52})));

  Fluid.FixedResistances.Pipe_Insulated pipe1(
    UA=10,
    redeclare package Medium = Medium,
    m=1,
    dp_nominal=20,
    m_flow_nominal=m_flow_nominal)
                   annotation (Placement(transformation(
        extent={{10,-4},{-10,4}},
        rotation=270,
        origin={58,-6})));

  Fluid.Sources.FixedBoundary bou(
    nPorts=2,
    redeclare package Medium = Medium,
    use_T=false) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={82,38})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{8,78},{28,98}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=sim.Te - 273.15)
    annotation (Placement(transformation(extent={{-22,78},{-2,98}})));
  Modelica.Thermal.HeatTransfer.Celsius.PrescribedTemperature
    prescribedTemperature2
    annotation (Placement(transformation(extent={{92,-16},{72,4}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=sim.Te - 273.15)
    annotation (Placement(transformation(extent={{124,-16},{104,4}})));
  Fluid.Sensors.TemperatureTwoPort senPoly(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{8,28},{28,48}})));
  Fluid.Sensors.TemperatureTwoPort senInterpolation(redeclare package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{10,-26},{30,-6}})));
  Modelica.Blocks.Sources.BooleanConstant avoidEvents(k=true)
    annotation (Placement(transformation(extent={{-96,50},{-76,70}})));
  Modelica.Blocks.Sources.BooleanPulse onOff(period=1000)
    annotation (Placement(transformation(extent={{-80,80},{-66,94}})));
equation
  connect(TSet.y, performanceMapProduction.TSet) annotation (Line(
      points={{-71,20},{-54,20},{-54,28},{-30,28},{-30,18.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSet.y, polynomialProduction.TSet) annotation (Line(
      points={{-71,20},{-54,20},{-54,86},{-30,86},{-30,78.44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(polynomialProduction.port_b, pump.port_a) annotation (Line(
      points={{-23.8,62.6},{-24,62.6},{-24,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(performanceMapProduction.port_b, pump1.port_a) annotation (Line(
      points={{-23.8,2.6},{-24,2.6},{-24,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(polynomialProduction.port_a, pipe.port_b) annotation (Line(
      points={{-23.8,71.4},{58,71.4},{58,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(performanceMapProduction.port_a, pipe1.port_b) annotation (Line(
      points={{-23.8,11.4},{58,11.4},{58,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[1], pipe.port_a) annotation (Line(
      points={{84,28},{84,22},{42,22},{42,38},{58,38},{58,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bou.ports[2], pipe1.port_b) annotation (Line(
      points={{80,28},{80,18},{50,18},{50,10},{58,10},{58,4}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(realExpression.y, prescribedTemperature.T) annotation (Line(
      points={{-1,88},{6,88}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature.port, pipe.heatPort) annotation (Line(
      points={{28,88},{38,88},{38,52},{54,52}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(prescribedTemperature2.T, realExpression2.y) annotation (Line(
      points={{94,-6},{103,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(prescribedTemperature2.port, pipe1.heatPort) annotation (Line(
      points={{72,-6},{66,-6},{66,-24},{44,-24},{44,-6},{54,-6}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pump.port_b, senPoly.port_a) annotation (Line(
      points={{-4,38},{8,38}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senPoly.port_b, pipe.port_a) annotation (Line(
      points={{28,38},{58,38},{58,42}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump1.port_b, senInterpolation.port_a) annotation (Line(
      points={{-4,-16},{10,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senInterpolation.port_b, pipe1.port_a) annotation (Line(
      points={{30,-16},{58,-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(onOff.y, polynomialProduction.on) annotation (Line(
      points={{-65.3,87},{-36,87},{-36,78.88}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onOff.y, performanceMapProduction.on) annotation (Line(
      points={{-65.3,87},{-60,87},{-60,36},{-36,36},{-36,18.88}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}),     graphics),
    experiment(StopTime=10000),
    __Dymola_experimentSetupOutput);
end BoilerComparison;