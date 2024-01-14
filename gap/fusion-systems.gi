InstallMethod(ViewObj,
    "Prints a fusion system",
    [IsFusionSystem],
    function(F)
        Print("Fusion System on ", UnderlyingGroup(F));
    end );

InstallMethod(FClassReps,
    "Returns a representative from each $F$-conjugacy class of $P$",
    [IsFusionSystem],
    function(F)
        local C, Reps, c, Q;

        # go through every conjugacy class of P and take a representative from each F-class
        C := ConjugacyClassesSubgroups(UnderlyingGroup(F));
        Reps := [];

        for c in C do 
            Q := Representative(c);

            if ForAll(Reps, rep -> not AreFConjugate(F, rep, Q)) then 
                Add(Reps, Q);
            fi;
        od;

        return Reps;
    end );

InstallMethod(FClasses,
    "Returns all the $F$-conjugacy classes of $P$",
    [IsFusionSystem],
    function(F)
        return List(FClassReps(F), Q -> FClass(F, Q));
    end );

InstallMethod(IsomF,
    "Given a fusion system $F$ on $P$ and $A$ and $B$ $F$-conjugate, returns $\\Isom_F(A, B)$",
    [IsFusionSystem, IsGroup, IsGroup],
    function(F, A, B)
        local phi, auts;
        
        phi := RepresentativeFIsomorphism(F, A, B);
        auts := [];
        if phi <> fail then 
            auts := Enumerator(AutF(F, A));
        fi;

        return EnumeratorByFunctions(
            CollectionsFamily(FamilyObj(UnderlyingGroup(F))),
            rec(
                ElementNumber := function( enum, n ) 
                    return enum!.auts[n] * enum!.phi;
                end,
                NumberElement := function( enum, elm )
                    local phi;

                    phi := elm * InverseGeneralMapping(enum!.phi);
                    return Position(enum!.auts, phi);
                end,
                Length := function ( enum )
                    return Length(enum!.auts);
                end,
                PrintObj := function( enum ) 
                    Print("IsomF(", A, ",", B, ")");
                end,
                phi := phi,
                auts := auts,
            )
        );
    end );

InstallMethod(ContainedFConjugates, 
    "Returns all $F$-conjugates of $A$ that are contained in $B$",
    [IsFusionSystem, IsGroup, IsGroup],
    function(F, A, B)
        local Cons, Q, phi;

        if Size(A) > Size(B) then 
            return [];
        fi;

        if Size(A) < Size(B) then 
            Cons := [];
            
            for Q in FClass(F, A) do 
                if IsSubset(B, Q) then 
                    phi := RepresentativeFIsomorphism(F, A, Q);
                    Add(Cons, [Q, phi]);
                fi;
            od;

            return Cons;
        fi;

        phi := RepresentativeFIsomorphism(F, A, B);
        if phi <> fail then 
            return [[B, phi]];
        fi;

        return [];
    end );

# TODO: Is CollectionsFamily correct?
# TODO: Group the 2 EnumeratorByFunctions together

InstallMethod(HomF, 
    "Returns the Hom-$F$ set of $A, B \\leq P$",
    [IsFusionSystem, IsGroup, IsGroup],
    function(F, A, B)
        local printFn, type;

        printFn := function()
            Print("HomF(", A, ",", B, ")");
        end;

        type := CollectionsFamily(FamilyObj(UnderlyingGroup(F)));

        return UnionEnumerator(printFn, List(ContainedFConjugates(F, A, B), Q -> EnumeratorByFunctions(
            type, rec(
                ElementNumber := function( enum, n ) 
                    local phi;
                    
                    phi := enum!.maps[n];
                    SetRange(phi, B);
                    return phi;
                end,
                NumberElement := function( enum, elm )
                    local phi;
                    
                    if Source(elm) <> A or Image(elm) <> B or Range(elm) <> Q then 
                        return fail;
                    fi;

                    phi := GroupHomomorphismByFunction(A, B, elm);
                    return Position(enum!.maps, phi);
                end,
                Length := function ( enum )
                    return Length(enum!.maps);
                end,
                PrintObj := function( enum ) 
                    Print("HomF(",A, ",", B, ") with image ", Q);
                end,
                maps := IsomF(F, A, Q[1]),
            ))),
        type);
    end );

InstallMethod(AreFConjugate, 
    "Checks whether the two subgroups $A$ and $B$ are $F$-conjugate",
    [IsFusionSystem, IsGroup, IsGroup],
    function (F, A, B) 
        return RepresentativeFIsomorphism(F, A, B) <> fail;
    end );

InstallMethod(IsFullyNormalized,
    "Checks whether $Q$ is fully $F$-normalized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, NPQ;

        P := UnderlyingGroup(F);
        NPQ := Normalizer(P, Q);

        return ForAll(FClass(F, Q), R -> Size(NPQ) >= Size(Normalizer(P, R)));
    end );

InstallMethod(IsFullyCentralized,
    "Checks whether $Q$ is fully $F$-centralized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, CPQ;

        P := UnderlyingGroup(F);
        CPQ := Centralizer(P, Q);

        return ForAll(FClass(F, Q), R -> Size(CPQ) >= Size(Centralizer(P, R)));
    end );

InstallMethod(IsFullyAutomized,
    "Checks whether $Q$ is fully $F$-automized",
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

InstallMethod(ExtendMapToNPhi,
    "Tries to extend the map $\\phi$ to $N_\\phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        local N, R, P, L;

        N := NPhi(F, phi);
        R := Image(phi);
        P := UnderlyingGroup(F);
        L := HomF(F, N, Normalizer(P, R));

        return FindHomExtension(phi, L);
    end );

InstallMethod(IsFReceptive,
    "Checks whether $Q$ is $F$-receptive",
    [IsFusionSystem, IsGroup],
    function (F, Q)
        return ForAll(FClass(F, Q), 
            R -> ForAll(IsomF(F, R, Q), phi -> ExtendMapToNPhi(F, phi) <> fail));
    end );

InstallMethod(IsSaturated, 
    "Checks whether the fusion system is saturated",
    [IsFusionSystem],
    function(F)
        return ForAll(FClasses(F), C -> 
            ForAny(C, Q -> IsFullyNormalized(F, Q) and IsFReceptive(F, Q))
        );
    end );

InstallMethod(IsFCentric,
    "Checks whether $Q$ is $F$-centric",
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
    "Checks whether $Q$ is $F$-radical",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local Op, Inn;

        Op := PCore(Q, Prime(F));
        Inn := InnerAutomorphismGroup(Q);

        return Op = Inn;
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
            TransportedF := F^sigma;
            if TransportedF = E then 
                return sigma;
            fi;
        od;

        return fail;
    end );
