InstallMethod(RealizedFusionSystem, 
    "Constructs a realized fusion system F_P(G)",
    [IsGroup, IsGroup, IsScalar],
    function (G, P, p)
        local i, SizeP;

        if not (IsSubset(G, P)) then 
            Error("P must be a subgroup of G");
        elif not IsPrime(p) then
            Error("p is not a prime");
        fi;

        SizeP := Size(P);
        i := LogInt(SizeP, p);
        if p^i <> SizeP then 
            Error("P is not a p-subgroup");
        fi;

        return Objectify(NewType(FusionSystemFamily, IsRealizedFusionSystemRep), 
            rec(G := G, P := P, p := p));
    end );

InstallMethod(UnderlyingGroup,
    "Returns the group on which the fusion system $F$ is",
    [IsRealizedFusionSystemRep],
    function (F)
        return F!.P;
    end );

InstallMethod(RealizingGroup,
    "Returns the group that realizes the fusion system $F$",
    [IsRealizedFusionSystemRep],
    function (F)
        return F!.G;
    end );

InstallMethod(Prime,
    "Returns the p-group on which the fusion system $F$ is",
    [IsRealizedFusionSystemRep],
    function (F)
        return F!.p;
    end );

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsRealizedFusionSystemRep, IsGroup],
    function (F, Q)
        local FNormalizer;

        if not(IsSubset(UnderlyingGroup(F), Q)) then 
            Error("Q must be a subgroup of P");
        fi;

        return Automizer(RealizingGroup(F), Q);
    end );

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsRealizedFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local g, NGA, Coset;
        
        if not(IsSubset(UnderlyingGroup(F), A)) then
            Error("A must be a subgroup of P");
        elif not(IsSubset(UnderlyingGroup(F), B)) then
            Error("B must be a subgroup of P");
        fi;

        g := RepresentativeAction(RealizingGroup(F), A, B);
        if g = fail then
            return fail;
        fi;

        return ConjugationHomomorphism(A, B, g);
    end );

# Trying these versions on Sylow-2 subgroups of S_n for:
# n & 1 & 2
# 10 & 63 & 0
# 12 & 16 & 0
# Second method seems to be faster somehow - choosing that version
# # Constructing F-class from N_G(P)
# FClass_1 := function(F, Q)
#     local P, G, NGP, classes, x, R, found, class;

#     P := UnderlyingGroup(F);
#     G := RealizingGroup(F);
#     NGP := Normalizer(G, P);

#     classes := [];
#     # Find right cosets of G in NGP and try to find new co-classes
#     for x in RightTransversal(G, NGP) do 
#         R := Q^x;
#         if not IsSubset(P, R) then 
#             break;
#         fi;
#         found := false;
#         for class in classes do 
#             if R in class then 
#                 found := true;
#                 break;
#             fi;
#         od;

#         if not found then 
#             Add(classes, R^NGP);
#         fi;
#     od;

#     return classes;
# end;

# # Constructing F-class from G
# FClass_2 := function(F, Q)
#     local P, G, NGP;

#     P := UnderlyingGroup(F);
#     G := RealizingGroup(F);

#     return Filtered(Q^G, R -> IsSubset(P, R));
# end;

# This version is slower - check out how a conjugacy class is computed to see if there's some way to be more efficient
# FClass_Alt := function(F, Q)
#     local P, G, NGQ, Reps, elms, x;

#     P := UnderlyingGroup(F);
#     G := RealizingGroup(F);

#     NGQ := Normalizer(G, Q);
#     Reps := RightTransversal(G, NGQ);
    
#     elms := [];

#     for x in Reps do
#         if IsSubset(P, Q^x) then 
#             Add(elms, Q^x);
#         fi;
#     od;

#     return EnumeratorByFunctions(Domain(elms), rec(
#         elms := elms,
#         ElementNumber := function(enum, i)
#             return enum!.elms[i];
#         end,
#         NumberElement := function(enum, R)
#             return Position(enum!.elts, R);
#         end,
#         Length := enum -> Length(elms),
#         PrintObj := function(enum)
#             Print(Q, "^F");
#         end,
#     ));
# end;

