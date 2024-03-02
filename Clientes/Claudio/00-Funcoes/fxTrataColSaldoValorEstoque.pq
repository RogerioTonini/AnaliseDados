/*
  Função..: fxTrataColSaldoValorEstoque.pq
  Objetivo: Gerar tabelas a partir de uma  ou mais planilhas, sempre com
  a estrutura de 2 colunas, onde uma é a CHAVE e a outra a DESCRICAO.
  Criador.: ROGERIO TONINI
  Data....: 15/02/2024
  -------------------------------------------------------------------------
  Parametros:
      _Tabela: Nome da Tabela a ser tratada
*/

(
    _Tabela as table
) =>

let
    //---------- Corrige Colunas: Saldo e Valor de Estoque ----------

    AcertoVlrsZerados = 
        Table.ReplaceValue(
            _Tabela,
            null,
            0,
            Replacer.ReplaceValue,
            {"SaldoEstoque", "ValorEstoque"}
        ),

    _DadosNormatizados_ = 
        Table.Buffer(
            Table.TransformColumnTypes(
            AcertoVlrsZerados,
                {
                    {"SaldoEstoque", Int64.Type}, 
                    {"ValorEstoque", Currency.Type}
                }
            )
        )
in
    _DadosNormatizados_