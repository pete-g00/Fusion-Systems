# Given 2 F-conjugate subgroups A and B, Aut_F(A) and an isomorphism phi \colon A \to B, constructs all the isomorphisms
ConstructAllIsomorphisms := function(A, B, AutFA, phi)
    return List(AutFA, psi -> psi * phi);
end;

# Given set $A$ and $B$ with $A \leq B$, returns the inclusion map $\iota \colon A \to B$.
InclusionMap := function(A, B)
    local id;

    id := IdentityMapping(B);
    return RestrictedMapping(id, A);
end;

## given 2 F-conjugates $A$ and $Q$, with $Q \leq B$, constructs the hom maps $A \to B$ that are inclusions of an isomorphism $A \to Q$.
ConstructHomMaps := function(F, A, Q, B, AutFA)
    local phi;

    phi := RepresentativeFIsomorphism(F, A, Q);

    return List(ConstructAllIsomorphisms(A, Q, AutFA, phi), psi -> psi * InclusionMap(Q, B));
end;

# Conjugates a list of elements by phi
ConjugateList := function(Elts, phi)
    return List(Elts, x -> x^phi);
end;

InstallMethod(HomF, 
    "Given a fusion system $F$ on $P$, returns the Hom-$F$ set of $A, B \\leq P$",
    [IsFusionSystem, IsGroup, IsGroup],
    function(F, A, B)
        local AClass, ShouldAdd, AutFA;

        if Size(A) > Size(B) then 
            return [];
        fi;

        AClass := FClass(F, A);
        ShouldAdd := Filtered(AClass, Q -> IsSubset(B, Q));
        AutFA := AutF(F, A);

        return Flat(List(ShouldAdd, Q -> ConstructHomMaps(F, A, Q, B, AutFA)));
    end );

# Checks whether the groups A and B could be F-conjugate.
# Checks their order as well as their isomorphism class if they are small
CouldBeFConjugate := function(A, B, p)
    local size_A, size_B, limit_size, id_A, id_B;
        
    size_A := Size(A);
    size_B := Size(B);

    if size_A <> size_B then 
        return false;
    fi;

    # The limitations of the IdGroup command. For primes p > 5, this only works for p^4, but for smaller primes, it works for higher powers
    # Using this allows us not to check for size but also for isomorphism classes and is optimal,
    # especially given there are many more subgroups of small size
    if p = 2 then 
        limit_size := 2^8;
    elif p = 3 then 
        limit_size := 3^6;
    elif p = 5 then 
        limit_size := 5^5;
    else
        limit_size := p^4;
    fi;

    if size_A < limit_size then 
        id_A := IdGroup(A);
        id_B := IdGroup(B);

        return id_A = id_B;
    fi;

    return true;
end;

InstallMethod(AreFConjugate, 
    "Given a fusion system $F$ on $P$, checks whether the two subgroups $A$ and $B$ are $F$-conjugate",
    [IsFusionSystem, IsGroup, IsGroup],
    function (F, A, B) 
        local g, AClass;
    
        # Check whether A and B are conjugate in P
        g := RepresentativeAction(UnderlyingGroup(F), A, B);
        if g <> fail then 
            return true;
        fi;

        # Check whether A and B could actually be conjugate
        if not CouldBeFConjugate(A, B, Prime(F)) then 
            return true;
        fi;

        AClass := FClass(F, A);
        return B in AClass;
    end );

InstallMethod(IsFullyNormalized,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is fully $F$-normalized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, QClass, NPQ, R, NPR;

        P := UnderlyingGroup(F);
        QClass := FClass(F, Q);

        NPQ := Normalizer(P, Q);

        for R in QClass do
            NPR := Normalizer(P, R);
            if Size(NPR) > Size(NPQ) then 
                return false;
            fi;
        od;

        return true;
    end );

InstallMethod(IsFullyCentralized,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is fully $F$-centralized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, QClass, CPQ, R, CPR;

        P := UnderlyingGroup(F);
        QClass := FClass(F, Q);

        CPQ := Centralizer(P, Q);

        for R in QClass do
            CPR := Centralizer(P, R);
            if Size(CPR) > Size(CPQ) then 
                return false;
            fi;
        od;

        return true;
    end );

InstallMethod(IsFullyAutomized,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is fully $F$-automized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local AutFQ, Auts;

        AutFQ := AutF(Q);
        Auts := AutomorphismGroup(Q);

        return IsSylowPSubgroup(AutFQ, Auts, Prime(F));
    end );

# DeclareOperation("NPhi", [IsFusionSystem, IsGroupHomomorphism]);
InstallMethod(NPhi,
    "Given a fusion system $F$ on $P$ and a map $\\phi$ in $F$, computes $N_\\phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        local P, Q, R, CMap, AutPQ, AutPR, AutPRPhi, Aut;

        P := UnderlyingGroup(F);
        Q := Source(phi);
        R := Range(phi);

        CMap := AutomizerHomomorphism(P, Q);
        AutPQ := Automizer(P, Q);
        AutPR := Automizer(P, R);
        AutPRPhi := ConjugateList(AutPR, InverseGeneralMapping(phi));
        Aut := Intersection(AutPQ, AutPRPhi);

        # TODO: Computing preimage isn't fast! Although a homomorphism can take a fn that computes the entire preimage?
        return Group(PreImage(CMap, Aut));
    end );


