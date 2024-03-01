gap> START_TEST("Fusion Systems package: fusion-system.tst");

#############################################################################
## IsomType, CompareByIsom and GroupByIsomType

gap> G := SymmetricGroup(8);;
gap> P := SylowSubgroup(G, 2);;
gap> M := MaximalSubgroups(P);;
gap> CompareByIsom(M[1], M[2]);
0
gap> CompareByIsom(M[2], M[3]);
4
gap> CompareByIsom(M[3], M[4]);
-92
gap> CompareByIsom(M[4], M[5]);
194
gap> L := List(M, A -> IsomType(A));;
gap> Length(L);
7
gap> L[1];
[ 64, 138 ]
gap> L[2];
[ 64, 138 ]
gap> L[3];
[ 64, 134 ]
gap> L[4];
[ 64, 226 ]
gap> L[5];
[ 64, 32 ]
gap> L[6];
[ 64, 32 ]
gap> L[7];
[ 64, 34 ]
gap> R := GroupByIsomType(M);;
gap> L := RecNames(R);;
gap> Length(L);
5
gap> L[1];
"[ 64, 32 ]"
gap> L[2];
"[ 64, 34 ]"
gap> L[3];
"[ 64, 134 ]"
gap> L[4];
"[ 64, 138 ]"
gap> L[5];
"[ 64, 226 ]"
gap> Length(R.(L[1]));
2
gap> Length(R.(L[2]));
1
gap> Length(R.(L[3]));
1
gap> Length(R.(L[4]));
2
gap> Length(R.(L[5]));
1
gap> ForAll(L, l -> ForAll(R.(l), Q -> String(IsomType(Q)) = l));
true

#############################################################################
gap> G := SymmetricGroup(12);;
gap> P := SylowSubgroup(G, 2);;
gap> Q := CyclicGroup(1024);;
gap> IsomType(G);
[ 479001600, 1, 239500800, 3, 27720, 11 ]
gap> IsomType(P);
[ 1024, 4, 32, 11, 8, 31, 5 ]
gap> IsomType(Q);
[ 1024, 1024, 1, 11, 1024, 1, 1 ]
gap> CompareByIsom(G, P);
479000576
gap> CompareByIsom(P, G);
-479000576
gap> CompareByIsom(P, Q);
-1020
gap> R := DihedralGroup(1024);;
gap> S := QuaternionGroup(1024);;
gap> CompareByIsom(R, S);
0

#############################################################################
## Defining Fusion Systems (needed for the upcoming sections)

gap> P := DihedralGroup(8);;
gap> r := First(P, x -> Order(x) = 4);;
gap> f := First(P, x -> not x in Center(P) and Order(x) = 2);;
gap> P = Group(r, f);
true
gap> Q := Group(r^2, f);;
gap> R := Group(r^2, r*f);;
gap> A := Group(f);;
gap> B := Group(r*f);;
gap> C := Group(r^2);;
gap> phi1 := GroupHomomorphismByImages(Q, [Q.1, Q.2], [Q.2, Q.1*Q.2]);;
gap> phi2 := GroupHomomorphismByImages(R, [R.1, R.2], [R.2, R.1*R.2]);;
gap> phi3 := GroupHomomorphismByImages(P, [r, f], [r, r*f]);;
gap> phi1 <> fail;
true
gap> phi2 <> fail;
true
gap> phi3 <> fail;
true
gap> Order(phi1) = 3;
true
gap> Order(phi2) = 3;
true
gap> Order(phi3) = 4;
true
gap> F1 := GeneratedFusionSystem(P, []);;
gap> F2 := GeneratedFusionSystem(P, [phi1]);;
gap> F3 := GeneratedFusionSystem(F2, [phi2]);;
gap> F4 := GeneratedFusionSystem(P, [phi3]);;

#############################################################################
## FClass, FClassesReps, FClasses

