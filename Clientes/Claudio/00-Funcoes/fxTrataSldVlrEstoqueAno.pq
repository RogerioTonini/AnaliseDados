// fxTrataSldVlrEstoqueAno.pq

(
    _NomeTabela as table,
    _ID_Metrica as number,
    _NomeCampo  as text
) =>

let
    DespivotaTabela = 
        Table.UnpivotOtherColumns(
            _NomeTabela, 
            {
                "ID_SKU", 
                "ID_Metrica", 
                "ID_Cluster"
            }, 
            "Periodo", 
            "Valor"
        ),

    //---------- Trata a Coluna Periodo ----------
    __ = "",

    DivideColunaPeriodo = 
        Table.SplitColumn(
            DespivotaTabela, 
            "Periodo", 
            Splitter.SplitTextByDelimiter(
                " ", 
                QuoteStyle.Csv), 
                {
                    "Periodo.1", 
                    "Periodo.2"
                }
        ),
        
    PrefixoAdicionado = 
        Table.TransformColumns(
            DivideColunaPeriodo, 
            {
                {
                    "Periodo.2", 
                    each 
                        if Text.Length(_) = 2 
                            then 
                                // Cabeçalho da coluna contém uma string + o ano com 2 posições, acrescento o número 20 antes do ano.
                                "20" & (_)  
                            else 
                                // Cabeçalho da coluna contém umaa string + o ano com 4 posições
                                "" & (_),
                        type text
                }
            }
        ),

    CorrigeColunaPeriodo = 
        Table.CombineColumns(
            PrefixoAdicionado,
            {
                "Periodo.1", 
                "Periodo.2"
            },
            Combiner.CombineTextByDelimiter(
                "-", 
                QuoteStyle.None
            ), 
            "Periodo"
        ),


    //---------- Trata a Coluna Valor ----------
    ___ = "",

    TipagemAlterada = 
        Table.TransformColumnTypes(
            CorrigeColunaPeriodo,
            {
                if _ID_Metrica = 1 then
                    {"Valor", Int64.Type}
                else
                    {"Valor", Currency.Type}
            }
        ),

    FiltraValorDifZero = 
        Table.SelectRows(
            TipagemAlterada, 
            each 
                ([Valor] <> 0)
        ),

    FiltraID_Metrica = 
        Table.SelectRows(
            FiltraValorDifZero, 
            each 
                [ID_Metrica] <> _ID_Metrica
        ),
        
    ColunaRenomeada = 
        Table.RenameColumns(
            FiltraID_Metrica,
            {
                {"Valor", _NomeCampo}
            }
        )
in
    ColunaRenomeada