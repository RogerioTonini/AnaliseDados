/*
Tabela Calendário Modelo 2
Autor:            Wanderlei Hüttel
----------------------------------------
Alterações:
16/10/2020 - RT - Adequação de nome de colunas
10/01/2021 - RT - Criação da coluna MesesDecorridos - Demonstrar qtde de meses decorridos entre a data atual e a mais antiga.
24/02/2021 - RT - Adequar a coluna DiaUtilFeriado para constar a data que for feriado e criação da coluna NomeFeriado 

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

Dicas do Joviano Silveira - https://joviano.com/

List.Min(fDespesasCCred[Dt Compra]), List.Max(fDespesasCCred[MesAnoFatura])
*/

let
    DataMin = 
        List.Min(fDespesasMes[DataVencto] & fDespesasCCred[MesAnoFatura]),
    DataMax = 
        List.Max(fDespesasMes[DataVencto] & fDespesasCCred[MesAnoFatura]),
    DataInicial = 
        #date(Date.Year(DataMin), 1, 1),
    DataFinal =
         #date(Date.Year(DataMax), Date.Month(DataMax), Date.Day(DataMax)),
    Duracao = 
        Duration.Days(DataFinal - DataInicial) + 1,
    ListDates = 
        List.Buffer(List.Sort(List.Dates (DataInicial, Duracao, #duration(1,0,0,0)), Order.Ascending)),
    //
    AdicionarColunas = 
        List.Transform(
            ListDates, 
            each 
                {
                    List.PositionOf(ListDates, _) + 1,                  // ID_Data
                    _,                                                  // DataBase
                    if List.Contains({0,6}, Date.DayOfWeek(_)) or
                    (Date.Day(_) =  1 and Date.Month(_) =  1) or
                    (Date.Day(_) = 25 and Date.Month(_) =  1) or
                    (Date.Day(_) = 21 and Date.Month(_) =  4) or
                    (Date.Day(_) =  1 and Date.Month(_) =  5) or
                    (Date.Day(_) =  9 and Date.Month(_) =  7) or
                    (Date.Day(_) =  7 and Date.Month(_) =  9) or
                    (Date.Day(_) =  2 and Date.Month(_) = 11) or
                    (Date.Day(_) = 15 and Date.Month(_) = 11) or
                    (Date.Day(_) = 20 and Date.Month(_) = 11) or
                    (Date.Day(_) = 25 and Date.Month(_) = 12)
                        then false
                        else true,                                      // Dia útil
                    Text.Proper(Date.ToText(_,"ddd", Culture.Current)), // Nome dia da semana abreviado
                    Text.Proper(Date.DayOfWeekName(_)),                 // Nome dia da semana
                    Date.Year(_),                                       // Ano
                    Date.Month(_),                                      // Mês
                    Date.Day(_),                                        // Dia
                    Text.Proper(Date.MonthName(_)),                     // Nome do mês
                    Text.Proper(Date.ToText(_,"MMM", Culture.Current)), // Nome do mês abreviado,
                    Text.Proper(Date.ToText(_, "MMMM/yyyy")),           // Nome mês/ano,
                    Text.Proper(Date.ToText(_, "MMM/yyyy")),            // Nome mês abreviado/ano
                    Date.DayOfWeek(_),                                  // Dia da semana
                    if Date.From(DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3) ) = _ 
                        then true 
                        else false,                                     // Dia corrente
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
                    if Date.Month(_) <= 6 
                        then 1 
                        else 2,
                    Number.FromText(Date.ToText(_, "yyyyMM")),          // Número: AnoMês
                    Number.FromText(Date.ToText(_, "yyyyMMdd")),        // Data serial
                    Date.DaysInMonth(_)                                 // Dias no mês
                }
        ),
        ListaParaTabela = 
            #table(
                type 
                    table [
                        #"ID_Data"         = Int64.Type,
                        #"DataBase"        = date,
                        #"DiaUtil"         = logical,
                        #"NomeAbrvDiaSem"  = text,
                        #"NomeDiaSemana"   = text,
                        #"Ano"             = Int64.Type,
                        #"Mes"             = Int32.Type,
                        #"Dia"             = Int32.Type,
                        #"NomeMes"         = text,
                        #"NomeMesAbrv"     = text,
                        #"NomeMesAno"      = text,
                        #"NomeAbrvMesAno"  = text,
                        #"DiaDaSemana"     = Int32.Type,
                        #"DiaCorrente"     = logical,
                        #"DiaMes"          = text,
                        #"MesAno"          = text,
                        #"MesesDecorridos" = Int64.Type,
                        #"SemanaDoMes"     = Int32.Type,
                        #"SemanaDoAno"     = Int32.Type,
                        #"Bimestre"        = Int32.Type,
                        #"Trimestre"       = Int32.Type,
                        #"Semestre"        = Int32.Type,
                        #"NumAnoMes"       = Int32.Type,
                        #"DataSerial"      = Int64.Type,
                        #"DiasNoMes"       = Int32.Type
                    ],
                    AdicionarColunas
            )
in
    ListaParaTabela