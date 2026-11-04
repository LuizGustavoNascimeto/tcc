# Compila para build/. PDF final: build/main.pdf
# Uso: latexmk -f
# Limpa: latexmk -C

use Cwd qw(abs_path);
use File::Basename;
use File::Path qw(make_path);

@default_files = ('main.tex');

$pdf_mode = 1;
$out_dir  = 'build';
$aux_dir  = 'build';

$pdflatex = 'pdflatex -interaction=nonstopmode -file-line-error -synctex=1 %O %S';
$bibtex_use = 2;

# bibtex nativo do MiKTeX não lê BIBINPUTS no formato MSYS (/c/...).
# --include-directory com caminho Windows acha main.bib e o .bst na raiz.
# NÃO colocar TEXINPUTS=.// — o epstopdf perde o prefixo figuras/.
my $root = abs_path('.');
$root =~ s{^/([a-z])/}{\U$1:/}i;
$bibtex = 'internal utfpr_bibtex %B';
sub utfpr_bibtex {
    my ($base) = @_;
    my ($name, $path) = fileparse($base);
    $path =~ s/[\/\\]+$//;
    my $old = abs_path('.');
    chdir $path if $path ne '' && $path ne '.';
    my $ret = system('bibtex', "--include-directory=$root", $name);
    chdir $old;
    return $ret;
}

# \include{capitulos/...} grava .aux no mesmo caminho relativo dentro de build/
make_path("$out_dir/capitulos", "$out_dir/PreTexto", "$out_dir/PosTexto");

# glossaries: acrônimos, siglas, abreviaturas, glossário
add_cus_dep('glo',  'gls',  0, 'run_makeglossaries');
add_cus_dep('acn',  'acr',  0, 'run_makeglossaries');
add_cus_dep('acn2', 'acr2', 0, 'run_makeglossaries');
add_cus_dep('acn3', 'acr3', 0, 'run_makeglossaries');

sub run_makeglossaries {
    my ($name, $path) = fileparse($_[0]);
    $path =~ s/[\/\\]+$//;
    $path = '.' if $path eq '';
    my @cmd = ('makeglossaries', '-d', $path, $name);
    unshift @cmd, '-q' if $silent;
    return system(@cmd);
}

# nomencl (lista de símbolos)
add_cus_dep('nlo', 'nls', 0, 'nlo2nls');
sub nlo2nls {
    return system(
        'makeindex',
        "$_[0].nlo",
        '-s', 'nomencl.ist',
        '-o', "$_[0].nls",
        '-t', "$_[0].nlg",
    );
}

push @generated_exts, qw(
    acn acr alg acn2 acr2 alg2 acn3 acr3 alg3
    glg glo gls ist
    nlg nlo nls
    bbl brf lol
    xmpi mw run.xml
    synctex.gz
);
