within IDEAS.Fluid.PVTCollectors.Validation.PVT_UI.Electrical;
model PVT_UI_Electrical_DayType3
  "Test model for Unglazed Rear-Insulated PVT Collector"
  extends PVT_UI_Electrical_DayType1(pvtTyp="Typ3", T_start=36.70783953 + 273.15);
  annotation (
__Dymola_Commands(file="modelica://IDEAS/Resources/Scripts/Dymola/Fluid/PVTCollectors/Validation/PVT_UI/Electrical/PVT_UI_Electrical_DayType3.mos"
        "Simulate and plot"),
 experiment(
      StartTime=17747640,
      StopTime=17788560.0,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end PVT_UI_Electrical_DayType3;
