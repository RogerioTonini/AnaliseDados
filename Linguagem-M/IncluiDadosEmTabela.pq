let
    /*
    Script utilizado quando uma tabela Dimensão não possuir o dado chave da tabela Fato.
    Normalmente é utilizado quando não se tem acesso a base de dados.
    //
    DATAB - LAENDDER ALVES - YOUTUBE - 24/08/2020
    */
    FonteDados             = Excel.Workbook(File.Contents(caminho do arquivo), null, true),
    dNomes_Table           = Fonte{[Item="dNomes",Kind="Table"]}[Data],
    Tabela_Origem          = Table.TransformColumnTypes(dNomes_Table,{{"ID_Codigo", Int64.Type}, {"Nome", type text}}),
    Lst_fDestino_Id_Nome   = List.Distinct(fDestino[Id_CodNome]),
    Lst_TabFinal_ID_Codigo = Tabela_Origem[ID_Codigo],
    Lst_CodSemCadastro     = List.Difference(Lst_fDestino_Id_Nome, Lst_TabFinal_ID_Codigo),
    Inclui_SemNome         = List.Transform(Lst_CodSemCadastro, each {_, "Sem nome"}),
    Tabela_Temp            = #table({"ID_Codigo", "Nome"}, Inclui_SemNome),
    Tabela_Final           = Table.Combine({Tabela_Origem, Tabela_Temp}),
    #"Tipo Alterado"       = Table.TransformColumnTypes(Tabela_Final,{{"ID_Codigo", Int64.Type}})
in
    #"Tipo Alterado"
