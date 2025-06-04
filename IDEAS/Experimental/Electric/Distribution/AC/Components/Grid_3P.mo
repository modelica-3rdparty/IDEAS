within IDEAS.Experimental.Electric.Distribution.AC.Components;
model Grid_3P "Three-fase grid cable-structure"
  replaceable parameter IDEAS.Experimental.Electric.Data.Interfaces.GridType grid
    "Choose a grid Layout (with 3 phaze values)"
    annotation (choicesAllMatching=true);

  Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.PositivePin[4,Nodes]
    node annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.PositivePin TraPin[3](
      i(im(each start=0)))
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Electrical.QuasiStatic.SinglePhase.Interfaces.NegativePin TraGnd
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  IDEAS.Experimental.Electric.Distribution.AC.BaseClasses.Branch branch[3,Nodes](
      R=R3, X=X3) annotation (Placement(transformation(extent={{0,-4},{20,16}})));
  IDEAS.Experimental.Electric.Distribution.AC.BaseClasses.Branch neutral[Nodes](R=
        Modelica.ComplexMath.real(Z), X=Modelica.ComplexMath.imag(Z)) annotation (Placement(transformation(extent={{0,-50},
            {20,-30}})));
  Modelica.Units.SI.ActivePower PGriTot;
  Modelica.Units.SI.ComplexPower SGriTot;
  Modelica.Units.SI.ReactivePower QGriTot;
  Modelica.Units.SI.ActivePower PGriTotPha[3];
  Modelica.Units.SI.ComplexPower SGriTotPha[3];
  Modelica.Units.SI.ReactivePower QGriTotPha[3];

  //parameter Boolean Loss = true
  //"if true, PLosBra and PGriLosTot gives branch and Grid losses";
  output Modelica.Units.SI.ActivePower PLosBra[3,Nodes];
  output Modelica.Units.SI.ActivePower PLosNeu[Nodes];
  output Modelica.Units.SI.ActivePower PGriLosPha[3];
  output Modelica.Units.SI.ActivePower PGriLosNeu;
  output Modelica.Units.SI.ActivePower PGriLosPhaTot;
  output Modelica.Units.SI.ActivePower PGriLosTot;

protected
  parameter Integer Nodes=grid.nNodes;
  parameter Integer nodeMatrix[Nodes, Nodes]=grid.nodeMatrix;
  parameter Modelica.Units.SI.ComplexImpedance[Nodes] Z=grid.Z;
  parameter Modelica.Units.SI.Resistance[3,Nodes] R3={Modelica.ComplexMath.real(
      Z) for i in 1:3};
  parameter Modelica.Units.SI.Reactance[3,Nodes] X3={Modelica.ComplexMath.imag(
      Z) for i in 1:3};
  //  parameter Modelica.Units.SI.ComplexVoltage[3] Vsource3={Vsource*(cos(c.pi*2*i/3)+Modelica.ComplexMath.j*sin(c.pi*2*i/6)) for i in 1:3};

  //Absolute voltages at the nodes
  output Modelica.Units.SI.Voltage Vabs[3,Nodes];
equation
  /***Connecting all neutral connectors (=4th row of nodes)***/
  connect(TraGnd, neutral[1].pin_p) annotation (Line(points={{-100,-60},{-56,
          -60},{-56,-32},{-10,-32},{-10,-40},{0,-40}},
                                 color={85,170,255}));
  for x in 1:Nodes loop
    for y in 1:Nodes loop
      if nodeMatrix[x, y] == 1 then
        connect(neutral[x].pin_p, node[4, y]) annotation (Line(points={{0,-40},
                {-10,-40},{-10,-32},{54,-32},{54,7.5},{100,7.5}},
                                 color={85,170,255}));
      elseif nodeMatrix[x, y] == -1 then
        connect(neutral[x].pin_n, node[4, y]) annotation (Line(points={{20,-40},
                {28,-40},{28,-32},{54,-32},{54,7.5},{100,7.5}},
                                 color={85,170,255}));
      end if;
    end for;
  end for;
  /***Connecting all phases***/
  for z in 1:3 loop
    connect(TraPin, branch[:, 1].pin_p) annotation (Line(points={{-100,60},{-60,
            60},{-60,0},{-8,0},{-8,6},{0,6}},
                                 color={85,170,255}));
    for x in 1:Nodes loop
      for y in 1:Nodes loop
        if nodeMatrix[x, y] == 1 then
          connect(branch[z, x].pin_p, node[z, y]) annotation (Line(points={{0,6},{0,
                  6},{-8,6},{-8,0},{100,0}},
                                 color={85,170,255}));
        elseif nodeMatrix[x, y] == -1 then
          connect(branch[z, x].pin_n, node[z, y]) annotation (Line(points={{20,6},{
                  20,6},{28,6},{28,0},{100,0}},
                                 color={85,170,255}));
        end if;
      end for;
    end for;
  end for;

  /*** Calculating the absolute node voltages ***/
  for z in 1:3 loop
    for x in 1:Nodes loop
      Vabs[z, x] =Modelica.ComplexMath.abs(node[z, x].v - node[4, x].v);
    end for;
  end for;

  /***Calculating all power phase powers***/
  for z in 1:3 loop
    SGriTotPha[z] = (branch[z, 1].pin_p.v - neutral[1].pin_p.v)*
      Modelica.ComplexMath.conj(branch[z, 1].pin_p.i);
    PGriTotPha[z] = Modelica.ComplexMath.real(SGriTotPha[z]);
    QGriTotPha[z] = Modelica.ComplexMath.imag(SGriTotPha[z]);
  end for;
  /***Calculating total power exchange at the transformer***/
  PGriTot = ones(3)*PGriTotPha;
  QGriTot = ones(3)*QGriTotPha;
  SGriTot = PGriTot + Modelica.ComplexMath.j*QGriTot;

  //if Loss then
  for z in 1:3 loop
    for x in 1:Nodes loop
      PLosBra[z, x] =branch[z, x].R*(Modelica.ComplexMath.abs(branch[z, x].i))^
        2;
    end for;
    PGriLosPha[z] = ones(Nodes)*PLosBra[z, :];
  end for;
  for x in 1:Nodes loop
    PLosNeu[x] =neutral[x].R*(Modelica.ComplexMath.abs(neutral[x].i))^2;
  end for;
  PGriLosNeu = ones(Nodes)*PLosNeu;
  PGriLosPhaTot = ones(3)*PGriLosPha;
  PGriLosTot = PGriLosPhaTot + PGriLosNeu;
  //end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),  Icon(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,100}}),
                                      graphics={
        Line(
          points={{0,36},{24,12},{100,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{0,44},{24,16},{100,0}},
          color={85,170,255},
          smooth=Smooth.Bezier,
          pattern=LinePattern.Dash),
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
          lineColor={95,95,95},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={95,95,95}),
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
          smooth=Smooth.Bezier),
        Line(
          points={{-100,-60},{-42,20},{0,44}},
          color={85,170,255},
          smooth=Smooth.Bezier,
          pattern=LinePattern.Dash)}),
Documentation(revisions="<html>
<ul>
<li>
February 7, 2025, by Jelger Jansen:<br/>
Added <code>Modelica.Units.</code> to one or multiple parameter(s) due to the removal of <code>import</code> in IDEAS/package.mo.
Added <code>Modelica.ComplexMath.</code> to one or multiple parameter(s) due to the removal of <code>import</code> in IDEAS/Experimental/Electric/package.mo.
See <a href=\"https://github.com/open-ideas/IDEAS/issues/1415\">#1415</a> .
</li>
</ul>
</html>"));
end Grid_3P;
