/*
  Função..: fxFiltraTabela
  Objetivo: Gerar tabelas a partir de uma  ou mais planilhas, sempre com
  a estrutura de 2 colunas, onde uma é a CHAVE e a outra a DESCRICAO.
  Criador.: ROGERIO TONINI
  Data....: 15/02/2024
  -------------------------------------------------------------------------
  Parametros:
      _Tabela: Nome da Tabela a ser gerada
*/

(
    _Tabela as text
) =>

let
    FonteDados = 
        Excel.CurrentWorkbook(),

    FiltraTabela = 
        Table.SelectRows(
            FonteDados, 
            each ( [Name] = _Tabela )
        ),

    ExpandeTabela = 
        Table.ExpandTableColumn(
            FiltraTabela, 
            "Content", 
            {"ID_CODIGO", "DESCRICAO"}, 
            {"ID_CODIGO", "DESCRICAO"}
        ),

    AlteraTipoChave = 
        Table.TransformColumnTypes(
            ExpandeTabela,
            { 
                {"ID_CODIGO", Int64.Type} 
            }
        ),

    _TabelaNormatizada_ = 
        Table.Buffer(
            Table.SelectColumns(
                AlteraTipoChave,
                {
                    "ID_CODIGO", 
                    "DESCRICAO"
                }
            )
        )
in
    _TabelaNormatizada_
