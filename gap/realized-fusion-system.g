# For $g \in G$ and $A, B \leq G$ with $A^g \leq B$, returns the induced homomorphism.
ConjugationMap := function(A, B, g)
    return GroupHomomorphismByFunction(A, B, x -> x^g);
end;

# For $Q \leq P$ and $g \in N_P(Q)$, returns the automorphism map induced by $g$.
AutMap := function(Q, g)
    return GroupHomomorphismByFunction(Q, Q, x -> x^g);
end;

# Constructs the conjugation homomorphism from $N_G(Q) \to Aut(Q)$.
ConjugationAuts := function(G, Q)
    local NGQ, Aut;

    NGQ := Normalizer(G, Q);
    # TODO: Is there a way not to compute the automorphism group?
    Aut := AutomorphismGroup(Q);

    return GroupHomomorphismByFunction(NGQ, Aut, g -> ConjugationMap(Q, Q, g));
end;

# Computes the automorphisms of $Q$ induced by $G$.
Automizer := function(G, Q)
    return Image(ConjugationAuts(G, Q));
end;

DeclareRepresentation("IsRealizedFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["G", "P", "p"]);

DeclareOperation("RealizedFusionSystem", [IsGroup, IsGroup, IsScalar]);
InstallMethod(RealizedFusionSystem, 
    "Defines a realized fusion system F_P(G)",
    [IsGroup, IsGroup, IsScalar],
    function (P, G, p)
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

        if not(IsSubset(F!.P, Q)) then 
            Error("Q must be a subgroup of P");
        fi;

        return Automizer(F!.G, Q);
    end );

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsRealizedFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local g, NGA, Coset;
        
        if not(IsSubset(F!.P, A)) then
            Error("A must be a subgroup of P");
        elif not(IsSubset(F!.P, B)) then
            Error("B must be a subgroup of P");
        fi;

        g := RepresentativeAction(F!.G, A, B);
        if g = fail then
            return fail;
        fi;

        return ConjugationMap(A, B, g);
    end );

InstallMethod(FClass,
    "Computes the $F$-conjugacy class of $Q$",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        local P;

        P := UnderlyingGroup(F);

        if not(IsSubset(P, Q)) then 
            Error("Q must be a subgroup of P");
        fi;
        
        # We want to restrict the action to just K. Possibly this is the best way?
        return Filtered(Orbit(F!.G, Q), K -> IsSubset(P, K));
    end );

# InstallMethod(AreFConjugate,
#     "Checks whether $A$ and $B$ are $F$-conjugate",
#     [IsRealizedFusionSystemRep, IsGroup, IsGroup], 
#     function(F, A, B)
#         local g;

#         if not(IsSubset(F!.P, A)) then
#             Error("A must be a subgroup of P");
#         elif not(IsSubset(F!.P, B)) then
#             Error("B must be a subgroup of P");
#         fi;
        
#         g := RepresentativeAction(F!.G, A, B);
        
#         return g <> fail;
#     end );

# InstallMethod(IsFullyAutomized,
#     "Checks whether $Q$ is fully $F$-automized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local AllAuts, AutGQ;

#         if not(IsSubset(F!.P, Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         Auts := AutomorphismGroup(G);
#         AutGQ := Automizer(G, Q);

#         return IsSylowSubgroup(Auts, AutGQ, F!.p);
#     end );

# InstallMethod(IsFullyNormalized,
#     "Checks whether $Q$ is fully $F$-normalized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local NGQ;

#         if not(IsSubset(F!.P, Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         NGQ := Normalizer(G, Q);

#         return IsSylowSubgroup(Q, NGQ, F!.p);
#     end );


# InstallMethod(IsFullyCentralized,
#     "Checks whether $Q$ is fully $F$-centralized"
#     [IsRealizedFusionSystemRep, IsGroup],
#     function(F, Q)
#         local CGQ;

#         if not(IsSubset(F!.P, Q)) then 
#             Error("Q must be a subgroup of P");
#         fi;

#         CGQ := Centralizer(G, Q);

#         return IsSylowSubgroup(Q, CGQ, F!.p);
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
