/*
Tabela Calendário Modelo 2
Autor:            Wanderlei Hüttel
----------------------------------------
Alterações:
16/10/2020 - RT - Adequação de nome de colunas
10/01/2021 - RT - Criação da coluna MesesDecorridos - Demonstrar qtde de meses decorridos entre a data atual e a mais antiga.

https://www.linkedin.com/in/rogerio-tonini-1b914b4a/
https://github.com/RogerioTonini/Ling_M

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

Dicas do Joviano Silveira
https://joviano.com/

- Exemplos:
List.Min(fDespesasCCred[Dt Compra]), List.Max(fDespesasCCred[MesAnoFatura])

DataMin = Date.FromText("01/01/2019"),
DataMax = Date.FromText("31/12/2020"),

DataMin = List.Min(Fato1[Data] & Fato2[Data]),
DataMax = List.Max(Fato1[Data] & Fato2[Data]),
--------------------------------------------------------------------------------
*/

(DataInicio as date, DataFim as date) =>

let
    DataMin     = List.Min(DataInicio),
    DataMax     = List.Max(DataFim),
    DataInicial = #date(Date.Year(DataMin), 1, 1),
    DataFinal   = #date(Date.Year(DataMax), Date.Month(DataMax), Date.Day(DataMax)),
    Duracao     = Duration.Days(DataFinal - DataInicial) + 1,
    ListDates   = List.Buffer(List.Sort(List.Dates (DataInicial, Duracao, #duration(1,0,0,0)), Order.Ascending)),
    //
    AdicionarColunas = List.Transform(ListDates, each 
        {
            //List.PositionOf(ListDates, _) + 1,                  // ID_Data
            _,                                                  // DataBase
            Date.Year(_),                                       // Ano
            Date.Month(_),                                      // Mês
            Date.Day(_),                                        // Dia
            Text.Proper(Date.MonthName(_)),                     // Nome do mês
            Text.Proper(Date.ToText(_,"MMM", Culture.Current)), // Nome do mês abreviado,
            Text.Proper(Date.ToText(_, "MMMM/yyyy")),           // Nome mês/ano,
            Text.Proper(Date.ToText(_, "MMM/yyyy")),            // Nome mês abreviado/ano
            Date.DayOfWeek(_),                                  // Dia da semana
            if not List.Contains({0,6}, Date.DayOfWeek(_))      
                then true 
                else false,                                     // Dia útil
            if Date.From(DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3) ) = _ 
                then true else 
                false,                                          // Dia corrente
            Text.Proper(Date.DayOfWeekName(_)),                 // Nome dia da semana
            Text.Proper(Date.ToText(_,"ddd", Culture.Current)), // Nome dia da semana abreviado
            Date.ToText(_, "dd/MM"),                            // Dia/mês
            Date.ToText(_, "MM/yyyy"),                          // Mês/ano
            ((((Date.Year(DataFinal) - Date.Year(_)) * 12) + 
                (Date.Month(DataFinal))) - Date.Month(_)),      // Qtde de meses decorridos entre a data atual e a mais antiga
            Date.WeekOfMonth(_),                                // Semana do mês
            Date.WeekOfYear(_),                                 // Semana do ano
            if Number.Mod(Date.Month(_), 2) = 0 
                then Date.Month(_) / 2 
                else (Date.Month(_) + 1) / 2,                   // Bimestre
            Date.QuarterOfYear(_),                              // Trimestre
            if Date.Month(_) <= 6 then 1 else 2,                // Semestre
            Number.FromText(Date.ToText(_, "yyyyMM")),          // Número: AnoMês
            Number.FromText(Date.ToText(_, "yyyyMMdd")),        // Data serial
            Date.DaysInMonth(_)                                 // Dias no mês
      }
    ),
    ListaParaTabela = #table(
        type table [
            //#"ID_Data"           = Int64.Type,
            #"DataBase"          = date,
            #"Ano"               = Int64.Type,
            #"Mes"               = Int64.Type,
            #"Dia"               = Int64.Type,
            #"NomeDoMes"         = text,
            #"NomeMesAbrv"       = text,
            #"NomeMes_Ano"       = text,
            #"NomeMesAbrv_Ano"   = text,
            #"DiaDaSemana"       = Int64.Type,
            #"DiaUtil"           = logical,
            #"DiaCorrente"       = logical,
            #"NomeDiaDaSemana"   = text,
            #"NomeAbrvDiaDaSem"  = text,
            #"Dia_Mes"           = text,
            #"Mes_Ano"           = text,
            #"MesesDecorridos"   = Int64.Type,
            #"SemanaDoMes"       = Int64.Type,
            #"SemanaDoAno"       = Int64.Type,
            #"Bimestre"          = Int64.Type,
            #"Trimestre"         = Int64.Type,
            #"Semestre"          = Int64.Type,
            #"Num_Ano_Mes"       = Int64.Type,
            #"DataSerial"        = Int64.Type,
            #"DiasNoMes"         = Int64.Type
        ],
        AdicionarColunas
    )
in
    ListaParaTabela
