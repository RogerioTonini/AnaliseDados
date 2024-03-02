/*
  Função..: fxfxExpandeColunasTabela
  Objetivo: Expandir as colunas de uma Tabela
  Criador.: JOVIANO SILVEIRA
  Data....: 
  -------------------------------------------------------------------------
  Parametros:
      _Tabela: Nome da Tabela a ser expandida
      _NomeDaColuna: Nome da coluna(s) que contém os dados
*/
(
    Tabela as table,
    NomeDaColunaComDados as text
) =>

let
    Colunas = 
        List.Buffer(
            List.Union(
                List.Transform(
                    Table.Column(
                        Tabela,
                        NomeDaColunaComDados
                    ),
                    each Table.ColumnNames(_)
                )
            )
        ),
    
    Out =
        Table.ExpandTableColumn(
            Tabela,
            NomeDaColunaComDados,
            Colunas,
            Colunas
        )
in
    Out
