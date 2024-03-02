/*
  Função..: fxTransformaTabelaEmLista.pq
  Objetivo: Transforma uma planilha em Lista para realizar tratamentos e 
posteriormente expandido para uma tabela
  Criador.: ROGERIO TONINI
  Data....: 15/02/2024
  -------------------------------------------------------------------------
  Parametros:
      _Tabela: Nome da Tabela a ser tratada
	  _Campo.: Qual campo será transformado em Lista, tratado e expandido
*/

(
    _Tabela as table,
    _Coluna as text
) =>

let
    //---------- Captura a lista de arquivos existentes na Pasta ----------

    ListaBuffer = 
        List.Buffer(
            Table.Column(
                _Tabela, 
                _Coluna
            )            
        ),

    ListaTratada = 
        List.Transform(
            ListaBuffer, 
            each 
                fxExplodeDados_XLS(_)
        ),

    ConverteParaTabela = 
        Table.FromList(
            ListaTratada, 
            Splitter.SplitByNothing(), 
            null, 
            null, 
            ExtraValues.List
        ),

    ExpandeColuna = 
        ConverteParaTabela{0}[Column1]
in
    ExpandeColuna