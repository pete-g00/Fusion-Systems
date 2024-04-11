#############################################################################
SetPackageInfo( rec(
    PackageName := "FusionSystems",
    Subtitle := "Fusion Systems for finite p-groups",
    Version := "1.0.0",
    Date := "31/03/2024",
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

    AbstractHTML :=
        "The <span class=\"pkgname\">FusionSystems</span> package allows for \
        construction and interaction with fusion systems.",

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
