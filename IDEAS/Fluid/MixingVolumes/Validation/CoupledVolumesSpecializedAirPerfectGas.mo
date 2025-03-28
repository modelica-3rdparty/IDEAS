within IDEAS.Fluid.MixingVolumes.Validation;
model CoupledVolumesSpecializedAirPerfectGas
  "Validation model for two coupled volumes with air as a perfect gas"
  extends IDEAS.Fluid.MixingVolumes.Validation.CoupledVolumesWater(
    redeclare package Medium =
        IDEAS.Media.Specialized.Air.PerfectGas);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Validation model for two directly coupled volumes.
</p>
<p>
This tests whether a Modelica translator can perform the index reduction.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2018, by Michael Wetter:<br/>
First implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/910\">IBPSA, issue 910</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/CoupledVolumesSpecializedAirPerfectGas.mos"
           "Simulate and plot"));
end CoupledVolumesSpecializedAirPerfectGas;
