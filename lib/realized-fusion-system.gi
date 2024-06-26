InstallMethod(RealizedFusionSystem, 
    "Constructs a realized fusion system F_P(G)",
    [IsGroup, IsGroup],
    function (G, P)
        local p, IsSylowSubgroup;

        p := FindPrimeOfPrimePower(Size(P));

        if p = fail then 
            Error("P is not a p-subgroup");
        fi;

        if not (IsSubset(G, P)) then 
            Error("P must be a subgroup of G");
        fi;

        IsSylowSubgroup := PValuation(Size(G), p) = PValuation(Size(P), p);

        return Objectify(NewType(FusionSystemFamily, IsRealizedFusionSystemRep), 
            rec(
                G := G, 
                P := P, 
                p := p, 
                IsSylowSubgroup := IsSylowSubgroup
            ));
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

        return ConjugatorIsomorphism(A, g);
    end );

InstallMethod(FClassReps,
    "Computes the $F$-conjugacy class of $Q$",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        local P, G, class, reps, R;

        P := UnderlyingGroup(F);
        G := RealizingGroup(F);

        # from co-cl reps of P, find those that can be conjugate
        # check whether a rep from each is conjugate

        if not(IsSubset(P, Q)) then 
            Error("Q must be a subgroup of P");
        fi;

        class := Q^G;
        reps := [];

        for R in class do 
            if IsSubset(P, R) then 
                if ForAll(reps, S -> not R in S^P) then 
                    Add(reps, R);
                fi;
            fi;
        od;

        return reps;
    end );

InstallMethod(IsFullyNormalized,
    "Checks whether $Q$ is fully $F$-normalized",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        local NPQ, NGQ, P, G, p;

        # if P is a Sylow-p subgroup of G, then check whether NPQ <= NGQ is Syl-p
        if not F!.IsSylowSubgroup then 
            TryNextMethod();
        fi;

        P := UnderlyingGroup(F);
        G := RealizingGroup(F);

        NPQ := Normalizer(P, Q);
        NGQ := Normalizer(G, Q);
        p := Prime(F);

        return PValuation(Size(NPQ), p) = PValuation(Size(NGQ), p);
    end );

InstallMethod(IsFullyCentralized,
    "Checks whether $Q$ is fully $F$-centralized",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        local CPQ, CGQ, P, G, p;

        # if P is a Sylow-p subgroup of G, then check whether NPQ <= NGQ is Syl-p
        if not F!.IsSylowSubgroup then 
            TryNextMethod();
        fi;
        
        P := UnderlyingGroup(F);
        G := RealizingGroup(F);

        CPQ := Centralizer(P, Q);
        CGQ := Centralizer(G, Q);
        p := Prime(F);

        return PValuation(Size(CPQ), p) = PValuation(Size(CGQ), p);
    end );

InstallMethod(IsFReceptive,
    "Checks whether $Q$ is $F$-receptive",
    [IsRealizedFusionSystemRep, IsGroup],
    function(F, Q)
        # if P is a Sylow-p subgroup of G, then check whether fully centralized
        if not F!.IsSylowSubgroup then 
            TryNextMethod();
        fi;
        
        return IsFullyCentralized(F, Q);
    end );

InstallMethod(IsSaturated,
    "Checks whether $F$ is a saturated fusion system",
    [IsRealizedFusionSystemRep],
    function(F)
        if F!.IsSylowSubgroup then 
            return true;
        else
            TryNextMethod();
        fi;
    end );

InstallMethod(\=,
    "Checks whether $F_1$ and $F_2$ are equal",
    [IsRealizedFusionSystemRep, IsRealizedFusionSystemRep],
    function(F1, F2)
        if RealizingGroup(F1) = RealizingGroup(F2) and UnderlyingGroup(F1) = UnderlyingGroup(F2) then 
            return true;
        else 
            TryNextMethod();
        fi;
    end );

InstallMethod(IsomorphismFusionSystems,
    "Tries to find an isomorphism between 2 fusion systems",
    [IsRealizedFusionSystemRep, IsRealizedFusionSystemRep],
    function(F1, F2)
        local G, P1, P2, x;
        
        if RealizingGroup(F1) <> RealizingGroup(F2) then 
            TryNextMethod();
        fi;

        # If P1 and P2 are conjugate in G, then the conjugation map is an isomorphism of fusion systems
        G := RealizingGroup(F1);
        P1 := UnderlyingGroup(F1);
        P2 := UnderlyingGroup(F2);

        x := RepresentativeAction(G, P1, P2);
        if x <> fail then 
            return ConjugatorIsomorphism(P1, x);
        else 
            TryNextMethod();
        fi;
    end );