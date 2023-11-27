DeclareRepresentation("IsTransportFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["fusion", "group", "phi", "phiInv"]);

# TODO: For permutation groups, we need another method
DeclareOperation("^", [IsFusionSystem, IsGroupHomomorphism]);
InstallMethod(\^, 
    "Transports the given fusion system $F$ to the fusion system $F^phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        if not(IsBijective(phi)) then 
            Error("The map must be an isomorphism!");
        fi;

        return Objectify(NewType(FusionSystemFamily, IsTransportFusionSystemRep),
            rec( fusion := F, group := Image(phi), phi := phi, phiInv := InverseGeneralMapping(phi)));
    end );

ConjugateList := function (l, phi) 
    return List(l, x -> Image(phi, x));
end;

InstallMethod(PrintObj, 
    "Prints a transport fusion system",
    [IsTransportFusionSystemRep],
    function ( F ) 
        Print("Fusion System on ", F!.group);
    end );

InstallMethod(FConjugacyClass, 
    "Returns all the $F$-conjugacy classes",
    [IsTransportFusionSystemRep],
    F -> List(FConjugacyClass(F!.fusion), class -> ConjugateList(class, F!.phi)));

InstallMethod(FClass,
    "Returns the $F$-conjugacy class of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function (F, Q) 
        if not (IsSubset(F!.group, Q)) then 
            Error("Q is not a subgroup!");
        fi;

        return ConjugateList(FClass(F!.fusion, Image(F!.phiInv, Q)), F!.phi);
    end );

InstallMethod(AreFConjugate,
    "Checks whether $Q$ and $R$ are $F$-conjugate",
    [IsTransportFusionSystemRep, IsGroup, IsGroup],
    function(F, Q, R)
        if not (IsSubset(F!.group, Q)) then 
            Error("Q is not a subgroup!");
        fi;
        if not (IsSubset(F!.group, R)) then 
            Error("R is not a subgroup!");
        fi;

        return AreFConjugate(F!.fusion, Image(F!.phiInv, Q), Image(F!.phiInv, R));
    end );

InstallMethod(AutF,
    "Computes the F-automorphism group of $Q$",
    [IsTransportFusionSystemRep, IsGroup],
    function(F, Q) 
        if not (IsSubset(F!.group, Q)) then 
            Error("Q is not a subgroup!");
        fi;
        
        return AutF(F!.fusion, Image(F!.phiInv, Q))^(F!.phi);
    end );

InstallMethod(HomF, 
    "Computes all morphisms $Q \to R$ in $F$",
    [IsTransportFusionSystemRep, IsGroup, IsGroup],
    function(F, Q, R)
        if not (IsSubset(F!.group, Q)) then 
            Error("Q is not a subgroup!");
        fi;
        if not (IsSubset(F!.group, R)) then 
            Error("R is not a subgroup!");
        fi;
        
        return ConjugateList(HomF(F!.fusion, Image(F!.phiInv, Q), Image(F!.phiInv, R)), F!.phi);
    end );
