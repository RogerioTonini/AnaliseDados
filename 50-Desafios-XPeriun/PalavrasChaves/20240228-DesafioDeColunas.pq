let
    Fonte = Excel.Workbook(File.Contents("E:\03-CursosMaterial\PowerBI\LeonardoKarpinski\Trilha00-BoasVindas\teste matriz.xlsx"), null, true),
    Navegacao = Fonte{[Item = "Transformar disso", Kind = "Sheet"]}[Data],
    FillColumns = Table.ColumnNames(Navegacao),
    PreencherDireita = Table.AddColumn(
        Navegacao,
        "Custom",
        each
            Table.FromRows(
                {
                    Table.FillDown(
                        Table.FromColumns({Record.FieldValues(Record.SelectFields(_, FillColumns))}), {"Column1"}
                    )[Column1]
                },
                FillColumns
            )
    ),
    ColunasSelecionadas = Table.RemoveColumns(PreencherDireita, FillColumns),
    CustomExpandida = Table.ExpandTableColumn(ColunasSelecionadas, "Custom", FillColumns),
    CabecalhosPromovidos = Table.PromoteHeaders(CustomExpandida, [PromoteAllScalars = true]),
    OutrasColunasNaoDinamicas = Table.UnpivotOtherColumns(
        CabecalhosPromovidos,
        {
            "Tipo de Unidade de Negócio",
            "Etapa do Projeto",
            "Empresa",
            "Unidade de Negócio (UN)",
            "CNPJ",
            "UN",
            "Participação NPO",
            "Diretoria Responsável",
            "Gestor Responsável",
            "Envolvidos"
        },
        "Competência",
        "Valor"
    ),
    AdicionarIndice = Table.AddColumn(
        OutrasColunasNaoDinamicas,
        "ID",
        each
            let
                Resto = Number.Mod(Number.From(Text.AfterDelimiter([Competência], "_")), 3)
            in
                if Resto = null then
                    3
                else
                    Resto,
        Int64.Type
    ),
    LinhasFiltradas = Table.SelectRows(
        AdicionarIndice, each [Tipo de Unidade de Negócio] <> null and [Tipo de Unidade de Negócio] <> ""
    ),
    __________ = "",
    TabelaAtributo = Table.FromRecords(
        {
            [
                ID = 0,
                Atributo = "Reprojeção realizado"
            ],
            [
                ID = 1,
                Atributo = "Fechamento Realizado"
            ],
            [
                ID = 2,
                Atributo = "Reprojeção previsto"
            ],
            [
                ID = 3,
                Atributo = "Fechamento Previsto"
            ]
        },
        type table [ID = Int64.Type, Atributo = Text.Type]
    ),
    ___________ = "",
    BuscarAtributos = Table.Join(
        LinhasFiltradas, "ID", TabelaAtributo, "ID", JoinKind.Inner, JoinAlgorithm.RightHash
    ),
    ExtrairData = Table.TransformColumns(
        BuscarAtributos, {{"Competência", each Date.From(Text.BeforeDelimiter(_, "_"), "pt-BR"), type date}}
    ),
    LinhasAgrupadas = Table.Group(
        ExtrairData,
        {
            "Tipo de Unidade de Negócio",
            "Etapa do Projeto",
            "Empresa",
            "Unidade de Negócio (UN)",
            "CNPJ",
            "UN",
            "Participação NPO",
            "Diretoria Responsável",
            "Gestor Responsável",
            "Envolvidos",
            "Competência"
        },
        {{"Tabela", each _[[Atributo], [Valor]], type table [Valor = date, Atributo = text]}}
    ),
    AjustarTabela = Table.AddColumn(
        LinhasAgrupadas,
        "Tabela Ajustada",
        each Table.PromoteHeaders(Table.Transpose([Tabela]), [PromoteAllScalars = true]),
        type table [
            Fechamento Previsto = date,
            Fechamento Realizado = date,
            Reprojeção previsto = date,
            Reprojeção realizado = date
        ]
    ),
    OutrasColunasRemovidas = Table.SelectColumns(
        AjustarTabela,
        {
            "Tipo de Unidade de Negócio",
            "Etapa do Projeto",
            "Empresa",
            "Unidade de Negócio (UN)",
            "CNPJ",
            "UN",
            "Participação NPO",
            "Diretoria Responsável",
            "Gestor Responsável",
            "Envolvidos",
            "Competência",
            "Tabela Ajustada"
        }
    ),
    TabelaAjustadaExpandido = Table.ExpandTableColumn(
        OutrasColunasRemovidas,
        "Tabela Ajustada",
        {"Fechamento Previsto", "Fechamento Realizado", "Reprojeção previsto", "Reprojeção realizado"},
        {"Fechamento Previsto", "Fechamento Realizado", "Reprojeção previsto", "Reprojeção realizado"}
    ),
    TipoAlterado = Table.TransformColumnTypes(
        TabelaAjustadaExpandido,
        {
            {"Tipo de Unidade de Negócio", Int64.Type},
            {"Etapa do Projeto", Int64.Type},
            {"Empresa", Int64.Type},
            {"Unidade de Negócio (UN)", Int64.Type},
            {"CNPJ", Int64.Type},
            {"UN", Int64.Type},
            {"Participação NPO", Int64.Type},
            {"Diretoria Responsável", Int64.Type},
            {"Gestor Responsável", Int64.Type},
            {"Envolvidos", Int64.Type}
        }
    )
in
    TipoAlterado