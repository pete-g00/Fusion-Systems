InstallMethod(GeneratedFusionSystem,
    "Constructs a generated fusion system",
    [IsGroup, IsListOrCollection],
    function(P, maps)
        return GeneratedFusionSystem(RealizedFusionSystem(P, P), maps);
    end );

# goes through all the maps and does a depth-first search looking at all maps that start from an F-conjugate of FReps[i]
AddIsomsDFS := function(FReps, F, visited, maps, repIsoms, i, classReps)
    local A, VisitByMap, phi;

    A := FReps[i];
    visited[i] := true;

    VisitByMap := function(phi)
        local L, B, C, j, rPhi, alpha, beta;

        L := ContainedFConjugates(F, A, Source(phi));

        for B in L do 
            C := Image(phi, B);
            j := First([1..Length(FReps)], j -> AreFConjugate(F, C, FReps[j]));
            Assert(0, j <> fail);

            if not visited[j] then 
                Add(classReps, FReps[j]);
                rPhi := RestrictedMapping(phi, B);
                alpha := RepresentativeFIsomorphism(F, B, A);
                beta := repIsoms[i];
                # rPhi: B -> C; beta: B -> A; alpha: A -> Q
                repIsoms[j] := RestrictedInverseGeneralMapping(rPhi) * alpha * beta;
                
                AddIsomsDFS(FReps, F, visited, maps, repIsoms, j, classReps);
            fi;
        od;
    end;

    for phi in maps do 
        VisitByMap(phi);
        VisitByMap(RestrictedInverseGeneralMapping(phi));
    od;
end;

CheckGenFSIsom := function(Isoms, F, A, B)
    local phiA, phiB, psiA, psiB;

    # TODO: Perhaps a faster way to tell whether two are F-conjugate?
    psiA := First(Isoms, phi -> AreFConjugate(F, Source(phi), A));
    psiB := First(Isoms, phi -> AreFConjugate(F, Source(phi), B));

    Assert(0, psiB <> fail);
    Assert(0, psiA <> fail);


    if Image(psiA) <> Image(psiB) then 
        return fail;
    fi;

    phiA := RepresentativeFIsomorphism(F, A, Source(psiA));
    phiB := RepresentativeFIsomorphism(F, Source(psiB), B);
    
    return rec(
        psiA := psiA,
        psiB := psiB,
        phiA := phiA,
        phiB := phiB
    );
end;

AddNewAutomorphism := function(phi, Q, AutGenList, NewFIsoms, NewFReps, F)
    local rPhi, R, mapData, psiQ, psiR, phiQ, phiR, alpha, i;

    rPhi := RestrictedMapping(phi, Q);
    R := Image(rPhi, Q);
                    
    # Q -> R is an F-automorphism, so add it to the AutF group for the representative at NewFReps[i]
    mapData := CheckGenFSIsom(NewFIsoms, F, Q, R);
    Assert(0, mapData <> fail);

    psiQ := mapData.psiA;
    psiR := mapData.psiB;
    phiQ := mapData.phiA;
    phiR := mapData.phiB;

    # psiQ^-1 : A -> Q'; phiQ^-1 : Q' -> Q; rPhi : Q -> R; phiR^-1 : R -> R'; psiR : R' -> A
    alpha := InverseGeneralMapping(psiQ) * InverseGeneralMapping(phiQ) * rPhi * InverseGeneralMapping(phiR) * psiR;
    i := First([1..Length(NewFReps)], i -> NewFReps[i] = Image(psiQ));
    Assert(0, i <> fail);

    # if alpha is not a map already NewFAuts[i]), then add to NewFAuts[i] alpha
    if not alpha in Group(AutGenList[i]) then 
        Add(AutGenList[i], alpha);
    fi;
end;

