gap> START_TEST("Fusion Systems package: transport-fusion-system.tst");

#############################################################################
## Initial Definitions

gap> G := SymmetricGroup(4);;
gap> P := SylowSubgroup(G, 2);;
gap> P1 := SylowSubgroup(G, 2);;
gap> P2 := DihedralGroup(8);;
gap> phi := IsomorphismGroups(P1, P2);;
gap> F1 := RealizedFusionSystem(G, P1);;
gap> F2 := F1^phi;;

#############################################################################
## Attributes

gap> UnderlyingGroup(F2) = P1;
false
gap> UnderlyingGroup(F2) = P2;
true
gap> Prime(F2) = 2;
true

#############################################################################
## FClassesReps

gap> Rep1 := FClassesReps(F1);;
gap> Rep2 := FClassesReps(F2);;
gap> Length(Rep1);
7
gap> Length(Rep2);
7
gap> List(Rep1, R -> Size(AutF(F1, R)));
[ 1, 1, 1, 2, 6, 2, 4 ]
gap> List(Rep2, R -> Size(AutF(F2, R)));
[ 1, 1, 1, 2, 6, 2, 4 ]

#############################################################################
## FClassReps

gap> ForAll([1..7], i -> Image(phi, Rep1[i]) = Rep2[i]);
true
gap> ForAll([1..7], i -> ForAll(FClassReps(F1, Rep1[i]), A -> Image(phi, A) in FClassReps(F2, Rep2[i])));
true

#############################################################################
## =

gap> F2 = F1^phi;
true
gap> F1 = F2;
false

#############################################################################
## IsomorphismFusionSystems

gap> IsomorphismFusionSystems(F1, F2) <> fail;
true

#############################################################################
## AreFConjugate

gap> ForAll(Rep2, rep -> ForAll(FClass(F2, rep), e -> AreFConjugate(F2, e, rep)));
true
gap> ForAll([1..7], i -> ForAll([1..7], j -> i = j or not AreFConjugate(F2, Rep2[i], Rep2[j])));
true

gap> STOP_TEST( "transport-fusion-system.tst", 10000 );
