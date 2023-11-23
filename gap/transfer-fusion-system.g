DeclareRepresentation("IsTransferFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, ["fusion", "group", "phi", "phiInv"]);

# TODO: For permutation groups, we need another method
DeclareOperation("^", [IsFusionSystem, IsGroupHomomorphism]);
InstallMethod(\^, 
    "Transfers the given fusion system $F$ to the fusion system $F^phi$",
    [IsFusionSystem, IsGroupHomomorphism],
    function(F, phi)
        if not(IsBijective(phi)) then 
            Error("The map must be an isomorphism!");
        fi;

        return Objectify(NewType(FusionSystemFamily, IsTransferFusionSystemRep),
            rec( fusion := F, group := Image(phi), phi := phi, phiInv := InverseGeneralMapping(phi)));
    end );

ConjugateList := function (l, phi) 
    return List(l, x -> Image(phi, x));
end;

InstallMethod(PrintObj, 
    "Prints a transfer fusion system",
    [IsTransferFusionSystemRep],
    function ( F ) 
        Print("Fusion System on ", F!.group);
    end );

InstallMethod(FConjugacyClass, 
    "Returns all the $F$-conjugacy classes",
    [IsTransferFusionSystemRep],
    F -> List(FConjugacyClass(F!.fusion), class -> ConjugateList(class, F!.phi)));

InstallMethod(FClass,
    "Returns the $F$-conjugacy class of $Q$",
    [IsTransferFusionSystemRep, IsGroup],
    function (F, Q) 
        return FClass(F!.fusion, Image(F!.phiInv, Q));
    end );

InstallMethod(AreFConjugate,
    "Checks whether $Q$ and $R$ are $F$-conjugate",
    [IsTransferFusionSystemRep, IsGroup, IsGroup],
    function(F, Q, R)
        return AreFConjugate(F!.fusion, Image(F!.phiInv, Q), Image(F!.phiInv, R));
    end );

# TODO: Aut_F

# TODO: Hom_F
