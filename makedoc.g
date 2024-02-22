LoadPackage("AutoDoc");

AutoDoc( rec( 
    autodoc := true,
    gapdoc := rec(
        LaTeXOptions := rec( EarlyExtraPreamble := """
            \usepackage{amsmath}
            \newcommand{\calF}{\mathcal{F}}
            \newcommand{\calE}{\mathcal{E}}
            \newcommand{\calU}{\mathcal{U}}
            \newcommand{\Aut}{\operatorname{Aut}}
            \newcommand{\Out}{\operatorname{Out}}
            \newcommand{\Inn}{\operatorname{Inn}}
            \newcommand{\Hom}{\operatorname{Hom}}
            \newcommand{\Isom}{\operatorname{Isom}}
        """ )
    ),
    scaffold := rec(
        # includes := [  ],
        # bib := "bib.xml", 
    )
));
