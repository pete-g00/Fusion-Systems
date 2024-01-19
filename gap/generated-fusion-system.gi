InstallMethod(GeneratedFusionSystem,
    "Constructs a generated fusion system",
    [IsGroup, IsScalar, IsCollection],
    function(P, p, maps)
        return GeneratedFusionSystem(RealizedFusionSystem(P, P, p), maps);
    end );

InstallMethod(GeneratedFusionSystem,
    "Constructs a generated fusion system on some fusion system",
    [IsFusionSystem, IsCollection],
    function(F, maps)
        local FReps, NewAuts, label, L, i, phi, A, B, C, Q, rPhi, R, psi, NewQAuts;

        if ForAny(maps, phi -> not IsInjective(phi)or not IsGroupHomomorphism(phi)) then 
            Error("Not all maps are injective homomorphisms");
        fi;

        if ForAny(maps, phi -> not IsSubset(UnderlyingGroup(F), Source(phi)) or not IsSubset(UnderlyingGroup(F), Range(phi))) then 
            Error("Not all maps have source/range inside P");
        fi;

        FReps := GroupByIsomType(FClassesReps(F));
        NewAuts := rec();
        # NewDictionary(FClass(F, UnderlyingGroup(F)), true)

        for label in RecNames(FReps) do
            # These are all those that could become F-conjugate (one representative from each F-class)
            L := FReps.(label);
            for A in L do 
                for phi in maps do 
                    B := Source(phi);
                    
                    # Look at all F-conjugates of A that lie in B
                    # TODO: Only need to care up to P-conjugates
                    C := ContainedFConjugates(F, A, B);

                    for Q in C do 
                        # only need to add it if \phi|_Q doesn't already exist in F
                        rPhi := RestrictedMapping(phi, Q);
                        # TODO: This needs to account also for the fact that we might have already added the map here!
                        if not rPhi in F then 
                            R := Image(rPhi, Q);
                            psi := RepresentativeFIsomorphism(F, R, Q);
                            if psi = fail then 
                                # Deal with isoms later
                            else 
                                if not label in RecNames(NewAuts) then 
                                    NewAuts.(label) := NewDictionary(FClass(F, UnderlyingGroup(F)), true);
                                fi;
                                
                                NewQAuts := LookupDictionary(NewAuts.(label), FClass(F, Q));
                                if NewQAuts = fail then 
                                    NewQAuts := [];
                                    AddDictionary(NewAuts.(label), FClass(F, Q), NewQAuts);
                                fi;
                                
                                Add(NewQAuts, rPhi*psi);
                            fi;
                        fi;
                    od;
                od;
            od;
        od;

        # for i in [1..Length(FReps)] do 
        #     L := FReps[i];

        #     for A in L do 
        #         for phi in maps do 
        #             B := Source(phi);
                    
        #             # Look at all F-conjugates of A that lie in B
        #             # TODO: Only need to care up to P-conjugates
        #             C := ContainedFConjugates(F, A, B);

        #             for Q in C do 
        #                 # only need to add it if \phi|_Q doesn't already exist in F
        #                 rPhi := RestrictedMapping(phi, Q);
        #                 # TODO: This needs to account also for the fact that we might have already added the map here!
        #                 if not rPhi in F then 
        #                     R := Image(rPhi, Q);
        #                     psi := RepresentativeFIsomorphism(F, R, Q);
        #                     if psi = fail then 
        #                         # Deal with isoms later
        #                     else 
        #                         NewQAuts := LookupDictionary(NewAuts, FClass(F, Q));
        #                         if NewQAuts = fail then 
        #                             NewQAuts := [];
        #                             AddDictionary(NewAuts, FClass(F, Q), NewQAuts);
        #                         fi;
        #                         Add(NewQAuts, rPhi*psi);
        #                     fi;
        #                 fi;
        #             od;
        #         od;
        #     od;
        # od;

        return Objectify(NewType(FusionSystemFamily, IsGeneratedFusionSystemRep),
            rec(F := F, NewAuts := NewAuts));
    end );

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

InstallMethod(AutF,
    "Returns the automorphism group",
    [IsFusionSystem, IsGroup],
    function(F, A)
        local label, NewFAuts, AutFA, Gens;

        if IdGroupsAvailable(Size(A)) then 
            label := String(IdGroup(A));
        else 
            label := Size(A);
        fi;

        AutFA := AutF(F!.F, A);
        
        # no new maps
        if not label in RecNames(F!.NewAuts) then 
            return AutFA;
        fi;

        NewFAuts := LookupDictionary(F!.NewAuts.(label), FClass(F, A));
        # no new maps
        if NewFAuts = fail then 
            return AutFA;
        # otherwise, generate a group using AutFA and NewFAuts
        else 
            NewFAuts := List(NewFAuts, function(psi)
                local phi, phiInv;

                phi := RepresentativeFIsomorphism(F!.F, A, Source(psi));
                phiInv := RepresentativeFIsomorphism(F!.F, Image(psi), A);
                return phi * psi * phiInv;
            end );
            Gens := GeneratorsOfGroup(AutFA);
            return Group(Union(Gens, NewFAuts));
        fi;
    end );


InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsGeneratedFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        return RepresentativeFIsomorphism(F!.F, A, B);
    end );

InstallMethod(FClassReps,
    "Computes the $F$-conjugacy class of $Q$",
    [IsGeneratedFusionSystemRep, IsGroup],
    function(F, Q)
        return FClassReps(F!.F, Q);
    end );


# IsGeneratedFusionSystemRep

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
