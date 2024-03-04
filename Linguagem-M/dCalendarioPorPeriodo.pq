/*
Tabela.: dCalendário v.3
Autor..: Davi Rodolfo - Consultor de BI & FP&A
Power BI | Power Query | DAX | Looker Studio | Excel | SQL
FP&A | Planejamento, Análise, Modelagem e Consultoria Financeira
Varejo | Franquias
21) 98390-4920 (Whatsapp)
davishofar@gmail.com
https://www.linkedin.com/in/davi-rodolfo-florentino/

Utilizador. Rogerio Tonini
(11) 98504-8872
rogerio.tonini@gmail.com
https://www.linkedin.com/in/rogerio-tonini-1b914b4a/
https://github.com/RogerioTonini/AnaliseDados/Linguagem-M

Alterações realizadas:
--------------------------------------------------------------------------------

*/

let
   //Criando minha funcao encapsulada
   fnGerarPeriodos = 
      (
         Periodo     as text,
         DataInicial as date, 
         DataFinal   as date, 
         Ordem       as number
      ) =>

      let
         QtdDias = 
            Duration.Days( DataFinal-DataInicial ) + 1,

         Datas = 
            List.Dates( 
               DataInicial, 
               QtdDias, 
               #duration(1,0,0,0)
            ),

         Cabecalho = 
            type table[ Data=date, Periodo=text, Ordem=number ],

         Lista = 
            List.Transform(
               Datas,
               each
               {
                  _,
                  Periodo,
                  Ordem
               }
            ),

         Tabela = 
            #table(Cabecalho, Lista)
      in
         Tabela
   ,

   //Hoje e Ontem
   DtHoje = 
      DateTime.Date( 
         DateTime.LocalNow() 
      ),

   DtOntem = 
      Date.AddDays( DtHoje, -1 ),

   //Semana Atual
   InicioSemana = 
      Date.StartOfWeek( DtHoje ),
   FimSemana = 
      Date.EndOfWeek( DtHoje ),

   //Semana Passada - 7 dias
   InicioSemanaPassada = 
      Date.AddDays( InicioSemana, -7 ),

   FimSemanaPassada = 
      Date.AddDays( FimSemana, -7 ),

   //Duas Semanas Antes - 15 dias
   InicioDuasSemanaPassada = 
      Date.AddDays( InicioSemanaPassada, -7 ),

   FimDuasSemanaPassada = 
      Date.AddDays( FimSemanaPassada, -7 ),

   //Mes Atual
   InicioMes = 
      Date.StartOfMonth( DtHoje ),
   FimMes = 
      Date.EndOfMonth( DtHoje ),

   //Mes Anterior
   InicioMesAnterior = 
      Date.AddMonths(
         Date.StartOfMonth( DtHoje ), -1
      ),

   FimMesAnterior = 
      Date.EndOfMonth( InicioMesAnterior ),

   //Este Ano
   InicioANo = 
      Date.StartOfYear( DtHoje ),

   FimAno = 
      Date.EndOfYear( DtHoje ),

   Intervalos = 
      {
         { "Hoje",                DtHoje, DtHoje, 1 },
         { "Ontem",               DtOntem, DtOntem , 2},
         { "Esta semana",         InicioSemana, FimSemana, 3 },
         { "Últimos 7 dias",      Date.AddDays(DtHoje, -6), DtHoje, 4 },
         { "Semana passada",      InicioSemanaPassada, FimSemanaPassada, 5 },
         { "Últimos 15 dias",     Date.AddDays(DtHoje, -14), DtHoje, 6 },
         { "Incio Mês até ontem", InicioMes, DtOntem, 7},
         { "Este mês",            InicioMes, FimMes, 8 },
         { "Últimos 30 dias",     Date.AddDays(DtHoje, -29), DtHoje, 9 },
         { "Mês passado",         InicioMesAnterior, FimMesAnterior, 10 },
         { "Este ano",            InicioANo, FimAno, 11 },
         { "Ano passado",         Date.AddYears(InicioANo, -1), Date.AddYears(FimAno, -1), 12}
      }
   //Aplicando a função de periodos a partir da lista movel de datas
   ,
   
   Períodos =
      List.Transform(
         Intervalos,
         each
            fnGerarPeriodos(_{0},_{1},_{2},_{3})
      ),
   
   Tabela = 
      Table.Buffer(
         Table.Combine( Períodos )
      )
in
   Tabela