InstallMethod(FClass,
    "Computes the $F$-conjugacy class of $Q$",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        local P, G, class, enum, indices, i;

        P := UnderlyingGroup(F);
        G := RealizingGroup(F);

        if not(IsSubset(P, Q)) then 
            Error("Q must be a subgroup of P");
        fi;

        # find the class Q^G and filter the subgroups that lie in P
        class := Q^G;
        enum := Enumerator(class);
        indices := [];

        for i in [1..Size(class)] do 
            if IsSubset(P, enum[i]) then 
                Add(indices, i);
            fi;
        od;
        
        return EnumeratorByFunctions(class, rec(
            ElementNumber := function(enum, i)
                return enum!.enum[enum!.indices[i]];
            end,
            NumberElement := function(enum, val)
                return Position(enum!.indices, Position(enum!.enum, val));
            end,
            Length := enum -> Length(indices),
            PrintObj := function(enum)
                Print(Q, "^F");
            end,
            enum := enum,
            indices := indices,
        ));
    end );

# For A \leq P \leq G,
# \cl_G(A) = \bigcup_{g \in G} \cl_P(A^g)
# \cl_G(A) = \bigcup_{g \in G} \cl_{N_P(G)}(A^g)

# Compute F-classes from G:
# 

# # Uses Nested For Loops, and builds from conjugacy class of P
# FClasses_A1 = function(F)
#     P := UnderlyingGroup(F);
#     G := RealizingGroup(F);

#     CoClasses := ConjugacyClassesSubgroups(P);

#     FClassesList := [];
#     Added = List([1..Size(CoClasses)], x -> false);
    
#     for i in [1..Size(CoClasses)] do 
#         if not Added[i] then 
#             A := Representative(CoClasses[i]);
#             for j in [(i+1)..Size(CoClasses)] do
#                 if not Added[j] then 
#                     B := Representative(CoClasses[j]);
#                     if RepresentativeAction(G, A, B) then 
#                         # 
#                         break;
#                     fi;
#                 fi;
#             od;
#         fi;
#     od;

# end;

# FClasses_A2 := function(F)
#     local P, G, i, A, B, Current_Class_List, F_Classes, Added, Classes, Co_Classes, Len;
        
#         P := UnderlyingGroup(F);
#         G := RealizingGroup(F);

#         Co_Classes := ConjugacyClassesSubgroups(P);

#         # F_Class => dictionary with key the size of the groups, and values list of list of 
#         # conjugacy classes (the normal representation of conjugacy classes)
#         # TODO: Use string keys- for small groups, use isomorphism class, but for big groups, just use the group size
#         F_Classes := NewDictionary(0, true);

#         for i in [1..Size(Co_Classes)] do 
#             A := Representative(Co_Classes[i]);
#             Len := Size(A);
#             Current_Class_List := LookupDictionary(F_Classes, Len);
#             if Current_Class_List = fail then 
#                 Current_Class_List := [];
#             fi;
            
#             Added := false;
            
#             for Classes in Current_Class_List do 
#                 B := Representative(Classes);
#                 if RepresentativeAction(G, A, B) <> fail then 
#                     Add(Classes, Co_Classes[i]);
#                     Added := true;
#                     break;
#                 fi;
#             od;

#             if not Added then 
#                 Add(Current_Class_List, [Co_Classes[i]]);
#             fi;

#             AddDictionary(F_Classes, Len, Current_Class_List);
#         od;

#         return F_Classes;
# end;

InstallMethod(FClasses,
    "Computes all the $F$-conjugacy classes",
    [IsRealizedFusionSystemRep],
    function(F)
        local P, G, p, NGP, Q, QCoClasses, HaveEncountered, FCoClasses, class, A, NGA, Elms, Elm, i, j;

        P := UnderlyingGroup(F);
        G := RealizingGroup(F);
        p := Prime(F);
        
        # # look at a Sylow p-subgroup of N_G(P)- computing conjugacy classes subgroups for a p-groups is much faster,
        # # and by looking within the normalizer, we can easily filter the right conjugacy classes
        NGP := Normalizer(G, P);
        Q := SylowSubgroup(NGP, p);

        QCoClasses := ConjugacyClassesSubgroups(Q);
        HaveEncountered := List(QCoClasses , x -> false);
        FCoClasses := [];
        i := 1;

        while i <= Length(QCoClasses) do 
            if not HaveEncountered[i] then 
                class := QCoClasses[i];
                A := Representative(class);

                if IsSubset(P, A) then 
                    NGA := Normalizer(G, A);
                    Elms := RightTransversal(G, NGA);

                    # Remove all the G-conjugates that weren't Q-conjugates
                    for Elm in Elms do 
                        # TODO: How do we make this not redundant?
                        if not (Elm in NGA) and IsSubset(P, A^Elm) then 
                            j := Position(QCoClasses, (A^Elm)^Q, i);
                            if j <> fail then 
                                HaveEncountered[j] := true;
                                i := i+1;
                            fi;
                        fi;
                    od;

                    Add(FCoClasses, FClass(F, A));
                fi;
            fi;
            i := i+1;
        od;

        return FCoClasses;
    end );

