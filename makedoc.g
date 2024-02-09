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
            \newcommand{\Hom}{\operatorname{Hom}}
            \newcommand{\Inn}{\operatorname{Inn}}
            \newcommand{\Isom}{\operatorname{Isom}}
        """ )
    ),
    scaffold := rec(
        # includes := [  ],
        # bib := "bib.xml", 
    )
));
