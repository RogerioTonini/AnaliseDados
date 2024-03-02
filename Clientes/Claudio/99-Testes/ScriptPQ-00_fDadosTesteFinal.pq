let
    //==========> Captura a lista de arquivos existentes na Pasta <==========
    ListaArquivos = Table.SelectRows(Folder.Files(_CaminhoArquivos), each ([Extension] = _ExtensaoArquivos)),
    //==========> Monta a Base de Dados <==========
    _ = "",
    AddColCaminhoNomeArquivo = Table.CombineColumns(
        ListaArquivos,
        {"Folder Path", "Name"},
        Combiner.CombineTextByDelimiter("", QuoteStyle.None),
        "CaminhoNomeArquivo"
    ),
    ColunasMantidas = Table.SelectColumns(AddColCaminhoNomeArquivo, {"CaminhoNomeArquivo"}),
    ColunaAddTabelaCampos = Table.AddColumn(
        ColunasMantidas, "TabelaCampos", each fxExplodeDados_XLS([CaminhoNomeArquivo])
    ),
    _DadosTratadosBruto_ = Table.Buffer(
        Table.SelectRows(
            fxExpandeColsTabela(ColunaAddTabelaCampos, "TabelaCampos"), each [Column1] <> " " or [Column1] = null
        )
    ),
    // ==========> Mesclas de Consultas para Geração do Novo Código EAN <==========
    __ = "",
    MesclaConsultaCLUSTER = Table.NestedJoin(
        _DadosTratadosBruto_, {"Column12"}, dCluster, {"TPCLUSTER"}, "dCluster", JoinKind.LeftOuter
    ),
    ID_ClusterExpandido = Table.ExpandTableColumn(MesclaConsultaCLUSTER, "dCluster", {"ID_Cluster"}, {"ID_Cluster"}),
    MesclaConsultaMETRICA = Table.NestedJoin(
        ID_ClusterExpandido, {"Column1"}, dMetrica, {"TpMetrica"}, "dMetrica", JoinKind.LeftOuter
    ),
    ID_MetricaExpandido = Table.ExpandTableColumn(MesclaConsultaMETRICA, "dMetrica", {"ID_Metrica"}, {"ID_Metrica"}),
    // ==========> Gera Novo Código SKU <==========
    _GeradoNovoSKU_ = Table.Buffer(
        Table.AddColumn(
            ID_MetricaExpandido, "ID_SKU", each Number.ToText([ID_Metrica]) & Number.ToText([ID_Cluster]) & [Column5]
        )
    ),
    //==========> Separa Cabecalho dos Dados <==========
    ___ = "",
    OutrasColunasRemovidas = Table.SelectColumns(
        _GeradoNovoSKU_,
        {
            "ID_SKU",
            "Column1",
            "Column12",
            "Column5",
            "Column2",
            "Column3",
            "Column4",
            "Column7",
            "Column8",
            "Column9",
            "Column10",
            "Column11",
            "Column13",
            "Column14",
            "Column15",
            "Column16",
            "Column17",
            "Column18",
            "Column19",
            "Column20",
            "Column21",
            "Column22",
            "Column23",
            "Column24",
            "Column25",
            "Column26",
            "Column27",
            "Column28",
            "Column29",
            "Column30",
            "Column31",
            "Column32",
            "Column33",
            "Column34",
            "Column35",
            "Column36",
            "Column37",
            "Column38",
            "Column39",
            "Column40",
            "Column41",
            "Column42",
            "Column43",
            "Column44",
            "Column45",
            "Column46"
        }
    ),
    CabecalhoRemovido = Table.Skip(OutrasColunasRemovidas, 1),
    //==========> Troca Traço por 0 nas Cols Data <==========
    CorrigeValoresColsData = Table.ReplaceValue(
        CabecalhoRemovido,
        "-",
        "0",
        Replacer.ReplaceText,
        {
            "Column18",
            "Column19",
            "Column20",
            "Column21",
            "Column22",
            "Column23",
            "Column24",
            "Column25",
            "Column26",
            "Column27",
            "Column28",
            "Column29",
            "Column30",
            "Column31",
            "Column32",
            "Column33",
            "Column34",
            "Column35",
            "Column36",
            "Column37",
            "Column38",
            "Column39",
            "Column40",
            "Column41",
            "Column42",
            "Column43",
            "Column44",
            "Column45",
            "Column46"
        }
    ),
    //==========> Trata Cabecalho <==========
    ____ = "",
    _TrataCabecalho_ = Table.Buffer(Table.FirstN(OutrasColunasRemovidas, 1)),
    //==========> Trata Colunas = Datas <==========
    TpAlterColunasParaData = Table.TransformColumnTypes(
        _TrataCabecalho_,
        {
            {"Column18", type date},
            {"Column19", type date},
            {"Column20", type date},
            {"Column21", type date},
            {"Column22", type date},
            {"Column23", type date},
            {"Column24", type date},
            {"Column25", type date},
            {"Column26", type date},
            {"Column27", type date},
            {"Column28", type date},
            {"Column29", type date},
            {"Column30", type date},
            {"Column31", type date},
            {"Column32", type date},
            {"Column33", type date},
            {"Column34", type date},
            {"Column35", type date},
            {"Column36", type date},
            {"Column37", type date},
            {"Column38", type date},
            {"Column39", type date},
            {"Column40", type date},
            {"Column41", type date}
        }
    ),
    CalculoUltimoDiaMes = Table.TransformColumns(
        TpAlterColunasParaData,
        {
            {"Column18", Date.EndOfMonth, type date},
            {"Column19", Date.EndOfMonth, type date},
            {"Column20", Date.EndOfMonth, type date},
            {"Column21", Date.EndOfMonth, type date},
            {"Column22", Date.EndOfMonth, type date},
            {"Column23", Date.EndOfMonth, type date},
            {"Column24", Date.EndOfMonth, type date},
            {"Column25", Date.EndOfMonth, type date},
            {"Column26", Date.EndOfMonth, type date},
            {"Column27", Date.EndOfMonth, type date},
            {"Column28", Date.EndOfMonth, type date},
            {"Column29", Date.EndOfMonth, type date},
            {"Column30", Date.EndOfMonth, type date},
            {"Column31", Date.EndOfMonth, type date},
            {"Column32", Date.EndOfMonth, type date},
            {"Column33", Date.EndOfMonth, type date},
            {"Column34", Date.EndOfMonth, type date},
            {"Column35", Date.EndOfMonth, type date},
            {"Column36", Date.EndOfMonth, type date},
            {"Column37", Date.EndOfMonth, type date},
            {"Column38", Date.EndOfMonth, type date},
            {"Column39", Date.EndOfMonth, type date},
            {"Column40", Date.EndOfMonth, type date},
            {"Column41", Date.EndOfMonth, type date}
        }
    ),
    TpAlterColsCabec = Table.TransformColumnTypes(
        CalculoUltimoDiaMes,
        {
            {"Column18", type text},
            {"Column19", type text},
            {"Column20", type text},
            {"Column21", type text},
            {"Column22", type text},
            {"Column23", type text},
            {"Column24", type text},
            {"Column25", type text},
            {"Column26", type text},
            {"Column27", type text},
            {"Column28", type text},
            {"Column29", type text},
            {"Column30", type text},
            {"Column31", type text},
            {"Column32", type text},
            {"Column33", type text},
            {"Column34", type text},
            {"Column35", type text},
            {"Column36", type text},
            {"Column37", type text},
            {"Column38", type text},
            {"Column39", type text},
            {"Column40", type text},
            {"Column41", type text}
        }
    ),
    _AgrupaCabecComDados_ = Table.Buffer(Table.Combine({TpAlterColsCabec, CorrigeValoresColsData}))
in
    _AgrupaCabecComDados_
