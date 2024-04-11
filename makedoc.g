LoadPackage("AutoDoc");

AutoDoc( rec( 
    autodoc := rec(
        scan_dirs := []
    ),
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
        includes := [ 
            "_Chapter_Preface.xml",
            "_Chapter_FClass.xml",
            "_Chapter_Constructing_a_Fusion_System.xml",
            "_Chapter_Operations_on_Fusion_Systems.xml",
            "_Chapter_Miscellaneous_functions.xml"
        ],
        bib := "bib.xml", 
    )
));
