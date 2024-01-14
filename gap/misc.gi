InstallMethod(IsSylowPSubgroup,
    "Checks whether $P$ is a Sylow $p$-subgroup of $G$",
    [IsGroup and IsFinite, IsGroup and IsFinite, IsInt],
    function(P, G, p)
        return PValuation(Size(P), p) = PValuation(Size(G), p);
    end );

InstallMethod(ConjugationHomomorphism,
    "For $Q \\leq P$ and $g \\in N_P(Q)$, returns the automorphism map induced by $g$",
    [IsGroup, IsGroup, IsObject],
    function(A, B, g)
        if not IsSubset(B, A^g) then 
            Error("A^g is not a subset of B");
        fi;
        return GroupHomomorphismByFunction(A, B, x -> x^g);
    end );

InstallMethod(Automizer,
    "Constructs the automizer \\Aut_G(H) for $G \\leq H$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, AutGens, AutG;
        
        NGH := Normalizer(G, H);
        AutGens := List(GeneratorsOfGroup(NGH), g -> ConjugationHomomorphism(H, H, g));
        
        AutG := Group(AutGens);
        SetIsAutomorphismGroup(AutG, true);

        return AutG;
    end );

InstallMethod(AutomizerHomomorphism,
    "Given $H \\leq G$, constructs the homomorphism $N_G(H) \\to \\Aut_G(H)$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, Aut;
        
        if not IsSubset(G, H) then 
            Error("H is not a subset of G");
        fi;

        NGH := Normalizer(G, H);
        Aut := Automizer(G, H);

        return GroupHomomorphismByFunction(NGH, Aut, g -> ConjugationHomomorphism(H, H, g));
    end );

InstallMethod(IsRestrictedHomomorphism,
    "Given two homomorphisms $\\phi$ and $\\psi$, checks whether $\\psi$ is a restriction of $\\phi$",
    [IsGroupHomomorphism, IsGroupHomomorphism],
    function(psi, phi)
        local G, H, GensH, x;

        G := Source(phi);
        H := Source(psi);

        Assert(0, IsSubset(G, H));

        if not IsFinitelyGeneratedGroup(H) then 
            TryNextMethod();
        fi;

        # Check they both map the generators of H to the same set
        GensH := GeneratorsOfGroup(H);

        for x in GensH do 
            if phi(x) <> psi(x) then 
                return false;
            fi;
        od;
        
        return true;
    end );


InstallMethod(NormalizesSubgroup,
    "Checks whether the homomorphism fixes the subgroup",
    [IsGroupHomomorphism, IsGroup],
    function(phi, H)
        local G;
        G := Source(Representative(H));
        Assert(0, IsSubset(G, H));

        return Image(phi, G) = G;
    end );

InstallMethod(CentralizesSubgroup,
    "Checks whether the homomorphism acts trivially on the given subgroup",
    [IsGroupHomomorphism, IsGroup],
    function(phi, H)
        local G;
        G := Source(phi);
        Assert(0, IsSubset(G, H));

        return IsRestrictedHomomorphism(phi, IdentityMapping(H));
    end );

InstallMethod(FindHomExtension,
    "Tries to find an extension of the group homomorphism in the given collection",
    [IsGroupHomomorphism, IsCollection],
    function(phi, L)
        return First(L, psi -> IsRestrictedHomomorphism(phi, psi));
    end );

InstallMethod(FindNormalizingHomExtension,
    "Tries to find an extension of the group homomorphism in the given collection that fixes the subgroup",
    [IsGroupHomomorphism, IsCollection, IsGroup],
    function(phi, L, H)
        local G;
        G := Source(phi);
        Assert(0, IsSubset(G, H));

        return First(L, psi -> NormalizesSubgroup(psi, H) and IsRestrictedHomomorphism(phi, psi));
    end );

InstallMethod(FindCentralizingHomExtension,
    "Tries to find an extension of the group homomorphism in the given collection that acts trivially on the subgroup",
    [IsGroupHomomorphism, IsCollection, IsGroup],
    function(phi, L, H)
        local G;
        G := Source(phi);
        Assert(0, IsSubset(G, H));

        return First(L, psi -> CentralizesSubgroup(psi, H) and IsRestrictedHomomorphism(phi, psi));
    end );

