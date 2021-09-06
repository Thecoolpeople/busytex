set -e

DIST=$PWD/dist-native
XETEXFMT=$DIST/xelatex.fmt
PDFTEXFMT=$DIST/pdflatex.fmt
LUATEXFMT=$DIST/lualatex.fmt
BUSYTEX=$DIST/busytex

export TEXMFDIST=$DIST/texlive/texmf-dist
export TEXMFVAR=$DIST/texlive/texmf-dist/texmf-var
export TEXMFCNF=$TEXMFDIST/web2c
export FONTCONFIG_PATH=$DIST

cd example

$BUSYTEX

for applet in $($BUSYTEX); do
    echo $BUSYTEX $applet --version
    $BUSYTEX $applet --version
done

$BUSYTEX xetex --no-shell-escape --interaction nonstopmode --halt-on-error --no-pdf --fmt $XETEXFMT example.tex
$BUSYTEX bibtex8 --8bit example.aux
$BUSYTEX xetex --no-shell-escape --interaction nonstopmode --halt-on-error --no-pdf --fmt $XETEXFMT example.tex
$BUSYTEX xetex --no-shell-escape --interaction nonstopmode --halt-on-error --no-pdf --fmt $XETEXFMT example.tex
$BUSYTEX xdvipdfmx -o example_xetex.pdf example.xdv
rm example.aux

$BUSYTEX pdftex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $PDFTEXFMT example.tex
$BUSYTEX bibtex8 --8bit example.aux
$BUSYTEX pdftex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $PDFTEXFMT example.tex
$BUSYTEX pdftex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $PDFTEXFMT example.tex
mv example.pdf example_pdftex.pdf
rm example.aux

$BUSYTEX luatex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $LUATEXFMT --nosocket example.tex
$BUSYTEX bibtex8 --8bit example.aux                                           
$BUSYTEX luatex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $LUATEXFMT --nosocket example.tex
$BUSYTEX luatex --no-shell-escape --interaction nonstopmode --halt-on-error --output-format=pdf --fmt $LUATEXFMT --nosocket example.tex
mv example.pdf example_luatex.pdf
rm example.aux
