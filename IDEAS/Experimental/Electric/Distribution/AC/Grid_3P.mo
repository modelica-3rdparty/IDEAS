within IDEAS.Experimental.Electric.Distribution.AC;
model Grid_3P "General model for three-phase grid"

protected
  IDEAS.Experimental.Electric.Distribution.AC.Components.Grid_3P gridOnly3P(grid=grid)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  parameter Real gridFreq=50
    "Grid frequency: should normally not be changed when simulating belgian grids!";

public
  replaceable parameter IDEAS.Experimental.Electric.Data.Interfaces.GridType grid(Pha=3)
    "Choose a grid Layout" annotation (choicesAllMatching=true);

  parameter Modelica.Units.SI.ComplexVoltage VSource=230 + 0*Modelica.ComplexMath.j
    "Voltage" annotation (choices(
      choice=(230*1) + 0* Modelica.ComplexMath.j "100% at HVpin of transformer",
      choice=(230*1.02) + 0* Modelica.ComplexMath.j "102% at HVpin of transformer",
      choice=(230*1.05) + 0* Modelica.ComplexMath.j "105% at HVpin of transformer",
      choice=(230*1.1) + 0* Modelica.ComplexMath.j "110% at HVpin of transformer",
      choice=(230*0.95) + 0* Modelica.ComplexMath.j "95% at HVpin of transformer",
      choice=(230*0.9) + 0* Modelica.ComplexMath.j "90% at HVpin of transformer"));

  /***Everything related to the transfomer***/
    Components.MvLvTransformer_3P transformer_MvLv(transformer=transformer, traTCal=
        traTCal)
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
     replaceable parameter
    IDEAS.Experimental.Electric.Data.Interfaces.TransformerImp transformer
    "Choose a transformer" annotation (choicesAllMatching=true);
  parameter Boolean traTCal = true "Calculate transformer hot spot?" annotation (choices(
        choice=false "No hot spot calculations",
        choice=true "Hot spot calculations",
        __Dymola_radioButtons=true));

  /***Output total power***/
  output Modelica.Units.SI.ActivePower PGriTot=gridOnly3P.PGriTot;
  output Modelica.Units.SI.ComplexPower SGriTot=gridOnly3P.SGriTot;
  output Modelica.Units.SI.ReactivePower QGriTot=gridOnly3P.QGriTot;
  output Modelica.Units.SI.ActivePower PGriTotPha[3]=gridOnly3P.PGriTotPha;
  output Modelica.Units.SI.ComplexPower SGriTotPha[3]=gridOnly3P.SGriTotPha;
  output Modelica.Units.SI.ReactivePower QGriTotPha[3]=gridOnly3P.QGriTotPha;

  output Modelica.Units.SI.Voltage Vabs[3,Nodes]=gridOnly3P.Vabs;

  /***Output the Losses***/
  output Modelica.Units.SI.ActivePower PLosBra[3,Nodes]=gridOnly3P.PLosBra;
  output Modelica.Units.SI.ActivePower PLosNeu[Nodes]=gridOnly3P.PLosNeu;
  output Modelica.Units.SI.ActivePower PGriLosPha[3]=gridOnly3P.PGriLosPha;
  output Modelica.Units.SI.ActivePower PGriLosNeu=gridOnly3P.PGriLosNeu;
  output Modelica.Units.SI.ActivePower PGriLosPhaTot=gridOnly3P.PGriLosPhaTot;
  output Modelica.Units.SI.ActivePower PGriLosTot=gridOnly3P.PGriLosTot;

  /***And the Transformer losses if present***/
  output Modelica.Units.SI.ActivePower traLosP0=transformer_MvLv.traLosP0;
  output Modelica.Units.SI.ActivePower traLosPtot=transformer_MvLv.traLosPTot;

  output Modelica.Units.SI.ComplexCurrent[3] Ibranch0={gridOnly3P.branch[p, 1].i
      for p in 1:3};
  output Modelica.Units.SI.Current Ibranch0Abs[3]={Modelica.ComplexMath.abs(
      Ibranch0[i]) for i in 1:3};
  output Modelica.Units.SI.ComplexCurrent Ineutral0=gridOnly3P.neutral[1].i;
  output Modelica.Units.SI.Current Ineutral0Abs=Modelica.ComplexMath.abs(
      Ineutral0);

protected
  parameter Integer Nodes=grid.nNodes;

  IDEAS.Experimental.Electric.BaseClasses.AC.Con3PlusNTo3 con3PlusNTo3_1[
    gridOnly3P.grid.nNodes]
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
public
  Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.PositivePin[3,
    gridOnly3P.grid.nNodes] gridNodes3P
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

equation
  for n in 1:gridOnly3P.grid.nNodes loop
    connect(gridOnly3P.node[:,n], con3PlusNTo3_1[n].fourWire)
                                                             annotation (Line(
      points={{40,0},{60,0}},
      color={85,170,255},
      smooth=Smooth.None));
    connect(con3PlusNTo3_1[n].threeWire, gridNodes3P[:, n]) annotation (Line(
        points={{80,0},{100,0}},
        color={85,170,255},
        smooth=Smooth.None));
  end for;

  connect(transformer_MvLv.pin_lv_p, gridOnly3P.TraPin) annotation (Line(
      points={{0,6},{20,6}},
      color={85,170,255},
      smooth=Smooth.None));
  connect(transformer_MvLv.pin_lv_n, gridOnly3P.TraGnd) annotation (Line(
      points={{0,-6},{20,-6}},
      color={85,170,255},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                      graphics), Icon(graphics={
        Line(
          points={{0,36},{24,12},{100,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{32,36},{56,10},{102,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-22,36},{30,2},{100,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-32,40},{-32,34},{-4,34},{-4,-80},{4,-80},{4,34},{34,34},{34,
              40},{4,40},{4,46},{-4,46},{-4,40},{-32,40}},
          lineColor={127,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={127,0,0}),
        Line(
          points={{-100,60},{-12,12},{30,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,58},{-46,12},{-28,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-100,60},{-42,12},{0,36}},
          color={0,0,0},
          smooth=Smooth.Bezier)}),
Documentation(revisions="<html>
<ul>
<li>
February 7, 2025, by Jelger Jansen:<br/>
Added <code>Modelica.ComplexMath.</code> to one or multiple parameter(s) due to the removal of <code>import</code> in IDEAS/Experimental/Electric/package.mo.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/1415\">#1415</a> .
</li>
</ul>
</html>"));
end Grid_3P;
