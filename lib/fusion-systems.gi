# Produces a list of numbers using which the isomorphism type 
# of the group G can be almost completely inferred.
# If G is small enough to support IdGroup, then we only rely on that (i.e. [size of G, isom id of G])
# 
# Otherwise, we make use of the following values:
# - Size of G
# - Size of the center of G
# - Size of the derived subgroup of G
# - Length of a composition series of G
# - Exponent of G
# - Length of the maximal subgroups of G (up to conjugacy classes)
# - (for p-groups) Rank of G
IsomType := function(G)
    if IdGroupsAvailable(Size(G)) then 
        return IdGroup(G);
    fi;

    if IsPrimePowerInt(Size(G)) then 
        return [
            Size(G),
            Size(Center(G)),
            Size(DerivedSubgroup(G)),
            Length(CompositionSeries(G)),
            Exponent(G),
            Length(MaximalSubgroupClassReps(G)),
            Rank(G)
        ];
    else 
        return [
            Size(G),
            Size(Center(G)),
            Size(DerivedSubgroup(G)),
            Length(CompositionSeries(G)),
            Exponent(G),
            Length(MaximalSubgroupClassReps(G))
        ];
    fi;
end;

# Returns a number that compares the isomorphism type of A with the isomorphism type of B
# Essentially, this is IsomType(A) - IsomType(B)
# So, if the value is 0, then the two groups have the same IsomType value
# If the value is -ve then A and B don't have the same IsomType value, and the first value that is different is where A has a smaller number than B
# The opposite is the case when the value is +ve
CompareByIsom := function(A, B)
    local IsomTypeA, IsomTypeB, i, sub;

    IsomTypeA := IsomType(A);
    IsomTypeB := IsomType(B);

    for i in [1..Length(IsomTypeA)] do 
        sub := IsomTypeA[i] - IsomTypeB[i];
        if sub <> 0 then 
            return sub;
        fi;
    od;

    return 0;
end;

# Groups a list of subgroups by IsomType
# Returns a record labelled by the isomtypes (a stringified version of the list)
# and entries the subgroups given that belong to the isomtype
GroupByIsomType := function(L)
    local Subs, i, C, Q, Cons, R, label;

    L := ShallowCopy(L);
    Sort(L, function(A, B)
        return CompareByIsom(A, B) <= 0;
    end );
    
    Subs := rec();
    i := 1;

    while i <= Length(L) do
        Q := L[i];
        Cons := [Q];
            
        while i+1 <= Length(L) and CompareByIsom(Q, L[i+1]) = 0 do 
            i := i+1;
            R := L[i];
            Add(Cons, R);
        od; 

        i := i+1;
        label := String(IsomType(Q));
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

        # C is a record, where the label gives us the an idea of the isom type, and 
        # the elements are a representative from each conjugacy class for each
        # of the subgroups
        for name in RecNames(C) do 
            c := C.(name);
            # c is a list of subgroups
            # produce a list of F-representatives in this isomorphism type
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
                    # TODO: Any better way to change the restrict the source/make the range larger?
                    return GroupHomomorphismByFunction(A, B, x -> Image(phi, x));
                end,
                NumberElement := function( enum, elm )
                    local phi;
                    
                    if Source(elm) <> A or Image(elm) <> B or Range(elm) <> Q then 
                        return fail;
                    fi;

                    phi := GroupHomomorphismByFunction(A, B, x -> Image(elm, x));
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
        
        if not (IsSubset(UnderlyingGroup(F), A) or IsSubset(UnderlyingGroup(F), B)) then 
            return false;
        fi;

        B := Image(phi);
        psi := RepresentativeFIsomorphism(F, B, A);

        if psi = fail then 
            return false;
        fi;
        
        # phi: A -> B, psi: B -> A
        # phi lies in Isom(A, B) <=> phi*psi lies in AutF(A)
        return phi*psi in AutF(F, A);
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

InstallMethod(ExtendMapToNPhi,
    "Tries to extend the map $\\phi$ to $N_\\phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        local L;

        L := HomF(F, NPhi(UnderlyingGroup(F), phi), Normalizer(UnderlyingGroup(F), Image(phi)));

        return FindHomExtension(phi, L);
    end );

