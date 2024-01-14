# Checks whether $P$ is a Sylow $p$-subgroup of $G$
DeclareOperation("IsSylowPSubgroup", [IsGroup, IsGroup, IsInt]);

# Given subgroups $A$ and $B$ of some group $G$, and a $g \in G$ such that 
# $A^g \leq B$, defines the homomorphism $A \to B$ by $a \mapsto a^g$
DeclareOperation("ConjugationHomomorphism", [IsGroup, IsGroup, IsObject]);

# Given a group $G$ and a subgroup $H$, finds the automorphism group of $H$ 
# of inner automorphisms of $G$
DeclareOperation("Automizer", [IsGroup, IsGroup]);

# Given $Q \leq P$, constructs the homomorphism $N_P(Q) \to \Aut_P(Q)$
DeclareOperation("AutomizerHomomorphism", [IsGroup, IsGroup]);

# Given two homomorphisms \phi and \psi, checks whether \psi is a restriction of \phi
DeclareOperation("IsRestrictedHomomorphism", [IsGroupHomomorphism, IsGroupHomomorphism]);

# TODO: The ability to restrict the domain and the codomain of a group homomorphism

# Checks whether a homomorphism fixes the given subgroup
DeclareOperation("NormalizesSubgroup", [IsGroupHomomorphism, IsGroup]);

# Checks whether a homomorphism acts trivially on the given subgroup
DeclareOperation("CentralizesSubgroup", [IsGroupHomomorphism, IsGroup]);

# Given a map $\phi \colon A \to B$ and a subgroup $H \leq \Aut(P)$, with $B \leq P$, tries to find an extension in $H$ of the map $\phi$
DeclareOperation("FindHomExtension", [IsGroupHomomorphism, IsCollection]);

# FindNormalizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi normalizes Q
DeclareOperation("FindNormalizingHomExtension", [IsGroupHomomorphism, IsCollection, IsGroup]);

# FindNormalizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi centralizes Q
DeclareOperation("FindCentralizingHomExtension", [IsGroupHomomorphism, IsCollection, IsGroup]);

# FindCentralizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi centralizes Q

# RangeRestrictedMapping
# SourceRangeRestrictedMapping

DeclareGlobalFunction("UnionEnumerator");