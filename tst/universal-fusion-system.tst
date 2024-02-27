gap> START_TEST("Fusion Systems package: universal-fusion-system.tst");

#############################################################################
## Initial Definitions

gap> P := DihedralGroup(8);;
gap> U := UniversalFusionSystem(P);;

#############################################################################
## Attributes

gap> UnderlyingGroup(U) = P;
true
gap> Prime(U) = 2;
true

#############################################################################
## AutF

gap> C := ConjugacyClassesSubgroups(P);;
gap> List(C, c -> Size(Representative(c)));
[ 1, 2, 2, 2, 4, 4, 4, 8 ]
gap> List(C, c -> Size(AutF(U, Representative(c))));
[ 1, 1, 1, 1, 6, 2, 6, 8 ]

#############################################################################
## AreFConjugate

gap> ForAll(C, c -> ForAll(c, rep -> AreFConjugate(U, rep, Representative(c))));
true
gap> AreFConjugate(U, Representative(C[1]), Representative(C[2]));
false
gap> AreFConjugate(U, Representative(C[2]), Representative(C[3]));
true

#############################################################################
## FClassesReps

gap> L := FClassesReps(U);;
gap> List(L, Size);
[ 1, 2, 4, 4, 8 ]
gap> List(L, IsCyclic);
[ true, true, true, false, false ]

#############################################################################
## FClassReps, AreFConjugate

gap> C := List(L, Q -> FClassReps(U, Q));;
gap> ForAll(C, c -> ForAll(c, rep -> AreFConjugate(U, rep, Representative(c))));
true
gap> ForAll([1..5], i -> ForAll([1..5], j -> i = j or not AreFConjugate(U, Representative(C[i]), Representative(C[j]))));
true
gap> List(C, Length);
[ 1, 3, 1, 2, 1 ]

gap> STOP_TEST( "universal-fusion-system.tst", 10000 );
