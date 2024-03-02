let dCalend_Dinamico = (DtInicio as date, DtFim as date) as table =>
    let
        // Contar número de dias entre a data de início e fim
		Dias = Duration.Days(DtFim - DtInicio) + 1,
		//Criando uma lista de datas
		Datas = List.Dates(DtInicio, Dias, #duration(1,0,0,0)),
		// Converter Lista em Tabela
		LstToTable = Table.FromList(Datas, Splitter.SplitByNothing(), {"DataBase"}, null, ExtraValues.Error),
		AlteraTipo = Table.TransformColumnTypes(LstToTable, {{"DataBase", type date}}),
		//
		// Criando Colunas
		//
		NumMes     = Table.AddColumn(AlteraTipo,  "NumMes",    each Date.Month([DataBase]), Int64.Type),
		NomeMes    = Table.AddColumn(NumMes,      "NomeMes",   each Text.Start(Date.MonthName([DataBase]), 3), type text),
		SemanaMes  = Table.AddColumn(NomeMes,     "SemanaMes", each Date.WeekOfMonth([DataBase]), Int64.Type),
		SemanaAno  = Table.AddColumn(SemanaMes,   "SemanaAno", each Date.WeekOfYear([DataBase]), Int64.Type),
		Ano        = Table.AddColumn(SemanaAno,   "Ano"      , each Date.Year([DataBase]), Int64.Type),
		Trimestre  = Table.AddColumn(Ano,         "Trimestre", each Text.Combine({Number.ToText(Date.QuarterOfYear([DataBase])), " - Trim"}), type text),
		NomeDia    = Table.AddColumn(Trimestre,   "NomeDia",   each Date.DayOfWeekName([DataBase]), type text),
		NomeDiaAbr = Table.AddColumn(NomeDia,     "DiaSemana", each Text.Start([NomeDia], 3), type text),
		MesAno     = Table.AddColumn(NomeDiaAbr,  "MesAno",    each Text.Combine({[NomeMes], "-", Text.End(Number.ToText(Date.Year([DataBase])), 2)}), type text),
		AnoMes     = Table.AddColumn(MesAno,      "AnoMes",    each if Date.Month([DataBase]) < 10 
                                                                    then Text.Combine({Number.ToText(Date.Year([DataBase])), "-0", Number.ToText(Date.Month([DataBase]))})
                                                                    else Text.Combine({Number.ToText(Date.Year([DataBase])), "-",  Number.ToText(Date.Month([DataBase]))}), type text),
 		RemoveColuna   = Table.RemoveColumns(AnoMes, {"NomeDia"}),
 		LetraMaiuscula = Table.TransformColumns(RemoveColuna, {{"NomeMes", Text.Proper, type text}, {"DiaSemana", Text.Proper, type text}, {"MesAno", Text.Proper, type text}})
    in
		LetraMaiuscula
in dCalend_Dinamico
