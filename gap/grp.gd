# Checks whether $P$ is a Sylow $p$-subgroup of $G$
DeclareOperation("IsSylowPSubgroup", [IsGroup, IsGroup, IsInt]);

# O_p subgroup
DeclareOperation("OpSubgroup", [IsGroup, IsInt]);

# Given subgroups $A$ and $B$ of some group $G$, and a $g \in G$ such that 
# $A^g \leq B$, defines the homomorphism $A \to B$ by $a \mapsto a^g$
DeclareOperation("ConjugationHomomorphism", [IsGroup, IsGroup, IsObject]);

# Given a subgroup $A$ of $G$ and a $g \in G$ such that $A^g = A$,
# defines the homomorphism $A \to A$ by $a \mapsto a^g$
DeclareOperation("ConjugationAutomorphism", [IsGroup, IsObject]);

# Given $Q \leq P$, constructs the homomorphism $N_P(Q) \to \Aut_P(Q)$
DeclareOperation("AutomizerHomomorphism", [IsGroup, IsGroup]);

# Given a group $G$ and a subgroup $H$, finds the automorphism group of $H$ 
# of inner automorphisms of $G$
DeclareOperation("Automizer", [IsGroup, IsGroup]);

# TODO: The ability to restrict the domain and the codomain of a group homomorphism
