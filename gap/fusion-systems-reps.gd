DeclareRepresentation("IsRealizedFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["G", "P", "p"]);

DeclareOperation("RealizedFusionSystem", [IsGroup, IsGroup, IsScalar]);

DeclareAttribute("RealizingGroup", IsRealizedFusionSystemRep);