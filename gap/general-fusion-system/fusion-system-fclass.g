DeclareOperation("FConjugacyClass", [IsFusionSystem]);
InstallMethod(FConjugacyClass, 
    "Returns all the $F$-conjugacy classes",
    [IsFusionSystemRep],
    F -> Union(List(F!.classes)));

DeclareOperation("FClass", [IsFusionSystem, IsGroup]);
InstallMethod(FClass, 
    "Return the $F$-conjugacy class of $Q$",
    [IsFusionSystemRep, IsGroup],
    function(F, Q)
        local id, classes, class;

        id := IdGroup(Q);
        classes := LookupDictionary(F!.classes, id);

        for class in classes do 
            if Position(class, Q) <> fail then 
                return class;
            fi;
        od;
    end);

DeclareOperation("AreFConjugate", [IsFusionSystem, IsGroup, IsGroup]);
InstallMethod(AreFConjugate,
    "Checks whether $Q$ and $R$ are $F$-conjugate",
    [IsFusionSystemRep, IsGroup, IsGroup],
    function(F, Q, R)
        local id_Q, id_R, classes, class, i, j;

        # Q and R must be isomorphic for them to be F-conjugate
        id_Q := IdGroup(Q);
        id_R := IdGroup(R);

        if id_Q <> id_R then 
            return false;
        fi;

        # we require both Q and R to lie in the same F-class
        classes := LookupDictionary(F!.classes, id_Q);

        for class in classes do 
            i := Position(class, Q);
            j := Position(class, R);

            if i <> fail and j <> fail then 
                return true;
            elif i <> fail then 
                return false;
            elif j <> fail then 
                return false;
            fi;
        od;
    end );

DeclareOperation("AutF", [IsFusionSystem, IsGroup]);
# TODO: Aut_F

DeclareOperation("HomF", [IsFusionSystem, IsGroup, IsGroup]);
# TODO: Hom_F
