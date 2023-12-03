# TODO: This might be unncessary - the functions already seem to be instantaneous for any group

DeclareCategory("IsGroupHomomorphismByConjugation", IsGroupHomomorphism);

DeclareRepresentation("IsGroupHomomorphismByConjugationRep",
    IsComponentObjectRep and IsGroupHomomorphismByConjugation, ["source", "range", "elm"]);

DeclareOperation("GroupHomomorphismByConjugation", [IsGroup, IsGroup, IsObject]);

# The element that induces the conjugation homomorphism
DeclareOperation("Elm", [IsGroupHomomorphismByConjugation]);

# > Range (A)
# > Source (B)
# > InverseGeneralMapping (only important if bijection; A^g -> A)
# > RestrictedInverseGeneralMapping (A^g -> A)
# > CompositionMapping (if both are c_g and c_h, then OK)
# > RestrictedMapping (g for a smaller subgroup)
# > IsInjective => always true
# > IsSurjective (use A^g = B)
# > ImageElm (a -> a^g)
# > Image (map) (map, elm) (map, coll)
# > PreImageElm (b -> b^(g^-1))
# > PreImage (map) (map, elm) (map, coll)
# > \= (check A, B and g match)
