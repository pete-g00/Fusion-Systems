InstallMethod(ConjugacyClassRepresentatives,
    "Returns the conjugacy class representatives for the F-conjugacy class",
    [IsFClassByCoClassesRep],
    function(clA)
        return clA!.reps;
    end );

InstallMethod(UnderlyingFusionSystem,
    "Returns the underlying fusion system for the F-conjugacy class",
    [IsFClassByCoClassesRep],
    function(clA)
        return clA!.F;
    end );

InstallMethod(PrintObj,
    "Prints a F-conjugacy class",
    [IsFClass],
    function(class)
        local H;

        H := Representative(class);
        Print(H, "^F");
    end );

InstallMethod(\=,
    "Checks whether two FClasses are equal",
    [IsFClass, IsFClass],
    function(clA, clB)
        local F1, F2, A, B, phi1, phi2, repsA, repsB, P, Q, j;

        F1 := UnderlyingFusionSystem(clA);
        F2 := UnderlyingFusionSystem(clB);

        if UnderlyingGroup(F1) <> UnderlyingGroup(F2) then 
            return false;
        fi;

        if CompareByIsom(Representative(clA), Representative(clB)) <> 0 then 
            return false;
        fi;
        
        A := Representative(clA);
        B := Representative(clB);

        phi1 := RepresentativeFIsomorphism(F1, A, B);
        # if A and B are not F1-conjugate, then the F1-class of A doesn't contain B
        if phi1 = fail then 
            return false;
        fi;

        # if F1 and F2 are the same fusion systems, then there's nothing more to check
        if IsIdenticalObj(F1, F2) then 
            return true;
        fi;

        # the two Fclasses must have the same size
        if Size(clA) <> Size(clB) then 
            return false;
        fi;

        # if A and B are not F2-conjugate, then the F2-class of B doesn't contain A
        phi2 := RepresentativeFIsomorphism(F2, A, B);
        if phi2 = fail then 
            return false;
        fi;
        
        # check that there is a bijection between the co-cl representatives between the two
        repsA := FClassReps(F1, A);
        repsB := ShallowCopy(FClassReps(F2, B));

        if Length(repsA) <> Length(repsB) then 
            return false;
        fi;
        
        P := UnderlyingGroup(F1);

        # find a bijection between repsA and repsB (up to P-cocl)
        for Q in repsA do 
            j := PositionProperty(repsB, R -> R in Q^P);
            if j = fail then 
                return false;
            fi;
            Remove(repsB, j);
        od;

        return true;
    end );

InstallMethod(\in,
    "Checks whether an IsFClass contains a subgroup",
    [IsGroup, IsFClass],
    function(B, clA)
        return AreFConjugate(UnderlyingFusionSystem(clA), Representative(clA), B);
    end );

InstallMethod(AsList,
    "Returns a list of elements in the IsFClass",
    [IsFClass],
    function(clA)
        local L, P, A;

        L := [];
        P := UnderlyingGroup(UnderlyingFusionSystem(clA));

        for A in ConjugacyClassRepresentatives(clA) do 
            Append(L, AsList(A^P));
        od;

        return L;
    end );

InstallMethod(Size,
    "Returns the size of the IsFClass",
    [IsFClass],
    function(clA)
        local size, P, A;

        size := 0;
        P := UnderlyingGroup(UnderlyingFusionSystem(clA));

        for A in ConjugacyClassRepresentatives(clA) do 
            size := size + Size(A^P);
        od;

        return size;
    end );

InstallMethod(Representative,
    "Returns the size of the IsFClass",
    [IsFClass],
    function(clA)
        return Representative(ConjugacyClassRepresentatives(clA));
    end );

InstallMethod(Enumerator,
    "Returns an enumerator of the F-conjugacy class",
    [IsFClass],
    function(clA)
        local P;

        P := UnderlyingGroup(UnderlyingFusionSystem(clA));

        return UnionEnumerator(
            function()
                Print("Enumerator of ", clA);
            end,
            List(ConjugacyClassRepresentatives(clA), Q -> Q^P)
        );
    end );

InstallMethod(EnumeratorSorted,
    "Returns an enumerator of the F-conjugacy class",
    [IsFClass],
    Enumerator
);
