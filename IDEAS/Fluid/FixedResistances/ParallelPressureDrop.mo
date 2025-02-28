within IDEAS.Fluid.FixedResistances;
model ParallelPressureDrop
  "Fixed flow resistance with multiple parallel circuits"
  extends IDEAS.Fluid.BaseClasses.PartialResistance(
    final m_flow_turbulent = if (computeFlowResistance and use_dh) then
                       eta_default*dh/4*Modelica.Constants.pi*ReC*nParCir
                       elseif (computeFlowResistance) then
                       deltaM * m_flow_nominal_pos
         else 0);
  parameter Real nParCir "Number of parallel circuits";
  parameter Boolean use_dh = false "Set to true to specify hydraulic diameter"
       annotation(Evaluate=true, Dialog(enable = not linearized));
  parameter Modelica.Units.SI.Length dh=1 "Hydraulic diameter"
    annotation (Evaluate=true, Dialog(enable=use_dh and not linearized));
  parameter Real ReC(min=0)=4000
    "Reynolds number where transition to turbulent starts"
       annotation(Evaluate=true, Dialog(enable = use_dh and not linearized));
  parameter Real deltaM(min=0.01) = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
       annotation(Evaluate=true, Dialog(enable = not use_dh and not linearized));

  final parameter Real k(unit="") = if computeFlowResistance then
        m_flow_nominal_pos/nParCir / sqrt(dp_nominal_pos) else 0
    "Flow coefficient for 1 of the parallel circuits";
  parameter Boolean computeFlowResistance=true
    "Flag to enable/disable computation of flow resistance"
   annotation(Evaluate=true);
initial equation
 if computeFlowResistance then
   assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
 end if;

 assert(m_flow_nominal_pos > 0, "m_flow_nominal_pos must be non-zero. Check parameters.");
 if ( m_flow_turbulent > m_flow_nominal_pos) then
   Modelica.Utilities.Streams.print("Warning: In FixedResistanceDpM, m_flow_nominal is smaller than m_flow_turbulent."
           + "\n"
           + "  m_flow_nominal = " + String(m_flow_nominal) + "\n"
           + "  dh      = " + String(dh) + "\n"
           + "  To fix, set dh < " +
                String(     4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC) + "\n"
           + "  Suggested value: dh = " +
                String(1/10*4*m_flow_nominal/eta_default/Modelica.Constants.pi/ReC));
 end if;

equation
  // Pressure drop calculation
  if computeFlowResistance then
    if linearized then
      m_flow*m_flow_nominal_pos/nParCir^2 = k^2*dp;
    else
      if homotopyInitialization then
        if from_dp then
          m_flow=homotopy(actual=IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                   m_flow_turbulent=m_flow_turbulent/nParCir)*nParCir,
                                   simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
        else
          dp=homotopy(actual=IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow/nParCir, k=k,
                                   m_flow_turbulent=m_flow_turbulent/nParCir),
                    simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
         end if;  // from_dp
      else // do not use homotopy
        if from_dp then
          m_flow=IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(dp=dp, k=k,
                                   m_flow_turbulent=m_flow_turbulent/nParCir)*nParCir;
        else
          dp=IDEAS.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(m_flow=m_flow/nParCir, k=k,
                                   m_flow_turbulent=m_flow_turbulent/nParCir);
        end if;  // from_dp
      end if; // homotopyInitialization
    end if; // linearized
  else // do not compute flow resistance
    dp = 0;
  end if;  // computeFlowResistance

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{100,100}}),
                      graphics),
