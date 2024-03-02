

let
    FonteDados = 
        Table.SelectRows(
            Folder.Files(CaminhoArquivo), 
            each ([Extension] = ".csv")
        ),

    Caminho_E_Arquivo =
        Table.CombineColumns(
            FonteDados,
            {"Folder Path", "Name"},
            Combiner.CombineTextByDelimiter("", QuoteStyle.None),"Caminho_E_Arquivo"
        ),
    ConteudoArquivos =
        Table.AddColumn(
            Caminho_E_Arquivo, 
            "ConteudoArquivos", 
            each fxTrataArquivos([Caminho_E_Arquivo])
        ),
    ColunasMantidas = 
        Table.SelectColumns(
            ConteudoArquivos,
            {"ConteudoArquivos"}
        ),
    _DadosExpandidos_ = 
        Table.Buffer(
            fxExpandeColunasTabela(ColunasMantidas, "ConteudoArquivos")
        ),
    TextoLimpo = 
        Table.TransformColumns(
            Table.TransformColumns(
                _DadosExpandidos_, 
                { {"Column2", Text.Trim, type text} }
            ),
            { {"Column2", Text.Clean, type text} }
        ),
    LinhasFiltradas = 
        Table.SelectRows(
            TextoLimpo, 
            each 
                not Text.StartsWith([Column1], "Últimos Lançamentos") and not Text.StartsWith([Column1], "Extrato de:")    and
                not Text.StartsWith([Column1], "Os dados")            and not Text.Contains([Column1],   "Data")           and
                not Text.Contains([Column2],   "Total")               and not Text.Contains([Column2],   "SALDO ANTERIOR")
        ),
    CabecRenom_TpColsAlter = 
        Table.TransformColumnTypes(
            Table.RenameColumns(
                LinhasFiltradas,
                { 
                  {"Column1", "Data"}, 
                  {"Column2", "Historico"}, 
                  {"Column3", "NumDocto"},
                  {"Column4", "Credito"}, 
                  {"Column5", "Debito"}
                }
            ),
            { 
                {"Data", type date}, 
                {"NumDocto", Int32.Type}, 
                {"Credito", Currency.Type}, 
                {"Debito", Currency.Type} 
            }
        ),
    _DadosTratados_ = 
        Table.Buffer(
            Table.FillDown(
                CabecRenom_TpColsAlter,
                {"Data", "NumDocto"}
            )
        ),
    LinhasAgrupadas = 
        Table.Group(
            _DadosTratados_,
            {"Data", "NumDocto"},
            { {"Data_NumDocto", each _, type table [Data=nullable date, Historico=text, NumDocto=nullable number, Credito=nullable number, Debito=nullable number]} }
        ),
    ColsAdicionadas =
        Table.AddColumn(
            Table.AddColumn(
                LinhasAgrupadas,
                "ColunaHistorico", each Table.SelectColumns([Data_NumDocto],{"Historico"})
            ),
            "TabParaLista", each Table.ToList([ColunaHistorico])
        ),
    HistoricoCompleto = 
        Table.TransformColumns(
            ColsAdicionadas, 
            {"TabParaLista", each Text.Combine(List.Transform(_, Text.From), ";"), type text}
        ),
    ConsultasMescladas = 
        Table.NestedJoin(
            _DadosTratados_, 
            {"Data", "NumDocto"}, 
            HistoricoCompleto, 
            {"Data", "NumDocto"}, 
            "HistoricoExplodido", 
            JoinKind.LeftOuter
        ),
    _HistComplExpand_ = 
        Table.Buffer(
            Table.ExpandTableColumn(
                ConsultasMescladas, 
                "HistoricoExplodido", 
                {"TabParaLista"}, 
                {"TabParaLista"}
            )
        ),
    HistoricoMovimExp = 
        Table.SplitColumn(
            _HistComplExpand_,
            "TabParaLista",
            Splitter.SplitTextByDelimiter(";", QuoteStyle.None),
            {"TabParaLista.1", "TabParaLista.2"}
        ),
    ColsRemovidas = 
        Table.RemoveColumns(
            HistoricoMovimExp,
            {"Historico"}
        ),
    ColsRenomeadas = 
        Table.RenameColumns(
            Table.ReorderColumns(
                ColsRemovidas, 
                {"Data", "NumDocto", "TabParaLista.1", "TabParaLista.2", "Credito", "Debito"}
            ),
            { 
                {"TabParaLista.1", "TpMovimentacao"}, 
                {"TabParaLista.2", "HistoricoMovimento"} 
            }
        ),
    ConsAcrescentada = 
        Table.Combine(
            {ColsRenomeadas, fDivRicMae}
        ),
    CriaIndice = 
        Table.AddColumn(
            ConsAcrescentada, 
            "DataDocto", 
            each 
                fxConvDatasToTexto([Data]) & Text.PadStart(Number.ToText([NumDocto]), 8, "0")
        ),
    DuplsRemovidas = 
        Table.Distinct(
            CriaIndice,
            {"DataDocto"}
        ),
    _FiltroTpMovimento_ = 
        Table.Buffer(
            Table.SelectRows (
                DuplsRemovidas,
                each 
                    List.Contains(
                        {"Emprest Pessoal", "Divida Plano Saude", "Emprestimo Carro", "Pagto Parcela", "Parc Cred Pess"},
                        [TpMovimentacao]
                    )
            )
        ),
    Subst_Null_por_0 = 
        Table.ReplaceValue(
            _FiltroTpMovimento_,
            null,
            0,
            Replacer.ReplaceValue,
            {"Credito", "Debito"}
        ),
    ADDIndicePorData = 
        Table.Sort(
            Subst_Null_por_0,
            { {"Data", Order.Ascending} }
        ),
    ADDSaldoTmp = 
        Table.AddColumn(
            ADDIndicePorData, 
            "SaldoTemp", 
            each [Credito] + [Debito], Currency.Type
        ),
    ADDNumLinhas = 
        Table.AddIndexColumn(
            ADDSaldoTmp, 
            "ID_Linhas", 
            1, 
            1, 
            Int64.Type
        ),
    ADDIndMovimento = 
        Table.AddColumn(
            ADDNumLinhas, 
            "IndMovimento", 
            each 1, 
            Int64.Type
        ),
    AgrupaLinhasPorMovto = 
        Table.Group(
            ADDIndMovimento, 
            {"IndMovimento"}, 
            { {"NumLinhaMin", each List.Min([ID_Linhas]), type number} }
        ),
    MesclaIndMovtoLinhasPorMovto = 
        Table.NestedJoin(
            ADDIndMovimento, 
            {"IndMovimento"}, 
            AgrupaLinhasPorMovto, 
            {"IndMovimento"}, 
            "AgrupaLinhasPorMovto", 
            JoinKind.LeftOuter
        ),
    ExpLinhasPorMovto = 
        Table.TransformColumnTypes(
            Table.ExpandTableColumn(
                MesclaIndMovtoLinhasPorMovto, 
                "AgrupaLinhasPorMovto", 
                {"NumLinhaMin"}, 
                {"NumLinhaMin"}
            ),
            {{"NumLinhaMin", Int64.Type}}
        ),
    ADDSaldoAtualizado = 
        Table.Buffer(
            Table.TransformColumnTypes(
                Table.AddColumn(
                    ExpLinhasPorMovto, "SaldoAtual", each
                    // -- Soma o Saldo da linha anterior com a atual, gerando o Saldo atualizado --
                    List.Sum(
                        List.Range(
                            ExpLinhasPorMovto[SaldoTemp],
                            ([NumLinhaMin] - 1),
                            (([ID_Linhas] - [NumLinhaMin]) + 1)
                        )
                    )
                ),
                {{"SaldoAtual", Currency.Type}}
            )
        ),
    ColunasRemovidas = 
        Table.SelectColumns(
            ADDSaldoAtualizado,
            {"Data", "NumDocto", "TpMovimentacao", "HistoricoMovimento", "Credito", "Debito", "SaldoAtual"}
        )
in
    ColunasRemovidas
