LoadPackage("AutoDoc");

AutoDoc( rec( 
    autodoc := true,
    gapdoc := rec(
        LaTeXOptions := rec( EarlyExtraPreamble := """
            \newcommand{\calF}{\mathcal{F}}
            \newcommand{\calE}{\mathcal{E}}
        """ )
    ),
    scaffold := rec(
        # includes := [  ],
        # bib := "bib.xml", 
    )
));
