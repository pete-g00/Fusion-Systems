gap> START_TEST("Fusion Systems package: realized-fusion-system.tst");

#############################################################################
## Initial Definitions

gap> G := SymmetricGroup(4);;
gap> P := SylowSubgroup(G, 2);;
gap> F := RealizedFusionSystem(G, P);;
gap> C := ConjugacyClassesSubgroups(P);;

#############################################################################
## Attributes

gap> UnderlyingGroup(F) = P;
true
gap> RealizingGroup(F) = G;
true
gap> Prime(F) = 2;
true

#############################################################################
## AreFConjugate

gap> ForAll(C, c -> AutF(F, Representative(c)) = Automizer(G, Representative(c)));
true
gap> ForAll(C, cl -> ForAll(cl, H -> AreFConjugate(F, H, Representative(cl))));
true
gap> AreFConjugate(F, Representative(C[2]), Representative(C[3]));
false
gap> AreFConjugate(F, Representative(C[2]), Representative(C[4]));
false
gap> AreFConjugate(F, Representative(C[3]), Representative(C[4]));
true

#############################################################################
## IsFullyCentralized, IsFullyNormalized, IsFReceptive

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

#############################################################################
## IsSaturated 

gap> r := First(P, x -> Order(x) = 4);;
gap> f := First(P, x -> Order(x) = 2 and not x in Group(r));;
gap> Q := Group(r^2, f);;
gap> R := Group(r^2, r*f);;
gap> A := Group(r*f);;
gap> B := Group(f);;
gap> C := Group(r^2);;

gap> IsSaturated(F);
true
gap> Size(FClass(F, P));
1
gap> Size(FClass(F, Q));
1
gap> Size(FClass(F, R));
1
gap> Size(FClass(F, A));
3
gap> Size(FClass(F, B));
2
gap> Size(FClass(F, C));
3
gap> STOP_TEST( "realized-fusion-system.tst", 10000 );