defaultComponentName="res",
Documentation(info="<html>
<p>
This is a model of a resistance with a fixed flow coefficient.
The mass flow rate is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
m&#775; = k  
&radic;<span style=\"text-decoration:overline;\">&Delta;P</span>,
</p>
<p>
where 
<i>k</i> is a constant and 
<i>&Delta;P</i> is the pressure drop.
The constant <i>k</i> is equal to
<code>k=m_flow_nominal/dp_nominal</code>,
where <code>m_flow_nominal</code> and <code>dp_nominal</code>
are parameters.
In the region
<code>abs(m_flow) &lt; m_flow_turbulent</code>, 
the square root is replaced by a differentiable function
with finite slope.
The value of <code>m_flow_turbulent</code> is
computed as follows:
</p>
<ul>
<li>
If the parameter <code>use_dh</code> is <code>false</code>
(the default setting), 
the equation 
<code>m_flow_turbulent = deltaM * abs(m_flow_nominal)</code>,
where <code>deltaM=0.3</code> and 
<code>m_flow_nominal</code> are parameters that can be set by the user.
</li>
<li>
Otherwise, the equation
<code>m_flow_turbulent = eta_nominal*dh/4*&pi;*ReC</code> is used,
where 
<code>eta_nominal</code> is the dynamic viscosity, obtained from
the medium model. The parameter
<code>dh</code> is the hydraulic diameter and
<code>ReC=4000</code> is the critical Reynolds number, which both
can be set by the user.
</li>
</ul>
<p>
The figure below shows the pressure drop for the parameters
<code>m_flow_nominal=5</code> kg/s,
<code>dp_nominal=10</code> Pa and
<code>deltaM=0.3</code>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://IDEAS/Resources/Images/Fluid/FixedResistances/FixedResistanceDpM.png\"/>
</p>
<p>
If the parameter
<code>show_T</code> is set to <code>true</code>,
then the model will compute the
temperature at its ports. Note that this can lead to state events
when the mass flow rate approaches zero,
which can increase computing time.
</p>
<p>
The parameter <code>from_dp</code> is used to determine
whether the mass flow rate is computed as a function of the 
pressure drop (if <code>from_dp=true</code>), or vice versa.
This setting can affect the size of the nonlinear system of equations.
</p>
<p>
If the parameter <code>linearized</code> is set to <code>true</code>,
then the pressure drop is computed as a linear function of the
mass flow rate.
</p>
<p>
Setting <code>allowFlowReversal=false</code> can lead to simpler
equations. However, this should only be set to <code>false</code>
if one can guarantee that the flow never reverses its direction.
This can be difficult to guarantee, as pressure imbalance after 
the initialization, or due to medium expansion and contraction,
can lead to reverse flow.
</p>
<h4>Notes</h4>
<p>
For more detailed models that compute the actual flow friction, 
models from the package 
<a href=\"modelica://Modelica.Fluid\">
Modelica.Fluid</a>
can be used and combined with models from the 
<code>Buildings</code> library.
</p>
<h4>Implementation</h4>
<p>
The pressure drop is computed by calling a function in the package
<a href=\"modelica://IDEAS.Fluid.BaseClasses.FlowModels\">
IDEAS.Fluid.BaseClasses.FlowModels</a>,
This package contains regularized implementations of the equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
and its inverse function.
</p>
<p>
To decouple the energy equation from the mass equations,
the pressure drop is a function of the mass flow rate,
and not the volume flow rate.
This leads to simpler equations.
</p>
</html>", revisions="<html>
<ul>
<li>
October 8, 2013, by Michael Wetter:<br/>
Removed parameter <code>show_V_flow</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>IDEAS.Fluid.BaseClasses.PartialResistance</code>,
<code>IDEAS.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>IDEAS.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>IDEAS.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>IDEAS.Fluid.FixedResistances.FixedResistanceDpM</code>.
</li>
<li>
May 30, 2008 by Michael Wetter:<br/>
Added parameters <code>use_dh</code> and <code>deltaM</code> for easier parameterization.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-102,86},{-4,22}},
          lineColor={0,0,255},
          textString="dp_nominal=%dp_nominal"), Text(
          extent={{-106,106},{6,60}},
          lineColor={0,0,255},
          textString="m0=%m_flow_nominal")}));
end ParallelPressureDrop;