gap> FC1 := FClasses(F1);;
gap> Length(FC1);
8
gap> FCR1 := FClassesReps(F1);;
gap> Length(FCR1);
8
gap> ForAll([1..8], i -> FClass(F1, FCR1[i]) = FC1[i]);
true
gap> Size(FClass(F1, Q));
1
gap> Size(FClass(F1, R));
1
gap> Size(FClass(F1, A));
2
gap> Size(FClass(F1, B));
2
gap> Size(FClass(F1, C));
1
gap> FC2 := FClasses(F2);;
gap> Length(FC2);
7
gap> FCR2 := FClassesReps(F2);;
gap> Length(FCR2);
7
gap> ForAll([1..7], i -> FClass(F2, FCR2[i]) = FC2[i]);
true
gap> Size(FClass(F2, Q));
1
gap> Size(FClass(F2, R));
1
gap> Size(FClass(F2, A));
3
gap> Size(FClass(F2, B));
2
gap> Size(FClass(F2, C));
3
gap> FC3 := FClasses(F3);;
gap> Length(FC3);
6
gap> FCR3 := FClassesReps(F3);;
gap> Length(FCR3);
6
gap> ForAll([1..6], i -> FClass(F3, FCR3[i]) = FC3[i]);
true
gap> Size(FClass(F3, Q));
1
gap> Size(FClass(F3, R));
1
gap> Size(FClass(F3, A));
5
gap> Size(FClass(F3, B));
5
gap> Size(FClass(F3, C));
5
gap> FC4 := FClasses(F4);;
gap> Length(FC4);
6
gap> FCR4 := FClassesReps(F4);;
gap> Length(FCR4);
6
gap> ForAll([1..6], i -> FClass(F4, FCR4[i]) = FC4[i]);
true
gap> Size(FClass(F4, Q));
2
gap> Size(FClass(F4, R));
2
gap> Size(FClass(F4, A));
4
gap> Size(FClass(F4, B));
4
gap> Size(FClass(F4, C));
1

#############################################################################
## ContainedFConjugates
gap> ConsAB1 := ContainedFConjugates(F1, C, A);;
gap> Length(ConsAB1);
0
gap> ConsAB2 := ContainedFConjugates(F2, C, A);;
gap> Length(ConsAB2);
1
gap> ConsAB2[1] = A;
true
gap> ConsAB3 := ContainedFConjugates(F3, C, A);;
gap> Length(ConsAB3);
1
gap> ConsAB3 = ConsAB2;
true
gap> ConsAB4 := ContainedFConjugates(F4, C, A);;
gap> Length(ConsAB4);
0
gap> ConsAP4 := ContainedFConjugates(F4, C, P);;
gap> Length(ConsAP4);
1
gap> ConsAP1 := ContainedFConjugates(F1, C, P);;
gap> Length(ConsAP1);
1
gap> ConsAP1[1] = C;
true
gap> ConsAP2 := ContainedFConjugates(F2, C, P);;
gap> Length(ConsAP2);
3
gap> ConsAP3 := ContainedFConjugates(F3, C, P);;
gap> Length(ConsAP3);
5
gap> ConsAP4 := ContainedFConjugates(F4, C, P);;
gap> Length(ConsAP4);
1
gap> ConsBP4 := ContainedFConjugates(F4, A, P);;
gap> Length(ConsBP4);
4

