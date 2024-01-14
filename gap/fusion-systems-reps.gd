DeclareRepresentation("IsRealizedFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["G", "P", "p"]);

DeclareOperation("RealizedFusionSystem", [IsGroup, IsGroup, IsScalar]);

DeclareAttribute("RealizingGroup", IsRealizedFusionSystemRep);

DeclareRepresentation("IsTransportFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["fusion", "group", "phi", "phiInv"]);

# TODO: For permutation groups, we need another method
DeclareOperation("^", [IsFusionSystem, IsGroupHomomorphism]);
