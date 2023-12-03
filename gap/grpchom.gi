# Might be unnecessary?

InstallMethod(GroupHomomorphismByConjugation,
    "Defines a group homomorphism A -> B by x -> x^g",
    [IsGroup, IsGroup, IsObject],
    function(A, B, g)
        return Objectify(
            NewType(NewFamily("IsGroupHomomorphismByConjugationFamily"), IsGroupHomomorphismByConjugationRep),
            rec(source := A, range := B, elm := g));
    end );

InstallMethod(Source,
    "The source of the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function(phi)
        return phi!.source;
    end );

InstallMethod(Range,
    "The source of the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function(phi)
        return phi!.range;
    end );

InstallMethod(Elm,
    "The element inducing the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function (phi)
        return phi!.elm;
    end );

InstallMethod(InverseGeneralMapping,
    "The inverse general mapping that is a homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function(phi)
        # Only for bijections
        if not IsSurjective(phi) then 
            TryNextMethod();
        fi;

        return GroupHomomorphismByConjugation(
            Source(phi)^(Elm(phi)), Range(phi), Inverse(Elm(phi)));
    end );

InstallMethod(RestrictedInverseGeneralMapping,
    "The inverse general mapping that is actually a homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function (phi)
        return GroupHomomorphismByConjugation(
            Source(phi)^(Elm(phi)), Range(phi), Inverse(Elm(phi)));
    end );

# # > CompositionMapping (if both are c_g and c_h, then OK)
# InstallMethod(CompositionMapping,
#     "Compose two conjugation maps",
#     [IsGroupHomomorphismByConjugationRep, IsGroupHomomorphismByConjugationRep],
#     function (phi)
    
#     end );

InstallMethod(RestrictedMapping,
    "Restrict a conjugation homomorphism to a subgroup",
    [IsGroupHomomorphismByConjugationRep, IsGroup],
    function (phi, C)
        if not (IsSubset(Source(phi), C)) then 
            Print(C, " is not a subset of ", Source(phi));
        fi;

        return GroupHomomorphismByConjugation(C, Source(phi), Range(phi), Elm(phi));
    end );

InstallTrueMethod(IsInjective, IsGroupHomomorphismByConjugationRep);

InstallMethod(IsSurjective,
    "Checks whether the map is surjective",
    [IsGroupHomomorphismByConjugationRep],
    function(phi) 
        return Range(phi) = Image(phi);
    end );

InstallMethod(ImageElm,
    "Applies the conjugation homomorphism to an element",
    [IsGroupHomomorphismByConjugationRep, IsObject],
    function(phi, x)
        return x^(Elm(phi));
    end );

InstallMethod(ImagesSource,
    "Returns the image of the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function(phi)
        return (Source(phi))^(Elm(phi));
    end );

InstallMethod(ImagesSet,
    "Applies the conjugation homomorphism to a collection",
    [IsGroupHomomorphismByConjugationRep, IsListOrCollection],
    function(phi, coll)
        return coll^(Elm(phi));
    end );

InstallMethod(PreImageElm,
    "Returns the preimage of an element with respect to the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep and IsInjective and IsSurjective, IsObject],
    function(phi, x)
        return x^(Inverse(Elm(phi)));
    end);

InstallMethod(PreImagesRange,
    "Returns the preimage of the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep],
    function(phi)
        return Source(phi);
    end );

FindPreImageElt := function(A, B, g, x) 
    local y;

    if not (x in B) then 
        ErrorNoReturn(x, " not in the source of phi");
    fi;

    y := x^(Inverse(g));
    if not (y in A) then 
        return fail;
    fi;

    return y;
end;

InstallMethod(PreImagesElm,
    "Returns the preimages of an element with respect to the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep, IsObject],
    function(phi, x)
        local y;

        y := FindPreImageElt(Source(phi), Range(phi), Elm(phi), x);

        if y = fail then 
            return [];
        fi;

        return [y];
    end );

InstallMethod(PreImagesRepresentative,
    "Returns a preimage representative of an element with respect to the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep, IsObject],
    function(phi, x)
        return FindPreImageElt(Source(phi), Range(phi), Elm(phi), x);
    end);

InstallMethod(PreImagesSet,
    "Returns the preimage of a collection with respect to  the conjugation homomorphism",
    [IsGroupHomomorphismByConjugationRep, IsListOrCollection],
    function(phi, coll)
        return coll^(Inverse(Elm(phi)));
    end );

InstallMethod(\=,
    "Checks whether two conjugation homomorphisms are equal",
    [IsGroupHomomorphismByConjugationRep, IsGroupHomomorphismByConjugationRep],
    function(phi, psi)
        local g, h, gen;

        if Source(phi) <> Source(psi) or Range(phi) <> Range(psi) or Image(phi) <> Image(psi) then 
            return false;
        fi;

        g := Elm(phi);
        h := Elm(psi);

        # Check that gh^-1 centralizes A 
        # We don't multiply g and h^-1 because they might not be compatible
        for gen in GeneratorsOfGroup(Source(phi)) do 
            if (gen^g)^(Inverse(h)) <> gen then 
                return false;
            fi;
        od;

        return true;
    end );