#############################################################################
## IsomF, HomF
gap> I1 := IsomF(F1, C, A);;
gap> Length(I1);
0
gap> I2 := IsomF(F2, C, A);;
gap> Length(I2);
1
gap> IsGroupHomomorphism(I2[1]);
true
gap> Source(I2[1]) = C;
true
gap> Range(I2[1]) = A;
true
gap> Image(I2[1]) = A;
true
gap> I1 = I2;
false
gap> I3 := IsomF(F3, C, A);;
gap> I3 = I2;
true
gap> I4 := IsomF(F4, C, A);;
gap> Length(I4);
0
gap> H1 := HomF(F1, C, P);;
gap> Length(H1);
1
gap> Source(H1[1]) = C;
true
gap> Range(H1[1]) = P;
true
gap> Image(H1[1]) = C;
true
gap> H1[1] = RestrictedMapping(IdentityMapping(P), C);
true
gap> H2 := HomF(F2, C, P);;
gap> Length(H2);
3
gap> ForAll(H2, phi -> Source(phi) = C and Range(phi) = P);
true
gap> H3 := HomF(F3, C, P);;
gap> Length(H3);
5
gap> ForAll(H3, phi -> Source(phi) = C and Range(phi) = P);
true
gap> H4 := HomF(F4, C, P);;
gap> Length(H4);
1
gap> H4 := HomF(F4, B, P);;
gap> Length(H4);
4
gap> ForAll(H4, phi -> Source(phi) = C and Range(phi) = P);
false
gap> ForAll(H4, phi -> Source(phi) = B and Range(phi) = P);
true
gap> I1 = HomF(F1, B, C);
true

#############################################################################
## in
gap> IdentityMapping(P) in F1;
true
gap> IdentityMapping(P) in F2;
true
gap> IdentityMapping(P) in F3;
true
gap> phi1 in F1;
false
gap> phi1 in F2;
true
gap> phi1 in F3;
true
gap> phi1 in F4;
false
gap> phi2 in F1;
false
gap> phi2 in F2;
false
gap> phi2 in F3;
true
gap> phi2 in F4;
false
gap> phi3 in F1;
false
gap> phi3 in F2;
false
gap> phi3 in F3;
false
gap> phi3 in F4;
true

#############################################################################
## IsFullyNormalized, IsFullyCentralized, IsFullyAutomized
gap> C := ConjugacyClassesSubgroups(P);;
gap> F1Aut := Filtered(C, c -> not IsFullyAutomized(F1, Representative(c)));;
gap> Length(F1Aut);
0
gap> F1Norm := Filtered(C, c -> not IsFullyNormalized(F1, Representative(c)));;
gap> Length(F1Norm);
0
gap> F1Cent := Filtered(C, c -> not IsFullyCentralized(F1, Representative(c)));;
gap> Length(F1Cent);
0
gap> F2Aut := Filtered(C, c -> not IsFullyAutomized(F2, Representative(c)));;
gap> Length(F2Aut);
0
gap> F2Norm := Filtered(C, c -> not IsFullyNormalized(F2, Representative(c)));;
gap> Length(F2Norm);
1
gap> F2Cent := Filtered(C, c -> not IsFullyCentralized(F2, Representative(c)));;
gap> Length(F2Cent);
1
gap> F2Norm = F2Cent;
true
gap> F3Aut := Filtered(C, c -> not IsFullyAutomized(F3, Representative(c)));;
gap> Length(F3Aut);
0
gap> F3Norm := Filtered(C, c -> not IsFullyNormalized(F3, Representative(c)));;
gap> Length(F3Norm);
2
gap> F3Cent := Filtered(C, c -> not IsFullyCentralized(F3, Representative(c)));;
gap> Length(F3Cent);
2
gap> F3Norm = F3Cent;
true
gap> F4Aut := Filtered(C, c -> not IsFullyAutomized(F4, Representative(c)));;
gap> Length(F4Aut);
1
gap> Representative(F4Aut[1]) = P;
true
gap> F4Cent := Filtered(C, c -> not IsFullyCentralized(F4, Representative(c)));;
gap> Length(F4Cent);
0
gap> F4Norm := Filtered(C, c -> not IsFullyNormalized(F4, Representative(c)));;
gap> Length(F4Norm);
0

