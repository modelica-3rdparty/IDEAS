within IDEAS.Electrical.AC.ThreePhasesBalanced.Interfaces;
connector Terminal_p "AC three-phase balanced terminal ('positive')"
  extends IDEAS.Electrical.Interfaces.Terminal(
    redeclare replaceable package PhaseSystem = PhaseSystems.OnePhase);
  annotation (defaultComponentName = "term_p",
  Documentation(info="<html>
<p>Electric connector with a vector of positive pins.</p>
</html>"),
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={           Text(
          extent={{-60,60},{60,-60}},
          textColor={255,255,255},
          pattern=LinePattern.None,
          textString=""),                    Polygon(
              points={{-100,100},{-100,-100},{100,-100},{100,100},{-100,100}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-120,120},{100,60}},
          textColor={0,120,120},
          textString="%name"),
        Text(
          extent={{14,16},{114,-84}},
          textColor={255,255,255},
          pattern=LinePattern.None,
          textString=""),                    Polygon(
          points={{0,50},{0,-50},{100,-50},{100,50},{0,50}},
          lineColor={0,120,120},
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid)}));
end Terminal_p;
