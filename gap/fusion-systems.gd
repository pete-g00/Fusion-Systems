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
#! This operation is time consuming since we need to find a representative from each $P$-conjugacy class, and then find which of them are $\calF$-conjugate.
#! 
#! @Arguments F
#! @Returns a list of groups
DeclareAttribute("FClassesReps", IsFusionSystem);

# TODO: Make this up to P-conjugacy classes
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns all the $\calF$-conjugates of $A$ that are subsets of $B$.
#! 
#! @Arguments F A B
#! @Returns a list of groups
DeclareOperation("ContainedFConjugates", [IsFusionSystem, IsGroup, IsGroup]);

#! @Section Complete Functionality
#! These operations complement the core functionality. In particular, all of these operations make use of the core operations, which return a representative whenever possible, and give a complete list of values. Since these operations make use of the core functionality, it is possible that certain representations perform better than others.

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group and a subgroup $A \leq P$, returns all the subgroups in the $\calF$-conjugacy class of $A$. This operation returns a collection, represented by an `IsFClass` object.
#! 
#! This operation makes use of the core operation `FClassReps`. 
#! @Arguments F A
#! @Returns a $\calF$-class
DeclareOperation("FClass", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, returns a list of $\calF$-conjugacy classes of $P$. 
#! 
#! This operation makes use of the core operation `FClassesReps`.
#! @Arguments F
#! @Returns a list of groups
DeclareAttribute("FClasses", IsFusionSystem);

# TODO: IsomF and HomF aren't returning the correct map range
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and subgroups $A, B \leq P$, returns a list of isomorphisms $A \to B$ in $\calF$, i.e. the set $\Isom_\calF(A, B)$. If $A$ and $B$ are not $\calF$-conjugate, then this operation returns an empty list. 
#! @Arguments F A B
#! @Returns a list of isomorphisms
DeclareOperation("IsomF", [IsFusionSystem, IsGroup, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and subgroups $A, B \leq P$, returns a list of homomorphisms $A \to B$ in $\calF$, i.e. the set $\Hom_\calF(A, B)$. 
#! @Arguments F A B
#! @Returns a list of homomorphisms
DeclareOperation("HomF", [IsFusionSystem, IsGroup, IsGroup]);

#! @Section Auxiliary Operations
#! The auxiliary operations on fusion systems are those that allow us to infer certain properties about the subgroups, such as checking whether a subgroup is fully normalized. They make use of the core operations, and not their complete versions, for efficiency whenever possible. 

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroups $A, B \leq P$, checks whether $A$ and $B$ are $\calF$-conjugate. 
#! @Arguments F A B
#! @Returns `true` or `false`
DeclareOperation("AreFConjugate", [IsFusionSystem, IsGroup, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$, checks whether $A, B \leq P$ and $\phi \in \Hom_\calF(A, B)$. 
#! @Arguments phi F
#! @Returns `true` or `false`
DeclareOperation("\in", [IsGroupHomomorphism, IsFusionSystem]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-normalized. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyNormalized", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-centralized. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyCentralized", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is fully $\calF$-centralized. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFullyAutomized", [IsFusionSystem, IsGroup]);

#! @BeginExample
#! gap> G := AlternatingGroup(4);
#! Alt( [ 1 .. 4 ] )
#! gap> H := SymmetricGroup(4);
#! Sym( [ 1 .. 4 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> F2 := RealizedFusionSystem(H, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> IsFullyNormalized(F1, P);
#! true
#! gap> IsFullyCentralized(F2, P);
#! true
#! gap> IsFullyAutomized(F1, P);
#! true
#! gap> IsFullyAutomized(F2, P);
#! false
#! @EndExample

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$ in $\calF$, computes the group $N_\phi$. 
#! @Arguments F phi
#! @Returns a group
DeclareOperation("NPhi", [IsFusionSystem, IsGroupHomomorphism]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a map $\phi \colon A \to B$ in $\calF$, tries to extend this map to $\overline{\phi} \colon N_\phi \to N_P(B)$. If successful, we return the given map; otherwise, we return `fail`.
#! @Arguments F phi
#! @Returns a homomorphism or `fail`
DeclareOperation("ExtendMapToNPhi", [IsFusionSystem, IsGroupHomomorphism]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-receptive.
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFReceptive", [IsFusionSystem, IsGroup]);

#! @BeginExample
#! gap> G := SymmetricGroup(4);
#! Sym( [ 1 .. 4 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2), (3,4), (1,3)(2,4) ])
#! gap> A := Group(P.1);
#! Group([ (1,2) ])
#! gap> B := Group(P.3);
#! Group([ (1,3)(2,4) ])
#! gap> F := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2), (3,4), (1,3)(2,4) ] )
#! gap> IsFReceptive(F, A);
#! true
#! gap> IsFReceptive(F, B);
#! false
#! @EndExample

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-centric. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFCentric", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is $\calF$-radical. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFRadical", [IsFusionSystem, IsGroup]);

#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$ and a subgroup $A \leq P$, checks whether $A$ is essential in $\calF$. 
#! @Arguments F A
#! @Returns `true` or `false`
DeclareOperation("IsFEssential", [IsFusionSystem, IsGroup]);

#! @BeginExample
#! gap> G := AlternatingGroup(6);
#! Alt( [ 1 .. 6 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ])
#! gap> H := Group(P.1, P.2, P.3, (3,5)(4,6));
#! Group([ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6), (3,5)(4,6) ])
#! gap> A := Group(P.1, P.2);
#! Group([ (1,2)(3,4), (1,3)(2,4) ])
#! gap> B := Group(P.1, P.3);
#! Group([ (1,2)(3,4), (1,2)(5,6) ])
#! gap> F1 := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> F2 := RealizedFusionSystem(H, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> IsFEssential(F1, A);
#! true
#! gap> IsFEssential(F1, B);
#! true
#! gap> IsFEssential(F2, B);
#! true
#! gap> IsFEssential(F2, A);
#! false
#! @EndExample

# TODO: Experiment with the different definitions of IsSaturated to improve efficiency both when it is and isn't saturated
#! @Description
#! Given a fusion system $\calF$ on a finite $p$-group $P$, checks whether $\calF$ is saturated. 
#! @Arguments F
DeclareProperty("IsSaturated", IsFusionSystem);

#! @BeginExample
#! gap> G := AlternatingGroup(4);
#! Alt( [ 1 .. 4 ] )
#! gap> H := SymmetricGroup(4);
#! Sym( [ 1 .. 4 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> F2 := RealizedFusionSystem(H, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> IsSaturated(F1);
#! true
#! gap> IsSaturated(F2);
#! false
#! @EndExample

#! @Description
#! Given two fusion systems $\calF_1$ and $\calF_2$ on finite $p$-groups $P_1$ and $P_2$ respectively, checks whether $\calF_1 = \calF_2$. 
#! @Arguments F1 F2
#! @Returns `true` or `false`
DeclareOperation("\=", [IsFusionSystem, IsFusionSystem]);

#! @BeginExample
#! gap> G1 := AlternatingGroup(4);
#! Alt( [ 1 .. 4 ] )
#! gap> G2 := SymmetricGroup(4);
#! Sym( [ 1 .. 4 ] )
#! gap> G3 := Group(G1.1, G1.2, (5,6));
#! Group([ (1,2,3), (2,3,4), (5,6) ])
#! gap> P := SylowSubgroup(G1, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G1, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> F2 := RealizedFusionSystem(G2, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> F3 := RealizedFusionSystem(G3, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> F1 = F1;
#! true
#! gap> F1 = F2;
#! false
#! gap> F1 = F3;
#! true
#! @EndExample

#! @Description
#! Given fusion systems $\calF_1$ and $\calF_2$ on a finite $p$-groups $P$ and $Q$ respectively, tries to find an isomorphism of fusion systems $\calF_1 \to \calF_2$. If there is no such isomorphism, returns `fail`.
#! @Arguments F1 F2
#! @Returns an isomorphism or `fail`
DeclareOperation("IsomorphismFusionSystems", [IsFusionSystem, IsFusionSystem]);

#! @BeginExample
#! gap> G1 := AlternatingGroup(4);
#! Alt( [ 1 .. 4 ] )
#! gap> P1 := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G1, P1);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> P2 := ElementaryAbelianGroup(4);
#! <pc group of size 4 with 2 generators>
#! gap> phi := GroupHomomorphismByImages(P2, [P2.1, P2.2], [P2.2, P2.1*P2.2]);
#! [ f1, f2 ] -> [ f2, f1*f2 ]
#! gap> F2 := GeneratedFusionSystem(P2, [phi]);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4) ] )
#! gap> IsomorphismFusionSystems(F1, F2);
#! [ (1,2)(3,4), (1,3)(2,4) ] -> [ f1, f2 ]
#! @EndExample
