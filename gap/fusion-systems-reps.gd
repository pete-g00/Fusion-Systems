DeclareRepresentation("IsRealizedFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["G", "P", "p", "IsSylowSubgroup"]);

DeclareOperation("RealizedFusionSystem", [IsGroup, IsGroup, IsScalar]);

DeclareAttribute("RealizingGroup", IsRealizedFusionSystemRep);

DeclareRepresentation("IsTransportFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["fusion", "group", "phi", "phiInv"]);

# TODO: For permutation groups, we need another method
DeclareOperation("^", [IsFusionSystem, IsGroupHomomorphism]);

DeclareRepresentation("IsUniversalFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["P", "Subs", "p"]);

DeclareOperation("UniversalFusionSystem", [IsGroup, IsScalar]);

DeclareOperation("GeneratedFusionSystem", [IsFusionSystem, IsCollection]);

DeclareOperation("GeneratedFusionSystem", [IsGroup, IsScalar, IsCollection]);

DeclareRepresentation("IsGeneratedFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["F", "NewAuts"]);
