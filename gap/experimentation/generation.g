# Given two integers $x$ and $y$ and a prime $p$, compares $x$ and $y$ with respect to the highest prime power dividing each
CompareByPrimePower := function(p, x, y)
    return PValuation(x, p) > PValuation(y, p);
end;

# Finds all conjugates in G that map A \to B
AllConjugates := function(G, A, B)
    local CGA, g;

    CGA := Centralizer(G, A);
    g := RepresentativeAction(G, A, B);

    if g = fail then
        return []; 
    fi;

    return RightCoset(CGA, g);
end;

# # Let $A, B \leq P \leq G$, and $\phi \colon A \to B$. This function tries to find a 
# # $g \in G$ such that $c_g = \phi$ on $A$, but $P$ is not normalized by $g$.
# FindSubgroup := function(G, P, phi)
#     local NGP, CGP, A, B, Coset, x, xMap, H, NHP, SmallestPossibility;

#     NGP := Normalizer(G, P);
#     CGP := Centralizer(G, P);

#     A := Source(phi);
#     B := Range(phi);

#     Coset := AllConjugates(G, A, B);
#     SmallestPossibility := fail;

#     for x in Coset do 
#         xMap := ConjugationHomomorphism(A, B, x);
#         if not x in NGP and phi = xMap then 
#             H := Group(Flat([x, GeneratorsOfGroup(A), GeneratorsOfGroup(B)]));
#             NHP := Normalizer(H, P);
#             if IsSubset(NHP, CGP) and (SmallestPossibility = fail or Size(SmallestPossibility.H) > Size(H)) then 
#                 SmallestPossibility := rec(
#                     x := x,
#                     H := H
#                 );
#             fi;
#         fi;
#     od;

#     return SmallestPossibility;
# end;

# If H \leq G, finds the subgroups in the lattice of G that are directly above H
FindSubgroupsAbove := function(G, H)
    local SubgroupsAbove, Intermediates, data, A;

    SubgroupsAbove := [];
    
    # This is too slow!
    Intermediates := IntermediateSubgroups(G, H);
    for data in Intermediates.inclusions do
        # data[1] gives where the intermediate subgroup contains 
        # (while data[2] gives the intermediate subgroup it is contained in)
        if data[1] = 0 then 
            if data[2] = Length(Intermediates.subgroups) + 1 then 
                A := G;
            else 
                A := Intermediates.subgroups[data[2]];
            fi;
            Add(SubgroupsAbove, A);
        fi;
    od;

    return SubgroupsAbove;
end;

PartitionToCoCl := function(coll, G)
    local partition, g, added, block;

    partition := [];
    for g in coll do 
        added := false;
        for block in partition do 
            if RepresentativeAction(G, block[1], g) <> fail then 
                Add(block, g);
                added := true;
                break;
            fi;
        od;

        if not added then 
            Add(partition, [g]);
        fi;
    od;

    return partition;
end;

# Given a collection of entries in G, returns a list containing representatives from each G-conjugacy class with entries in the collection
TakeRepsFromCoCl := function(coll, G)
    local elts, g;

    elts := [];
    for g in coll do
        if ForAll(elts, h -> RepresentativeAction(G, g, h) = fail) then 
            Add(elts, g);
        fi;
    od;

    return elts;
end;

FindSubgroups := function(U, F, phi)
    local P, G, p, A, B, Avoid, Normalizers, Coset, Possibilities, x, xMap, H;

    P := UnderlyingGroup(F);
    G := RealizingGroup(F);
    p := Prime(F);

    A := Source(phi);
    B := Range(phi);

    # Map already exists - nothing to do
    if phi in HomF(F, A, B) then 
        return G;
    fi;

    # the map \phi \colon A \to B should not lift to the subgroups in Avoid
    # if A <> B then there is a unique subgroup in Avoid - the join of A and B
    # otherwise, it is all of the subgroups above A
    if A = B then 
        Avoid := FindSubgroupsAbove(P, A);
    else 
        Avoid := [Group(Flat([ GeneratorsOfGroup(A), GeneratorsOfGroup(B) ]))];
    fi;

    Normalizers := List(Avoid, K -> Normalizer(U, K));

    Coset := AllConjugates(U, A, B);
    Possibilities := [];

    # TODO: Is it P or G?
    for x in TakeRepsFromCoCl(Coset, G) do 
        xMap := ConjugationHomomorphism(A, B, x);
        if phi = xMap and ForAll(Normalizers, NGH -> not x in NGH) then 
            H := Group(Flat([x, GeneratorsOfGroup(G)]));
            
            # Check we didn't add any new automorphism when taking the closure
            if ForAll(Avoid, K -> Size(Automizer(G, K)) = Size(Automizer(H, K))) then 
                Add(Possibilities, rec(x := x, H := H));
            fi;
        fi;
    od;

    return Possibilities;
end;

# Instead of checking that all non-identity elements are conjugate, we need to ensure
# that the map source and range of the map phi are conjugate (or else there's no way of getting it)
AllNonIdConjugate := function(G, A) 
    local x, y;
    # Randomly pick a non-identity elt?
    y := Elements(A)[2];

    for x in A do 
        if x <> Identity(G) and RepresentativeAction(G, x, y) = fail then
            return false;
        fi;
    od;

    return true;
end;

# FindC2C2AllConjugate := function(G, P)
#     local Elts, a, b, c, A, B, C, F1, phi1, H, F2, phi2;

#     Elts := Filtered(P, x -> not x = Identity(P));

#     a := Elts[1];
#     b := Elts[2];
#     c := Elts[3];

#     A := Group(a);
#     B := Group(b);
#     C := Group(c);

#     F1 := RealizedFusionSystem(P, P, 2);
#     phi1 := IsomorphismGroups(A, B);
    
#     H := FindSubgroup(G, F1, phi1);
#     if H = fail then 
#         return fail;
#     fi;
#     Print(H.x);

#     F2 := RealizedFusionSystem(H.H, P, 2);
#     phi2 := IsomorphismGroups(A, C);

#     return FindSubgroup(G, F2, phi2);
# end;