InstallGlobalFunction(UnionEnumerator, function(printFn, colls, type)
    if not IsEmpty(colls) and ForAll(colls, coll -> IsListOrCollection(colls) and FamilyObj(colls) = FamilyObj(colls[1])) then 
        Error("Not all collections or collections of different type provided");
    fi;

    return EnumeratorByFunctions(type,
        rec(
            ElementNumber := function ( enum, n )
                local i, k;

                i := 0;
                k := 1;
                
                while n > i + Length(enum!.colls[k]) do 
                    i := i + Length(enum!.colls[k]);
                    k := k+1;
                od;
                
                return enum!.colls[k][n-i];
            end,
            NumberElement := function( enum, elm )
                local offset, k, i;

                offset := 0;
                for k in [1..Length(enum!.colls)] do
                    i := Position(enum!.colls[k], elm);
                    if i <> fail then 
                        return offset + i;
                    fi;

                    offset := offset + Length(enum!.colls[k]);
                od;

                return fail;
            end,
            Length := function( enum )
                return Sum(List(enum!.colls, Size));
            end,
            PrintObj := function( enum )
                printFn();
            end,
            colls := colls
        )
    );
end );

# OnImage := function(x, phi)
#     return Image(phi, x);
# end;

# OnGroupImage := function(P, phi) 
#     return Image(phi, P);
# end;

# Given:
# - an isomorphism \phi \colon P \to Q;
# - subgroups P \leq A and Q \leq B
# - an isomorphism \Phi \colon A \to B;
# - a subgroup H \leq \Aut(A),
# finds a map \psi \colon A \to B that extends \phi, with \psi \in H*\phi.
# InstallMethod(FindHomExtension, 
#     "Given a map $\\phi \\colon P \\to Q$ and a subgroup $H \\leq \\Aut(P)$, with $B \\leq P$ and an isomorphism $\\Phi \\colon P \\to Q$, with tries to find an extension in $H$ of the map $\\phi$", 
#     [IsGroupHomomorphism, IsAutomorphismGroup, IsGroupHomomorphism],
#     function(phi, H, psi)
#         local P, Q, A, B, InvPsi, QPrime, alpha, PNormalizer, PCentralizer, mu, beta;

#         P := Source(phi);
#         Q := Image(phi);

#         A := Source(psi);
#         B := Source(psi);
        
#         Assert(0, IsSubset(A, P));
#         Assert(0, IsSubset(B, Q));
#         Assert(0, Identity(H) = IdentityMapping(A));
        
#         InvPsi := InverseGeneralMapping(psi);
#         QPrime := Image(InvPsi, Q);

#         alpha := RepresentativeAction(H, P, QPrime, OnGroupImage);

#         if alpha = fail then 
#             return fail;
#         fi;

#         # Find the automorphisms in A that stabilize P
#         # Then find the kernel of the action (i.e. those that restrict to the identity in P), and go through each representative
#         PNormalizer := Stabilizer(H, P, OnGroupImage);
#         PCentralizer := Kernel(ActionHomomorphism(PNormalizer, P));

#         # Transverse the cosets and find a map that extends phi
#         for mu in RightTransversal(PNormalizer, PCentralizer) do 
#             # mu : A -> A (a map modulo the action on P)
#             # alpha : A -> A (that maps P -> Q')
#             # psi : A -> B (that maps Q' -> Q)
#             beta := mu*alpha*psi;
#             if IsRestrictedHomomorphism(beta, phi) then 
#                 return beta;
#             fi;
#         od;

#         return fail;
#     end );

# InstallMethod(FindNormalizingAutExtension, 
#     "Given a map $\\phi \\colon A \\to B$, $Q \\leq A$ and a subgroup $H \\leq \\Aut(P)$, with $B \\leq P$, tries to find an extension in $H$ of the map $\\phi$", 
#     [IsGroupHomomorphism, IsAutomorphismGroup, IsGroup],
#     function(phi, A, Q)
#         local P, PNormalizer, PCentralizer, psi;

#         P := Source(phi);

#         # Find the automorphisms in A that stabilize P
#         # Then find the kernel of the action (i.e. those that restrict to the identity in P), and go through each representative
#         PNormalizer := Stabilizer(A, P, OnGroupImage);
#         PCentralizer := Kernel(ActionHomomorphism(PNormalizer, P));

#         # Transverse the cosets and find a map that extends phi
#         for psi in RightTransversal(PNormalizer, PCentralizer) do 
#             if IsRestrictedHomomorphism(phi, psi) then 
#                 return psi;
#             fi;
#         od;

#         return fail;
#     end );
