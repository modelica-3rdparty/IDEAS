within IDEAS.ThermalZones.ISO13790.BaseClasses;
model GainSurface "Surface node heat flow"
  Modelica.Units.SI.Area AMas "Effective mass area (see Table 12 in standard)";
  parameter Modelica.Units.SI.Area ATot "Total area of building's surfaces facing the thermal zone";
  parameter Modelica.Units.SI.ThermalConductance HWinGai "Thermal conductance through windows";
  parameter Real facMas "Effective mass area factor";
  parameter Modelica.Units.SI.Area AFlo "Floor area";
  Modelica.Blocks.Interfaces.RealInput intSenGai(final unit="W") "Internal sensible heat gains"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput solGai(final unit="W") "Solar gains"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput surGai(final unit="W") "Heat gain to surface node"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  AMas  = facMas*AFlo;
  surGai= (1 - AMas/ATot - HWinGai/(9.1*ATot))*(0.5*intSenGai + solGai);

  annotation (defaultComponentName="phiSur",Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Ellipse(
          extent={{28,-46},{-26,-100}},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Text(
          extent={{-110,138},{112,106}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model calculates the heat gains injected to the surface node. More information
can be found in the documentation of <a href=\"modelica://IDEAS.ThermalZones.ISO13790.Zone5R1C.Zone\">
IDEAS.ThermalZones.ISO13790.Zone5R1C.Zone</a>
</p>
</html>", revisions="<html><ul>
<li>
Mar 16, 2022, by Alessandro Maccarini:<br/>
First implementation.
</li>
</ul></html>"));
end GainSurface;
