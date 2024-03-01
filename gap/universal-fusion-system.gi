InstallMethod(UniversalFusionSystem,
    "Constructs the universal fusion system on $P$",
    [IsGroup],
    function (P)
        local p;

        p := FindPrimeOfPrimePower(Size(P));

        if p = fail then 
            Error("P is not a p-group!");
        fi;
        
        return Objectify(NewType(FusionSystemFamily, IsUniversalFusionSystemRep),
            rec( P := P, Subs := GroupByIsomType(List(ConjugacyClassesSubgroups(P), Representative)), p := p ));
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
        label := IsomType(A);

        # Length(label) = 2 <=> we know the isomorphism type
        if Length(label) = 2 then 
            return F!.Subs.(String(label));
        else 
            # TODO: Checking for isomorphism will be slow
            return First(F!.Subs.(String(label)), B -> IsomorphismGroups(A, B) <> fail);
        fi;
    end );

InstallMethod(FClassesReps,
    "Returns a representative from each $F$-conjugacy class",
    [IsUniversalFusionSystemRep],
    function(F)
        local P, reps, label, PReps, UniqueReps, Q;

        P := UnderlyingGroup(F);
        reps := [];

        for label in RecNames(F!.Subs) do
            if Length(Positions(label, ',')) = 1 then 
                # the label is the isom type
                Add(reps, Representative(F!.Subs.(label)));
            else 
                # we need to establish the isomorphic subgroups from each P-representative
                PReps := List(F!.Subs.(label), Representative);
                UniqueReps := [];
                for Q in PReps do
                    if ForAll(UniqueReps, R -> IsomorphismGroups(Q, R) = fail) then 
                        Add(UniqueReps, Q);
                    fi;
                od;
                Append(reps, UniqueReps);
            fi;
        od;

        return reps;
    end );

