InstallMethod(GeneratedFusionSystem,
    "Constructs a generated fusion system",
    [IsGroup, IsScalar, IsCollection],
    function(P, p, maps)
        return GeneratedFusionSystem(RealizedFusionSystem(P, P, p), maps);
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
    [IsFusionSystem, IsCollection],
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

# AddNewAutomorphism := function(label, rPhi, psi, A, AutGens, F)
#     # rPhi and psi are maps Q -> R
#     # Both are F'-conjugate to A
#     # AutGens are the new automorphism generators for A
    
#     autR := psi * RestrictedInverseGeneralMapping(rPhi);
#     # conjugate this by the representative map R -> R' -> A

#     # local NewQAuts, sigma, T, alpha, sigmaPrime, FMapGens, TotalGens;

#     # if not label in RecNames(NewAuts) then 
#     #     NewAuts.(label) := NewDictionary(FClass(F, UnderlyingGroup(F)), true);
#     # fi;
    
#     # NewQAuts := LookupDictionary(NewAuts.(label), FClass(F, Q));
#     # if NewQAuts = fail then 
#     #     NewQAuts := [];
#     # fi;

#     # # sigma is an automorphism of Q -> Q
#     # sigma := rPhi * psi;

    
#     # # TODO: Check wrt the current F-conjugates

#     # # add this map if it doesn't already exist in AutF and the new maps
#     # if IsEmpty(NewQAuts) then 
#     #     if not sigma in AutF(F, Q) then
#     #         AddDictionary(NewAuts.(label), FClass(F, Q), [sigma]);
#     #         Print("Adding to the empty list: ", sigma, "\n");
#     #     else 
#     #         Print("This map already exists: ", sigma, "\n");
#     #     fi;
#     # else 
#     #     T := Source(Representative(NewQAuts));
#     #     alpha := RepresentativeFIsomorphism(F, Q, T);
#     #     # sigmaPrime is an automorphism T -> T
#     #     sigmaPrime := sigma^alpha;
        
#     #     FMapGens := GeneratorsOfGroup(AutF(F, T));
#     #     TotalGens := Union(FMapGens, NewQAuts);
        
#     #     if not sigmaPrime in Group(TotalGens) then 
#     #         Add(TotalGens, sigmaPrime);
#     #         AddDictionary(NewAuts.(label), FClass(F, T), TotalGens);
#     #         Print("Adding the new map: ", sigmaPrime, "\n");
#     #     else 
#     #         Print("This map already exists: ", sigmaPrime, "\n");
#     #     fi;
#     # fi;
# end;

# InstallMethod(GeneratedFusionSystem,
#     "Constructs a generated fusion system on some fusion system",
#     [IsFusionSystem, IsCollection],
#     function(F, maps)
#         local FReps, NewAuts, IsomsInfo, label, A, phi, B, C, Q, rPhi, R, f, Data, phiQ, phiR, psiQ, psiR, alpha, i, altQRMap;

#         if ForAny(maps, phi -> not IsInjective(phi)or not IsGroupHomomorphism(phi)) then 
#             Error("Not all maps are injective homomorphisms");
#         fi;

#         if ForAny(maps, phi -> not IsSubset(UnderlyingGroup(F), Source(phi)) or not IsSubset(UnderlyingGroup(F), Range(phi))) then 
#             Error("Not all maps have source/range inside P");
#         fi;

#         FReps := GroupByIsomType(FClassesReps(F));
#         NewAuts := rec();
#         IsomsInfo := rec();
#         # NewDictionary(FClass(F, UnderlyingGroup(F)), true)

#         for label in RecNames(FReps) do
#             # FReps.(label) contains all those maps that could become F-conjugate (one representative from each F-class)
#             for A in FReps.(label) do 
#                 for phi in maps do 
#                     B := Source(phi);
                    
#                     # Look at all F-conjugates of A that lie in B
#                     # TODO: Only need to care up to P-conjugates
#                     C := ContainedFConjugates(F, A, B);

#                     for Q in C do 
#                         # only need to add it if \phi|_Q doesn't already exist in F
#                         rPhi := RestrictedMapping(phi, Q);
#                         R := Image(rPhi, Q);
                        
#                         if not label in RecNames(IsomsInfo) then 
#                             IsomsInfo.(label) := List(FReps.(label), Q -> IdentityMapping(Q));
#                         fi;
#                         Data := IsomsInfo.(label);

#                         # find the current representative maps for Q and R
#                         phiQ := First(Data, f -> AreFConjugate(F, Source(f), Q));
#                         phiR := First(Data, f -> AreFConjugate(F, Source(f), R));

#                         # if they have become F-conjugate, then add a new automorphism. Otherwise, add a new isomorphism
#                         if AreFConjugate(F, Image(phiQ), Image(phiR)) then 
#                             psiQ := RepresentativeFIsomorphism(F, Source(phiQ), Q);
#                             psiR := RepresentativeFIsomorphism(F, R, Source(phiR));
#                             alpha := RepresentativeFIsomorphism(F, Image(phiR), Image(phiQ));
#                             # we already have a map Q -> R, namely the inverse of altQRMap

#                             # psiR : R -> R'
#                             # phiR : R' -> A
#                             # alpha : A -> B
#                             # phiQ^{-1} : B -> Q'
#                             # psiR : Q' -> Q
#                             altQRMap := psiR * phiR * alpha * InverseGeneralMapping(phiQ) * psiR;
                            
#                             AddNewAutomorphism(label, altQRMap, rPhi, Q, NewAuts, F);
#                         else 
#                             # those with representative phiQ and phiR will now be combined into 1 F-cocl
#                             # In particular, all those with a representative map to Q will now be redirected to R
#                             for i in [1..Length(Data)] do 
#                                 if AreFConjugate(F, Image(Data[i]), Q) then 
#                                     f := RepresentativeFIsomorphism(F, Image(Data[i]), Q);
#                                     Data[i] := Data[i] * f * rPhi;
#                                 fi;
#                             od;
#                             # TODO: Deal with the automorphisms
#                         fi;
#                     od;
#                 od;
#             od;
#         od;

#         # for i in [1..Length(FReps)] do 
#         #     L := FReps[i];

#         #     for A in L do 
#         #         for phi in maps do 
#         #             B := Source(phi);
                    
#         #             # Look at all F-conjugates of A that lie in B
#         #             # TODO: Only need to care up to P-conjugates
#         #             C := ContainedFConjugates(F, A, B);

#         #             for Q in C do 
#         #                 # only need to add it if \phi|_Q doesn't already exist in F
#         #                 rPhi := RestrictedMapping(phi, Q);
#         #                 # TODO: This needs to account also for the fact that we might have already added the map here!
#         #                 if not rPhi in F then 
#         #                     R := Image(rPhi, Q);
#         #                     psi := RepresentativeFIsomorphism(F, R, Q);
#         #                     if psi = fail then 
#         #                         # Deal with isoms later
#         #                     else 
#         #                         NewQAuts := LookupDictionary(NewAuts, FClass(F, Q));
#         #                         if NewQAuts = fail then 
#         #                             NewQAuts := [];
#         #                             AddDictionary(NewAuts, FClass(F, Q), NewQAuts);
#         #                         fi;
#         #                         Add(NewQAuts, rPhi*psi);
#         #                     fi;
#         #                 fi;
#         #             od;
#         #         od;
#         #     od;
#         # od;

#         return Objectify(NewType(FusionSystemFamily, IsGeneratedFusionSystemRep),
#             rec(F := F, NewAuts := NewAuts, IsomsInfo := IsomsInfo));
#     end );

InstallMethod(UnderlyingGroup,
    "Returns the group on which the fusion system $F$ is",
    [IsGeneratedFusionSystemRep],
    function (F)
        return F!.F!.P;
    end );

InstallMethod(Prime,
    "Returns the p-group on which the fusion system $F$ is",
    [IsGeneratedFusionSystemRep],
    function (F)
        return F!.F!.p;
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

        # if IdGroupsAvailable(Size(A)) then 
        #     label := String(IdGroup(A));
        # else 
        #     label := Size(A);
        # fi;

        # AutFA := AutF(F!.F, A);
        
        # # no new maps
        # if not label in RecNames(F!.NewAuts) then 
        #     return AutFA;
        # fi;

        # NewFAuts := LookupDictionary(F!.NewAuts.(label), FClass(F, A));
        # # no new maps
        # if NewFAuts = fail then 
        #     return AutFA;
        # # otherwise, generate a group using AutFA and NewFAuts
        # else 
        #     NewFAuts := List(NewFAuts, function(psi)
        #         local phi, phiInv;

        #         phi := RepresentativeFIsomorphism(F!.F, A, Source(psi));
        #         phiInv := RepresentativeFIsomorphism(F!.F, Image(psi), A);
        #         return phi * psi * phiInv;
        #     end );
        #     Gens := GeneratorsOfGroup(AutFA);
        #     return Group(Union(Gens, NewFAuts));
        # fi;
    end );

# GeneratedFusionSystem := function(F, maps)
#     if ForAny(maps, phi -> not IsInjective(phi)) then 
#         Error("Not all maps are injective");
#     fi;

#     if ForAny(maps, phi -> not IsSubset(UnderlyingGroup(F), Source(phi)) or not IsSubset(UnderlyingGroup(F), Range(phi))) then 
#         Error("Not all maps have source/range inside P");
#     fi;

#     FReps := GroupByIsoType(FClassesReps(F));
#     NewAuts := List(FReps, Q -> []);
#     NewIsoms := List(FReps, Q -> []);
    
#     for i in [1..Length(FReps)] do 
#         L := FReps[i];

#         for phi in maps do 
#             A := Source(phi);
            
#             # Only need to care up to P-conjugates
#             C := ContainedFConjugates(F, L, A);

#             for Q in C do 
#                 # only need to add it if \phi|_Q doesn't already exist in F
#                 if not RestrictedMapping(phi, Q) in F then 
#                     R := Image(phi, Q);
#                     phi := RepresentativeFIsomorphism(F, R, Q);
#                     if psi = fail then 
#                         Add(NewIsoms[i], phi);
#                     else 
#                         Add(NewAuts[i], phi*psi);
#                     fi;
#                 fi;
#             od;
#         od;
#     od;

#     IsomIndices := [1..Length(FReps)];
#     RepIsoms := List([1..Length(FReps)], A -> IdentityMapping(A));

#     for i in [1..Length(FReps)] do 
#         Q := FReps[i];

#         # if we haven't dealt with this one then deal with it
#         if IsomIndices[i] = i and NewIsoms[i] then 
#             for phi in IsomIndices[i] do 
#                 A := Range(phi, Q);
#                 B := Image(phi, Q);

#                 # Change all the i's to j's
#                 # Make the minimal amount of change- see if there's more i's or j's
#                 j := First([1..Length(FReps)], R -> AreFConjugate(F, A, R));
#                 IsomIndices := List(IsomIndices, function(k)
#                     if k = i then 
#                         # Change the representative isomorphism from P -> A, to P -> B (will likely need a representative iso between F-conjugates)
#                         RepIsoms[k] = RepIsoms[k] * phi;
#                         return j;
#                     else 
#                         return k;
#                     fi;
#                 end );
#             od;
#         fi;
#     od;

#     # IsomIndices allows us to check whether 2 things are F-conjugate/find an F-isomorphism 

#     return [IsomIndices, NewAuts, RepIsoms];
# end;