InstallMethod(IsFReceptive,
    "Checks whether $Q$ is $F$-receptive",
    [IsFusionSystem, IsGroup],
    function (F, Q)
        local AutPQ, AutFQ, OutFQ;
        
        AutPQ := Automizer(UnderlyingGroup(F), Q);
        AutFQ := AutF(F, Q);

        # Check for every F-isomorphism R -> Q can be extended to N_\phi
        # TODO: Figure out a way to make fewer checks
        return ForAll(FClassReps(F, Q), 
            R -> ForAll(IsomF(F, R, Q), phi -> ExtendMapToNPhi(F, phi) <> fail));
    end );

InstallMethod(IsSaturated, 
    "Checks whether the fusion system is saturated",
    [IsFusionSystem],
    function(F)
        local C, Cls;
        
        C := FClassesReps(F);
        Cls := List(C, Q -> FClassReps(F, Q));

        # Check whether every F-class contains a fully automized member (for efficiency),
        # and if a subgroup is fully normalized, then it is receptive
        # TODO: Figure out a way to make fewer checks
        return ForAll([1..Length(C)], i -> ForAny(Cls[i], R -> IsFullyAutomized(F, R))) and
            ForAll([1..Length(C)], i -> ForAll(Cls[i], R -> not IsFullyNormalized(F, R) or IsFReceptive(F, R)));
    end );

InstallMethod(IsFCentric,
    "Checks whether $Q$ is $F$-centric",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        return ForAll(FClassReps(F, Q), 
            R -> IsSubset(R, Centralizer(UnderlyingGroup(F), R)));
    end );

InstallMethod(IsFRadical,
    "Checks whether $Q$ is $F$-radical",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        if IsAbelian(Q) then 
            return IsTrivial(PCore(AutF(F, Q), Prime(F)));
        else 
            return PCore(AutF(F, Q), Prime(F)) = InnerAutomorphismGroup(Q);
        fi;
    end );

InstallMethod(IsFEssential, 
    "Checks whether a subgroup is F-essential",
    [IsFusionSystem, IsGroup],
    function(F, Q)
        local InnQ, AutFQ, OutFQ;

        if not IsFCentric(F, Q) then 
            return false;
        fi;

        if IsAbelian(Q) then 
            InnQ := Group(IdentityMapping(Q));
        else 
            InnQ := InnerAutomorphismGroup(Q);
        fi;

        AutFQ := AutF(F, Q);
        OutFQ := AutFQ/InnQ;

        return ForAny(ConjugacyClassesSubgroups(OutFQ), 
            C -> not Representative(C) = OutFQ and
                IsStronglyPEmbedded(OutFQ, Representative(C), Prime(F)));
    end );

InstallMethod(\=,
    "Checks whether two fusion systems are equal",
    [IsFusionSystem, IsFusionSystem],
    function(F, E)
        local C;

        if IsIdenticalObj(F, E) then 
            return true;
        fi;

        if UnderlyingGroup(F) <> UnderlyingGroup(E) then 
            return false;
        fi;

        # compute the E-conjugacy classes and check they are the same as classes in F
        # check whether the size of the automorphism groups match and the F-classes
        # TODO: Might be simpler to just check using P-cocl (which may be faster to compute?)
        C := FClassesReps(F);

        # (checking AutF is faster than FClass in general)
        return 
            ForAll(FClassesReps(F), Q -> AutF(F, Q) = AutF(E, Q)) and
            ForAll(FClassesReps(F), Q -> FClass(F, Q) = FClass(E, Q));
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

        # TODO: The speed of this operation depends on the underlying group (choose P1 or P2 depending on which one will be more efficient)
        Auts := AutomorphismGroup(P1);
        
        # any map in automorphism of P1 (as a fusion system) won't yield us anything, so we can transverse it
        for psi in RightTransversal(Auts, AutF(F, P1)) do 
            sigma := psi*phi;
            if F^sigma = E then 
                return sigma;
            fi;
        od;

        return fail;
    end );
