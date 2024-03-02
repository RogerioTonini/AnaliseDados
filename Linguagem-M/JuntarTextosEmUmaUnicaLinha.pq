/*
Script Desenvolvido por Joviano Silveira
Objetivo: Concatenar texto de várias linhas em uma Única
https://joviano.com/
Canal: YOUTUBE
Data: 24/12/2020
*/

let
    Fonte = Excel.CurrentWorkbook(){[Name="_CT2010"]}[Content],
    #"Linhas Agrupadas" = Table.Group(Fonte, {"CT2_DATA", "CT2_LOTE", "CT2_DOC"}, {{"TabelaTodasLinhas", each _, type table [CT2_DATA=datetime, CT2_LOTE=text, CT2_DOC=number, CT2_DEBITO=nullable number, CT2_CREDIT=nullable number, CT2_HIST=text, CT2_UND=text, CT2_UNC=text, CT2_VALOR=any, R_E_C_N_O_=any]}}),
    #"Personalização Adicionada" = Table.AddColumn(#"Linhas Agrupadas", "ColunaHistoricoSozinha", each Table.SelectColumns([TabelaTodasLinhas],{"CT2_HIST"})),
    #"Personalização Adicionada1" = Table.AddColumn(#"Personalização Adicionada", "TabelaParaLista", each Table.ToList([ColunaHistoricoSozinha])),
    #"Valores Extraídos" = Table.TransformColumns(#"Personalização Adicionada1", {"TabelaParaLista", each Text.Combine(List.Transform(_, Text.From), ""), type text}),
    HistoricoExplodido = Table.ReplaceValue(#"Valores Extraídos","""","",Replacer.ReplaceText,{"TabelaParaLista"}),
    #"Consultas Mescladas" = Table.NestedJoin(Fonte, {"CT2_DATA", "CT2_LOTE", "CT2_DOC"}, HistoricoExplodido, {"CT2_DATA", "CT2_LOTE", "CT2_DOC"}, "HistoricoExplodido", JoinKind.LeftOuter),
    #"HistoricoExplodido Expandido" = Table.ExpandTableColumn(#"Consultas Mescladas", "HistoricoExplodido", {"TabelaParaLista"}, {"TabelaParaLista"}),
    #"Linhas Filtradas" = Table.SelectRows(#"HistoricoExplodido Expandido", each ([R_E_C_N_O_] <> "")),
    #"Colunas Removidas" = Table.RemoveColumns(#"Linhas Filtradas",{"CT2_HIST"}),
    #"Colunas Renomeadas" = Table.RenameColumns(#"Colunas Removidas",{{"TabelaParaLista", "CT2_HIST"}}),
    #"Tipo Alterado" = Table.TransformColumnTypes(#"Colunas Renomeadas",{{"CT2_DATA", type date}, {"CT2_LOTE", type text}, {"CT2_DOC", type text}, {"CT2_DEBITO", type text}, {"CT2_CREDIT", type text}, {"CT2_UND", type text}, {"CT2_UNC", type text}, {"CT2_VALOR", type number}, {"R_E_C_N_O_", Int64.Type}})
in
    #"Tipo Alterado"
