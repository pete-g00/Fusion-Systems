# In the universal fusion system, we store the group on which the fusion system is, along with the subgroups,
# in a dictionary, with key the IdGroup and values a list of conjugacy classes
DeclareRepresentation("IsUniversalFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["group", "subs"]);

DeclareOperation("UniversalFusionSystem", [IsGroup]);
InstallMethod(UniversalFusionSystem,
    "Constructs the universal fusion system on $P$",
    [IsGroup],
    function (P)
        local classes, subs, id, class, classes_list;

        classes := ConjugacyClassesSubgroups(P);
        subs := NewDictionary([0, 0], true);

        for class in classes do 
            id := IdGroup(Representative(class));
            classes_list := LookupDictionary(subs, id);

            if classes_list = fail then 
                classes_list := [];
            fi;

            Add(classes_list, class);
            AddDictionary(subs, id, classes_list);
        od;

        return Objectify(NewType(FusionSystemFamily, IsUniversalFusionSystemRep),
            rec( group := P, subs := subs));
    end );

InstallMethod(PrintObj, 
    "Prints a universal fusion system",
    [IsUniversalFusionSystemRep],
    function ( F ) 
        Print("Universal Fusion System on ", F!.group);
    end );

InstallMethod(FConjugacyClass,
    "Returns all the $F$-conjugacy classes",
    [IsUniversalFusionSystemRep],
    function (F) 
        return List(F!.subs);
    end );

InstallMethod(FClass,
    "Returns the $F$-conjugacy class of $Q$",
    [IsUniversalFusionSystemRep, IsGroup],
    function (F, Q) 
        local id, class;

        id := IdGroup(Q);
        class := LookupDictionary(F!.classes, id);

        return class;
    end );

InstallMethod(AreFConjugate,
    "Checks whether $Q$ and $R$ are $F$-conjugate",
    [IsUniversalFusionSystemRep, IsGroup, IsGroup],
    function(F, Q, R)
        local id_Q, id_R;

        id_Q := IdGroup(Q);
        id_R := IdGroup(R);

        return id_Q = id_R;
    end );

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsUniversalFusionSystemRep, IsGroup],
    function(F, Q) 
        return AutomorphismGroup(Q);
    end );

# HomF