DeclareCategory("IsFClass", IsCollection );

# Returns the underlying fusion system
DeclareAttribute("UnderlyingFusionSystem", IsFClass);

# Returns a representative for each conjugacy class representative of F-class
DeclareAttribute("ConjugacyClassRepresentatives", IsFClass);

DeclareRepresentation("IsFClassByCoClassesRep",
    IsComponentObjectRep and IsFClass, ["F", "reps"]);
