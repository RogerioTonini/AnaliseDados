let
    ListaHoras = List.Times(#time(0,0,0),24*60,#duration(0,0,1,0)),
    //
    AdicionarColunas = List.Transform(ListaHoras, each 
        {
            _,              // HoraBase
            Time.Hour(_),   // Hora Decimal
            Time.Minute(_), // Minuto Decimal
            Time.Second(_)  // Segundo Decimal
        }
    ),
    //
    ListaParaTabela = #table(
        type table [
            #"HoraBase" = time,
            #"Hora"     = Int32.Type, 
            #"Minuto"   = Int32.Type,
            #"Segundo"  = Int32.Type
        ],
        AdicionarColunas
    )
in
    ListaParaTabela
