/*
  Função..: fxLimpaTabela
  Objetivo: 
  Criador.: ROGERIO TONINI
  Data....: 15/02/2024
  -------------------------------------------------------------------------
  Parametros:
      _Tabela...: Nome da Tabela a ser gerada
	  _ID_Codigo: Chave da Tabela
	  _TpLimpeza: [A]nual, [M]ensal ou [C}adastro (Dimensao)
*/


(
    _Tabela    as table,
    _ID_Codigo as text,
    _TpLimpeza as text 
) => 

let
    _ColunasMantidas_ =
        Table.SelectColumns(
            _Tabela,

            if _TpLimpeza = "C" then
                //----------> Este parametro se refere a Tabela [C]adastro <----------
                {
                    _ID_Codigo, "ID_Metrica", "ID_Cluster", "Column1", "Column12", "Column5",  
                    "Column2",  "Column3",    "Column4",    "Column7",  "Column8", "Column9", 
                    "Column10", "Column11",   "Column13",   "Column14", "Column17"
                }
            else
                //----------> Este parametro se refere a Totalizadores: [A]nual / [M]ensal <----------
                if _TpLimpeza = "A" then
                    { _ID_Codigo, "ID_Metrica", "ID_Cluster", "Column42", "Column43", "Column44", "Column45", "Column46" }
                else
                    {
                        _ID_Codigo, "ID_Metrica", "ID_Cluster", "Column18", "Column19", "Column20", "Column21", 
                        "Column22", "Column23",   "Column24",   "Column25", "Column26", "Column27", "Column28", 
                        "Column29", "Column30",   "Column31",   "Column32", "Column33", "Column34", "Column35", 
                        "Column36", "Column37",   "Column38",   "Column39", "Column40", "Column41"
                    }
        ),

    CabecalhoCriado = 
        Table.PromoteHeaders(
            _ColunasMantidas_, 
            [PromoteAllScalars=true]
        ),
   
    ColRenomeadaIDs = 
        Table.RenameColumns(
            CabecalhoCriado,
            {
                {"99999999", _ID_Codigo},
                {"99",       "ID_Metrica"},
                {"98",       "ID_Cluster"}
            }
        )
in
    ColRenomeadaIDs

    // ColRenomeadaIDs = 
    //     Table.RenameColumns(
    //         CabecalhoCriado,
    //             // if _TpLimpeza = "C" then
    //                 {
    //                     {"99999999", _ID_Codigo},
    //                     {"99",       "ID_Metrica"},                        
    //                     {"98",       "ID_Cluster"}
    //                 }
    //             // else
    //             //     {   
    //             //         {"99999990", "ID_SKU_Unico"},
    //             //         {"99999991", _ID_Codigo},
    //             //         {"99",       "ID_Cluster"},                        
    //             //         {"99_1",     "ID_Metrica"}
    //             //     }
    //     )
