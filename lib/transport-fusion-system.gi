InstallMethod(\^, 
    "Transports the given fusion system $F$ to the fusion system $F^phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        if not(IsBijective(phi)) then 
            Error("The map must be an isomorphism!");
        elif not IsSubset(Source(phi), UnderlyingGroup(F)) then
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

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function(F, Q) 
        local ImageQ, phi;

        ImageQ := Image(F!.phiInv, Q);
        return OnAutGroupConjugation(AutF(F!.E, ImageQ), F!.phi);
    end );

InstallMethod(RepresentativeFIsomorphism,
    "Returns a representative $F$-isomorphism between $A \\to B$",
    [IsTransportFusionSystemRep, IsGroup, IsGroup],
    function(F, A, B)
        local ImageA, ImageB, psi;

        ImageA := Image(F!.phiInv, A);
        ImageB := Image(F!.phiInv, B);
        
        psi := RepresentativeFIsomorphism(F!.E, ImageA, ImageB);

        if psi = fail then 
            return fail;
        fi;

        return OnHomConjugation(psi, F!.phi);
    end );

InstallMethod(FClassReps,
    "Returns a conjugacy class representative from the $F$-conjugacy class of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function (F, Q) 
        return List(FClassReps(F!.E, Image(F!.phiInv, Q)), R -> OnImage(R, F!.phi));
    end );

InstallMethod(FClassesReps,
    "Returns a representative from each $F$-conjugacy class",
    [IsTransportFusionSystemRep],
    function (F) 
        return List(FClassesReps(F!.E), Q -> OnImage(Q, F!.phi));
    end );
