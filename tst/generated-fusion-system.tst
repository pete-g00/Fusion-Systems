gap> START_TEST("Fusion Systems package: generated-fusion-system.tst");

#############################################################################
## Initial Definitions

gap> P := DihedralGroup(8);;
gap> r := First(P, r -> Order(r) = 4);;
gap> f := First(P, f -> Order(f) = 2 and not f in Group(r));;
gap> Q := Group(r^2, f);;
gap> R := Group(r^2, r*f);;
gap> A := Group(f);;
gap> B := Group(r*f);;
gap> C := Group(r^2);;

gap> phi1 := GroupHomomorphismByImages(Q, [r^2, f], [f, r^2*f]);;
gap> phi2 := GroupHomomorphismByImages(P, [r, f], [r, r*f]);;
gap> phi1 <> fail;
true
gap> phi2 <> fail;
true
gap> Order(phi1);
3
gap> Order(phi2);
4

gap> F1 := GeneratedFusionSystem(P, [phi1]);;
gap> F2 := GeneratedFusionSystem(F1, [phi2]);;


#############################################################################
## Attributes

gap> UnderlyingGroup(F1) = P;
true
gap> Prime(F1) = 2;
true
gap> UnderlyingGroup(F1) = P;
true
gap> Prime(F2) = 2;
true

#############################################################################
## AutF
gap> Size(AutF(F1, P));
4
gap> Size(AutF(F1, Q));
6
gap> Size(AutF(F1, R));
2
gap> Size(AutF(F2, P));
8
gap> Size(AutF(F2, Q));
6
gap> Size(AutF(F2, R));
6

#############################################################################
## AreFConjugate
gap> AreFConjugate(F1, P, P);
true
gap> AreFConjugate(F1, P, Q);
false
gap> AreFConjugate(F1, Q, R);
false
gap> AreFConjugate(F1, A, B);
false
gap> AreFConjugate(F1, A, C);
true
gap> AreFConjugate(F2, P, Q);
false
gap> AreFConjugate(F2, Q, R);
true
gap> AreFConjugate(F2, A, B);
true
gap> AreFConjugate(F2, A, C);
true

#############################################################################
## FClassReps
gap> Length(FClassReps(F1, A));
2
gap> Length(FClassReps(F1, B));
1
gap> Length(FClassReps(F1, C));
2
gap> Length(FClassReps(F1, P));
1
gap> Length(FClassReps(F1, Q));
1
gap> Length(FClassReps(F1, R));
1
gap> Length(FClassReps(F2, A));
3
gap> Length(FClassReps(F2, B));
3
gap> Length(FClassReps(F2, C));
3
gap> Length(FClassReps(F1, P));
1
gap> Length(FClassReps(F2, Q));
2
gap> Length(FClassReps(F2, R));
2

gap> STOP_TEST( "generated-fusion-system.tst", 10000 );
