gap> START_TEST("Fusion Systems package: realized-fusion-system.tst");
gap> G := SymmetricGroup(4);;
gap> P := SylowSubgroup(G, 2);;
gap> F := RealizedFusionSystem(G, P);;
gap> UnderlyingGroup(F) = P;
true
gap> RealizingGroup(F) = G;
true
gap> Prime(F) = 2;
true
gap> C := ConjugacyClassesSubgroups(P);;
gap> ForAll(C, c -> AutF(F, Representative(c)) = Automizer(G, Representative(c)));
true
gap> ForAll(C, cl -> ForAll(cl, H -> AreFConjugate(F, H, Representative(cl))));
true
gap> List(C, c -> Size(Representative(c)));
[ 1, 2, 2, 2, 4, 4, 4, 8 ]
gap> AreFConjugate(F, Representative(C[2]), Representative(C[3]));
false
gap> AreFConjugate(F, Representative(C[2]), Representative(C[4]));
false
gap> AreFConjugate(F, Representative(C[3]), Representative(C[4]));
true
gap> FNorm := Filtered(C, c -> not IsFullyNormalized(F, Representative(c)));;
gap> Length(FNorm);
1
gap> Size(Representative(FNorm[1]));
2
gap> Size(FNorm[1]);
2
gap> FCent := Filtered(C, c -> not IsFullyCentralized(F, Representative(c)));;
gap> Length(FCent);
1
gap> FRec := Filtered(C, c -> not IsFReceptive(F, Representative(c)));;
gap> Length(FRec);
1
gap> FRec = FCent;
true
gap> FCent = FNorm;
true
gap> IsSaturated(F);
true
gap> C := FClassesReps(F);;
gap> List(C, Size);
[ 1, 2, 2, 4, 4, 4, 8 ]
gap> List(C, c -> Size(FClass(F, c)));
[ 1, 3, 2, 1, 1, 1, 1 ]
gap> STOP_TEST( "realized-fusion-system.tst", 10000 );
