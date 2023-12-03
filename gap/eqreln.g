EquivalenceRelationByFunction := function(dom, fn)
    local partitions, elt, added, partition;

    partitions := [];
    for elt in dom do
        added := false;
        for partition in partitions do 
            if fn(elt, Representative(partition)) then 
                Add(partition, elt);
                added := true;
                break;
            fi;
        od; 
        
        if not added then 
            Add(partitions, [elt]);
        fi;
    od;

    return EquivalenceRelationByPartition(dom, partitions);
end;

Compute := function(G, P)
    local fn, classes;

    fn := function(clA, clB) 
        local A, B;
        
        A := Representative(clA);
        B := Representative(clB);

        if Size(A) <> Size(B) then 
            return false;
        fi;

        return RepresentativeAction(G, A, B) <> fail;
    end;

    classes := ConjugacyClassesSubgroups(P);
    return EquivalenceRelationByFunction(Domain(classes), fn);
end;