#############################################################################
## NPhi, ExtendMapToNPhi, IsFReceptive
gap> phi := IdentityMapping(Q);;
gap> N := NPhi(P, phi);;
gap> N = P;
true
gap> psi1 := ExtendMapToNPhi(F1, phi);;
gap> psi2 := ExtendMapToNPhi(F2, phi);;
gap> psi3 := ExtendMapToNPhi(F3, phi);;
gap> psi := [psi1, psi2, psi3];;
gap> ForAll(psi, m -> m <> fail);
true
gap> ForAll(psi, m -> Source(m) = P and Range(m) = P);
true
gap> ForAll(psi, IsBijective and IsGroupHomomorphism);
true
gap> NPhi1 := NPhi(P, phi1);;
gap> NPhi1 = Source(phi1);
true
gap> psi1 := ExtendMapToNPhi(F1, phi1);;
gap> psi2 := ExtendMapToNPhi(F2, phi1);;
gap> psi3 := ExtendMapToNPhi(F3, phi1);;
gap> psi := [psi1, psi2, psi3];;
gap> ForAll(psi, m -> m <> fail);
false
gap> First(psi, m -> m = fail) = psi1;
true
gap> ForAll(psi{[2..3]}, m -> m <> fail);
true
gap> NPhi2 := NPhi(P, phi2);;
gap> NPhi2 = Source(phi2);
true
gap> psi1 := ExtendMapToNPhi(F1, phi2);;
gap> psi2 := ExtendMapToNPhi(F2, phi2);;
gap> psi3 := ExtendMapToNPhi(F3, phi2);;
gap> psi := [psi1, psi2, psi3];;
gap> ForAll(psi, m -> m = fail);
false
gap> First(psi, m -> m <> fail) = psi3;
true
gap> ForAll(psi{[1..2]}, m -> m = fail);
true
gap> F1Rec := Filtered(C, c -> not IsFReceptive(F1, Representative(c)));;
gap> Length(F1Rec);
0
gap> F2Rec := Filtered(C, c -> not IsFReceptive(F2, Representative(c)));;
gap> Length(F2Rec);
1
gap> F3Rec := Filtered(C, c -> not IsFReceptive(F3, Representative(c)));;
gap> Length(F3Rec);
2
gap> F4Rec := Filtered(C, c -> not IsFReceptive(F4, Representative(c)));;
gap> Length(F4Rec);
0
gap> F1Rec = F1Cent;
true
gap> F2Rec = F2Cent;
true
gap> F3Rec = F3Cent;
true

