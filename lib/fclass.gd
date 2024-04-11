#! @Chapter FClass 

#! We represent a $\calF$-conjugacy class with the category `IsFClass`. In the current implementation, we construct a $\calF$-conjugacy class by providing a list of $P$-conjugacy class representatives. 
#!
#! For efficiency, we do not represent a $\calF$-class as a list. It is instead a collection, like conjugacy class of a group.

#! An example of all the functionalities is given in the example below

#! @Section Operations

DeclareCategory("IsFClass", IsCollection );

#! @Description 
#! Given a $\calF$-class $C$ of a fusion system $\calF$, returns $\calF$.
#! @Arguments C
#! @Returns a fusion system
DeclareAttribute("UnderlyingFusionSystem", IsFClass);

#! @Description
#! Given a $\calF$-class $C$ of a fusion system $\calF$, returns the a list of $P$-conjugacy class representatives that forms $C$.
#! @Arguments C
#! @Returns a list of subgroups
DeclareAttribute("ConjugacyClassRepresentatives", IsFClass);

#! @Description
#! Given two $\calF$-conjugacy classes $C_1$ and $C_2$, possibly of different fusion systems $\calF_1$ and $\calF_2$, checks whether $C_1$ and $C_2$ are equal as sets. It is not necessary that both $C_1$ and $C_2$ are $\calF$-conjugacy classes have the same underlying fusion system.
#! @Arguments C1 C2
#! @Returns `true` or `false`
DeclareOperation("\=", [IsFClass, IsFClass]);

#! @BeginExample 
#! gap> G := AlternatingGroup(6);
#! Alt( [ 1 .. 6 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ])
#! gap> Q := Group(P.1);
#! Group([ (1,2)(3,4) ])
#! gap> R := Group(P.2);
#! Group([ (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> F2 := RealizedFusionSystem(P, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> FClass(F1, P) = FClass(F1, P);
#! true
#! gap> FClass(F1, Q) = FClass(F2, Q);
#! false
#! gap> FClass(F1, Q) = FClass(F2, R);
#! false
#! gap> FClass(F1, Q) = FClass(F1, R);
#! true
#! @EndExample

#! @Description
#! Given a $\calF$-class $C$ of a fusion system $\calF$ on $P$ and a subgroup $A \leq P$, checks whether $A$ is contained in $C$.
#! @Arguments A C
#! @Returns `true` or `false`
DeclareOperation("\in", [IsGroup, IsFClass]);

#! @BeginExample 
#! gap> G := AlternatingGroup(6);
#! Alt( [ 1 .. 6 ] )
#! gap> P := SylowSubgroup(G, 2);
#! Group([ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ])
#! gap> Q := Group(P.1);
#! Group([ (1,2)(3,4) ])
#! gap> R := Group(P.2);
#! Group([ (1,3)(2,4) ])
#! gap> F1 := RealizedFusionSystem(G, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> F2 := RealizedFusionSystem(P, P);
#! Fusion System on Group( [ (1,2)(3,4), (1,3)(2,4), (1,2)(5,6) ] )
#! gap> Q in FClass(F1, Q);
#! true
#! gap> Q in FClass(F1, R);
#! true
#! gap> Q in FClass(F2, R);
#! false
#! @EndExample

DeclareRepresentation("IsFClassByCoClassesRep",
    IsComponentObjectRep and IsFClass, ["F", "reps"]);
