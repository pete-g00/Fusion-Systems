InstallMethod(UniversalFusionSystem,
    "Constructs the universal fusion system on $P$",
    [IsGroup, IsScalar],
    function (P, p)
        return Objectify(NewType(FusionSystemFamily, IsUniversalFusionSystemRep),
            rec( P := P, Subs := PartitionedConjugacyClasses(P), p := p ));
    end );

InstallMethod(UnderlyingGroup,
    "Returns the group on which the fusion system $F$ is",
    [IsUniversalFusionSystemRep],
    function(F)
        return F!.P;
    end );

InstallMethod(Prime,
    "Returns the p-group on which the fusion system $F$ is",
    [IsUniversalFusionSystemRep],
    function(F)
        return F!.p;
    end );

InstallMethod(ViewObj, 
    "Prints a universal fusion system",
    [IsUniversalFusionSystemRep],
    function ( F ) 
        Print("Universal Fusion System on ", F!.P);
    end );

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsUniversalFusionSystemRep, IsGroup],
    function(F, Q) 
        return AutomorphismGroup(Q);
    end );

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsUniversalFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local P;

        P := UnderlyingGroup(F);

        if not IsSubset(P, A) then 
            Error("A is not a subgroup of P");
        elif not IsSubset(P, B) then
            Error("A is not a subgroup of P");
        fi;

        return IsomorphismGroups(A, B);
    end );

InstallMethod(FClassReps,
    "Returns a representative from each conjugacy class of subgroups that are $F$-conjugate",
    [IsUniversalFusionSystemRep, IsGroup],
    function(F, A)
        local P, label;

        P := UnderlyingGroup(F);
        
        if IdGroupsAvailable(Size(A)) then 
            label := String(IdGroup(A));
            return F!.Subs.(label);
        else 
            label := Size(A);
            return First(F!.Subs.(label), B -> IsomorphismGroups(A, B) <> fail);
        fi;
    end );

InstallMethod(FClassesReps,
    "Returns a representative from each $F$-conjugacy class",
    [IsUniversalFusionSystemRep],
    function(F)
        local P, reps, id;

        P := UnderlyingGroup(F);
        reps := [];

        for id in RecNames(F!.Subs) do
            if IsScalar(id) then 
                Append(reps, List(F!.Subs.(id), Representative));
            else 
                Add(reps, Representative(F!.Subs.(id)));
            fi;
        od;

        return reps;
    end );

InstallMethod(IsFReceptive,
    "Checks whether $Q$ is $F$-receptive",
    [IsUniversalFusionSystemRep, IsGroup],
    function (F, Q)
        return true;
    end );
