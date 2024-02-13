gap> START_TEST("Fusion Systems package: misc.tst");

## Find prime of prime order
gap> q := 2;
2
gap> FindPrimeOfPrimePower(q);
2
gap> q := 10;
10
gap> FindPrimeOfPrimePower(q);
fail
gap> q := 9;
9
gap> FindPrimeOfPrimePower(q);
3
gap> q := 9*81;
729
gap> FindPrimeOfPrimePower(q);
3
gap> q := 1024;
1024
gap> FindPrimeOfPrimePower(q);
2
gap> q := 256;
256
gap> FindPrimeOfPrimePower(q);
2
gap> q := 36;
36
gap> FindPrimeOfPrimePower(q);
fail

## Automizer for subgroups
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> P := SylowSubgroup(G, 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> A := Automizer(G, P);
<group with 2 generators>
gap> Size(A);
4
gap> IsElementaryAbelian(A);
true
gap> phi := GroupHomomorphismByImages(P, [P.1, P.2, P.3], [P.2, P.1, P.3]);
[ (1,2), (3,4), (1,3)(2,4) ] -> [ (3,4), (1,2), (1,3)(2,4) ]
gap> phi in A;
true
gap> phi := GroupHomomorphismByImages(P, [P.1, P.2, P.3], [P.3, P.1*P.2*P.3, P.1]);
[ (1,2), (3,4), (1,3)(2,4) ] -> [ (1,3)(2,4), (1,4)(2,3), (1,2) ]
gap> phi in A;
false

## Automizer for automorphism groups
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> P := SylowSubgroup(G, 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> A := AutomorphismGroup(G);
<group of size 24 with 4 generators>
gap> Size(Automizer(A, G));
24
gap> Size(Automizer(A, P));
4
gap> Q := Group([ (1,2)(3,4), (1,3)(2, 4) ]);
Group([ (1,2)(3,4), (1,3)(2,4) ])
gap> R := First(MaximalSubgroups(P), R -> R <> Q and IsElementaryAbelian(R));
Group([ (1,2), (1,2)(3,4) ])
gap> Size(Automizer(A, Q));
6
gap> Size(Automizer(A, R));
2

## AutomizerHomomorphism
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> P := SylowSubgroup(G, 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> c := AutomizerHomomorphism(G, P);
MappingByFunction( Group([ (1,4)(2,3), (3,4), (1,2) ]), <group with 
2 generators>, function( g ) ... end )
gap> c1 := Image(c, ());
^()
gap> Order(c1);
1
gap> c1 = IdentityMapping(P);
true
gap> c2 := Image(c, (1,2));
^(1,2)
gap> Order(c2);
2
gap> c3 := Image(c, (1,3,2,4));
^(1,3,2,4)
gap> Order(c3);
2
gap> c2 = c3;
false
gap> c3 := Image(c, P.1*P.2);
^(1,2)(3,4)
gap> Order(c3);
1
gap> c3 = c1;
true

## IsStronglyPEmbedded
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> P := SylowSubgroup(G, 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> IsStronglyPEmbedded(G, P, 2);
false
gap> IsStronglyPEmbedded(G, P, 3);
false
gap> P := SylowSubgroup(G, 3);
Group([ (1,2,3) ])
gap> IsStronglyPEmbedded(G, P, 2);
false
gap> IsStronglyPEmbedded(G, P, 3);
true
gap> STOP_TEST( "misc.tst", 10000 );
