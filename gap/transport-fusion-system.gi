InstallMethod(\^, 
    "Transports the given fusion system $F$ to the fusion system $F^phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        if not(IsBijective(phi)) then 
            Error("The map must be an isomorphism!");
        elif not IsSubset(UnderlyingGroup(F), Source(phi)) then
            Error("The map is not defined on the group!");
        fi;

        return Objectify(NewType(FusionSystemFamily, IsTransportFusionSystemRep),
            rec( 
                E := F, 
                P := Image(phi, UnderlyingGroup(F)), 
                phi := phi, 
                phiInv := InverseGeneralMapping(phi),
                p := Prime(F)
            ));
    end );

InstallMethod(UnderlyingGroup,
    "Returns the underlying group of the transport fusion system",
    [IsTransportFusionSystemRep],
    function(F)
        return F!.P;
    end );

InstallMethod(Prime,
    "Returns the prime of the underlying group in the transport fusion system",
    [IsTransportFusionSystemRep],
    function(F)
        return F!.p;
    end );

# if \phi \in \Aut(P) and $L$ a list of subgroups of $P$, this is a group action 
OnListApplication := function(L, phi)
    return List(L, Q -> Image(phi, Q));
end;

OnFunctionListApplication := function(L, phi)
    return List(L, psi -> psi^phi);
end;

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function(F, Q) 
        local ImageQ, phi;

        if not (IsSubset(F!.P, Q)) then 
            Error("Q is not a subgroup!");
        fi;
        ImageQ := Image(F!.phiInv, Q);

        phi := GroupHomomorphismByFunction(ImageQ, Q, x -> Image(F!.phi, x));

        return Group(OnFunctionListApplication(
            GeneratorsOfGroup(AutF(F!.E, ImageQ)),
            phi
        ));
    end );

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsTransportFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local ImageA, ImageB, psi, phiInv, phi;

        if not (IsSubset(F!.P, A)) then 
            Error("A is not a subgroup!");
        elif not (IsSubset(F!.P, B)) then 
            Error("B is not a subgroup!");
        fi;

        ImageA := Image(F!.phiInv, A);
        ImageB := Image(F!.phiInv, B);
        
        psi := RepresentativeFIsomorphism(F!.E, ImageA, ImageB);

        if psi = fail then 
            return fail;
        fi;

        phiInv := GroupHomomorphismByFunction(A, ImageA, x -> Image(F!.phiInv, x));
        phi := GroupHomomorphismByFunction(ImageB, B, x -> Image(F!.phi, x));

        return phiInv * psi * phi;
    end );

# TODO: Need TransportHom
# MappedCollection would also be a good thing to construct

InstallMethod(FClassReps,
    "Returns a conjugacy class representative from the $F$-conjugacy class of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function (F, Q) 
        if not (IsSubset(F!.P, Q)) then 
            Error("Q is not a subgroup!");
        fi;

        return OnListApplication(FClassReps(F!.E, Image(F!.phiInv, Q)), F!.phi);
    end );

InstallMethod(FClassesReps,
    "Returns a representative from each $F$-conjugacy class",
    [IsTransportFusionSystemRep],
    function (F) 
        return OnListApplication(FClassesReps(F!.E), F!.phi);
    end );
