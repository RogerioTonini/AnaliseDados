// dCalendario
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

    ListaParaTabela = 
        #table(
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

// ---------------------------------------------------------------------------------------
// dCanal
let
    Fonte = 
      Table.Buffer(
         fxGeraTabDimensao(
            DadosBruto, 
            "Column13", 
            "ID_Canal"
         )
      )
in
    Fonte

// ---------------------------------------------------------------------------------------
// dCluster
let
    FonteDados = 
        Excel.CurrentWorkbook(){[Name="tbClusterTemp"]}[Content],

    TpAlteradoColunas = 
        Table.TransformColumnTypes(
            FonteDados,
            { {"ID_Cluster", Int32.Type} }
        ),
        
    RemoveEspacosVazios = 
        Table.Buffer(
            Table.TransformColumns(
                TpAlteradoColunas, 
                { {"TPCLUSTER", each fxRemoveEspacosColunas(_), type text} }
            )
        )
in
    RemoveEspacosVazios

// ---------------------------------------------------------------------------------------
// dCadosCadastrais
let
    FonteDados = 
        fxLimpaTabela(DadosBruto, "ID_SKU", "C"),

    _DadosNormatizados_ = 
        Table.Buffer(
            Table.TransformColumnTypes(
                FonteDados,
                {
                    {"ID_SKU", Int64.Type}, 
                    {"FCC", Int64.Type}, 
                    {"Métrica",                    type text}, 
                    {"Cluster",                    type text}, 
                    {"Família",                    type text}, 
                    {"Molécula",                   type text}, 
                    {"Apresentação",               type text}, 
                    {"Laboratório",                type text}, 
                    {"Classe terapêutica nível 4", type text}, 
                    {"Genéricos",                  type text}, 
                    {"Concorrente/Medley",         type text}, 
                    {"Segmento",                   type text}, 
                    {"Canal",                      type text}, 
                    {"Play / Not Play SKU",        type text}, 
                    {"Categoria",                  type text}
                }
            )
        )
in
    _DadosNormatizados_

// ---------------------------------------------------------------------------------------
// dMetrica

let
    FonteDados = 
        Excel.CurrentWorkbook(){[Name = "tbMetricaTemp"]}[Content],

    TipoAlteradoColunas = 
        Table.TransformColumnTypes(
            FonteDados,
            { {"ID_Metrica", Int32.Type} }
        ),
        
    RemoveEspacosVazios = 
        Table.TransformColumns(
            TipoAlteradoColunas, 
            { {"TpMetrica", each fxRemoveEspacosColunas(_), type text} }
        ),
    LinhasClassificadas = Table.Sort(RemoveEspacosVazios,{{"ID_Metrica", Order.Ascending}})
in
    LinhasClassificadas

// ---------------------------------------------------------------------------------------
// dMolecula
let
    FonteDados =
        Table.Buffer(
            fxGeraTabDimensao(
                DadosBruto, 
                "Column3", 
                "ID_Molecula"
            )
        )
in
    FonteDados

// ---------------------------------------------------------------------------------------
// dSegmento
let
    Fonte = Table.Buffer(
            fxGeraTabDimensao(
                DadosBruto, 
                "Column11", 
                "ID_Segmento"
            )
        )
in
    Fonte

// ---------------------------------------------------------------------------------------
// fTotQtdVlrMensal

let
    //---------- Fonte de Dados ----------
    FonteDados =
        Table.Buffer(
            fxLimpaTabela(DadosBruto, "ID_SKU", "M")
        ),

    //---------- Monta as Consultas de Saldo e Valorização do Estoque ----------
    __ = "",

    CriaConsultaSaldo =
        fxTrataSldVlrEstoqueMes(
            FonteDados, 
            1, 
            "SaldoEstoque"
        ),

    CriaConsultaValor =
        fxTrataSldVlrEstoqueMes(
            FonteDados, 
            2, 
            "ValorEstoque"
        ),

    UnificaConsultas = 
        Table.Combine(
            {
                CriaConsultaSaldo, 
                CriaConsultaValor
            }
        ),
    
    //---------- Normatiza Consulta ----------
    ___ = "",

    _DadosNormatizados_ =
        Table.Buffer(
            fxTrataColSaldoValorEstoque(
                UnificaConsultas
            )
        )
in
    _DadosNormatizados_

// ---------------------------------------------------------------------------------------
// fTotQtdVlrAnual
let

    //---------- Fonte de Dados ----------
    FonteDados =
        Table.Buffer(
            fxLimpaTabela(
                DadosBruto, 
                "ID_SKU", 
                "A"
            )
        ),

    //---------- Monta as Consultas de Saldo e Valorização do Estoque ----------
    __ = "",

    CriaConsultaSaldo =
        fxTrataSldVlrEstoqueAno(
            FonteDados, 
            1, 
            "SaldoEstoque"
        ),

    CriaConsultaValor =
        fxTrataSldVlrEstoqueAno(
            FonteDados, 
            2, 
            "ValorEstoque"
        ),

    UnificaConsultas = 
        Table.Combine(
            {
                CriaConsultaSaldo, 
                CriaConsultaValor
            }
        ),

    //---------- Normatiza Consulta ----------
    ___ = "",

    _DadosNormatizados_ =
        Table.Buffer(
            fxTrataColSaldoValorEstoque(
                UnificaConsultas
            )
        )
