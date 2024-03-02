/*
    Função..: fxExplodeDados_XLS
    Objetivo: Expandir as colunas de um arquivo com as extensão: XLS, XLSX, XLSB
    Criador.: ROGERIO TONINI
    Data....: 10/10/2023
    -------------------------------------------------------------------------
    Parametros:
        _NomeArquivo: Nome do arquivo a ser tratado
*/

(
    _NomeArquivo as text
) =>

let
    NomeArquivo = 
        Excel.Workbook(
            File.Contents(
                _NomeArquivo
            ), 
            null, 
            true
        ),
    FonteDados = 
         NomeArquivo{[Name=_NomePlanilha]}[Data]
in
    FonteDados
