within IDEAS.Electrical.AC.OnePhase.Loads;
model Capacitive "Model of a capacitive and resistive load"
  extends IDEAS.Electrical.Interfaces.CapacitiveLoad(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare replaceable Interfaces.Terminal_n terminal,
    V_nominal(start = 110));

protected
  Modelica.Units.SI.Angle theRef "Absolute angle of rotating reference system";

initial equation
  if mode == IDEAS.Electrical.Types.Load.FixedZ_dynamic then
    // q = Y[2]*{V_nominal, 0}/omega;
    // Steady state initialization
    der(q) = zeros(PhaseSystem.n);
  end if;
equation
  theRef = PhaseSystem.thetaRef(terminal.theta);
  omega = der(theRef);

  if mode == IDEAS.Electrical.Types.Load.FixedZ_dynamic then

    // Use the dynamic phasorial representation
    Y[1] = -(P_nominal/pf)*pf/V_nominal^2;
    Y[2] = -(P_nominal/pf)*Modelica.Fluid.Utilities.regRoot(1 - pf^2, delta=0.001)/V_nominal^2;

    // Electric charge
    q = Y[2]*{v[1], v[2]}/omega;

    // Dynamics of the system
    der(q) + omega*j(q) + Y[1]*v = i;

  else

    // Use the power specified by the parameter or inputs
    if linearized then
      i[1] = -homotopy(actual= (v[2]*Q + v[1]*P)/(V_nominal^2), simplified= v[1]*Modelica.Constants.eps*1e3);
      i[2] = -homotopy(actual= (v[2]*P - v[1]*Q)/(V_nominal^2), simplified= v[2]*Modelica.Constants.eps*1e3);
    else
      if initMode == IDEAS.Electrical.Types.InitMode.zero_current then
        i[1] = -homotopy(actual=(v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2), simplified=0.0);
        i[2] = -homotopy(actual=(v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2), simplified=0.0);
      else
        i[1] = -homotopy(actual=(v[2]*Q + v[1]*P)/(v[1]^2 + v[2]^2), simplified=(v[2]*Q + v[1]*P)/(V_nominal^2));
        i[2] = -homotopy(actual=(v[2]*P - v[1]*Q)/(v[1]^2 + v[2]^2), simplified=(v[2]*P - v[1]*Q)/(V_nominal^2));
      end if;

    end if;

    Y = {0, 0};
    q = {0, 0};

  end if;

  annotation (
    defaultComponentName="loa",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={
        Rectangle(
          extent={{-80,40},{80,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{0,28},{0,-28}},
          color={0,0,0},
          origin={48,0},
          rotation=180),
        Line(
          points={{0,28},{0,-28}},
          color={0,0,0},
          origin={40,0},
          rotation=180),
          Line(points={{-42,-5.14335e-15},{10,0}},
                                         color={0,0,0},
          origin={-2,0},
          rotation=180),
          Line(points={{-26,-3.18398e-15},{0,0}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180),
          Line(points={{-10,-1.22461e-15},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-42,1},
          rotation=90),
        Text(
          extent={{-120,80},{120,40}},
          textColor={0,0,0},
          textString="%name")}), Documentation(info="<html>

<p>
Model of an capacitive load. It may be used to model a bank of capacitors.
</p>
<p>
The model computes the complex power vector as
<p align=\"center\" style=\"font-style:italic;\">
S = P + jQ = V &sdot; i<sup>*</sup>
</p>
<p>
where <i>V</i> is the voltage phasor and <i>i<sup>*</sup></i> is the complex
conjugate of the current phasor. The voltage and current phasors are shifted
by an angle <i>&phi;</i>.
</p>

<p>
The load model takes as input the power consumed by the inductive load and
the power factor <i>pf=cos(&phi;)</i>. The power
can be either fixed using the parameter <code>P_nominal</code>, or
it is possible to specify a variable power using the inputs <code>y</code> or
<code>Pow</code>.

The power factor can be either specified by the parameter <code>pf</code>
or using the input variable <code>pf_in</code>.

The different modes can be selected with the parameter
<code>mode</code> and <code>use_pf_in</code>, see <a href=\"modelica://IDEAS.Electrical.Interfaces.Load\">
IDEAS.Electrical.Interfaces.Load</a> and
<a href=\"modelica://IDEAS.Electrical.Interfaces.CapacitiveLoad\">
IDEAS.Electrical.Interfaces.CapacitiveLoad</a> for more information.
</p>

<p>
Given the active power <i>P</i> and the power factor <i>pf</i> the complex
power <i>Q</i> is computed as
</p>

<p align=\"center\" style=\"font-style:italic;\">
Q = - P  tan(arccos(pf)).
</p>

<p>
The equations of the model can be rewritten as
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = (P V<sub>1</sub> + Q V<sub>2</sub>)/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>),
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>2</sub> = (P V<sub>2</sub> - Q V<sub>1</sub>)/(V<sub>1</sub><sup>2</sup> + V<sub>2</sub><sup>2</sup>),
</p>

<p>
where <i>i<sub>1</sub></i>, <i>i<sub>2</sub></i>, <i>V<sub>1</sub></i>, and <i>V<sub>2</sub></i>
are the real and imaginary parts of the current and voltage phasors.
</p>
<p>
The nonlinearity of the model is due to the fact that the load consumes the power specified by the variables <i>P</i>
and <i>Q</i> irrespectively of the voltage of the load.
</p>
<p>
When multiple loads are connected in a grid through cables that cause voltage drops,
the dimension of the system of nonlinear equations increases linearly with the number of loads.
This nonlinear system of equations introduces challenges during the initialization,
as Newton solvers may diverge if initialized far from a solution, as well during the simulation.
In this situation, the model can be parameterized to use a linear approximation
as discussed in the next section.
</p>

<h4>Linearized model</h4>
<p>
Given the constraints and the two-dimensional nature of the problem, it is difficult to
find a linearized version of the AC load model. A solution could be to divide the voltage
domain into sectors, and for each sector compute the best linear approximation.
However the selection of the proper approximation depending on the value of the
voltage can generate events that increase the simulation time. For these reasons, the
linearized model assumes a voltage that is equal to the nominal value
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>1</sub> = (P V<sub>1</sub> + Q V<sub>2</sub>)/V<sub>RMS</sub><sup>2</sup>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
i<sub>2</sub> = (P V<sub>2</sub> - Q V<sub>1</sub>)/V<sub>RMS</sub><sup>2</sup>,
</p>
<p>
where <i>V<sub>RMS</sub></i> is the Root Mean Square voltage os the AC system.
Even though this linearized version of the load model introduces an approximation
error in the current, it satisfies the constraints related to the ratio of the
active and reactive powers.
</p>

<h4>Initialization</h4>
<p>
The initialization problem can be simplified using the homotopy operator. The homotopy operator
uses two different types of equations to compute the value of a variable: the actual one
and a simplified one. The actual equation is the one used during the normal operation.
During initialization, the simplified equation is first solved and then slowly replaced
with the actual equation to compute the initial values for the nonlinear systems of
equations. The load model uses the homotopy operator, with the linearized model being used
as the simplified equation. This numerical expedient has proven useful when simulating models
with more than ten connected loads.
</p>
<p>
The load model has a parameter <code>initMode</code> that can be used to select
the assumption to use during the initialization phase by the homotopy operator.
The choices are between a null current or the linearized model.
</p>


</html>",
      revisions="<html>
<ul>
<li>
January 29, 2019, by Michael Wetter:<br/>
Added <code>replaceable</code> for terminal.
</li>
<li>
May 26, 2016, by Michael Wetter:<br/>
Moved function call to <code>PhaseSystem.thetaRef</code> out of
derivative operator as this is not yet supported by JModelica.
</li>
<li>September 4, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>August 5, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacitive;
