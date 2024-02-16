gap> START_TEST("Fusion Systems package: generated-fusion-system.tst");
gap> P := DihedralGroup(8);;
gap> AutP := AutomorphismGroup(P);;
gap> L := Filtered(MaximalSubgroups(P), IsElementaryAbelian);;
gap> Length(L);
2
gap> AutQ := AutomorphismGroup(L[1]);;
gap> phi1 := First(AutQ, phi -> Order(phi) = 3);;
gap> phi2 := First(AutP, phi -> Order(phi) = 4);;
gap> phi1 <> fail;
true
gap> phi2 <> fail;
true
gap> F1 := GeneratedFusionSystem(P, [phi1]);;
gap> F2 := GeneratedFusionSystem(F1, [phi2]);;
gap> UnderlyingGroup(F1) = P;
true
gap> Prime(F1) = 2;
true
gap> UnderlyingGroup(F1) = P;
true
gap> Prime(F2) = 2;
true
gap> C := ConjugacyClassesSubgroups(P);;
gap> List(C, c -> Size(AutF(F1, Representative(c))));
[ 1, 1, 1, 1, 6, 2, 2, 4 ]
gap> List(C, c -> Size(AutF(F2, Representative(c))));
[ 1, 1, 1, 1, 2, 2, 2, 8 ]
gap> List(C, c -> Size(Representative(c)));
[ 1, 2, 2, 2, 4, 4, 4, 8 ]
gap> AreFConjugate(F1, Representative(C[2]), Representative(C[3]));
true
gap> AreFConjugate(F1, Representative(C[4]), Representative(C[3]));
false
gap> AreFConjugate(F2, Representative(C[2]), Representative(C[3]));
true
gap> AreFConjugate(F2, Representative(C[4]), Representative(C[3]));
true
gap> List(C, c -> Size(FClassReps(F1, Representative(c))));
[ 1, 2, 2, 1, 1, 1, 1, 1 ]
gap> List(C, c -> Size(FClassReps(F2, Representative(c))));
[ 1, 3, 3, 3, 2, 1, 2, 1 ]
gap> C1 := FClassesReps(F1);;
gap> List(C1, Size);
[ 1, 2, 2, 4, 4, 4, 8 ]
gap> C2 := FClassesReps(F2);;
gap> List(C2, Size);
[ 1, 2, 4, 4, 8 ]
gap> STOP_TEST( "generated-fusion-system.tst", 10000 );
