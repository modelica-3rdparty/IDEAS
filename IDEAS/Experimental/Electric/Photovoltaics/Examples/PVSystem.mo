within IDEAS.Experimental.Electric.Photovoltaics.Examples;
model PVSystem
  "Only a PV system, see python script for generating profiles from this model"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Angle inc=40/180*Modelica.Constants.pi
    annotation (evaluate=False);
  parameter Modelica.Units.SI.Angle azi=45/180*Modelica.Constants.pi
    annotation (evaluate=False);

  IDEAS.Experimental.Electric.Photovoltaics.PVSystemGeneral pVSystemGeneral(
    amount=20,
    inc=inc,
    azi=azi) annotation (Placement(transformation(extent={{-38,4},{-18,24}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Basic.Ground ground
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Sources.VoltageSource
    voltageSource(f=50, V=230) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,0})));
  inner IDEAS.BoundaryConditions.SimInfoManager sim
    annotation (Placement(transformation(extent={{-98,78},{-78,98}})));
equation
  connect(pVSystemGeneral.pin[1], voltageSource.pin_p) annotation (Line(
      points={{-17.8,18},{40,18},{40,10}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(voltageSource.pin_n, ground.pin) annotation (Line(
      points={{40,-10},{40,-30}},
      color={85,170,255},
      smooth=Smooth.None));
  annotation (Diagram(graphics),
    Documentation(revisions="<html>
<ul>
<li>
February 4, 2025, by Jelger Jansen:<br/>
Added <code>Modelica.Units.</code> to one or multiple parameter(s) due to the removal of <code>import</code> in IDEAS/package.mo.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/1415\">#1415</a> .
</li>
</ul>
</html>"));
end PVSystem;
