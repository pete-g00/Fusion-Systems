#############################################################################
SetPackageInfo( rec(
    PackageName := "FusionSystems",
    Subtitle := "Fusion Systems for finite p-groups",
    Version := "1.0.0",
    Date := "09/02/2024",
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

    Status := "dev",

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

    PackageDoc := rec(
        BookName  := "Fusion Systems",
        ArchiveURLSubset := ["doc"],
        HTMLStart := "doc/chap0_mj.html",
        PDFFile   := "doc/manual.pdf",
        SixFile   := "doc/manual.six",
        LongTitle := "Fusion Systems for finite p-groups",
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
                "construction of fusion systems on finite p-groups ",
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