InstallMethod(GeneratedFusionSystem,
    "Constructs a generated fusion system on some fusion system",
    [IsFusionSystem, IsListOrCollection],
    function(F, maps)
        local FReps, NewFReps, NewFClassesReps, NewFIsoms, NewFAuts, label, reps, visited, repIsoms, newReps, classesReps, classReps, i, A, phi, B, C, Q;

        if ForAny(maps, phi -> not IsInjective(phi)or not IsGroupHomomorphism(phi)) then 
            Error("Not all maps are injective homomorphisms");
        fi;

        if ForAny(maps, phi -> not IsSubset(UnderlyingGroup(F), Source(phi)) or not IsSubset(UnderlyingGroup(F), Range(phi))) then 
            Error("Not all maps have source/range inside P");
        fi;

        FReps := GroupByIsomType(FClassesReps(F));
        NewFReps := rec();
        NewFClassesReps := rec();
        NewFIsoms := rec();

        NewFAuts := rec();

        for label in RecNames(FReps) do
            reps := FReps.(label);

            # establish the new F-conjugacy class
            visited := List(reps, Q -> false);
            repIsoms := List(reps, Q -> IdentityMapping(Q));
            newReps := [];
            classesReps := [];

            for i in [1..Length(reps)] do 
                if not visited[i] then 
                    classReps := [reps[i]];
                    AddIsomsDFS(reps, F, visited, maps, repIsoms, i, classReps);
                    Add(newReps, reps[i]);
                    Add(classesReps, classReps);
                fi;
            od;

            NewFReps.(label) := newReps;
            NewFClassesReps.(label) := classesReps;
            NewFIsoms.(label) := repIsoms;

            # establish the new automorphisms
            if not label in RecNames(NewFAuts) then 
                NewFAuts.(label) := List(NewFReps.(label), Q -> ShallowCopy(GeneratorsOfGroup(AutF(F, Q))));
            fi;

            for A in reps do 
                for phi in maps do 
                    B := Source(phi);
                    
                    # Look at all F-conjugates of A that lie in B
                    # TODO: Should this now be F'-conjugates, where F' is this fusion system?
                    C := ContainedFConjugates(F, A, B);
                    
                    for Q in C do 
                        AddNewAutomorphism(phi, Q, NewFAuts.(label), NewFIsoms.(label), NewFReps.(label), F);
                    od;
                od;
            od;
        od;
        
        return Objectify(NewType(FusionSystemFamily, IsGeneratedFusionSystemRep),
            rec(F := F, Reps := NewFReps, Isoms := NewFIsoms, ClassReps := NewFClassesReps, NewFAuts := NewFAuts));
    end);

InstallMethod(UnderlyingGroup,
    "Returns the group on which the fusion system $F$ is",
    [IsGeneratedFusionSystemRep],
    function (F)
        return UnderlyingGroup(F!.F);
    end );

InstallMethod(Prime,
    "Returns the p-group on which the fusion system $F$ is",
    [IsGeneratedFusionSystemRep],
    function (F)
        return Prime(F!.F);
    end );

GenerateGroupLabel := function(A)
    if IdGroupsAvailable(Size(A)) then 
        return String(IdGroup(A));
    else 
        return Size(A);
    fi;
end;

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsGeneratedFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local labelA, labelB, data;

        labelA := GenerateGroupLabel(A);
        labelB := GenerateGroupLabel(B);

        if labelA <> labelB then 
            return fail;
        fi;

        data := CheckGenFSIsom(F!.Isoms.(labelA), F!.F, A, B);
        
        if data = fail then 
            return fail;
        else 
            # phiA: A -> A'; psiA: A' -> Q; psiB: B' -> Q; phiB: B' -> B
            return data.phiA * data.psiA * InverseGeneralMapping(data.psiB) * data.phiB;
        fi;
    end );

InstallMethod(FClassesReps,
    "Computes a representative from each $F$-conjugacy class",
    [IsGeneratedFusionSystemRep],
    function(F)
        return Flat(List(RecNames(F!.Reps), label -> F!.Reps.(label)));
    end );

InstallMethod(FClassReps,
    "Computes the $F$-conjugacy class of $Q$",
    [IsGeneratedFusionSystemRep, IsGroup],
    function(F, Q)
        local label, phi, R, NewReps;
        
        label := GenerateGroupLabel(Q);
        phi := First(F!.Isoms.(label), phi -> AreFConjugate(F, Source(phi), Q));
        Assert(0, phi <> fail);

        R := Image(phi);
        NewReps := First(F!.ClassReps.(label), L -> L[1] = R);
        Assert(0, NewReps <> fail);

        return Flat(List(NewReps, A -> FClassReps(F!.F, A)));
    end );

InstallMethod(AutF,
    "Returns the automorphism group",
    [IsFusionSystem, IsGroup],
    function(F, A)
        local label, psi, r, AutGens;

        label := GenerateGroupLabel(A);

        psi := First(F!.Isoms.(label), psi -> AreFConjugate(F, Source(psi), A));
        Assert(0, psi <> fail);
        r := RepresentativeFIsomorphism(F, Source(psi), A);
        
        AutGens := First(F!.NewFAuts.(label), L -> not IsEmpty(L) and Source(Representative(L)) = Image(psi));
        Assert(0, AutGens <> fail);

        
        return Group(OnFunctionListApplication(AutGens, InverseGeneralMapping(psi) * r));
    end );
