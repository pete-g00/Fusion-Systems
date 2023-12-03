InstallMethod(IsSylowPSubgroup,
    "Checks whether $P$ is a Sylow $p$-subgroup of $G$",
    [IsGroup, IsGroup, IsInt],
    function(P, G, p)
        local SizeP, i;

        if not IsPrime(p) then 
            Error(p, " is not a prime");
        fi;

        SizeP := Size(P);
        i := LogInt(SizeP, p);
        
        # Must be a $p$-subgroup
        if SizeP <> p^i then 
            return false;
        fi;

        return Gcd(p^(i+1), Size(G)) = p^i;
    end );

ComputeIntersection := function(G, AllSylow)
    local it, int, syl;

    it := Iterator(AllSylow);
    int := NextIterator(it);

    # Look at normal subgroups of a Sylow $p$-subgroup and compare?
    # Look at 2 subgroups with maximal difference?
    
    while not IsDoneIterator(it) do
        syl := NextIterator(it);
        int := Intersection(int, syl);
        if IsNormal(G, int) then 
            return int;
        fi;
    od;

    return int;
end;

# TODO: This isn't fast! What about using the lattice to figure this out?
# But lattice also isn't fast to compute?
InstallMethod(OpSubgroup, 
    "Given a group $G$ and a prime $p$, computes the subgroup $O_p(G)$",
    [IsGroup, IsInt],
    function(G, p)
        local P, AllSylow;
        
        if not IsPrime(p) then 
            Error(p, " is not a prime");
        fi;

        P := SylowSubgroup(G, p);
        AllSylow := P^G;

        return ComputeIntersection(G, AllSylow);
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

InstallMethod(AutomizerHomomorphism,
    "Given $H \\leq G$, constructs the homomorphism $N_G(H) \\to \\Aut_G(H)$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, AutGens, Aut;
        
        if not IsSubset(G, H) then 
            Error("H is not a subset of G");
        fi;

        NGH := Normalizer(G, H);
        AutGens := List(GeneratorsOfGroup(NGH), g -> ConjugationHomomorphism(H, H, g));
        Aut := Group(AutGens);

        return GroupHomomorphismByFunction(NGH, Aut, g -> ConjugationHomomorphism(H, H, g));
    end );

InstallMethod(Automizer,
    "Constructs the automizer \\Aut_G(H) for $G \\leq H$",
    [IsGroup, IsGroup],
    function(G, H)
        return Range(AutomizerHomomorphism(G, H));
    end );

# Comparisons for FindAutHom1 and FindAutHom2:
# - G = Sym(n) and P = Sylow-2 subgroup of G
# n & 1 &  2 
# 4 & 16 & 0
# 5 & 31 & 0
# 6 & 47 & 0
# 7 & 31 & 0
# 8 & 141 & 31
# 9 & 63 & 0
# 10 & 203 & 15
# 11 & 141 & 0
# 12 & 125 & 0
# 13 & 390 & 16
# 20 & 1890 & 32
# Choosing FindAutHom1

# FindAutHom1 := function(G, H)
#     local NGH, Aut;
    
#     if not IsSubset(G, H) then 
#         Error("H is not a subset of G");
#     fi;

#     NGH := Normalizer(G, H);
#     Aut := AutomorphismGroup(H);

#     return GroupHomomorphismByFunction(NGH, Aut, g -> ConjugationHomomorphism(H, H, g));
# end;

# FindAutHom2 := function(G, H)
#     local NGH, AutGens, Aut;
    
#     if not IsSubset(G, H) then 
#         Error("H is not a subset of G");
#     fi;

#     NGH := Normalizer(G, H);
#     AutGens := List(GeneratorsOfGroup(NGH), g -> ConjugationHomomorphism(H, H, g));
#     Aut := Group(AutGens);

#     return GroupHomomorphismByFunction(NGH, Aut, g -> ConjugationHomomorphism(H, H, g));
# end;