InstallMethod(IsSylowPSubgroup,
    "Checks whether $P$ is a Sylow $p$-subgroup of $G$",
    [IsGroup and IsFinite, IsGroup and IsFinite, IsInt],
    function(P, G, p)
        return Size(P) = PValuation(Size(G), p);
    end );

# # Not the best method for solvable groups, but quite good nonetheless
# OpSubgroup_Alt := function (G, p)
#     local   P,         # a Sylow-p subgroup
#             R,         # the largest p-subgroup we know of
#             C,         # one conjugacy class of <P>
#             g,         # representative of a conjugacy class of <P>
#             M;         # normal closure of <R> and <g>

#     P := SylowSubgroup(G, p);
#     if IsNormal(G, P) then 
#         return P;
#     fi;

#     R := TrivialSubgroup(G);

#     for C in ConjugacyClasses(P) do
#         g := Representative(C);
#         if not g in R then
#             M := NormalClosure(G, ClosureGroup(R, g));
#             # increase the size of the normal p-subgroup as long as it is a p-group
#             if PValuation(p, Size(M)) <> fail then
#                 R := M;
#             fi;
#         fi;
#     od;

#     return R;
# end;

InstallMethod(OpSubgroup, 
    "Given a group $G$ and a prime $p$, computes the subgroup $O_p(G)$",
    [IsGroup, IsInt],
    function(G, p)
        local P, Normals, Normal, Op, OpSize, i;
        
        if not IsPrime(p) then 
            Error(p, " is not a prime");
        fi;

        P := SylowSubgroup(G, p);
        if IsNormal(G, P) then 
            return P;
        fi;

        # Find the largest normal p-subgroup
        Normals := NormalSubgroupsAbove(G, TrivialSubgroup(G), []);
        
        Op := Group(Identity(G));
        OpSize := 0;

        for Normal in Normals do 
            i := PValuation(p, Size(Normal));
            if i <> fail and i > OpSize then 
                Op := Normal;
                OpSize := i;
            fi;
        od;

        return Op;
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
        local NGH, Aut;
        
        if not IsSubset(G, H) then 
            Error("H is not a subset of G");
        fi;

        NGH := Normalizer(G, H);
        Aut := Automizer(G, H);

        return GroupHomomorphismByFunction(NGH, Aut, g -> ConjugationHomomorphism(H, H, g));
    end );

InstallMethod(Automizer,
    "Constructs the automizer \\Aut_G(H) for $G \\leq H$",
    [IsGroup, IsGroup],
    function(G, H)
        local NGH, AutGens;
        
        NGH := Normalizer(G, H);
        AutGens := List(GeneratorsOfGroup(NGH), g -> ConjugationHomomorphism(H, H, g));
        
        return Group(AutGens);
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
# Choosing FindAutHom2

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