gap> START_TEST("Fusion Systems package: fclass.tst");

#############################################################################
## Initial Definitions

gap> G := AlternatingGroup(6);;
gap> P := SylowSubgroup(G, 2);;
gap> F := RealizedFusionSystem(G, P);;

gap> r := First(P, r -> Order(r) = 4);;
gap> f := First(P, f -> Order(f) = 2 and not f in Group(r));;

gap> Q := Group(r^2, f);;
gap> R := Group(r^2, r*f);;
gap> A := Group(r^2);;
gap> B := Group(f);;
gap> C := Group(r*f);;

gap> clQ := FClass(F, Q);;
gap> clR := FClass(F, R);;
gap> clA := FClass(F, A);;
gap> clB := FClass(F, B);;
gap> clC := FClass(F, C);;

#############################################################################
## UnderlyingFusionSystem
gap> UnderlyingFusionSystem(clQ) = F;
true
gap> UnderlyingFusionSystem(clR) = F;
true
gap> UnderlyingFusionSystem(clA) = F;
true
gap> UnderlyingFusionSystem(clB) = F;
true
gap> UnderlyingFusionSystem(clC) = F;
true

#############################################################################
## Size

gap> Size(clQ);
1
gap> Size(clR);
1
gap> Size(clA);
5
gap> Size(clB);
5
gap> Size(clC);
5

#############################################################################
## in

gap> Q in clQ;
true
gap> Q in clR;
false
gap> A in clB;
true
gap> B in clB;
true
gap> C in clB;
true

#############################################################################
## =

gap> clQ = clR;
false
gap> clA = clB;
true
gap> clC = clB;
true

gap> STOP_TEST( "fclass.tst", 10000 );