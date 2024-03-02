/*
Tabela....: dCalendário v.3
Autor.....: Wanderlei Hüttel
Alterações: Rogerio Tonini
--------------------------------------------------------------------------------
Alterações:
16/10/2020 - RT - Adequação de nome de colunas
10/01/2021 - RT - Criação da coluna [MesesDecorridos] - Demonstrar qtde de meses decorridos entre a data atual e a mais antiga.
28/10/2023 - RT - Documentação no código
                  Adequação dos Nomes das Colunas, 
                  Retirada de algumas colunas desnecessárias,
                  Ela não é mais invocada como uma função,
                  Também foram extintas as variaveis [DataMin] e [DataMax], devido ao fato que foi a Tabela dParametros contendo as variaveis [DataInicio] e [DataFinal]

https://www.linkedin.com/in/rogerio-tonini-1b914b4a/
https://github.com/RogerioTonini/Linguagem-M

https://www.linkedin.com/in/wanderleihuttel
https://github.com/wanderleihuttel/powerbi

Dicas do Joviano Silveira
https://joviano.com/
--------------------------------------------------------------------------------
*/

let
    //---------- Inicialização das variaveis ----------
    _DataInicial = 
        #date(Date.Year(_DataInicio), Date.Month(_DataInicio), Date.Day(_DataInicio)),

    _DataFinal = 
        #date(Date.Year(_DataFinal), Date.Month(_DataFinal), Date.Day(_DataFinal)),

    _Duracao = Duration.Days(_DataFinal - _DataInicial) + 1,
    
    _ListaDatas  = 
        List.Buffer(
            List.Sort(
                List.Dates(
                    _DataInicial, 
                    _Duracao, 
                    #duration(1,0,0,0)
                ), 
                Order.Ascending
            )
        ),

    //---------- Cria as informações que serão armazenadas na tabela  ----------
    _____ ="",

    AdicionarColunas = List.Transform(_ListaDatas, each 
        {
            List.PositionOf(_ListaDatas, _) + 1,                // ID_Data
            _,                                                  // DataBase
            Date.EndOfMonth(_),                                 // Último data do mês
            Date.DaysInMonth(_),                                // Dias no mês
            Number.FromText(Date.ToText(_, "yyyyMMdd")),        // Data serial

            if Date.From(
                DateTimeZone.SwitchZone(DateTimeZone.UtcNow(),-3)) = _ 
                then true 
                else false,                                     // Dia corrente

            if List.Contains({0,6}, Date.DayOfWeek(_)) or
               (Date.Day(_) =  1 and Date.Month(_) =  1) or (Date.Day(_) = 25 and Date.Month(_) =  1) or
               (Date.Day(_) = 21 and Date.Month(_) =  4) or (Date.Day(_) =  1 and Date.Month(_) =  5) or
               (Date.Day(_) =  9 and Date.Month(_) =  7) or (Date.Day(_) =  7 and Date.Month(_) =  9) or
               (Date.Day(_) = 12 and Date.Month(_) = 10) or (Date.Day(_) =  2 and Date.Month(_) = 11) or
               (Date.Day(_) = 15 and Date.Month(_) = 11) or (Date.Day(_) = 20 and Date.Month(_) = 11) or
               (Date.Day(_) = 25 and Date.Month(_) = 12)
                then false
                else true,                                      // Dia útil?

            Date.DayOfWeek(_),                                  // Dia da semana
            Text.Proper(Date.DayOfWeekName(_)),                 // Dia da semana
            Text.Proper(Date.ToText(_,"ddd", Culture.Current)), // Dia da semana abreviado

            Text.Proper(Date.MonthName(_)),                     // Nome do mês
            Text.Proper(Date.ToText(_,"MMM", Culture.Current)), // Nome do mês abreviado,

            Text.Proper(Date.ToText(_, "MMMM/yyyy")),           // Nome mês/ano,
            Text.Proper(Date.ToText(_, "MMM/yyyy")),            // Nome mês abreviado/ano

            Date.WeekOfMonth(_),                                // Semana do mês
            Date.WeekOfYear(_),                                 // Semana do ano
            ((((Date.Year(_DataFinal) - Date.Year(_)) * 12) + 
                (Date.Month(_DataFinal))) - Date.Month(_)),     // Qtde de meses decorridos entre a data atual e a mais antiga

            if Number.Mod(Date.Month(_), 2) = 0 
                then Date.Month(_) / 2 
                else (Date.Month(_) + 1) / 2,                  // Bimestre

            Date.QuarterOfYear(_),                             // Trimestre

            if Date.Month(_) <= 6 
                then 1 
                else 2                                         // Semestre

            // Date.ToText(_, "dd/MM"),                         // Dia/mês
            // Date.ToText(_, "MM/yyyy"),                       // Mês/ano
            // Date.day(_),                                     // Dia Data Base
            // Date.month(_),                                   // Mês Data Base
            // Date.year(_),                                    // Ano Data Base
            // Number.FromText(Date.ToText(_, "yyyyMM")),       // Número: AnoMês
      }
    ),

    //---------- Cria as Colunas, Tipifica e Insere os dados criados anteriormente  ----------
    ______ ="",

    ListaParaTabela = #table(
        type table [
            #"ID_Data"         = Int64.Type,
            #"DataBase"        = date,
            #"UltimaDataMes"   = date,
            #"QtdeDiasMes"     = Int64.Type,
            #"DataSerial"      = Int64.Type,

            #"DiaCorrente"     = logical,
            #"DiaUtil"         = logical,

            #"NumDiaSemana"    = Int64.Type,
            #"DiaSemana"       = text,
            #"DiaSemanaAbrv"   = text,

            #"NomeMes"         = text,
            #"NomeMesAbrv"     = text,

            #"NomeMes_Ano"     = text,
            #"NomeMesAbrv_Ano" = text,

            #"SemanaMesBase"   = Int64.Type,
            #"SemanaAnoBase"   = Int64.Type,
            #"MesesDecorridos" = Int64.Type,

            #"BimestreBase"    = Int64.Type,
            #"TrimestreBase"   = Int64.Type,
            #"SemestreBase"    = Int64.Type

            // #"Dia_Mes"         = text,
            // #"Mes_Ano"         = text,
            // #"DiaDataBase"     = Int64.Type,
            // #"MesDataBase"     = Int64.Type,
            // #"AnoDataBase"     = Int64.Type,
            // #"AnoMesSerial"    = Int64.Type,
        ],
        AdicionarColunas
    )
in
    ListaParaTabela
