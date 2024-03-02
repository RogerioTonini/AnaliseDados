let
    //---------- Captura a lista de arquivos existentes na Pasta ----------
    ListaArquivos = Table.SelectRows(Folder.Files(_CaminhoArquivos), each ([Extension] = _ExtensaoArquivos)),
    // ----------Monta a Base de Dados ----------
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
    _TabelaExpandida_ = Table.Buffer(fxExpandeColsTabela(ColunaAddTabelaCampos, "TabelaCampos")),
    // ---------- Remove Linhas / Colunas Sem Dados ou Desnecessários ----------
    __ = "",
    OutrasColsRemovidas = Table.SelectColumns(
        _TabelaExpandida_,
        {
            "Column1",
            "Column2",
            "Column3",
            "Column4",
            "Column5",
            "Column7",
            "Column8",
            "Column9",
            "Column10",
            "Column11",
            "Column12",
            "Column13",
            "Column14",
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
    RemoveLinhasSemDados = Table.SelectRows(OutrasColsRemovidas, each [Column1] <> " " or [Column1] = null),
    _TrocaTracoPor0_ = Table.Buffer(
        Table.ReplaceValue(
            RemoveLinhasSemDados,
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
        )
    ),
    //---------- Mescla de Consultas para Geração do Novo Código EAN ----------
    ___ = "",
    MesclaConsultaCLUSTER = Table.NestedJoin(
        _TrocaTracoPor0_, {"Column12"}, dCluster, {"TPCLUSTER"}, "dCluster", JoinKind.LeftOuter
    ),
    ID_ClusterExpandido = Table.ExpandTableColumn(MesclaConsultaCLUSTER, "dCluster", {"ID_Cluster"}, {"ID_Cluster"}),
    MesclaConsultaMETRICA = Table.NestedJoin(
        ID_ClusterExpandido, {"Column1"}, dMetrica, {"TpMetrica"}, "dMetrica", JoinKind.LeftOuter
    ),
    ID_MetricaExpandido = Table.ExpandTableColumn(MesclaConsultaMETRICA, "dMetrica", {"ID_Metrica"}, {"ID_Metrica"}),
    // ========== Gera Novo Código SKU ==========
    _NovoSKU_Criado_ = Table.Buffer(
        Table.AddColumn(
            ID_MetricaExpandido, "ID_SKU", each Number.ToText([ID_Metrica]) & Number.ToText([ID_Cluster]) & [Column5]
        )
    ),
    //---------- Cria Novo Cabecalho da Tabela ----------
    ____ = "",
    SeparaCabecDados = Table.FirstN(_NovoSKU_Criado_, 1),
    ColunasDatasVlrsRemovidas = Table.SelectColumns(
        SeparaCabecDados,
        {
            "Column1",
            "Column2",
            "Column3",
            "Column4",
            "Column5",
            "Column7",
            "Column8",
            "Column9",
            "Column10",
            "Column11",
            "Column12",
            "Column13",
            "Column14",
            "Column17"
        }
    ),
    // ---------- Cria as colunas: "ID_Metrica", "ID_Cluster", "ID_SKU", "MesAno", "QtdTotal", "VlrTotal", ----------
    CriaColID_Metrica = fxCriaColuna(ColunasDatasVlrsRemovidas, "ID_Metrica", "ID_Metrica"),
    CriaColID_Cluster = fxCriaColuna(CriaColID_Metrica, "ID_Cluster", "ID_Cluster"),
    CriaColID_SKU = fxCriaColuna(CriaColID_Cluster, "ID_SKU", "ID_SKU"),
    CriaColunaMesAno = fxCriaColuna(CriaColID_SKU, "MesAno", "MesAno"),
    CriaColunaQtdTotal = fxCriaColuna(CriaColunaMesAno, "QtdTotal", "QtdTotal"),
    CriaColunaVlrTotal = Table.Buffer(fxCriaColuna(CriaColunaQtdTotal, "VlrTotal", "VlrTotal")),
    _CabecalhoCriado_ = Table.PromoteHeaders(CriaColunaVlrTotal, [PromoteAllScalars = true])
in
    _CabecalhoCriado_