#############################################################################
## IsFCentric, IsFRadical, IsFEssential
gap> F1Cent := Filtered(C, c -> IsFCentric(F1, Representative(c)));;
gap> Length(F1Cent);
4
gap> List(F1Cent, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F2Cent := Filtered(C, c -> IsFCentric(F1, Representative(c)));;
gap> Length(F2Cent);
4
gap> List(F2Cent, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F2Cent := Filtered(C, c -> IsFCentric(F2, Representative(c)));;
gap> Length(F2Cent);
4
gap> List(F2Cent, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F3Cent := Filtered(C, c -> IsFCentric(F3, Representative(c)));;
gap> Length(F3Cent);
4
gap> List(F3Cent, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F4Cent := Filtered(C, c -> IsFCentric(F4, Representative(c)));;
gap> Length(F4Cent);
4
gap> List(F4Cent, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F1NRad := Filtered(C, c -> not IsFRadical(F1, Representative(c)));;
gap> Length(F1NRad);
3
gap> List(F1NRad, c -> Size(Representative(c)));
[ 4, 4, 4 ]
gap> F2NRad := Filtered(C, c -> not IsFRadical(F2, Representative(c)));;
gap> Length(F2NRad);
2
gap> List(F2NRad, c -> Size(Representative(c)));
[ 4, 4 ]
gap> F3NRad := Filtered(C, c -> not IsFRadical(F3, Representative(c)));;
gap> Length(F3NRad);
1
gap> List(F3NRad, c -> Size(Representative(c)));
[ 4 ]
gap> IsCyclic(Representative(F3NRad[1]));
true
gap> F4NRad := Filtered(C, c -> not IsFRadical(F4, Representative(c)));;
gap> Length(F4NRad);
4
gap> List(F4NRad, c -> Size(Representative(c)));
[ 4, 4, 4, 8 ]
gap> F1Ess := Filtered(C, c -> IsFEssential(F1, Representative(c)));;
gap> Length(F1Ess);
0
gap> F2Ess := Filtered(C, c -> IsFEssential(F2, Representative(c)));;
gap> Length(F2Ess);
1
gap> Source(phi1) = Representative(F2Ess[1]);
true
gap> F3Ess := Filtered(C, c -> IsFEssential(F3, Representative(c)));;
gap> Length(F3Ess);
2
gap> Source(phi1) = Representative(F3Ess[1]);
true
gap> Source(phi2) = Representative(F3Ess[2]);
true
gap> F4Ess := Filtered(C, c -> IsFEssential(F4, Representative(c)));;
gap> Length(F4Ess);
0

#############################################################################
## IsSaturated
gap> IsSaturated(F1);
true
gap> IsSaturated(F2);
true
gap> IsSaturated(F3);
true
gap> IsSaturated(F4);
false

#############################################################################
## = and IsomorphismFusionSystems
gap> F1 = F2;
false
gap> F2 = F3;
false
gap> F3 = F4;
false
gap> F4 = F1;
false
gap> F1 = F3;
false
gap> F2 = F4;
false
gap> F1 = F4;
false

gap> rho := ActionHomomorphism(P, P, OnRight);;
gap> P := Image(rho, P);;
gap> Q := Image(rho, Q);;
gap> R := Image(rho, R);;
gap> r := Image(rho, r);;
gap> f := Image(rho, f);;
gap> phi1 := GroupHomomorphismByImages(Q, [Q.1, Q.2], [Q.2, Q.1*Q.2]);;
gap> phi2 := GroupHomomorphismByImages(R, [R.1, R.2], [R.2, R.1*R.2]);;
gap> phi3 := GroupHomomorphismByImages(P, [r, f], [r, r*f]);;
gap> G := SymmetricGroup(8);;
gap> CGP := Centralizer(G, P);;
gap> CGQ := Centralizer(G, Q);;
gap> CGR := Centralizer(G, R);;
gap> repA := RepresentativeAction(G, [Q.1, Q.2], [Q.2, Q.1*Q.2], OnTuples);;
gap> a := First(RightCoset(CGQ, repA), a -> Size(SylowSubgroup(Group(r, f, a), 2)) = 8);; 
gap> repB := RepresentativeAction(G, [R.1, R.2], [R.2, R.1*R.2], OnTuples);;
gap> b := First(RightCoset(CGR, repB), a -> Size(SylowSubgroup(Group(r, f, a), 2)) = 8);;
gap> repC := RepresentativeAction(G, [r, f], [r, r*f], OnTuples);;
gap> c := First(RightCoset(CGP, repC), a -> Size(SylowSubgroup(Group(r, f, a), 3)) = 1);;
gap> G1 := Group(r, f);;
gap> G2 := Group(r, f, a);;
gap> G3 := Group(r, f, a, b);;
gap> G4 := Group(r, f, c);;
gap> Size(G1);
8
gap> Size(G2);
24
gap> Size(G3);
168
gap> Size(G4);
32
gap> E1 := RealizedFusionSystem(G1, P);;
gap> E2 := RealizedFusionSystem(G2, P);;
gap> E3 := RealizedFusionSystem(G3, P);;
gap> E4 := RealizedFusionSystem(G4, P);;
gap> Fs := [F1, F2, F3, F4];;
gap> Es := [E1, E2, E3, E4];;
gap> ForAll([1..4], i -> ForAll([1..4], j -> IsomorphismFusionSystems(Fs[i], Es[i]) <> fail or i = j));
true
gap> STOP_TEST( "fusion-system.tst", 10000 );
