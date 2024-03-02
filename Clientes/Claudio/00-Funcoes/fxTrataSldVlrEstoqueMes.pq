// fxTrataSldVlrEstoqueMes.pq

(
    _NomeTabela as table,
    _ID_Metrica as number, 
    _NomeCampo  as text
) =>

let
    //---------- Trata a Metrica solicitada ----------
    ID_METRICA_Diferente = 
        Table.SelectRows(
            _NomeTabela, 
            each 
                [ID_Metrica] <> _ID_Metrica
        ),

    //---------- Transforma em Colunas as Linhas de Quantidades / Valores ----------
    __ = "",

    DespivotaTabela = 
        Table.UnpivotOtherColumns(
            ID_METRICA_Diferente, 
            {
                "ID_SKU",
                "ID_Cluster",
                "ID_Metrica"
            }, 
            "MesReferencia", 
            _NomeCampo
        ),

    //---------- Normatiza a coluna MesReferencia ----------
    ___ = "",

    CorrigeDataSaldo =
        Table.TransformColumns(
            DespivotaTabela, 
            {
                "MesReferencia", 
                each Text.Insert(_, 3, "/2")
            }
        ),

    AcertaTipagemMesReferencia = 
        Table.TransformColumns( 
            Table.TransformColumnTypes( 
                CorrigeDataSaldo, 
                {
                    {"MesReferencia", type date}
                }
            ),
            {
                {"MesReferencia", Date.EndOfMonth, type date}
            }
        ),

    //---------- Normatiza a coluna MesReferencia ----------
    ____ = "",

    AcertaTipagemColuna = 
        Table.TransformColumnTypes(
            AcertaTipagemMesReferencia,
            {
                if _ID_Metrica = 1 then
                    {_NomeCampo, Int64.Type}
                else
                    {_NomeCampo, Currency.Type}
            }
        )
in
    AcertaTipagemColuna