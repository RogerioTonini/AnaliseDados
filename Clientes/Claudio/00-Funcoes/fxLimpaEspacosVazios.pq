/*
    Função..: fxLimpaEspacosVazios
    Objetivo: Retira todos espaços em branco (ESQ/DIR) e caracteres NÃO IMPRIMIVEIS de uma coluna
    Criador.: ROGERIO TONINI
    Data....: 26/10/2023
    -------------------------------------------------------------------------
    Parametros:
        _NomeColuna: Nome da Coluna a ser tratada
*/

(
    _NomeColuna as text
) =>

let
    // Remove espaços do lado direito, do lado esquerdo e caracteres não imprimíveis
    _ColunaNormatizada_ = 
		Table.Buffer(
			Text.Clean(
				Text.Trim(
					_NomeColuna
				)
			)
		)
in
    _ColunaNormatizada_