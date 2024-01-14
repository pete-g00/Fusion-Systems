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

InstallMethod(ViewObj,
    "Prints a fusion system",
    [IsFusionSystem],
    function(F)
        Print("Fusion System on ", UnderlyingGroup(F));
    end );

# TODO: No need to construct all maps in this manner
# HomF should return a list of collection of maps, one collection for every possible image
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

    if IdGroupsAvailable(size_A) then 
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
        local AutPQ, AutFQ, p;

        # Check $Aut_P(Q)$ is a Sylow-$p$ subgroup of $Aut_F(Q)$
        AutFQ := AutF(F, Q);
        AutPQ := Automizer(UnderlyingGroup(F), Q);
        p := Prime(F);

        return PValuation(Size(AutPQ), p) = PValuation(Size(AutFQ), p);
    end );

InstallMethod(NPhi,
    "Given a fusion system $F$ on $P$ and a map $\\phi$ in $F$, computes $N_\\phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        local P, Q, R, CMap, AutPQ, AutPR, AutPRPhi, Aut;

        P := UnderlyingGroup(F);
        Q := Source(phi);
        R := Range(phi);

        if not (IsSubset(P, Q) and IsSubset(P, R)) then 
            Error("The map doesn't lie in F");
        fi;

        CMap := AutomizerHomomorphism(P, Q);
        AutPQ := Automizer(P, Q);
        AutPR := Automizer(P, R);
        AutPRPhi := Group(OnTuples(GeneratorsOfGroup(AutPR), InverseGeneralMapping(phi)));
        Aut := Intersection(AutPQ, AutPRPhi);

        # TODO: Computing preimage isn't fast! Maybe this should be done using the other way?
        return PreImages(CMap, Aut);
    end );

InstallMethod(IsFReceptive,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is $F$-receptive",
    [IsFusionSystem, IsGroup],
    function (F, Q)
        local QClass, R, Isoms, phi, LargerSet;

        QClass := FClass(F, Q);
        for R in QClass do 
            Isoms := HomF(F, Q, R);
            for phi in Isoms do 
                if ExtendMapToNPhi(F, phi) = fail then 
                    return false;
                fi;
            od;
        od;

        return true;
    end );

InstallMethod(IsFCentric,
    "Given a fusion system $F$ on $P$, checks whether $Q$ is $F$-centric",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, QClass, R, NPR;

        P := UnderlyingGroup(F);
        QClass := FClass(F, Q);
        
        for R in QClass do 
            NPR := Normalizer(P, R);
            if not IsSubset(R, NPR) then 
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

        Op := PCore(Q, Prime(F));
        Inn := InnerAutomorphismGroup(Q);

        return Op = Inn;
    end );

InstallMethod(IsSaturated, 
    "Checks whether the fusion system is saturated",
    [IsFusionSystem],
    function(F)
        # for every F-conjugacy class,
        # find all that are fully automized and receptive
        return false;
    end );

InstallMethod(\=,
    "Checks whether two fusion systems are equal",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local ClassesF, ClassesE, classF, A, classE, Auts, sigma, i;

        if IsIdenticalObj(F, E) then 
            return true;
        fi;

        if UnderlyingGroup(F) <> UnderlyingGroup(E) then 
            return false;
        fi;

        ClassesF := FClasses(F);
        ClassesE := [];

        # compute the E-conjugacy classes and check they are the same as classes in F
        for classF in ClassesF do 
            A := Representative(classF);
            classE := FClass(E, A);
            if not IsEqualSet(classE, classF) then 
                return false;
            fi;
        od;

        return true;
    end );

InstallMethod(IsomorphismFusionSystems,
    "Tries to find an isomorphism between 2 fusion systems",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local P1, P2, phi, Auts, classes, class, sigma, TransportedF;

        if IsIdenticalObj(F, E) then 
            return IdentityMapping(UnderlyingGroup(F));
        fi;

        # try to find an isomorphism between the 2 groups
        P1 := UnderlyingGroup(F);
        P2 := UnderlyingGroup(E);

        phi := IsomorphismGroups(P1, P2);

        if phi = fail then 
            return fail;
        fi;

        Auts := AutomorphismGroup(P1);
        classes := ConjugacyClass(Auts);

        for class in classes do 
            sigma := phi*Representative(class);
            TransportedF := F^(sigma);
            if TransportedF = E then 
                return sigma;
            fi;
        od;

        return fail;
    end );
