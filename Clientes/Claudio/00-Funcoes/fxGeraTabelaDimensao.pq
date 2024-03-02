/*
  Função..: fxGeraTabDimensao
  Objetivo: Gerar tabelaDimensao com uma ÚNICA coluna.
  Criador.: ROGERIO TONINI
  Data....: 15/02/2024
  -------------------------------------------------------------------------
  Parametros:
      _Tabela: Nome da Tabela a qual será retirada a coluna com os dados
	  _NumCol: Número da coluna que contém os dados.
	  
  Observação: Todas as colunas devem ter o mesmo padrão de nome [Column]
*/



(
    _Tabela as table,
    _NumCol as number
) =>

let
    // só podemos concatenar elementos do mesmo tipo, por isso converter antes o número em texto
    _Column = "Column" & Text.From(_NumCol),

    // para acessar uma coluna da tabela, a função a seguir permite passar um argumento com o texto contendo o nome da coluna
    // o resultado será uma lista com os valores da coluna
    FonteDados = 
        List.Buffer(
            Table.Column(
                _Tabela, 
                _Column
            )
        ),

    RemoveLinhaNum01 = 
        List.Skip(
            FonteDados, 
            1
        ),

    GeraListaRegistros = 
        List.Distinct(
            RemoveLinhaNum01
        ),

    ___ = "",

    _ConverteLista2Tabela_ = 
        Table.Buffer(
            Table.FromList(
                GeraListaRegistros, 
                Splitter.SplitByNothing(), 
                null, 
                null, 
                ExtraValues.Error
            )
        ),

    RenomeiaColuna = 
        Table.RenameColumns(
            _ConverteLista2Tabela_,
            { {"Column1", "DESCRICAO"} }
        ),

    _TabelaNormatizada_ = 
        Table.Buffer(
            Table.AddIndexColumn(
                RenomeiaColuna, 
                "ID_CODIGO", 
                1, 
                1, 
                Int64.Type
            )
        )
in
    _TabelaNormatizada_