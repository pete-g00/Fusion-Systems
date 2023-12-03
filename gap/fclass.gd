DeclareCategory("IsFClass", IsIterator and IsCollection );

DeclareRepresentation("FClassByCoClassesRep",
    IsComponentObjectRep and IsFClass, ["classes", "classIdx", "classIter"]);

DeclareOperation("FClassByCoClasses", [IsList]);

DeclareRepresentation("FClassBySubgroupsRep",
    IsComponentObjectRep and IsFClass, ["subgroups"]);

DeclareOperation("FClassBySubgroups", [IsList]);

DeclareRepresentation("FClassByFilteredCoClassRep",
    IsComponentObjectRep and IsFClass, ["enum", "class"]);

DeclareOperation("FClassFiltered", [IsCollection, IsGroup]);
