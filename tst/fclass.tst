gap> START_TEST("Fusion Systems package: fclass.tst");
gap> G := AlternatingGroup(6);;
gap> P := SylowSubgroup(G, 2);;
gap> F := RealizedFusionSystem(G, P);;
gap> C := ConjugacyClassesSubgroups(P);;
gap> FCls := List(C, c -> FClass(F, Representative(c)));;
gap> List(FCls, Size);
[ 1, 5, 5, 5, 1, 1, 1, 1 ]
gap> List(FCls, c -> Size(Representative(c)));
[ 1, 2, 2, 2, 4, 4, 4, 8 ]
gap> ForAll(FCls, Cl -> UnderlyingFusionSystem(Cl) = F);
true
gap> FCls[1] = FCls[2];
false
gap> FCls[2] = FCls[3];
true
gap> FCls[2] = FCls[2];
true
gap> ForAll(FCls, Cl -> ForAll(C, c -> c in C));
true
gap> ForAll(FCls, Cl -> ForAll(Cl, c -> Size(Representative(Cl)) = Size(c)));
true
gap> ForAll(FCls, Cl -> ForAll(Cl, c -> IdGroup(Representative(Cl)) = IdGroup(c)));
true
gap> STOP_TEST( "fclass.tst", 10000 );