InstallMethod(FindPrimeOfPrimePower, 
    "Given a prime power $q$, returns the prime $p$ whose power it is",
    [IsScalar],
    function(q)
        local p;

        p := SmallestRootInt(q);

        if IsPrime(p) then 
            return p;
        else 
            return fail;
        fi;
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
        local NGH, CGH, phi, Gens, AutGens, AutG;

        if IsGroupOfAutomorphisms(G) then 
            return Automizer(G, H);
        fi;

        if not IsSubset(G, H) then 
            Error("H is not a subset of G");
        fi;
        
        NGH := Normalizer(G, H);
        CGH := Centralizer(G, H);

        phi := NaturalHomomorphismByNormalSubgroupNC(NGH, CGH);

        Gens := GeneratorsOfGroup(Image(phi));

        if IsEmpty(Gens) then 
            return Group(IdentityMapping(H));
        fi;

        AutGens := List(Gens, 
            psi -> ConjugatorAutomorphismNC(H, PreImagesRepresentative(phi, psi)));
        
        AutG := Group(AutGens);
        SetIsAutomorphismGroup(AutG, true);

        return AutG;
    end );

OnImage := function(x, phi)
    return Image(phi, x);
end;

InstallMethod(Automizer,
    "Constructs the group of automorphisms induced on G by the group of automorphisms on some overgroup",
    [IsGroupOfAutomorphisms, IsGroup],
    function(Auts, H)
        local G, NGH, CGH, phi, Gens, AutGens, AutG;

        G := Source(Representative(Auts));
        if not IsSubset(G, H) then 
            Error("The automorphisms do not restrict to H");
        fi;

        NGH := Stabilizer(Auts, H, OnImage);
        CGH := Kernel(ActionHomomorphism(NGH, H, OnImage));

        phi := NaturalHomomorphismByNormalSubgroup(NGH, CGH);

        Gens := GeneratorsOfGroup(Image(phi));

        if IsEmpty(Gens) then 
            return Group(IdentityMapping(H));
        fi;
        
        AutGens := List(Gens, 
            psi -> GroupHomomorphismByFunction(H, H, x -> OnImage(x, PreImagesRepresentative(phi, psi))));
        
        AutG := Group(AutGens);
        SetIsAutomorphismGroup(AutG, true);

        return AutG;
    end );

InstallMethod(AutomizerHomomorphism,
    "Given $H \\leq G$, constructs the homomorphism $N_G(H) \\to \\Aut_G(H)$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, CGH, Aut;
        
        if not IsSubset(G, H) then 
            Error("H is not a subset of G");
        fi;

        NGH := Normalizer(G, H);
        CGH := Centralizer(G, H);
        
        Aut := Automizer(G, H);

        return GroupHomomorphismByFunction(NGH, Aut, 
            g -> ConjugatorAutomorphismNC(H, g), 
            false, psi -> First(RightTransversal(NGH, CGH), g -> ConjugatorAutomorphismNC(H, g) = psi));
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

# InstallMethod(NormalizesSubgroup,
#     "Checks whether the homomorphism fixes the subgroup",
#     [IsGroupHomomorphism, IsGroup],
#     function(phi, H)
#         local G;
#         G := Source(Representative(H));
#         Assert(0, IsSubset(G, H));

#         return Image(phi, G) = G;
#     end );

# InstallMethod(CentralizesSubgroup,
#     "Checks whether the homomorphism acts trivially on the given subgroup",
#     [IsGroupHomomorphism, IsGroup],
#     function(phi, H)
#         local G;
#         G := Source(phi);
#         Assert(0, IsSubset(G, H));

#         return IsRestrictedHomomorphism(phi, IdentityMapping(H));
#     end );

InstallMethod(FindHomExtension,
    "Tries to find an extension of the group homomorphism in the given collection",
    [IsGroupHomomorphism, IsCollection],
    function(phi, L)
        return First(L, psi -> IsRestrictedHomomorphism(phi, psi));
    end );

# InstallMethod(FindNormalizingHomExtension,
#     "Tries to find an extension of the group homomorphism in the given collection that fixes the subgroup",
#     [IsGroupHomomorphism, IsCollection, IsGroup],
#     function(phi, L, H)
#         local G;
#         G := Source(phi);
#         Assert(0, IsSubset(G, H));

#         return First(L, psi -> NormalizesSubgroup(psi, H) and IsRestrictedHomomorphism(phi, psi));
#     end );

# InstallMethod(FindCentralizingHomExtension,
#     "Tries to find an extension of the group homomorphism in the given collection that acts trivially on the subgroup",
#     [IsGroupHomomorphism, IsCollection, IsGroup],
#     function(phi, L, H)
#         local G;
#         G := Source(phi);
#         Assert(0, IsSubset(G, H));

#         return First(L, psi -> CentralizesSubgroup(psi, H) and IsRestrictedHomomorphism(phi, psi));
#     end );

InstallMethod(IsStronglyPEmbedded,
    "Checks whether M is strongly p-embedded in G",
    [IsGroup, IsGroup, IsScalar],
    function(G, M, p)
        local NGM;

        if PValuation(Size(G), p) <> PValuation(Size(M), p) then 
            return false;
        fi;

        NGM := Normalizer(G, M);

        # Transversing NGM to avoid duplicate M^g tests
        return ForAll(RightTransversal(G, NGM), g -> g in M or PValuation(Size(Intersection(M, M^g)), p) = 0);
    end );

InstallGlobalFunction(UnionEnumerator, function(printFn, colls, fam...)
    local LenFn;

    if IsEmpty(fam) then 
        if IsEmpty(colls) then 
            Error("Type not given for an empty collection");
        fi;

        fam := FamilyObj(colls[1]);
    else 
        fam := fam[1];
    fi;

    LenFn := Length;
    if not IsEmpty(colls) and IsCollection(colls[1]) then 
        LenFn := Size;
    fi;

    if not IsEmpty(colls) and ForAll(colls, coll -> IsListOrCollection(colls) and FamilyObj(colls) = fam) then 
        Error(String(colls));
    fi;

    return EnumeratorByFunctions(CollectionsFamily(fam),
        rec(
            ElementNumber := function ( enum, n )
                local i, k;

                i := 0;
                k := 1;
                
                while n > i + LenFn(enum!.colls[k]) do 
                    i := i + LenFn(enum!.colls[k]);
                    k := k+1;
                od;
                
                return enum!.colls[k][n-i];
            end,
            NumberElement := function( enum, elm )
                local offset, k, i;

                offset := 0;
                for k in [1..LenFn(enum!.colls)] do
                    i := Position(enum!.colls[k], elm);
                    if i <> fail then 
                        return offset + i;
                    fi;

                    offset := offset + LenFn(enum!.colls[k]);
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
