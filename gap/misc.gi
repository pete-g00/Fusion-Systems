RemoveRedundantGenerators := function(L)
    local A, i, j;

    i := First([1..Length(L)], i -> Order(L[i]) > 1);
    if i = fail then 
        return [L[1]];
    fi;

    A := [L[i]];
    for j in [i..Length(L)] do
        if Order(L[j]) > 1 and not L[j] in Group(A) then 
            Add(A, L[j]);
        fi;
    od;

    return A;
end;

Join := function(L...)
    if Length(L) = 0 then 
        Error("Cannot join empty");
    fi;

    if Length(L) = 1 and IsList(L[1]) then 
        L := L[1];
    fi;

    return Group(RemoveRedundantGenerators(Flat(List(L, GeneratorsOfGroup))));
end;

InstallGlobalFunction(OnImage, function(x, phi)
    return Image(phi, x);
end );

InstallGlobalFunction(OnHomConjugation, function(phi, psi)
    local A, C, CGens, CImageGens;

    A := Source(phi);
    C := Image(psi, A);
    
    if phi = IdentityMapping(A) then 
        return IdentityMapping(C);
    fi;

    psi := RestrictedHomomorphism(psi, A, C);

    return InverseGeneralMapping(psi) * phi * psi;
end );

InstallGlobalFunction(OnHomListConjugation, function(L, psi)
    return List(L, phi -> OnHomConjugation(phi, psi));
end );

InstallGlobalFunction(OnAutGroupConjugation, function(A, psi)
    local B;

    B := Group(OnHomListConjugation(GeneratorsOfGroup(A), psi));
    if IsInjective(psi) then 
        SetSize(B, Size(A));
    fi;

    return B;
end );

InstallGlobalFunction(OnCoCl, function(P)
    return function(x, phi)
        return Image(phi, Representative(x))^P;
    end;
end );

InstallMethod(RestrictedHomomorphism, 
    "Given a homomorphism $\\phi \\colon P \\to Q$, and $A \\leq P$ and $Q \\leq B$, returns the induced homomorphism $\\psi \\colon A \\to B$",
    [IsGroupHomomorphism, IsGroup, IsGroup],
    function(phi, A, B)
        local P, Q;

        P := Source(phi);
        if not IsSubset(P, A) then 
            Error("A is not a subgroup of the domain.");
        fi;

        Q := Image(phi, A);
        if not IsSubset(B, Q) then 
            Error("The codomain is not a subgroup of B.");
        fi;

        return RestrictedHomomorphismNC(phi, A, B);
    end);

InstallMethod(RestrictedHomomorphismNC,
    "Given a homomorphism $\\phi \\colon P \\to Q$, and $A \\leq P$ and $Q \\leq B$, returns the induced homomorphism $\\psi \\colon A \\to B$",
    [IsGroupHomomorphism, IsGroup, IsGroup],
    function(phi, A, B)
        local AGens, ImageAGens;
    
        AGens := GeneratorsOfGroup(A);
        ImageAGens := List(AGens, a -> Image(phi, a));
        return GroupHomomorphismByImagesNC(A, B, AGens, ImageAGens);
    end);

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
        return GroupHomomorphismByFunction(A, B, x -> x^g);
    end );


InstallMethod(Automizer,
    "Constructs the automizer \\Aut_G(H) for $G \\leq H$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, L, AutGH;

        if IsGroupOfAutomorphisms(G) then 
            return Automizer(G, H);
        fi;

        NGH := Normalizer(G, H);

        L := RemoveRedundantGenerators(List(GeneratorsOfGroup(NGH), a -> ConjugatorAutomorphismNC(H, a)));
        if IsEmpty(L) then 
            return Group(IdentityMapping(H));
        fi;

        AutGH := Group(L);
        SetIsGroupOfAutomorphisms(AutGH, true);

        return AutGH;
    end );

InstallMethod(Automizer,
    "Constructs the group of automorphisms induced on G by the group of automorphisms on some overgroup",
    [IsGroupOfAutomorphisms, IsGroup],
    function(Auts, H)
        local G, A, f1, f2, fAuts, fH, AutfAH, AutAH;

        G := Source(Representative(Auts));
        if not IsSubset(G, H) then 
            Error("The automorphisms do not restrict to H");
        fi;

        A := SemidirectProduct(Auts, G);
        f1 := Embedding(A, 1);
        f2 := Embedding(A, 2);
        
        fAuts := Image(f1);
        fH := Image(f2, H);

        AutfAH := Automizer(fAuts, fH);
        AutAH := OnAutGroupConjugation(AutfAH, RestrictedInverseGeneralMapping(f2));
        SetIsGroupOfAutomorphisms(AutAH, true);

        return AutAH;
    end );

InstallMethod(NPhi,
    "Given a map $\\phi$, computes $N_\\phi$ in $P$",
    [IsGroup, IsGroupHomomorphism],
    function(P, phi)
        local Q, R, CPQ, NPQ, AutPR, NPhiGens, QCPQ, g, N;

        Q := Source(phi);
        R := Image(phi);

        CPQ := Centralizer(P, Q);
        NPQ := Normalizer(P, Q);
        AutPR := Automizer(P, R);

        NPhiGens := Union(GeneratorsOfGroup(Q), GeneratorsOfGroup(CPQ));
        QCPQ := Group(NPhiGens);

        # Transverse NPQ in QCPQ and find all those g such that c_g^\phi \in \Aut_P(R)
        for g in RightTransversal(NPQ, QCPQ) do 
            if not g in Group(NPhiGens) and ConjugatorAutomorphismNC(P, g)^phi in AutPR then 
                Add(NPhiGens, g);

                if Group(NPhiGens) = NPQ then 
                    return NPQ;
                fi;
            fi;
        od;

        return Group(NPhiGens);
    end );

InstallMethod(AutomizerHomomorphism,
    "Given $H \\leq G$, constructs the homomorphism $N_G(H) \\to \\Aut_G(H)$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, CGH, Aut;

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
