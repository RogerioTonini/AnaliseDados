(
    txtColuna01 as text,
    txtColuna02 as text
)=>

let
    FonteDados = Excel.CurrentWorkbook(){[Name = "tbDados"]}[Content],
    TabelaDados = Table.FromRecords(
        {
            [ColDados = DateTime.FromText(txtColuna01)],
            [ColDados = DateTime.FromText(txtColuna02)]
        }
    ),
    SepararDataHora = Table.SplitColumn(
        Table.TransformColumnTypes(
            TabelaDados, 
            {{"ColDados", type text}}, 
            "pt-BR"
        ),
        "ColDados",
        Splitter.SplitTextByDelimiter(
            " ",
            QuoteStyle.Csv
        ),
        {"Data", "Hora"}
    )
in
    SepararDataHora
