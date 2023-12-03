# TODO: Might be easier to do the iterator by delegating?

InstallMethod(PrintObj,
    "Prints a F-conjugacy class",
    [FClass],
    function(class)
        local H;

        H := Representative(class);
        Print(H, "^F");
    end );

InstallMethod(FClassByCoClasses,
    "Constructs an F-conjugacy class from a list of conjugacy classes (i.e. collection of groups)",
    [IsList],
    function(classes)
        if not IsHomogeneousList(classes) then 
            Error("Must be a homogeneous list");
        fi;
        if IsEmpty(classes) then 
            Error("Empty list");
        fi;
        if not IsCollection(classes[1]) then 
            Error("Must be a list of collections");
        fi;
        if not IsGroup(Representative(classes[1])) then 
            Error("Must be a list of groups");
        fi;

        return Objectify(
            NewType(IteratorsFamily, IsIterator and IsCollection and FClassByCoClassesRep),
            rec(classes := classes, classIdx := 1, classIter := Iterator(classes[1])));
    end );

InstallMethod(IsDoneIterator,
    "Checks whether there is another group in the F-conjugacy class",
    [FClassByCoClassesRep],
    function(iter)
        # if we're not at the end of the current iterator, we're fine
        if not IsDoneIterator(iter!.classIter) then 
            return false;
        fi;

        # if we are finished with this iterator, and there's no other iterator, we have finished iterating
        return iter!.classIdx = Length(iter!.classes);
    end );

InstallMethod(NextIterator,
    "Returns the next group in the F-conjugacy class",
    [FClassByCoClassesRep and IsMutable],
    function(iter)
        local i;

        if IsDoneIterator(iter!.classIter) then 
            i := iter!.classIdx + 1;
            
            if i > Length(iter!.classes) then 
                Error("Iteration completed.");
            fi;
            
            iter!.classIter := Iterator(iter!.classes[i]);
        fi;
        
        return NextIterator(iter!.classIter);
    end );

# Returns enum!.classes[i]
ElementNumber := function(enum, i)
    local cur_pos, class, class_size, class_enum;

    cur_pos := 0;
    for class in enum!.classes do 
        class_size := Size(class);
        if i > cur_pos and i <= cur_pos + class_size then 
            class_enum := Enumerator(class);
            return class_enum[i - cur_pos];
        fi;
        cur_pos := cur_pos + Size(class);
    od;

    Error("Element out of range 1-", cur_pos);
end;

# Returns the position of elt in enum!.classes
NumberElement := function(enum, elt)
    local cur_pos, class, class_enum, i;

    cur_pos := 0;
    for class in enum!.classes do 
        class_enum := Enumerator(class);
        i := Position(class_enum, elt);
        if i <> fail then 
            return cur_pos + i;
        fi;
        cur_pos := cur_pos + Size(class);
    od;

    return fail;
end;

InstallMethod(Enumerator,
    "Returns an enumerator for an F-conjugacy class",
    [FClassByCoClassesRep],
    function(iter)
        return EnumeratorByFunctions(CollectionsFamily(FamilyObj(iter!.classes)),
            rec(
                classes := iter!.classes,
                ElementNumber := ElementNumber,
                NumberElement := NumberElement,
                Length := enum -> Size(iter),
                PrintObj := function(enum)
                    Print("<enumerator of ", iter,">");
                end 
            ));
    end );

InstallMethod(Size,
    "Computes the size of the F-conjugacy class",
    [FClassByCoClassesRep],
    function(iter)
        local size, class;

        size := 0;
        for class in iter!.classes do 
            size := size + Size(class);
        od;

        return size;
    end );

# TODO: How do I transfer the enumerator functionalities to FClassRep?
InstallMethod(Representative,
    "Returns a representative from the F-conjugacy class",
    [FClassByCoClassesRep],
    iter -> Representative(Enumerator(iter)));

InstallMethod(FClassBySubgroups,
    "Constructs an F-conjugacy class from a list of groups",
    [IsList]);
