#############################################################################
##
##
#W  fusion-systems.gd         Fusion Systems                      Pete Gautam
##
##  Declaration file for general functions of the fusion systems package.
##
#Y  Copyright (C) 2024      University of Birmingham, 
#Y                          Birmingham, England
##
#############################################################################


# General declarations of fusion systems
# In this file, we declare the fusion system category along with the attributes/operations it has.
# This is an abstract representation of a fusion system- we expect every representation to have these functionalities,
# but they might have different implementatinos to make it optimal with respect to what we know about the given fusion system.

# There are 2 kinds of attibutes/operations here- the first few must be implemented by every representation to make the fusion system work. 
# This is the minimal set of attributes/operations a fusion system needs in order for us to define all the other operations. 
# It is however possible that there are more efficient ways of computing the other operations/attibutes, and so these functionalities can also be overridden in a specific representation.

# TODO: Infer the prime instead of getting it from the user

#! @Chapter Operations on Fusion Systems 

DeclareCategory("IsFusionSystem", IsObject);

BindGlobal( "FusionSystemFamily", NewFamily("FusionSystemFamily") );

# 
# Every representation of a fusion system MUST implement this attributes/operations
# 

#! @Section Core Functionality
#! The core operations are those that we deem the most important when dealing with a fusion system $\calF$. These include finding the underlying group/prime of the fusion system and finding an isomorphism between 2 $\calF$-conjugate subgroups.
#! 
#! The implementation of most of these core attributes is dictated by the representation we choose. This means that it may be more efficient to interact with a fusion system depending on its representation.

