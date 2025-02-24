within IDEAS.Fluid.Examples.Performance.PressureDrop;
model SeriesDpOptimised
  "Series connection with prescribed pressure difference and optimised parameters"
  extends SeriesDp(
    resSeries(each from_dp=false));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 26, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example model that demonstrates how translation statistics
depend on the type of boundary conditions,
the parallel or series configuration of the components
and the value of parameter <code>from_dp</code>.
</p>
</html>"), experiment(Tolerance=1e-6, StopTime=1), __Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/SeriesDpOptimised.mos"
        "Simulate and plot"));
end SeriesDpOptimised;
