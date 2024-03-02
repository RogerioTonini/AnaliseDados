let
    // trocar o link, para buscar sua formula
    GIT = Web.Contents("https://raw.githubusercontent.com/jovianosilveira/fx_m/master/LimparLinhasAntesCabecalho.txt"),

    // lendo o binario do conteudo
    script = Text.FromBinary(GIT),

    /*
    O comando #shared sozinho traz a documentação doPower Query
    
    Executando
    */
    run = Expression.Evaluate(script, #shared)

in
    run