# CompleteFClass := function(F)
# local P, G, i, A, B, Current_Class_List, F_Classes, Added, Classes, Co_Classes, Len;

# P := UnderlyingGroup(F);
# G := RealizingGroup(F);
# Co_Classes := ConjugacyClassesSubgroups(P);

# # F_Class => dictionary with key the size of the groups, and values list of list of conjugacy classes 
# (the normal representation of conjugacy classes)
# # TODO: Use string keys- for small groups, use isomorphism class, but for big groups, just use the group size
# F_Classes := NewDictionary(0, true);

# for i in [1..Size(Co_Classes)] do 
#     A := Representative(Co_Classes[i]);
#     Len := Size(A);
#     Current_Class_List := LookupDictionary(F_Classes, Len);
#     if Current_Class_List = fail then 
#         Current_Class_List := [];
#     fi;
    
#     Added := false;
    
#     for Classes in Current_Class_List do 
#         B := Representative(Classes);
#         if RepresentativeAction(G, A, B) <> fail then 
#             Add(Classes, Co_Classes[i]);
#             Added := true;
#             break;
#         fi;
#     od;

#     if not Added then 
#         Add(Current_Class_List, [Co_Classes[i]]);
#     fi;

#     AddDictionary(F_Classes, Len, Current_Class_List);
# od;

# return F_Classes;

# InstallMethod(AreFConjugate,
#     "Checks whether $A$ and $B$ are $F$-conjugate",
#     [IsRealizedFusionSystemRep, IsGroup, IsGroup], 
#     function(F, A, B)
#         local g;

#         if not(IsSubset(UnderlingGroup(F), A)) then
#             Error("A must be a subgroup of P");
#         elif not(IsSubset(UnderlingGroup(F), B)) then
#             Error("B must be a subgroup of P");
#         fi;
        
#         g := RepresentativeAction(RealizingGroup(F), A, B);
        
#         return g <> fail;
#     end );

# InstallMethod(IsFullyAutomized,
#     "Checks whether $Q$ is fully $F$-automized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local AllAuts, AutGQ;

#         if not(IsSubset(UnderlingGroup(F), Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         Auts := AutomorphismGroup(G);
#         AutGQ := Automizer(G, Q);

#         return IsSylowSubgroup(Auts, AutGQ, UnderlingGroup(F));
#     end );

# InstallMethod(IsFullyNormalized,
#     "Checks whether $Q$ is fully $F$-normalized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local NGQ;

#         if not(IsSubset(UnderlingGroup(F), Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         NGQ := Normalizer(G, Q);

#         return IsSylowSubgroup(Q, NGQ, UnderlingGroup(F));
#     end );


# InstallMethod(IsFullyCentralized,
#     "Checks whether $Q$ is fully $F$-centralized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local CGQ;

#         if not(IsSubset(UnderlingGroup(F), Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         CGQ := Centralizer(G, Q);

#         return IsSylowSubgroup(Q, CGQ, UnderlingGroup(F));
#     end );

# `IsFReceptive(F, A)` that takes a fusion system `F`, and a subgroup `A`, and checks whether `A` is receptive in `F`.
# `IsFCentric(F, A)` that takes a fusion system `F`, and a subgroup `A`, and checks whether `A` is `F`-centric.
# `IsFRadical(F, A)` that takes a fusion system `F`, and a subgroup `A`, and checks whether `A` is `F`-radical.
# `IsEssentialSubgroup(P, A)` that takes a p-group `P` and a subgroup `A`, and checks whether `A` is an essential subgroup.

# `Intersect(F, E)` that takes 2 fusion systems `F` and `E` and returns their intersection.
# `AddMap(F, phi)` that constructs a fusion system generated by `F` and `phi` a morphism between any two subgroups.
# `AddMapSaturated(F, phi)` that tries to construct a saturated fusion system generated by a saturated fusion system `F` and `phi` an automorphism of a centric subgroup.
# `IsSaturated(F)` that checks whether `F` is a saturated fusion system.
# `IsExotic(F)` that checks whether `F` is an exotic fusion system.
# `IsomorphismFusionSystems(F, E)` that checks whether `F` and `E` are isomorphic as fusion systems.