InstallMethod(IsFReceptive,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is $F$-receptive",
    [IsFusionSystem, IsGroup],
    function (F, Q)
        local QClass, R, Isoms, phi, LargerSet;

        QClass := FClass(Q);
        for R in QClass do 
            Isoms := HomF(Q, R);
            for phi in Isoms do 
                LargerSet := NPhi(F, phi);
                # check whether we can find an extension of this map in the FClass of NPhi
            od;
        od;
    end );

# Checks whether $N_P(Q) \leq Q$
ContainsNormalizer := function(P, Q) 
    local NPQ;

    NPQ := Normalizer(P, Q);
    return IsSubset(Q, NPQ);
end;

InstallMethod(IsFCentric,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is $F$-centric",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local QClass, R;

        QClass := FClass(F, Q);
        
        for R in QClass do 
            if not ContainsNormalizer(UnderlyingGroup(F), R) then 
                return false;
            fi;
        od;

        return true;
    end );

InstallMethod(IsFRadical,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is $F$-radical",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local Op, Inn;

        Op := OpSubgroup(Q, Prime(F));
        Inn := InnerAutomorphismGroup(Q);

        return Op = Inn;
    end );

# Every F-conjugacy class of subgroups contains a subgroup that is receptive and fully automized
# DeclareOperation("IsSaturated", [IsFusionSystem]);

InstallMethod(\=,
    "Checks whether two fusion systems are equal",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local ClassesE, ClassesF;

        if IsIdenticalObj(F, E) then 
            return true;
        fi;

        ClassesF := FClasses(F);
        ClassesE := FClasses(E);

        if Size(ClassesF) <> Size(ClassesE) then 
            return false;
        fi;

        # for every class in F, check whether 
    end );

# # Tries to find an isomorphism between 2 fusion systems
# # DeclareOperation("IsomorphismFusionSystems", [IsFusionSystem, IsFusionSystem]);
# InstallMethod(IsomorphismFusionSystems,
#     "Tries to find an isomorphism between 2 fusion systems",
#     [IsFusionSystem, IsFusionSystem],
#     function(F, E)
#         local P1, P2, classesE, classesF;

#         if IsIdenticalObj(F, E) then 
#             return IdentityMapping(P1);
#         fi;

#         # try to find an isomorphism between the 2 groups

#         P1 := UnderlyingGroup(F);
#         P2 := UnderlyingGroup(E);
#         phi := IsomorphismGroups(P1, P2);

#         if phi = fail then 
#             return fail;
#         fi;

#         # do preliminary checks before checking an isomorphism is a match

#         # in particular, check that there are same number of F-classes and E-classes up to size, and that the sizes of each F-class and E-class up to size is just a permutation

#         ClassesF := FClasses(F);
#         ClassesE := FClasses(E);

#         if Length(ClassesF) <> Length(ClassesE) then 
#             return fail;
#         fi;

#         ClassesUpToSizeCheck := NewDictionary(0, true);
#         EntriesUpToSizeCheck := NewDictionary(0, true);

#         for ClassF in ClassesF do 
#             RepSize := Size(Representative(ClassF));
            
#             ClassTotal := LookupDictionary(ClassesUpToSizeCheck, RepSize);
#             if ClassTotal = fail then 
#                 ClassTotal := 0;
#             fi;
#             AddDictionary(ClassesUpToSizeCheck, RepSize, ClassTotal + 1);

#             SizeEntries := LookupDictionary(EntriesUpToSizeCheck, RepSize);
#             if SizeEntries = fail then 
#                 SizeEntries = [];
#             fi;
#             Add(SizeEntries, Size(ClassF));
#             AddDictionary(EntriesUpToSizeCheck, RepSize, SizeEntries);
#         od;

#         for ClassE in ClassesE do 
#             RepSize := Size(Representative(ClassE));

#             ClassTotal := LookupDictionary(ClassesUpToSizeCheck, RepSize);
#             if ClassTotal = fail or ClassTotal = 0 then 
#                 return fail;
#             fi;
#             AddDictionary(ClassesUpToSizeCheck, RepSize, ClassTotal - 1);

#             SizeEntries := LookupDictionary(EntriesUpToSizeCheck, RepSize);
#             PrevSize := Length(SizeEntries);
#             Remove(SizeEntries, Size(classE));
#             # if nothing got removed, there cannot be a bijection between the F-conjugacy classes and E-conjugacy classes
#             if Length(SizeEntries) = PrevSize then 
#                 return false;
#             fi;
#         od;

#         # TODO: Can also check the automorphism group size between the representatives

#         # It is quite likely that we have an isomorphism now, and we need to figure out which one it is
#         AutP := AutomorphismGroup(P);
#         for sigma in AutP do 
#             psi := aut * phi;
#             inversePsi := InverseGeneralMapping(psi);

#             isPsiIsomorphism := true;
#             # Transport E to a fusion system on F and check this is equal => should make use of a common fn to not have redundant checks
#         od;
#     end );