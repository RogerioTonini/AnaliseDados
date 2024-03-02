(
    Tabela as table,
    NomeDaColunaComTabelas as text
) =>

let
    Colunas = 
        List.Buffer(
            List.Union(
                List.Transform(
                    Table.Column(
                        Tabela,
                        NomeDaColunaComTabelas
                    ),
                    each Table.ColumnNames(_)
                )
            )
        ),
    
    Out =
        Table.ExpandTableColumn(
            Tabela,
            NomeDaColunaComTabelas,
            Colunas,
            Colunas
        )
in
    Out