in
    _DadosNormatizados_


// ---------------------------------------------------------------------------------------
// dDadosBruto-Antigo
let
    //---------- Captura a lista de arquivos existentes na Pasta ----------

    ListaArquivos = 
        Table.SelectRows(
            Folder.Files(
                _CaminhoArquivos
            ),
            each ([Extension] = _ExtensaoArquivos)
        ),

    PastaFiltrada = 
        Table.SelectRows(
            ListaArquivos, 
            each ([Folder Path] = _CaminhoArquivos)
        ),
        
    // ----------Monta a Base de Dados ----------
    _ = "",

    AddColCaminhoNomeArquivo = 
        Table.CombineColumns(
            PastaFiltrada,
            {"Folder Path", "Name"},
            Combiner.CombineTextByDelimiter("", QuoteStyle.None),
            "CaminhoNomeArquivo"
        ),
        
    ColunasMantidas = 
        Table.SelectColumns(
            AddColCaminhoNomeArquivo,
            {"CaminhoNomeArquivo"}
        ),

    ColunaAddTabelaCampos =
        Table.AddColumn(
            ColunasMantidas, 
            "TabelaCampos", 
            each 
                fxExplodeDados_XLS([CaminhoNomeArquivo])
        ),

    _TabelaExpandida_ = 
        Table.Buffer(
            fxExpandeColunasTabela(
                ColunaAddTabelaCampos, 
                "TabelaCampos"
            )
        ),

    // ---------- Remove Linhas / Colunas Sem Dados ou Desnecessários ----------
    __ = "",

    ColunasRemovidas = 
        Table.SelectColumns(
            _TabelaExpandida_,
            {
                "Column1",  "Column2",  "Column3",  "Column4",  "Column5",  "Column7",  "Column8",  "Column9",  "Column10", "Column11", "Column12", 
                "Column13", "Column14", "Column17", "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", 
                "Column26", "Column27", "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", 
                "Column37", "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46"
            }
        ),

    RemoveLinhasSemDados = 
        Table.SelectRows(
            ColunasRemovidas, 
            each
                [Column1] <> " " or [Column1] = null
        ),

    // IndiceCriado = 
    //     Table.AddIndexColumn(
    //         RemoveLinhasSemDados, 
    //         "ID_Registro", 
    //         0, 
    //         1, 
    //         Int64.Type
    //     ),

    TrocaTracoPorZero = 
        Table.ReplaceValue(
            RemoveLinhasSemDados,
            "-",
            "0",
            Replacer.ReplaceText,
            {
                "Column18", "Column19", "Column20", "Column21", "Column22", "Column23", "Column24", "Column25", "Column26", "Column27", 
                "Column28", "Column29", "Column30", "Column31", "Column32", "Column33", "Column34", "Column35", "Column36", "Column37", 
                "Column38", "Column39", "Column40", "Column41", "Column42", "Column43", "Column44", "Column45", "Column46"
            }
        ),

    //----------> Mescla de Consultas para Geração do Novo Código EAN <----------
    ___ = "",

   MesclaConsultaCLUSTER = 
        Table.NestedJoin(
            TrocaTracoPorZero, 
            {"Column12"}, 
            dCluster, 
            {"TPCLUSTER"}, 
            "dCluster", 
            JoinKind.LeftOuter
        ),

    ID_ClusterExpandido = 
        Table.ExpandTableColumn(
            MesclaConsultaCLUSTER, 
            "dCluster", 
            {"ID_Cluster"}, 
            {"ID_Cluster"}
        ),

    MesclaConsultaMETRICA = 
        Table.NestedJoin(
            ID_ClusterExpandido, 
            {"Column1"}, 
            dMetrica, 
            {"TpMetrica"}, 
            "dMetrica", 
            JoinKind.LeftOuter
        ),
        
    ID_MetricaExpandido = 
        Table.Buffer(
            Table.ExpandTableColumn(
                MesclaConsultaMETRICA, 
                "dMetrica", 
                {"ID_Metrica"}, 
                {"ID_Metrica"}
            )
        ),

    //----------> Gera Novo Código SKU <----------
    ____ = "",

    GeraNovoSKU = 
        Table.AddColumn(
            ID_MetricaExpandido, 
            "ID_SKU",
            each
                if [Column5] <> "FCC" then 
                    Number.ToText([ID_Cluster]) & [Column5] 
                else 
                    "99999999"
        ),
    
    _DadosNormatizados_ = 
        Table.Buffer(
            Table.TransformColumnTypes(
                GeraNovoSKU,
                {
                    {"ID_SKU", Int64.Type}
                }
            )
        )

in
    _DadosNormatizados_