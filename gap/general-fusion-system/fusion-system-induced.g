### Defines the conjugation map from $P \to Q$ by $x \mapsto x^g$.
InducedConjugationMap := function(P, Q, g) 
    return GroupHomomorphismByFunction(P, Q, x -> x^g);
end;

DeclareOperation("InducedFusionSystem", [IsGroup, IsGroup]);
InstallMethod( InducedFusionSystem,
    "Retuns the Fusion System F_P(G)",
    [IsGroup, IsGroup],
    function( G, P )
        local c_subs, auts, homs, classes, sub_class, filtered_subs, group_id, aut_sub, homs_sub, classes_sub, g, hom_representatives;
        # Check P is a Sylow $p$-subgroup of $G$

        c_subs := ConjugacyClassesSubgroups(G);

        # Computing the group if for each conjugacy class immediately might improve performance?
        auts := NewDictionary([0, 0], true);
        homs := NewDictionary([0, 0], true);
        classes := NewDictionary([0, 0], true);

        for sub_class in c_subs do 
            # only looking at groups in P that are G-conjugate
            filtered_subs := Filtered(sub_class, sub -> IsSubset(P, sub));
            
            if Length(filtered_subs) = 0 then
                continue;
            fi;

            group_id := IdGroup(filtered_subs[1]);
            
            aut_sub := LookupDictionary(auts, group_id);
            homs_sub := LookupDictionary(homs, group_id);
            classes_sub := LookupDictionary(classes, group_id);

            if aut_sub = fail then
                aut_sub := [];
                homs_sub := [];
                classes_sub := [];
            fi;

            # Will need to make use of conjugacy classes & ContainedConjugates

            hom_representatives := List(filtered_subs, 
                sub -> InducedConjugationMap(filtered_subs[1], sub, 
                RepresentativeAction(G, filtered_subs[1], sub)));
            
            Add(aut_sub, AutomorphismGroup(filtered_subs[1]));
            Add(homs_sub, hom_representatives);
            Add(classes_sub, filtered_subs);
            
            AddDictionary(auts, group_id, aut_sub);
            AddDictionary(homs, group_id, homs_sub);
            AddDictionary(classes, group_id, classes_sub);
        od;

        return Objectify(NewType(FusionSystemFamily, IsFusionSystemRep),
            rec( group := P, auts := auts, homs := homs, classes := classes));
    end );
