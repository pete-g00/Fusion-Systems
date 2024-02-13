gap> START_TEST("Fusion Systems package: realized-fusion-system.tst");

## Dih(8) in Sym(4)
gap> G := SymmetricGroup(4);
Sym( [ 1 .. 4 ] )
gap> P := SylowSubgroup(G, 2);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> F := RealizedFusionSystem(G, P);
Fusion System on Group( [ (1,2), (3,4), (1,3)(2,4) ] )
gap> RealizingGroup(F);
Sym( [ 1 .. 4 ] )
gap> UnderlyingGroup(F);
Group([ (1,2), (3,4), (1,3)(2,4) ])
gap> F!.IsSylowSubgroup;
true
gap> IsSaturated(F);
true

## Example 2
## C2*C2 in D8
gap> G := DihedralGroup(8);
<pc group of size 8 with 3 generators>
gap> P := First(MaximalSubgroups(G), IsElementaryAbelian);
Group([ f1, f3 ])
gap> F := RealizedFusionSystem(G, P);
Fusion System on Group( [ f1, f3 ] )
gap> IsSaturated(F);
false
gap> F!.IsSylowSubgroup;
false
gap> STOP_TEST( "realized-fusion-system.tst", 10000 );
