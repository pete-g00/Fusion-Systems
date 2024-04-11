#! @Chapter Miscallenous functions
#! In this section, we define some functionalities about groups and group homomorphisms that are used in the main fusion systems package. It is hoped that these operations will be of use in general.

#! @Section Operations

#! @Description
#! Given a map $\phi \colon A \to B$ and an element $x \in A$, returns the evaluated value $x^\phi$.
#! @Arguments x phi
DeclareGlobalFunction("OnImage");

#! @Description
#! Given a map $\phi \colon A \to B$ and a map $\psi \colon C \to D$, with $A, B \leq C$, 
#! returns the conjugated map $\phi^\psi \colon A^\psi \to B^\psi$
#! @Arguments phi psi
DeclareGlobalFunction("OnHomConjugation");

#! @Description
#! Given a list of maps $\phi_i \colon A_i \to B_i$ and a map $\psi \colon C \to D$, with $A_i, B_i \leq C$, 
#! returns the list of conjugated maps $\phi_i^\psi \colon A_i^\psi \to B_i^\psi$
#! @Arguments phi psi
DeclareGlobalFunction("OnHomListConjugation");

#! @Description
#! Given a group of automorphisms $A$ on the group $P$ and an isomorphism $\psi \colon P \to Q$, returns
#! the corresponding group of automorphism $A^\psi$ of $Q$.
#! @Arguments A psi
DeclareGlobalFunction("OnAutGroupConjugation");

#! @Description
#! Given a group $P$, defines the action of $H \leq \Aut(P)$ on the conjugacy classes of $P$.
#! 
#! In particular, $H$ acts on a conjugacy class $Q^P$ by application, i.e. $\phi \colon Q^P = (Q^\phi)^P$.
#! 
#! @Arguments P
DeclareGlobalFunction("OnCoCl");

#! @Description
#! Given a homomorphism $\phi \colon P \to Q$, and $A \leq P$ and $Q \leq B$, 
#! returns the induced homomorphism $\psi \colon A \to B$.
#! 
#! This version does not check whether $A \leq P$ and $Q \leq B$.
#! @Arguments phi A B
DeclareOperation("RestrictedHomomorphismNC", [IsGroupHomomorphism, IsGroup, IsGroup]);

#! @Description
#! Given a homomorphism $\phi \colon P \to Q$, and $A \leq P$ and $Q \leq B$, 
#! returns the induced homomorphism $\psi \colon A \to B$.
#! 
#! This version checks whether $A \leq P$ and $Q \leq B$.
#! @Arguments phi A B
DeclareOperation("RestrictedHomomorphism", [IsGroupHomomorphism, IsGroup, IsGroup]);

# TODO: Improve code
# Given subgroups $A$ and $B$ of some group $G$, and a $g \in G$ such that 
# $A^g \leq B$, defines the homomorphism $A \to B$ by $a \mapsto a^g$
DeclareOperation("ConjugationHomomorphism", [IsGroup, IsGroup, IsObject]);

#! @Description
#! Given a prime power $q = p^n$, returns the prime $p$. If $q$ is not a prime power, then returns `fail`.
#! @Arguments q
DeclareOperation("FindPrimeOfPrimePower", [IsScalar]);

#! @BeginExample
#! gap> FindPrimeOfPrimePower(1024);
#! 2
#! gap> FindPrimeOfPrimePower(10);
#! fail
#! @EndExample

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
#! Given a group $P$ and a map $\phi \colon A \to B$ with $A, B \leq P$, computes the group $N_\phi$ in $P$. 
#! @Arguments P phi 
#! @Returns a group
DeclareOperation("NPhi", [IsGroup, IsGroupHomomorphism]);

# TODO: Improve code
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

# TODO: Improve code
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
#! @Arguments G M p
#! @Returns `true` or `false`
DeclareOperation("IsStronglyPEmbedded", [IsGroup, IsGroup, IsScalar]);

#! @BeginExample
#! gap> P := Group((1,2,3), (1,3));
#! Group([ (1,2,3), (1,3) ])
#! gap> Q := Group(P.1);
#! Group([ (1,2,3) ])
#! gap> IsStronglyPEmbedded(P, Q, 2);
#! false
#! gap> IsStronglyPEmbedded(P, Q, 3);
#! true
#! @EndExample

# TODO: Probably need to do something better here?
DeclareGlobalFunction("UnionEnumerator");
