# General declarations of fusion systems
# In this file, we declare the fusion system category along with the attributes/operations it has.
# This is an abstract representation of a fusion system- we expect every representation to have these functionalities,
# but they might have different implementatinos to make it optimal with respect to what we know about the given fusion system.

# There are 2 kinds of attibutes/operations here- the first few must be implemented by every representation to make the fusion system work. 
# This is the minimal set of attributes/operations a fusion system needs in order for us to define all the other operations. 
# It is however possible that there are more efficient ways of computing the other operations/attibutes, and so these functionalities can also be overridden in a specific representation.


# Defines the category of fusion systems
DeclareCategory("IsFusionSystem", IsObject);

# Defines the family of fusion systems
BindGlobal( "FusionSystemFamily", NewFamily("FusionSystemFamily") );

# 
# Every representation of a fusion system MUST implement this attributes/operations
# 

# Gives the underlying group of the fusion system
DeclareAttribute("UnderlyingGroup", IsFusionSystem);

# Gives the prime of the fusion system
DeclareAttribute("Prime", IsFusionSystem);

# Returns the Aut-F set of a subgroup in F
DeclareOperation("AutF", [IsFusionSystem, IsGroup]);

# Returns an isomorphism in F between 2 F-conjugate subgroups
DeclareOperation("RepresentativeFIsomorphism", [IsFusionSystem, IsGroup, IsGroup]);

# 
# These operations have been implemented in the general case, but can be overriden if there are more efficient ways of computing them
# 

# Returns a representative from each $F$-conjugacy classes of subgroups of $P$
DeclareAttribute("FClassReps", IsFusionSystem);

# Returns the F-conjugacy class of a subgroup in F
DeclareOperation("FClass", [IsFusionSystem, IsGroup]);

# Returns all the F-conjugacy classes
DeclareAttribute("FClasses", IsFusionSystem);

# Returns the set of F-isomorphisms between two subgroups in F
DeclareOperation("IsomF", [IsFusionSystem, IsGroup, IsGroup]);

# Returns all the F-conjugates of A contained in B
DeclareOperation("ContainedFConjugates", [IsFusionSystem, IsGroup, IsGroup]);

# Returns the Hom-F set of two subgroups in F
DeclareOperation("HomF", [IsFusionSystem, IsGroup, IsGroup]);

# Checks whether two subgroups in F are F-conjugate
DeclareOperation("AreFConjugate", [IsFusionSystem, IsGroup, IsGroup]);

# Checks whether a subgroup is fully F-normalized
DeclareOperation("IsFullyNormalized", [IsFusionSystem, IsGroup]);

# Checks whether a subgroup is fully F-centralized
DeclareOperation("IsFullyCentralized", [IsFusionSystem, IsGroup]);

# Checks whether a subgroup is fully F-automized
DeclareOperation("IsFullyAutomized", [IsFusionSystem, IsGroup]);

# Computes the group N_phi for a map in F
DeclareOperation("NPhi", [IsFusionSystem, IsGroupHomomorphism]);

# Tries to extend the map $\\phi$ to N_\phi
DeclareOperation("ExtendMapToNPhi", [IsFusionSystem, IsGroupHomomorphism]);

# Checks whether a subgroup is F-receptive
DeclareOperation("IsFReceptive", [IsFusionSystem, IsGroup]);

# Checks whether a subgroup is F-centric
DeclareOperation("IsFCentric", [IsFusionSystem, IsGroup]);

# Checks whether a subgroup is F-radical
DeclareOperation("IsFRadical", [IsFusionSystem, IsGroup]);

# Checks whether a fusion system is saturated
DeclareProperty("IsSaturated", IsFusionSystem);

# Tries to find an isomorphism between 2 fusion systems
DeclareOperation("IsomorphismFusionSystems", [IsFusionSystem, IsFusionSystem]);

# `Intersect(F, E)` that takes 2 fusion systems `F` and `E` and returns their intersection.
# `AddMap(F, phi)` that constructs a fusion system generated by `F` and `phi` a morphism between any two subgroups.
# `AddMapSaturated(F, phi)` that tries to construct a saturated fusion system generated by a saturated fusion system `F` and `phi` an automorphism of a centric subgroup.
# `IsSaturated(F)` that checks whether `F` is a saturated fusion system.
# `IsExotic(F)` that checks whether `F` is an exotic fusion system.
