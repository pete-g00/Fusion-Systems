## We declare a FusionSystem to be a type of a category. 
DeclareCategory("IsFusionSystem", IsObject);

## We declare a representation of a fusion system as a record. In this attempt, we store:
## - the underlying group
## - the automorphisms for every F-conjugacy class (a dictionary with keys IdGroup and values representatives of F)
## - the homomorphisms within the F-conjugacy classes (a dictionary with keys IdGroup and values a list [representing the corresponding F-conjugacy class] of dictionaries with keys the subgroups in the F-conjugacy class and values a map from the representative to this group in F)
## - all the conjugacy classes (a dictionary with keys IdGroup and values lists of conjugacy classes of P in a F-conjugacy class)
DeclareRepresentation("IsFusionSystemRep", 
    IsComponentObjectRep and IsFusionSystem, [ "group", "auts", "homs", "classes" ]);

BindGlobal( "FusionSystemFamily", NewFamily("FusionSystemFamily") );

InstallMethod( PrintObj,
    "Print a Fusion System",
    [IsFusionSystemRep],
    function( F ) 
        Print("Fusion System on ", F!.group);
    end );
