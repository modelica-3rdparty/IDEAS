within IDEAS.Buildings.Validation.Data.Materials;
record Roofdeck_195
  "BESTEST roof deck for case 195"
  extends IDEAS.Buildings.Data.Interfaces.Material(
    final k=0.14,
    final c=900,
    final rho=530,
    epsLw=0.1,
    epsSw=0.1);
end Roofdeck_195;