# TODO: Describe what would be a good way to represent fusion systems

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns the group $P$.
#! @Arguments F
#! @Returns a group
DeclareAttribute("UnderlyingGroup", IsFusionSystem);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns the prime $p$.
#! @Arguments F
#! @Returns a prime
DeclareAttribute("Prime", IsFusionSystem);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, returns the group of automorphisms $\Aut_\calF(A)$.
#! @Arguments F A
#! @Returns a group
DeclareOperation("AutF", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and subgroup $A, B \leq P$, returns a representative isomorphism between them if they are $\calF$-conjugate, and `fail` otherwise.
#! @Arguments F A B
#! @Returns an isomorphism or `fail`
DeclareOperation("RepresentativeFIsomorphism", [IsFusionSystem, IsGroup, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $Q \leq P$, returns all groups in the $\calF$-conjugacy class of $Q$, up to $P$-conjugacy class.
#! @Arguments F Q
#! @Returns a list of groups
DeclareOperation("FClassReps", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns a representative from each $\calF$-conjugacy class in $P$. 
#!
#! Although this is a core operation, it is the same for every representation. We first find `ConjugacyClassesSubgroups(P)`, and then group them by isomorphism type (or size if the group is too big) to find a representative of an $\calF$-conjugacy class for each isomorphism type.
#! 
#! @Arguments F
#! @Returns a list of groups
DeclareAttribute("FClassesReps", IsFusionSystem);

# TODO: Make this up to P-conjugacy classes
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns all the $\calF$-conjugates of $A$ that are subsets of $B$.
#! 
#! Although this is a core operation, it is the same for every representation. If `Size(A)` is strictly smaller than `Size(B)`, then we look at the $\calF$-class of $A$ and return all those that are subsets of $B$. Otherwise, we check whether $A$ and $B$ are $\calF$-conjugate.
#! @Arguments F A B
#! @Returns a list of groups
DeclareOperation("ContainedFConjugates", [IsFusionSystem, IsGroup, IsGroup]);

#! @Section Complete Functionality
#! These operations complement the core functionality. In particular, all of these operations make use of the core operations, which return a representative whenever possible, and give a complete list of values. Since these operations make use of the core functionality, it is possible that certain representations perform better than others. A brief description of the implementation is provided for each of the operations.

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group and a subgroup $A \leq P$, returns all the subgroups in the $\calF$-conjugacy class of $A$. 
#! 
#! This operation makes use of the `FClassReps` operation, which only returns a representative from each $P$-conjugacy class, and returns the entire $\calF$-conjugacy class. This operation returns a collection, represented by an `IsFClass` object.
#! @Arguments F A
#! @Returns a $\calF$-class
DeclareOperation("FClass", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns a list of $\calF$-conjugacy classes of $P$. 
#! 
#! This operation makes use of the `FClassesReps` operation, which only returns a representative $A$ from each $\calF$-conjugacy class, and converts each representative into a $\calF$-conjugacy class using `FClass(F, A)`.
#! @Arguments F
#! @Returns a list of groups
DeclareAttribute("FClasses", IsFusionSystem);

# TODO: IsomF and HomF aren't returning the correct map range
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and subgroups $A, B \leq P$, returns a list of isomorphisms $A \to B$ in $\calF$, i.e. the set $\Isom_\calF(A, B)$. If $A$ and $B$ are not $\calF$-conjugate, then this operation returns an empty list. 
#! 
#! This operation first calls `RepresentativeFIsomorphism(F, A, B)`, and uses `AutF(F, A)` to return the coset of isomorphisms.
#! @Arguments F A B
#! @Returns a list of isomorphisms
DeclareOperation("IsomF", [IsFusionSystem, IsGroup, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and subgroups $A, B \leq P$, returns a list of homomorphisms $A \to B$ in $\calF$, i.e. the set $\Hom_\calF(A, B)$. 
#! 
#! This operation first calls `ContainedFConjugates(F, A, B)` to find all subgroups of $B$ that $A$ is $\calF$-conjugate to, and then calls `IsomF(F, A, C)` for every subgroup $C \leq B$ that $A$ is $\calF$-conjugate to.
#! @Arguments F A B
#! @Returns a list of homomorphisms
DeclareOperation("HomF", [IsFusionSystem, IsGroup, IsGroup]);

#! @Section Auxiliary Operations
#! The auxiliary operations on fusion systems are those that allow us to infer certain properties about the subgroups, such as checking whether a subgroup is fully normalized. They make use of the core operations, and not their complete versions, for efficiency whenever possible. A brief description of the implementation is provided for each of the operations.

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroups $A, B \leq P$, checks whether $A$ and $B$ are $\calF$-conjugate. 
#! 
#! This is done by checking that `RepresentativeFIsomorphism(F, A, B)` doesn't return `fail`.
#! @Arguments F A B
#! @Returns `true` or `false`
DeclareOperation("AreFConjugate", [IsFusionSystem, IsGroup, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$, checks whether $A, B \leq P$ and $\phi \in \Hom_\calF(A, B)$. 
#! 
#! We first find `RepresentativeFIsomorphism(F, A, Image(phi))` to see if the 2 subgroups are $\calF$-conjugate, and to generate a second map $\psi \colon A \to A\phi$. If they are $\calF$-conjugate, then we check whether the map $\psi \phi^{-1}$ lies in `AutF(F, A)`.
#! @Arguments phi F
#! @Returns `true` or `false`
DeclareOperation("\in", [IsGroupHomomorphism, IsFusionSystem]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-normalized. 
#! 
#! This is done by checking whether the size of `Normalizer(P, A)` is maximal amongst the normalizer of all subgoups $B$ that lie in `FClassReps(F, A)`.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyNormalized", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-centralized. 
#! 
#! This is done by checking whether the size of `Centralizer(P, A)` is maximal amongst the centralizer of all subgoups $B$ that lie in `FClassReps(F, A)`.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyCentralized", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-centralized. 
#! 
#! This is done by checking whether `Automizer(P, A)` is a Sylow $p$-subgroup of `AutF(F, A)`.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyAutomized", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$ in $\calF$, computes the group $N_\phi$. 
#!
#! This is done by transversing $AC_P(A)$ in $N_P(A)$, and checking which ones satisfy the $N_\phi$ condition, i.e. whether $x \in N_P(A)$ satisfies $c_x^\phi \in \Aut_P(B)$.
#! @Arguments F phi
#! @Returns a group
DeclareOperation("NPhi", [IsFusionSystem, IsGroupHomomorphism]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$ in $\calF$, tries to extend this map to $\overline{\phi} \colon N_\phi \to N_P(B)$. If successful, we return the given map; otherwise, we return `fail`.
#! 
#! This is done by checking whether there exists an extension of $\phi$ in the set $\Hom_\calF(N_\phi, N_P(B))$.
#! 
#! @Arguments F phi
#! @Returns a homomorphism or `fail`
DeclareOperation("ExtendMapToNPhi", [IsFusionSystem, IsGroupHomomorphism]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-receptive.
#! 
#!  This is done by checking with every $B$ in `FClassRep(F, A)` whether for every a representative map $\phi \colon A \to A$ from the cosets of $\Aut_\calF(Q)/\Aut_P(Q)$, the map $\sigma = \phi*\psi$ extends $N_\sigma$, where $\psi$ is a representative $\calF$-isomorphism $A \to B$.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFReceptive", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-centric. 
#! 
#! This is done by checking whether every $B$ in `FClassReps(F, A)` satisfies $C_P(B) \leq B$.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFCentric", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-radical. 
#! 
#! This is done by checking whether $O_p(A) = \Inn(A)$.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFRadical", [IsFusionSystem, IsGroup]);

# TODO: Move the IsFEssential code
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is essential in $\calF$. 
#! 
#! This is done by first checking whether $A$ is $\calF$-centric, and if so, whether $\Out_\calF(Q) = \Aut_\calF(Q)/\Inn(Q)$ contains a strongly $p$-embedded subgroup (up to conjugacy class).
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFEssential", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, checks whether $\calF$ is saturated. 
#! 
#! This is done by checking whether for every $\calF$-class rep $A$, there exists a $\calF$-conjugate of $Q$ (up to $P$-conjugation) that is fully $\calF$-automized and $\calF$-receptive.
#! @Arguments F
DeclareProperty("IsSaturated", IsFusionSystem);

#! @Description
#! Given two fusion systems $\calF_1$ and $\calF_2$ on finite $p$-groups $P_1$ and $P_2$ respectively, checks whether $\calF_1 = \calF_2$. 
#! 
#! This is done by checking whether for every $\calF$-conjugcy class representative $A$, the automorphism groups and the $\calF$-classes are equal.
#! @Arguments F1 F2
#! @Returns `true` or `false`
DeclareOperation("\=", [IsFusionSystem, IsFusionSystem]);

#! @Description
#! Given fusion systems $\calF_1$ and $\calF_2$ on a finite $p$-groups $P$ and $Q$ respectively, tries to find an isomophism of fusion systems $\calF_1 \to \calF_2$. If there is no such isomorphism, returns `fail`.
#! 
#! This is done by first finding an isomorphism between the groups $P$ and $Q$, using `IsomorphismGroups(P, Q)`. If successful, we then check for every representative $\phi$ from each coset of `AutomorphismGroup(P)` in `AutF(F, P)` whether $\calF_1^\phi = \calF_2$.
#! @Arguments F1 F2
#! @Returns an isomorphism or `fail`
DeclareOperation("IsomorphismFusionSystems", [IsFusionSystem, IsFusionSystem]);
