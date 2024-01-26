CouldBeIsomorphic := function(A, B)
    if Size(A) <> Size(B) then 
        return false;
    fi;
    if IdGroupsAvailable(Size(A)) then 
        return IdGroup(A)[2] = IdGroup(B)[2];
    else 
        return true;
    fi;
end;

GroupByIsomType := function(L)
    local Subs, i, C, Q, Cons, R, label;

    L := ShallowCopy(L);
    Sort(L, function(A, B)
        if Size(A) <> Size(B) then 
            return Size(A) <= Size(B);
        fi;

        if IdGroupsAvailable(Size(A)) then 
            return IdGroup(A)[2] <= IdGroup(B)[2];
        fi;

        return true;
    end );
    
    Subs := rec();
    i := 1;

    while i <= Length(L) do
        Q := L[i];
        Cons := [Q];
        
        while i+1 <= Length(L) and CouldBeIsomorphic(Q, L[i+1]) do 
            i := i+1;
            R := L[i];
            Add(Cons, R);
        od; 

        i := i+1;

        if IdGroupsAvailable(Size(Q)) then 
            label := String(IdGroup(Q));
        else 
            label := Size(Q);
        fi;

        Subs.(label) := Cons;
    od;
    
    return Subs;
end;

InstallMethod(ViewObj,
    "Prints a fusion system",
    [IsFusionSystem],
    function(F)
        Print("Fusion System on ", UnderlyingGroup(F));
    end );

InstallMethod(FClass,
    "Returns the of $F$-conjugacy class of $Q$",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        return Objectify(
            NewType(CollectionsFamily(FamilyObj(Q)), IsFClassByCoClassesRep),
            rec(F := F, reps := FClassReps(F, Q))
        );
    end );

InstallMethod(FClassesReps,
    "Returns a representative from each $F$-conjugacy class of $P$",
    [IsFusionSystem],
    function(F)
        local P, C, Reps, name, c, CReps, Q;

        P := UnderlyingGroup(F);
        C := GroupByIsomType(List(ConjugacyClassesSubgroups(P), Representative));
        Reps := [];

        # C is a record, where the label gives us the size/group id, and 
        # the elements are a representative from each conjugacy class for each
        # of the subgroups
        for name in RecNames(C) do 
            c := C.(name);
            # c is a list of subgroups
            CReps := [];
            for Q in c do 
                if ForAll(CReps, rep -> not AreFConjugate(F, rep, Q)) then 
                    Add(CReps, Q);
                fi;
            od;
            Append(Reps, CReps);
        od;

        return Reps;
    end );

InstallMethod(FClasses,
    "Returns all the $F$-conjugacy classes of $P$",
    [IsFusionSystem],
    function(F)
        return List(FClassesReps(F), Q -> FClass(F, Q));
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
        if Size(A) >= Size(B) then
            if AreFConjugate(F, A, B) then 
                return [B];
            else 
                return [];
            fi;
        fi;
        
        return Filtered(FClass(F, A), Q -> IsSubset(B, Q));
    end );

# TODO: Is CollectionsFamily correct?
# TODO: Group the 2 EnumeratorByFunctions together

InstallMethod(HomF, 
    "Returns the Hom-$F$ set of $A, B \\leq P$",
    [IsFusionSystem, IsGroup, IsGroup],
    function(F, A, B)
        return UnionEnumerator(function()
            Print("HomF(", A, ",", B, ")");
        end,
        List(ContainedFConjugates(F, A, B), Q -> EnumeratorByFunctions(CollectionsFamily(FamilyObj(UnderlyingGroup(F))),
            rec(
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
                maps := IsomF(F, A, Q),
            ))),
        FamilyObj(UnderlyingGroup(F)));
    end );

InstallMethod(AreFConjugate, 
    "Checks whether the two subgroups $A$ and $B$ are $F$-conjugate",
    [IsFusionSystem, IsGroup, IsGroup],
    function (F, A, B) 
        return RepresentativeFIsomorphism(F, A, B) <> fail;
    end );

InstallMethod(\in,
    "Checks whether $\\phi$ lies in $F$",
    [IsGroupHomomorphism, IsFusionSystem],
    function (phi, F)
        local A, B, psi;

        if not IsInjective(phi) then 
            return false;
        fi;
        
        A := Source(phi);
        B := Range(phi);
        
        if not (IsSubset(A, UnderlyingGroup(F)) or IsSubset(B, UnderlyingGroup(F))) then 
            return false;
        fi;

        B := Image(phi);
        
        psi := RepresentativeFIsomorphism(F, A, B);

        if psi = fail then 
            return false;
        fi;

        phi := RestrictedInverseGeneralMapping(phi);

        return psi*phi in AutF(F, A);
    end );

