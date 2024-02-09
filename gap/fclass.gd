#! @Chapter FClass 

#! We represent a $\calF$-conjugacy class with the category `IsFClass`. In the current implementation, we construct a $\calF$-conjugacy class by providing a list of $P$-conjugacy class representatives. 
#!
#! For efficiency, we do not represent a $\calF$-class as a list. It is instead a collection, like the normal conjugacy class. We do this by making it a collection. The collection operations `AsList`, `Size`, `Representative`, `Enumerator` and `EnumeratorSorted` have been overriden for efficiency.

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
#! Given two conjugacy classes $C_1$ and $C_2$, possibly of different fusion systems $\calF_1$ and $\calF_2$, checks whether $C_1$ and $C_2$ are equal as sets. 
#! 
#! This function is used in checking whether two fusion systems are equals, which is why we allow conjugacy classes with different underlying fusion systems as well.
#! 
#! This operation first check whether the underlying groups of $\calF_1$ and $\calF_2$ are equal, and whether they could be isomorphic (same size and same id if small). We then check whether representatives of $A$ and $B$ of $C_1$ and $C_2$ are $\calF_1$-isomorphic. This is enough in the case that $\calF_1 = \calF_2$. Otherwise, we check whether the representatives are also $\calF_2$-conjugate, the classes have the same size, and finally if there is a bijection between $P$-conjugacy classes of $C_1$ and $C_2$.
#! @Arguments C1 C2
#! @Returns `true` or `false`
DeclareOperation("\=", [IsFClass, IsFClass]);

#! @Description
#! Given a $\calF$-class $C$ of a fusion system $\calF$ on $P$ and a subgroup $A \leq P$, checks whether $A$ is contained in $C$.
#! 
#! This operation first checks whether finding a representative $B$ of $C$, and then whether `AreFConjugate(F, A, B)` returns `true`.
#! @Arguments A C
#! @Returns `true` or `false`
DeclareOperation("\in", [IsGroup, IsFClass]);

DeclareRepresentation("IsFClassByCoClassesRep",
    IsComponentObjectRep and IsFClass, ["F", "reps"]);
