#! @Chapter Miscallenous functions
#! In this section, we define some functionalities about groups and group homomorphisms that are used in the main fusion systems package. It is hoped that these operations will be of use in general.

#! @Section Operations

# Given subgroups $A$ and $B$ of some group $G$, and a $g \in G$ such that 
# $A^g \leq B$, defines the homomorphism $A \to B$ by $a \mapsto a^g$
DeclareOperation("ConjugationHomomorphism", [IsGroup, IsGroup, IsObject]);

#! @Description
#! Given a prime power $q = p^n$, returns the prime $p$
DeclareOperation("FindPrimeOfPrimePower", [IsScalar]);

#! @BeginGroup Automizers
#! @Arguments G H
#! @Returns a group
DeclareOperation("Automizer", [IsGroup, IsGroup]);

#! @Description 
#! Let $G$ be a group, $H$ a subgroup of $G$, and $A \leq \Aut(G)$.
#! 
#! The operation `Automizer(G, H)` computes the automorphism group of $H$ induced by conjugation in $G$, denoted $\Aut_G(H)$. Specifically, we return the group
#! $$\Aut_G(H) = \{c_g \in \Aut(H) \mid g \in N_G(H)\},$$
#! where $c_g \in \Aut(H)$ is the map given by conjugation, i.e. $xc_g = x^g$ for $x \in H$.
#! 
#! The operation `Automizer(A, H)` returns the automorphism group of $H$ induced maps in $A$, denoted $\Aut_A(H)$. Specifically, we return the group
#! $$\Aut_A(H) = \{\phi \in \Aut(G) \mid \phi|_H \in \Aut(H)\},$$
#! 
#! @Arguments A H
#! @Returns a group
DeclareOperation("Automizer", [IsGroupOfAutomorphisms, IsGroup]);
#! @EndGroup

#! @Description
#! Given a group $G$ and a subgroup $H$, the operation `AutomizerHomomorphism(G, H)` constructs the automizer homomorphism $c \colon N_G(H) \to \Aut_G(H)$. This is the homomorphism that maps every $g \in N_G(H)$ to the automorphism map $c_g \in \Aut(H)$ given by conjugation, i.e. $xc_g = x^g$ for $x \in H$.
#! 
#! @Arguments G H
#! @Returns a homomorphism
DeclareOperation("AutomizerHomomorphism", [IsGroup, IsGroup]);

#! @Description 
#! Given two homomorphisms $\phi$ and $\psi$, checks whether $\psi$ is a restriction of $\phi$
#! 
#! @Arguments phi psi
#! @Returns `true` or `false`
DeclareOperation("IsRestrictedHomomorphism", [IsGroupHomomorphism, IsGroupHomomorphism]);

# TODO: The ability to restrict the domain and the codomain of a group homomorphism

# # Checks whether a homomorphism fixes the given subgroup
# DeclareOperation("NormalizesSubgroup", [IsGroupHomomorphism, IsGroup]);

# # Checks whether a homomorphism acts trivially on the given subgroup
# DeclareOperation("CentralizesSubgroup", [IsGroupHomomorphism, IsGroup]);

#! @Description 
#! Let $G$ be a group, with subgroups $A$ and $B$ and a homomorphism $\phi \colon A \to B$. If $L \subseteq \Aut(P)$, then the operation `FindHomExtension(phi, L)` finds an extension in $L$ of $\phi$. If we cannot find an extension, then the operation returns `fail`.
#! 
#! @Arguments phi L
#! @Returns an automorphism or `fail`
DeclareOperation("FindHomExtension", [IsGroupHomomorphism, IsCollection]);

# # FindNormalizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi normalizes Q
# DeclareOperation("FindNormalizingHomExtension", [IsGroupHomomorphism, IsCollection, IsGroup]);

# # FindNormalizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi centralizes Q
# DeclareOperation("FindCentralizingHomExtension", [IsGroupHomomorphism, IsCollection, IsGroup]);

# FindCentralizingAutExtension => find an extension of phi : A -> B to psi : QA -> QB where psi centralizes Q

# RangeRestrictedMapping
# SourceRangeRestrictedMapping

#! @Description
#! Given a group $G$, a subgroup $M$ and a prime $p$, checks whether $H$ is strongly $p$-embedded.
#! 
#! This operation first checks whether $M$ contains a Sylow $p$-subgroup of $G$. If so, we then check whether for every representative $g$ of $G/N_G(M)$ not in $M$, whether $M \cap M^g$ is a $p'$-group.
#! @Arguments G M p
#! @Returns `true` or `false`
DeclareOperation("IsStronglyPEmbedded", [IsGroup, IsGroup, IsScalar]);

# TODO: Probably need to do something better here?
DeclareGlobalFunction("UnionEnumerator");