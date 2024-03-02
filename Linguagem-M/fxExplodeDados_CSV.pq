/*
    Função..: fxExplodeDados_CSV
    Objetivo: Expandir as colunas de um arquivo de extensão: CSV, TXT
    Criador.: ROGERIO TONINI
    Data....: 10/10/2023
    -------------------------------------------------------------------------
    Parametros:
        _NomeArquivo........: Caminho + Nome do arquivo a ser tratado
        _CaracterDelimitador: Caracter Delimitador que separa os dados
        _NumeroColunas......: Quantidade de colunas que contém o arquivo
*/

(
    _LocalArquivos as text,
    _CaracterDelimitador as text, 
    _NumeroColunas as number
) =>

let
    FonteDados = 
        Csv.Document(
            File.Contents(_LocalArquivos), [Delimiter = _CaracterDelimitador, Columns = _NumeroColunas, Encoding=65000, QuoteStyle=QuoteStyle.None])
in
    FonteDados
