#############################################################################
SetPackageInfo( rec(
    PackageName := "FusionSystems",
    Subtitle := "Construct Fusion Systems for finite groups",
    Version := "1.0.0",
    Date := "12/02/2024",
    License := "GPL-2.0-or-later",
    PackageWWWHome := "https://github.com/pete-g00/GAP-Fusion-Systems",
    SourceRepository := rec(
        Type := "git",
        URL := "https://github.com/pete-g00/GAP-Fusion-Systems",
    ),
    IssueTrackerURL := Concatenation( ~.SourceRepository.URL, "/issues" ),
    SupportEmail := "pgdchs@hotmail.co.uk",

    ArchiveURL      := Concatenation( ~.SourceRepository.URL,
                                    "/releases/download/v", ~.Version,
                                    "/", ~.PackageName, "-", ~.Version ),
    ArchiveFormats := ".tar.gz",

    Persons := [
        rec(
            LastName      := "Gautam",
            FirstNames    := "Pete",
            IsAuthor      := true,
            IsMaintainer  := true,
            Email         := "pgdchs@hotmail.co.uk"
        ),
    ],

    Status := "deposited",

    README_URL      := Concatenation( ~.PackageWWWHome, "/README.md" ),
    PackageInfoURL  := Concatenation( ~.PackageWWWHome, "/PackageInfo.g" ),

    ##  Provide a short (up to a few lines) abstract in HTML format, explaining
    ##  the package content. This text will be displayed on the package overview
    ##  Web page. Please use '<span class="pkgname">GAP</span>' for GAP and
    ##  '<span class="pkgname">MyPKG</span>' for specifying package names.
    ##  
    # AbstractHTML := "This package provides  a collection of functions for \
    # computing the Smith normal form of integer matrices and some related \
    # utilities.",
    # AbstractHTML := 
    #   "The <span class=\"pkgname\">Example</span> package, as its name suggests, \
    #    is an example of how to create a <span class=\"pkgname\">GAP</span> \
    #    package. It has little functionality except for being a package.",
    AbstractHTML :=
        "The <span class=\"pkgname\">Example</span> package, as its name suggests, \
    is an example of how to create a <span class=\"pkgname\">GAP</span> \
    package. It has little functionality except for being a package.",


    ##  Here is the information on the help books of the package, used for
    ##  loading into GAP's online help and maybe for an online copy of the 
    ##  documentation on the GAP website.
    ##  
    ##  For the online help the following is needed:
    ##       - the name of the book (.BookName)
    ##       - a long title, shown by ?books (.LongTitle, optional)
    ##       - the path to the manual.six file for this book (.SixFile)
    ##  
    ##  For an online version on a Web page further entries are needed, 
    ##  if possible, provide an HTML- and a PDF-version:
    ##      - if there is an HTML-version the path to the start file,
    ##        relative to the package home directory (.HTMLStart)
    ##      - if there is a PDF-version the path to the .pdf-file,
    ##        relative to the package home directory (.PDFFile)
    ##      - give the paths to the files inside your package directory
    ##        which are needed for the online manual (as a list 
    ##        .ArchiveURLSubset of names of directories and/or files which 
    ##        should be copied from your package archive, given in .ArchiveURL 
    ##        above (in most cases, ["doc"] or ["doc","htm"] suffices).
    ##  
    ##  For links to other GAP or package manuals you can assume a relative 
    ##  position of the files as in a standard GAP installation.
    ##  
    # in case of several help books give a list of such records here:
    PackageDoc := rec(
        BookName  := "Fusion Systems",
        ArchiveURLSubset := ["doc"],
        # HTMLStart := "doc/chap0_mj.html",
        PDFFile   := "doc/manual.pdf",
        # the path to the .six file used by GAP's help system
        SixFile   := "doc/manual.six",
        # a longer title of the book, this together with the book name should
        # fit on a single text line (appears with the '?books' command in GAP)
        # LongTitle := "Elementary Divisors of Integer Matrices",
        LongTitle := "Fusion Systems for finite $p$-groups",
    ),

    Dependencies := rec(
        GAP := "4.10",
        NeededOtherPackages := [ [ "GAPDoc", "1.5" ] ],
        SuggestedOtherPackages := [ ],
        ExternalConditions := [],
    ),

    AvailabilityTest := ReturnTrue,

    TestFile := "tst/testall.g",

    Keywords := [ "Fusion Systems" ],

    AutoDoc := rec(
        entities := rec(
            VERSION := ~.Version,
            DATE := ~.Date,
            # io := "<Package>io</Package>",
            # PackageName := "<Package>PackageName</Package>",
        ),
        TitlePage := rec(
            Copyright := Concatenation(
                "&copyright; 2024 by Pete Gautam\n\n",
                "This package may be distributed under the terms and conditions ",
                "of the GNU Public License Version 2 or (at your option) any later version.\n"
                ),
            Abstract := Concatenation(
                "FusionSystems is a &GAP; package that allows for ",
                "construction of fusion systems on finite $p$-groups ",
                "and provides many basic functionalities on them."
                ),
            Acknowledgements := Concatenation(
                "This documentation was prepared using the ",
                "&GAPDoc; package.\n",
                "<P/>\n"
                ),
        ),
    ),

));
