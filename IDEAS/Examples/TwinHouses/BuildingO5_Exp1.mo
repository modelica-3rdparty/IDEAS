within IDEAS.Examples.TwinHouses;
model BuildingO5_Exp1
  "Model for simulation of experiment 1 for the O5 building"
 extends BuildingN2_Exp1(
   bui=2,
   exp=1,
   redeclare BaseClasses.Structures.TwinhouseO5 struct,
    sim(unify_n50=true,
      n50=1.64,
      locTer=IDEAS.BoundaryConditions.Types.LocalTerrain.Custom,
      A0_custom=1,
      a_custom=0.15));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
   coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
May 20, 2026, by Anna Dell'Isola:<br/>
Update custom parameters in <code>sim</code>. See
<a href=\"https://github.com/open-ideas/IDEAS/issues/1488\">#1488</a>. 
</li>
</ul>
</html>"),
    experiment(
      StartTime=20736000,
      StopTime=23587200,
      Interval=900.00288,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=false, OutputModelicaCode=false),
      Evaluate=true,
      OutputCPUtime=true,
      OutputFlatModelica=false),
    __Dymola_Commands(file=
          "modelica://IDEAS/Resources/Scripts/Dymola/Examples/TwinHouses/BuildingO5_Exp1.mos"
        "Simulate and plot"));
end BuildingO5_Exp1;