InstallMethod(IsFullyNormalized,
    "Checks whether $Q$ is fully $F$-normalized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, NPQ;

        P := UnderlyingGroup(F);
        NPQ := Normalizer(P, Q);

        if NPQ = P then 
            return true;
        fi;

        return ForAll(FClassReps(F, Q), R -> Size(NPQ) >= Size(Normalizer(P, R)));
    end );

InstallMethod(IsFullyCentralized,
    "Checks whether $Q$ is fully $F$-centralized",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local P, CPQ;

        P := UnderlyingGroup(F);
        CPQ := Centralizer(P, Q);

        if CPQ = P then 
            return true;
        fi;

        return ForAll(FClassReps(F, Q), R -> Size(CPQ) >= Size(Centralizer(P, R)));
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
        local P, Q, R, CPQ, NPQ, AutGR, NPhiGens, QCPQ, g;

        P := UnderlyingGroup(F);
        Q := Source(phi);
        R := Image(phi);

        CPQ := Centralizer(P, Q);
        NPQ := Normalizer(P, Q);
        AutGR := Automizer(P, R);

        NPhiGens := Union(GeneratorsOfGroup(Q), GeneratorsOfGroup(CPQ));
        QCPQ := Group(NPhiGens);

        for g in RightTransversal(NPQ, QCPQ) do 
            if not g in Group(NPhiGens) and ConjugatorAutomorphismNC(P, g)^phi in AutGR then 
                Add(NPhiGens, g);

                if Group(NPhiGens) = NPQ then 
                    return NPQ;
                fi;
            fi;
        od;

        return Group(NPhiGens);
    end );

InstallMethod(ExtendMapToNPhi,
    "Tries to extend the map $\\phi$ to $N_\\phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        local L;

        L := HomF(F, NPhi(F, phi), Normalizer(UnderlyingGroup(F), Image(phi)));

        return FindHomExtension(phi, L);
    end );

InstallMethod(IsFReceptive,
    "Checks whether $Q$ is $F$-receptive",
    [IsFusionSystem, IsGroup],
    function (F, Q)
        return ForAll(FClassReps(F, Q), 
            R -> ForAll(IsomF(F, R, Q), phi -> ExtendMapToNPhi(F, phi) <> fail));
    end );

InstallMethod(IsSaturated, 
    "Checks whether the fusion system is saturated",
    [IsFusionSystem],
    function(F)
        return ForAll(FClassesReps(F), Q -> 
            ForAny(FClassReps(F, Q), R -> IsFullyAutomized(F, R) and IsFReceptive(F, R))
        );
    end );

InstallMethod(IsFCentric,
    "Checks whether $Q$ is $F$-centric",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        return ForAll(FClassReps(F, Q), 
            R -> IsSubset(R, Normalizer(UnderlyingGroup(F), R)));
    end );

InstallMethod(IsFRadical,
    "Checks whether $Q$ is $F$-radical",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        return PCore(Q, Prime(F)) = InnerAutomorphismGroup(Q);
    end );

# TODO: `IsEssentialSubgroup(P, A)` that takes a p-group `P` and a subgroup `A`, and checks whether `A` is an essential subgroup.

InstallMethod(\=,
    "Checks whether two fusion systems are equal",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local classF, A, classE, Auts, sigma, i;

        if IsIdenticalObj(F, E) then 
            return true;
        fi;

        if UnderlyingGroup(F) <> UnderlyingGroup(E) then 
            return false;
        fi;

        # compute the E-conjugacy classes and check they are the same as classes in F
        # check whether the size of the automorphism groups match and the F-classes
        return ForAll(FClassesReps(F), 
            Q -> AutF(F, Q) = AutF(E, Q) and FClass(F, Q) = FClass(E, Q));
    end );

InstallMethod(IsomorphismFusionSystems,
    "Tries to find an isomorphism between 2 fusion systems",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local P1, P2, phi, Auts, psi, sigma;

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
        # any map in automorphism of P1 (as a fusion system) won't yield us anything, so we can transverse it?

        for psi in RightTransversal(Auts, AutF(F, P1)) do 
            sigma := psi*phi;
            if F^sigma = E then 
                return sigma;
            fi;
        od;

        return fail;
    end );
