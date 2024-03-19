/*
Problema:
1-) Os dados estão em uma planilha.
2-) São 2 colunas para um registro,onde: a primeira linha é o nome do produto (esta mesclado em 2 colunas ([A] e [B])) e
   as demais linhas a coluna [A] são para as Colunas e [B] são para os Registros.
3-) Neste caso temos 3 registros ou seja, 6 colunas. Segue exemplo dos dados:

+-------------------------------------------+
|            AC-001-REU                     |
+--------------------+----------------------+
| Local              | Sala de Reunião      |
| Em operacao        | Sim                  |
| Capacidade (BTU/h) | 36.000               |
| Fabricante         | TOP                  |
|                    |                      |
| Tipo               | Piso Teto - Inverter |
| Tensão (V)         | 217                  |
| Corrente R (A)     | 27,4                 |
| Corrente S (A)     | 27,0                 |
| Corrente T (A)     | 27,8                 |
| Observações        |                      |
| Inspecionada em    | 23/10/2023           |
| Proxima inspecao   | 23/11/2023           |
+-------------------------------------------+

Transcrição do vídeo: 
0:00 - Quem nunca precisou importar uma base meio bagunçada dentro do Power BI? Na verdade,
0:06 - aqui nessa base, exemplo hoje nós temos uma planilha que contém inspeções de equipamentos de ar condicionado,
0:13 - cujas tags estão aqui nessa primeira linha, inclusive são células mescladas que é muito comum encontrar por aí.
0:19 - Tá bom. A minha estrutura é o seguinte eu tenho uma dupla de colunas
0:24 - que define campo e valor para cada uma dessas três expressões. Aqui.
0:29 - Note que eu tenho algumas lacunas aqui que não tem campos nem valores, algumas completas, e aqui eu não tenho valor.
0:37 - E aqui eu tenho o valor, mas não tenho o campo que identifica. Como se não bastasse, eu não tenho uma ordem 100%
0:44 - definida nesses campos aqui, ok? O local para as três pessoas aqui em operação e aqui está faltando
0:50 - um campo que não pode ser em operação porque tem um valor de três oito sete V. E aqui,
0:55 - por exemplo, eu tenho fabricante capacidade em operação. Além disso, eu tenho que me atentar que eu posso ter campos repetidos
1:03 - e eu não posso ter. Tem que ser campos distintos. Por exemplo, que tenho um local em operação aqui em cima, mas eu tenho que embaixo também, tá?
1:10 - Então eu tenho que me atentar para isso. Então a ideia é importar esses dados e extrair os dados dessa planilha,
1:19 - fazer o tratamento e as transformações não querem importar dentro do Power BI.
1:25 - Essa tabela aqui nesse formato, devidamente configurado e tratada,
1:30 - onde cada linha é uma expressão diferente, com seus campos, com suas colunas
1:36 - devidamente equipadas para que nós consigamos fazer nossas análises dentro do PMR.
1:43 - Hoje nós iremos tratar sobre listas sobre o recurso de listas dentro do Power Query utilizando a linguagem M avançada
1:51 - aliada a lógica que nós iremos utilizar para fazer esse tratamento que eu vou explicar para vocês passo a passo.
1:59 - Bora comigo? Então utilizando esse mesmo arquivo para nós ganharmos tempo, eu vou direto para o query.
2:11 - E aqui ele está reclamando que o arquivo está aberto, que vou fechar, que o Excel pode dar um refresh.
2:21 - Ok, eu vou excluir esse cara que ok.
2:27 - Então eu tenho que só o parâmetro com o endereço da minha pasta de trabalho do Excel, ok?
2:35 - Então vou começar aqui clicando no botão direito com uma consulta nula. Blank Query
2:43 - E aqui eu quero um File.Contents De quem? No meu arquivo
2:52 - ele já detectou que é um Excel. Eu posso pegar esse parâmetro aqui que está em null e trocar para true,
2:59 - que assim ele vai elevar os cabeçalho na minha planilha. Tá bom?
3:04 - Ahn. Os meus dados estão aqui em data, então eu posso clicar aqui. E eu já acessei a minha base conforme eu mostrei para vocês lá.
3:14 - Só que ele criou essa etapa navigation aqui que eu acho que ele suja bastante código né?
3:19 - Então eu posso fazer o seguinte e uma dica para vocês posso copiar essa última etapa aqui que ele está fazendo a navegação
3:24 - ali pelo record, pelo e pela coluna, tá? Então copiei esse cara.
3:30 - Eu venho aqui em editor avançado e colo aqui no final, tá? Como que no final vou apagar aqui
3:38 - essa minha source que eu vou chama de sheet, tá? E aqui vou em
3:48 - sheet planilha em inglês. Tá, aí não mudou nada. Eu fiquei com uma etapa só e totalmente configurada, ok?
3:57 - Então qual que vai ser a lógica que eu escolhi para fazer esse tratamento? Não usam aqui pra explicar pra vocês?
4:04 - Eu tenho três listas principais aqui, a primeira lista e são os nomes desses meus equipamentos,
4:13 - as tags que estão aqui nos nomes das colunas dessa tabela. Eu ainda tenho os campos
4:19 - um pouco aqui, uma cor em vermelho que estão aqui. Esses são os meus campos, tá?
4:29 - E ainda eu tenho o outro tipo de listas, que são os meus valores.
4:34 - Quem é a ideia final?
4:42 - O que eu preciso fazer é o seguinte eu preciso gerar três linhas numa tabela, que são os meus
4:49 - valores. Ok? Aqui embaixo eu preciso
4:56 - das minhas três tags, que são os equipamentos aqui do lado
5:02 - e eu ainda preciso dos nomes dos campos e será o nome das colunas dessa tabela.
5:10 - E aqui eu não coloquei, mas eu vou colocar aqui em vermelhinho, porque esse aqui a gente vai ter que tá na mão, porque o campo,
5:17 - nome ou tag do equipamento não está aqui, não está nesse campo, mas eu vou ter que fazer isso aqui.
5:23 - Isso aqui é o objeto final e a nossa tabela foto expressões que a gente vai importar
5:30 - para o Power BI, ok? Então ok, vamos lá.
5:35 - A primeira coisa que a gente vai pegar aqui é uma lista com os nomes desses equipamentos, com as tags, Tá,
5:44 - Então eu posso vim aqui em FX e hoje vai ser avançado mesmo. O pessoal bastante código aqui
5:52 - nessa nesse vídeo. Então vamos lá. Eu tenho a função zinha chamada table
6:00 - Table.ColumnNames que extrai os nomes, dá só o
6:05 - retorno de coluna as list inteiro. Vai retornar uma lista dos nomes dessa tabela, ok?
6:13 - Perfeito. Só que também veio a outra coluna. Lembra que eu mostrei que nós tínhamos células mescladas?
6:21 - Então, esse carinha ele vale para esses, para esses, para isso, o que importa pra nós?
6:26 - Eu tenho dois critérios de seleção aqui dessa lista, logo, ou eu escolho se começa com AC
6:33 - ou se não começa com col de columns, né? Como eu já o preenchimento ali daquela tabela já não está muito ok, né?
6:42 - Então é mais fácil definir que eu não quero os itens que não começam com col um que eu faço isso.
6:48 - Eu posso usar essa mesma linha que eu vou fazer uma list select.
6:55 - Ele pede uma lista que é minha lista esse próprio Table.ColumnNames agora, eu vou usar o argumento.
7:01 - each porque para cada item eu quero que o Text.StartsWith
7:08 - talvez você nunca deve ter ouvido falar dessa função, mas ela ela pega de cada item
7:15 - e compara se começa com um texto ali, então eu quero de cada item. Por isso underscore ou underline
7:23 - que começa com col e aqui ele vai trazer o col. Só que eu quero o inverso disso, então inverter
7:31 - eu vou usar o argumento not ali na frente, ok? Já tenho a minha lista com as tags, então vou renomear aqui
7:39 - esse cara para tags. Quem aí eu posso importar
7:45 - fx pra mim numa próxima etapa? Só que essa próxima etapa eu não vou mais mexer com tags, já está pronto,
7:52 - eu vou lá. Voltei pra minha planilha, voltei pro meu sheet, tá?
7:58 - Então por isso que eu escrevi igual ao sheet e agora eu tenho uma funçãozinha pra eu quebrar esses cara em listas.
8:04 - Tá, eu vou quebrar em seis listas porque eu tenho seis colunas, tá? Então a função é a Table.ToColumns
8:14 - que ele pede um único argumento que é uma tabela. Minha tabela sheet então quebrou em seis listas aqui.
8:21 - Se eu clicar aqui ao lado a gente pode ver essas colunas abertas aqui, cada uma com os seus campos em ordem diferentes.
8:29 - O que nós sabemos aqui é que eu tenho nessa primeira lista chaves ou Campos.
8:36 - Aí eu pulo uma. Vou ter campos e campos alternadamente. Eu tenho campos e valores e isso é o único padrão que nós temos aqui
8:44 - e que eu posso chamar essa etapa aqui de lists
8:52 - A minha é minha lista principal, ok? Agora, o que eu preciso fazer?
8:57 - Eu preciso selecionar alternadamente esses campos. Tá, eu poderia pegar a posição, dividir por dois,
9:05 - pegar um módulo e selecionar, mas ter uma função mais fácil. Para isso eu deixo aqui uma outra tela para mostrar pra vocês
9:12 - que é a list alternate, tá? Então ela pega uma lista e ela vai selecionar alternadamente
9:19 - de acordo com os parâmetros que eu vou colocar aqui. Então olha só o exemplo que lhe deu. Ele fez uma listinha de 1 a 10 e aqui ele colocou virgula 1,1, 1,
9:26 - então ele pulou o primeiro, pegou o segundo, pulou mais um e esse aqui resolve pra eu pegar os valores né?
9:33 - Agora o exemplo três aqui ele faz justamente ele coloca um argumento a mais que daí ele pega os ímpares um, três, cinco, sete.
9:42 - Tá, então eu vou usar justamente esse código aqui
9:48 - para nós extrairmos os dados ali. Tá bom, então eu vou. Vou começar pelo exemplo três e depois o exemplo dois.
9:56 - Tá? Então FX, eu quero pegar aqui List alternante.
10:03 - Ele pede uma lista que é Alice. E aí eu vi que o primeiro exemplo é assim
10:11 - um e um que você mantém, um que você pula e é de quanto em quanto que eu só passo.
10:17 - Esse é o resumo aqui. Eu tenho as chaves
10:23 - ou campos, então eu vou nomear esse cara que como fields
10:28 - são os nomes das minhas colunas, tá? Agora a próxima etapa
10:36 - é o List Alternate. Qual é a minha lista list que é o original?
10:42 - Tá nesses e aqui é só um e um que é diferente.
10:50 - Agora sim, eu tenho meus valores. Tá? Esse cara aqui é meu guru
10:59 - perfeito. Então eu juntei minhas tags, tem meus tios e tem meus velhos. Então agora eu vou, eu vou unir tudo isso em uma única tabela
11:08 - através de uma nova função que ela se chama Tabl.FromColumns
11:14 - Como está no primeiro momento, nós usamos Table.ToColumns pra quebrar as listas.
11:21 - Agora a gente tratou, selecionou e agora a gente vai unir esses caras, tá?
11:28 - E aí eu tenho que passar dentro de uma lista, por isso vou abrir e fechar chaves, tá?
11:33 - Quem que é minha primeira lista? Tags são os nomes dos equipamentos.
11:38 - Depois eu tenho fields, que são os campos, os nomes
11:43 - da coluna, das colunas da minha tabela e valores que são os valores.
11:49 - Tá bom e já veio ok? O nome, a chave, o campo e o valor,
11:57 - mas eu posso dar um já renomear esses caras aqui mesmo? Tá, veio um nome genérico desses como estão no virgula
12:04 - e aqui ele já falou columns as any Quando ele fala ele geralmente é uma lista ali.
12:10 - Então você vou digitar o nome dessas colunas que eu quero aqui,
12:15 - então vou colocar tag field
12:23 - e aqui value Veja só, já
12:30 - fiz aqui a renomeação, vamos renomear essa etapa aqui
12:35 - para te chamar aqui
12:40 - tbFromColumns
12:46 - tá beleza? Agora você pode pensar que seria fácil eu só expandisse
12:54 - cara no Novas Linhas e depois aqui para novas linhas. E aí vai dar certo.
12:59 - Não vai dar certo porque ele vai repetir todos os campos para todos os campos e está errado. Tá?
13:07 - Agora nós vamos precisar trabalhar isso aqui. Só que lembra na demonstração no início do vídeo,
13:14 - que aqui nos campos tem alguns campos que estão vazios e eu ainda tenho campos que estão
13:22 - repetidos, por exemplo, o local, impressão, local, impressão. Então eu tenho que tratar isso.
13:28 - Eu não posso ter um campo nulo, por exemplo, nulo.
13:33 - E se eu tiver um valor aqui, o que aquele valor único vai encaixar? Esse valor? Então eu tenho que encontrar
13:40 - as posições onde essa lista não é nula e onde ela é única
13:47 - para que eu também filtre do outro lado no valor baseado no campo.
13:53 - Então vamos lá. Um puxa um pouquinho pra cá, para ver se abre um espaço que na demonstração
14:00 - já está minimizado. Vamos lá. E de colo vou adicionar uma custom coluna que
14:07 - é essa coluna personalizada. Eu vou chamar de null
14:14 - positivos, tá, que são as posições nulas ali tá.
14:22 - E aí eu vou usar uma função de lista List.PositionOf tá?
14:28 - Aí ele pede um parâmetro de uma lista. Qual lista a lista?
14:33 - Fields Eu Quando eu estou adicionando uma coluna, eu estou trabalhando que nesse contexto que daquela linha Tá, então eu to olhando horizontalmente aqui.
14:44 - Tudo o que eu fizer vou fazer para cada uma dessas linhas. Então por isso da necessidade inclusive de juntar numa tabela,
14:51 - então vou pegar aqui Field List Position e qual o valor que eu quero encontrar?
14:59 - Eu quero encontrar os números, por isso no campo eu tenho um terceiro parâmetro,
15:05 - que é a ocorrência. Quantas linhas?
15:11 - Quantos itens você quer varrer? Eu quero todos trabalhem todos, porque posso ter mais de uma nula,
15:17 - então eu posso fazer o seguinte eu quero todos. E como cada uma tem um tamanho de lista diferente,
15:24 - eu vou retornar o tamanho dessa lista que é a contagem nessa lista, então List.Count
15:31 - O próprio field que fechei parênteses ali, fechei aqui.

   Solução Criação de Coluna Personalizada AddNullPositions, fórmula: [NullPositions] = List.PositionOf([Filed], null, List.Count([Field]))
   - List.PositionOf - Parametros [Lista], [argumento a ser encontrado], [quantidade de vezes]
   - List.Count - Contagem total do [argumento a ser encontrado]

15:38 - Vamos ver o retorno. O retorno vai ser uma lista com o número 4, posição quatro aqui a posição 12 e aqui a posição um e nove
15:49 - que eu estou falando. Posição um e nove. Essa é a posição zero. Essa posição. Beleza, Aí encontrou um nulo 1123456789, encontrou outro nulo.
16:02 - Se eu não especifico isso, essa contagem já ia dá algum problema. Ok,
16:09 - então eu encontrei as posições nulas. Agora que eu preciso fazer e tratar isso repetido aqui
16:17 - que eu tenho o local em operação local de operação e pra isso eu vou fazer uma cópia aqui fora.
16:23 - Mas antes disso, aqui nas etapas eu gosto de dar nomes semântico ali. Tá, Então vou fazer add
16:36 - null positions Então adicionei a coluna no posição um tratar aqui.
16:43 - Fora isso que eu estou querendo dizer para vocês, eu vou fazer uma nova query
16:49 - e vou gerar uma lista. Como eu posso gerar uma lista que eu simplesmente abro chaves e vou digitando os itens?
16:55 - Então um, dois, três vou repetir o número um, vou colocar dez, 19 pode ser
17:03 - dois. Ahn 06h01 de novo, tá?
17:09 - Gerei uma lista aleatória de números aí, ok? Inclusive vou renomear esse carinha aqui para
17:18 - lista. Lista, ok?
17:25 - Perfeito. O que eu quero identificar aqui? O número um.
17:31 - Ele está se repetindo algumas vezes. Eu quero a posição do número um,
17:37 - a mínima posição desse número. Ou seja, eu não quero. Eu quero extrair as posições que não são
17:46 - a primeira aparição daquele valor igual o dois. Ele ter retornado só pra mim. A posição dele como retorna a posição de uma lista,
17:56 - então FX Agora eu vou retornar todas as posições de list positions de uma lista.
18:04 - Não é Position of Olá. Posição de 0 a 7 Sempre comece do zero, tá?
18:12 - Como cuidar dessa pegadinha aí? Então, esse carinha aqui são as minhas posições,
18:19 - ok? Então agora lembre que eu agrupei duas colunas de uma tabela.
18:26 - Eu preciso fazer a mesma coisa que eu estou fazendo essa filtragem. Então a minha próxima etapa é Table
18:34 - from Columns. Ele pede uma lista que é a minha primeira lista, a list
18:42 - e minha segunda lista e positions.
18:48 - Nós podemos dar nomes já. Então vou colocar aqui.
18:53 - Vale o valor e posição e o nome da coluna.
18:59 - Só que aqui é texto e passa dentro de aspas o nome dessas colunas dessa tabelinha aí,
19:07 - mas não tem o valor e a posição dela como se fosse o índice, tá como se fosse, não é?
19:14 - Eu só gerei de uma outra forma, ok? Então esse cara que é minha tribo
19:22 - agora, basta eu agrupar essa tabela pelo mínimo dessa posição,
19:27 - agrupar os valores pelo mínimo dessa posição. Aí eu posso usar até interface
19:33 - gráfica, então eu quero agrupar. Vai ali a minha nova coluna, eu vou chamar de posição position
19:42 - e aqui eu quero o mínimo da minha posição. Veja bem. Oh, então.
19:47 - Então se eu estou agrupando pelo mínimo, eu só vou ter uma ocorrência para cada valor. Eu estou removendo as duplicadas aqui,
19:54 - mas eu não posso remover somente as duplicadas, porque eu tenho que usar posição para filtrar tanto os filtros como os valores.
20:00 - Então zero um um dois quatro seis Ok. Então esse cara que eu vou chamar mim
20:08 - position inclusive, na verdade eu posso já economizar isso que eu vou chamar de positions
20:17 - que eu vou transformar eu já tenho, já tem, então vou colocar que output output é a minha saída.
20:25 - A minha saída não me interessa e velho e sim a essa lista aqui. Então eu posso transformar essa tabela numa lista,
20:32 - simplesmente abrindo colchetes e invocando a coluna ali. Por isso que eu não me preocupei em tipar coluna porque vai virar uma lista.
20:39 - Tá lá uma lista. Então eu recebi uma lista de valores e eu retornei a posição
20:48 - do menor valor de cada uma. A posição de cada um dos valores tá removendo os distintos.
20:55 - Então é isso que eu preciso, tá? Isso aqui vai virar uma função, unzinho também.
21:00 - Aqui vou transformar esse cara numa função, tá? Então como transforma esse cara numa função?
21:06 - Posso pegar aqui e apertar
21:13 - control shift, mais mais ele dá um zoom aqui para vocês, Então eu vou falar aqui list
21:19 - essa list e vai me entregar uma lista. Então é uma entrada.
21:24 - Ele recebe uma lista de nome lista e me entrega
21:29 - uma lista, uma saída de lista. E agora essa lista aqui não faz mais sentido
21:35 - porque eu chumbei ela na mão. Tá pronto aqui. Perfeito.
21:43 - Vamos fazer aqui o transformou numa função. Tá,
21:48 - eu vou copiar esse carinha Todos carinha, dono que voltemos para nossa,
21:56 - para nossa tabela. E agora eu vou encontrar as posições dos caras que são válidos aqui
22:02 - são distintos para remover essa duplicada aí. Então é com estão com
22:09 - eu vou chamar aqui de in distinct positions.
22:16 - São as posições distintas e positions
22:22 - e vou colar aquela minha função aqui. Tá bom, só que assim dessa forma não funciona.
22:29 - Eu preciso fazer definir um nome para essa função, invocar ela aqui, tá?
22:34 - Então vamos lá, Vou fazer um let e vou chamar aqui de Get DISTINCT
22:45 - Positions, que é igual a essa função
22:51 - que faz tudo isso aqui, tá? Só que essa função só quer fazer com ela.
22:57 - Recebe uma lista. Agora que eu vou invocar ela, né? Então get
23:02 - distinct positions e aqui eu tenho que passar. Qual é a lista que eu declarei? É a minha lista referência e filtros.
23:11 - Posso fechar e dá ok? Oh, agora eu tenho a minha lista dos extintos, tá?
23:18 - Veja bem, olha a diferença aqui E aqui tem menos itens, tá?
23:25 - Então ele removeu O910 desse cara que é esses carinhas aqui que estão distinct.
23:33 - E agora vamos renomear aqui para
23:39 - Add distinct positions.
23:47 - Agora que eu preciso fazer o seguinte, eu preciso agora finalizar as minhas posições
23:52 - para eu passar tanto pro field como para o valor com as linhas que eu vou importar ou não, tá?
24:00 - Então eu posso, a partir das linhas distintas, remover as nulas e aí eu vou ter as válidas.
24:08 - Então vamos lá adicionar uma questão como e eu vou chamar aqui essa nova coluna de
24:15 - positions? Então, já que a minha é o índice
24:23 - que eu quero final, então positivas e eu vou usar uma outra função de lista
24:29 - aqui que a list remove matching itens, então vai fazer a exceção, tá?
24:35 - Então ele vai pegar da primeira lista que é, perdão, distinct Positions,
24:42 - onde tem todas as posições distintas e vai remover as duas.
24:49 - Simples assim. E agora eu tenho as válidas. Ok, então ele removeu as nulas e as duplicadas.
24:57 - Então vamos renomear aqui para bad positions.
25:05 - Perfeito! E agora eu tenho minha referência prontinha para filtrar tanto a Field como a Values E depois nós agrupamos isso.
25:12 - Perfeito! Então vamos lá, vamos tratar primeiro field. Então, como
25:19 - eu estou fazendo bem em etapas para demonstrar para vocês, a gente poderia fazer isso numa etapa só,
25:25 - mas ia ficar muito complicado e a gente também não vai ter perda de performance fazendo assim. Tá?
25:32 - Vamos lá, vou pegar que o Fields vou chamar de ok,
25:38 - tá ok que é o final. Então o seguinte pega só essa,
25:44 - essa ideia, eu vou fazer uma transformação de lista,
25:49 - por isso a lista Transform. Olha quantas soluções de lista nós estamos usando que hoje tá?
25:55 - Então List Transform eu quero transformar cada lista.
26:02 - Eu vou transformar uma lista que é a Positions, que contem o índice ali daquele cara
26:10 - onde está um de cada
26:15 - valor do field. Então Field. E agora que pelo lugar and score dentro de chaves,
26:22 - Então o que eu estou fazendo aqui? Eu estou usando o índice do positions
26:28 - para filtrar a linha do field para filtrar linha do feed.
26:34 - Só que ainda falta um detalhe que vou causar aqui. Vai dar um erro, tá?
26:39 - Porque ele não consegue acessar aqui o Fields. Tá,
26:46 - eu preciso jogar esse field dentro de uma variável para ele entender como uma lista, tá?
26:52 - Então vamos voltar aqui. É isso, a gente usa o parâmetro let in aqui de forma fácil,
27:00 - então vou pegar aqui, eu vou chamar.
27:06 - Na verdade tem um outro detalhe que está faltando e eu uso argumento.
27:12 - Isso aqui porque ele vai fazer iteração para cada item daquela lista. Ainda vai dar erro,
27:18 - vai dar erro interno, não vai dar erro na cabeça, mas vai evitar melhor porque ele não conseguiu filtrar ali.
27:25 - Então por isso que eu vou gerar um let aqui,
27:30 - então gerar aqui let em e dentro desse let
27:38 - eu vou fazer o seguinte vou chamar de Field,
27:45 - é igual coluna Field
27:52 - e aqui esse filtro vem pra cá. Quem?
27:59 - Agora sim, eu tenho a minha lista filtrada, sem nenhum nulo, sem repetidos,
28:07 - cada um no seu quadrado, ok? E esse cara que eu vou chamar de
28:14 - Bad Fields ok,
28:19 - legal. Ahn, vamos fazer isso também para os valores, Tá, Mas antes disso tem
28:29 - um detalhe que a gente pode já aproveitar aqui. Tá vendo que eu tenho todos os
28:36 - os nomes das minhas colunas, todos os meus campos? Aqui tá faltando um campo aqui que é a tag do equipamento.
28:45 - Esse é o valor do equipamento, mas falta o título desse campo, então eu posso que na última etapa
28:52 - fazer uma concatenação de listas e acrescentar ele ali no começo inclusive. Então eu vou falou de lista, abre, fecha chaves.
29:01 - Então eu quero o valor tag concatenado com aquele com a lista que eu gerei aqui em cima.
29:09 - Agora veja lá, pegue e os campos. Legal,
29:14 - vamos fazer agora semelhante para os valores, para os valores
29:20 - e não esquecer de captar a tag que está aqui. Legal,
29:26 - Então vamos lá de colocamos no colo e vou trazer aqui value ok?
29:34 - Eu já vi que eu preciso definir uma variável chamado de value que referencia a coluna value
29:42 - e vou dar um in porque agora eu vou fazer uma concatenação
29:48 - de quem da minha coluna tag que tem lá dentro dentro do chaves é claro,
29:55 - porque eu vou concatenar listas, tá ali e
30:01 - é agora sim, eu vou fazer o meu list transform
30:09 - na minha positions, onde cada valor da variável ali
30:16 - é filtrada pelo posição, por cada item dessa lista posição que são os índices dos itens, tá?
30:24 - Então vamos lá. Vamos ver se deu ok
30:30 - Acho que eu peguei alguma coisa errada ali. A peguei sim,
30:37 - que eu fiz aqui e pegue que não vale ler não.
30:43 - Aí agora sim, eu já importei aqui a tag aqui dentro,
30:48 - então tudo o que eu preciso está aqui nessas duas colunas, tá?
30:54 - Então vamos renomear esse cara para addValuesOk
31:01 - Agora a próxima etapa vai ser gerar uma tabela com esses caras para cada linha.
31:07 - Tá bom? Então vamos lá AddColumn Custom column
31:12 - E aqui eu vou chamar essa essa coluna de tables,
31:20 - E aí eu posso usar o construtor de tabela com hashtag Tag table tá
31:25 - no primeiro campo. Aqui eu tenho que especificar uma lista dos nomes e qual é a lista dos nomes dessas colunas fields.
31:32 - Ok, tá. E depois eu tenho uma lista dos valores que é quem value ok
31:38 - mas como eu tenho que fazer um gerar para cada campo, então esse carinha aqui vai dentro de uma lista,
31:47 - dentro de uma lista e fechei aqui. Vamos ver o que gerou
31:53 - uma tabelinha para cada linha. Claro que algumas tem mais campos, outras tem menos campos.
32:00 - Tá vendo? Ô, se tem alguns mais campos, porque nós fizemos o tratamento
32:06 - e esse foi inclusive o objetivo fazer o tratamento.
32:12 - Quando você não tem todos os campos corrente, RS Em cade a T? não existe.
32:17 - E quando tem duplicados também, tá? Então esse que eu vou chamar de add
32:27 - Extract Table está porque nós extraímos as tabelas elas Então tudo o que eu preciso tá aqui, tá?
32:35 - E eu poderia clicar e expandir pra cá, mas isso eu não vou fazer porque
32:42 - existe uma forma melhor de fazer mais segura, porque nem todas as tabelas tem as mesmas colunas.
32:48 - Entenderam? Então eu vou combinar essa coluna primeiro eu preciso transformar ela para lista, tá?
32:55 - Uma transforma esse cara para uma lista. Então essa etapa anterior eu vou abrir colchetes aqui.
33:01 - Nós já fizemos isso aqui hoje e vou colocar aqui. Há tempos gerei uma lista de tabelas
33:08 - e essa etapa aqui é table,
33:15 - como que aliste as tribos. Na verdade existe of tribos
33:20 - e agora basta combinar essa lista, tá? Qual função
33:25 - table combine? E ela é muito mais segura para, caso estiver faltando algum campo,
33:32 - essas coisas. Então ela pede uma lista de tabelas e é a minha etapa. listOfTables
33:39 - E aqui, ok, finalizou. Olha o tratamento que que ficou. Tá, eu vou só renomear esse cara pra chamar de
33:54 - console consolidated consolidated tbs
34:02 - e agora só falta tipo os dados, tá? Então eu vou selecionar todos que são texto aqui no texto.
34:08 - Isso que texto, texto transform, tipo do dado e texto.
34:16 - Vou aproveitar que aqui está com data, já vou colocar em leite esse cara que.
34:22 - Numérico numérico numérico uma tensão numérica BT.
34:28 - O numérico também é a gente pode vim aqui em decimal número
34:35 - que está finalizado. Pessoal, posso excluir aqui essa função zip
34:42 - que eu fiz só pra criar ali, aqui essa etapa eu só vou remover
34:49 - os espaços, escrever camelCase
34:55 - e aqui eu vou chamar de fact
35:02 - inspection. São expressões de máquina condicional, tá
35:08 - beleza? Um Fechar e aplicar
35:19 - e não mudou nada, tá? Só mudou que voltou aqui pro espaço de short date Mudou, digamos, do início do vídeo,
35:26 - mas nós tratamos os dados novamente, tá?
35:31 - E todo esse tratamento, apesar de complexo, ele prevê para que nós façamos
35:39 - o que a gente pode fazer, seja prova de erro ali no tratamento por exemplo, se eu vier aqui, deixa eu pegar o arquivo novamente.
35:49 - Eu vou pegar esse novo arquivo e vou acrescentar
35:55 - uma coluna aqui ao lado, tá? E vou chamar esse cara de quatro,
36:01 - tá de quatro, fica lá no setor. Ahn, da manutenção então.
36:08 - Manut Local que chama de manut.
36:13 - E aí o cara que preencheu lá se baseou no item do lado de cá e não colocou nada aqui por exemplo,
36:20 - só preencheu o local aqui, deixou um monte de valores, tá? Oh,
36:26 - tem um monte de valores e só tem um local aqui, né? Vou fechar, vou atualizar aqui,
36:33 - ele vai acrescentar uma linha, mas só com o local, tá? Cadê o atualizar
36:40 - Refresh? Não deu erro, mas apareceu manut tá?
36:47 - Então isso aqui está bem legal. Inclusive se ele vier aqui, vamos abrir o arquivo de novo e fazer uma.
36:56 - Vou incluir uma linha aqui de um dado nada a ver. Vou colocar aqui. Quando o equipamento, por exemplo cor do equipamento
37:06 - e vou escrever aqui azul, tá? Vamos ver o que vai acontecer lá.
37:13 - A refresh. Aí apareceu uma coluna cor do equipamento azul.
37:21 - Afetou os outros? Não. Então esse tratamento aqui, pessoal, ele está totalmente in.
37:28 - Como posso dizer? Ele está a prova de erro. Poka yoke, mesmo
37:34 - Pessoal, gostaria de pedir o vosso like pra esse vídeo, tá?
37:40 - Se você não é inscrito no canal, então se inscreve no canal e ative as notificações. Mais da metade dos meus escritos não tem as notificações
37:49 - ativadas, então você provavelmente não fica sabendo dos meus novos vídeos, então ativa lá o sininho, não perde também Vou deixar aqui
37:58 - as minhas redes sociais passando aqui embaixo. Me adiciona lá, me segue que as vezes eu sempre posto
38:05 - material útil pra comunidade e o que eu tinha pra passar para vocês era tudo isso.
38:12 - Espero que vocês. O material eu vou deixar publicado no link no meu LinkedIn não, no meu GitHub.
38:20 - Você vai poder baixar tanto o código que eu vou comentar ele bonitinho. Cada linha é com essa base flexível para que vocês possam treinar
38:28 - e entender tudo o que foi feito aqui, beleza? Forte abraço e até o próximo vídeo. - 

# Tratamento de base com M avançado
> Exemplo: Equipamentos de ar condicionado <br>
> Atualizado em 2024-03-02

## Descrição
O código abaixo trata uma base extremamente bagunçada e que cresce para a direita, porém apresenta a carcaterística de possuir chave valor.
Neste código, foi empregado o código sem hard code ou seja sem referência de colunas da base. Além disso este códgo tem a capacidade de aceitar novas colunas (equipamentos) sem a necessidade de manutenção.<br>
> Baixe aqui o arquivo base para o tratamento: [Link](https://github.com/alisonpezzott/powerbi/blob/main/power-query-m/etlExamples/2024-03-04-fact_inspections/BaseDados.xlsx) <br>
> Acesse aqui o vídeo sobre este case: [Video](https://youtu.be/hHNNPbg0v9M)
*/
let
   //Extrai os dados da planilha cujo endereço está no parâmetro arquivo
   sheet = Excel.Workbook(File.Contents(Arquivo), true, true)
      {[Item = "Planilha1", Kind = "Sheet"]}
      [Data], 
   
   //Extrai a lista com as tags a partir dos nomes das colunas 
   tags = List.Select(Table.ColumnNames(sheet), each not Text.StartsWith(_, "Col")),
   
   //Extrai lista a partir das colunas
   lists = Table.ToColumns(sheet),
   
   //Seleciona os itens que correpondem aos campos
   fields = List.Alternate(lists, 1, 1, 1),
   
   //Seleciona os itens que correspondem aos valores
   values = List.Alternate(lists, 1, 1),
   
   //Gera uma tabela a partir das listas tags, fields e values
   tbFromColumns = Table.FromColumns(
      {tags, fields, values},
      {"Tag", "Field", "Value"}
   ),
   
   //Adiciona uma coluna com as posições nulas dos campos
   addNullPositions = Table.AddColumn(
      tbFromColumns,
      "NullPositions",
      each List.PositionOf([Field], null, List.Count([Field]))
   ),
   
   //Adiciona uma coluna com as posições distintas
   addDistinctPositions = Table.AddColumn(
      addNullPositions,
      "DistinctPositions",
      each
         let
            getDistinctPositions = (list as list) as list =>
               let
                  positions = List.Positions(list),
                  table = Table.FromColumns(
                        {list, positions},
                        {"Value", "Position"}
                  ),
                  output = Table.Group(
                        table,
                        {"Value"},
                        {{"Position", each List.Min([Position]), type number}}
                  )[Position]
               in
                  output
         in
            getDistinctPositions([Field])
   ),
   
   //Adiciona uma coluna contendo apenas as posições válidas que foi gerada
   //excluindo da lista das posições distintas, a lista das posições nulas.
   addPositions = Table.AddColumn(
      addDistinctPositions,
      "Positions",
      each List.RemoveMatchingItems([DistinctPositions], [NullPositions])
   ),
   
   //Adiciona uma coluna com os campos distintos e não nulos
   addFieldsOk = Table.AddColumn(
      addPositions,
      "FieldsOk",
      each
         let
            field = [Field]
         in
            {"Tag"} & List.Transform([Positions], each field{_})
   ),
   
   //Adiciona uma coluna com os valores distintos e não nulos
   addValuesOk = Table.AddColumn(
      addFieldsOk,
      "ValueOk",
      each
         let
            value = [Value]
         in
            {[Tag]} & List.Transform([Positions], each value{_})
   ),
   
   //Adiciona uma coluna contendo as tabelas geradas a partir dos campos e valores
   addExtractTables = Table.AddColumn(
      addValuesOk,
      "Tables",
      each #table([FieldsOk], {[ValueOk]})
   ),
   
   //Transforma a coluna Tables em uma lista de tabelas
   listOfTables = addExtractTables[Tables],
   
   //Consolida a lista de tabelas em uma única tabela
   consolidatedTables = Table.Combine(listOfTables),
   
   //Altera os tipos das colunas da tabela
   chagedType = Table.TransformColumnTypes(
      consolidatedTables,
      {
         {"Tag", type text},
         {"Local", type text},
         {"Em operação", type text},
         {"Tipo", type text},
         {"Fabricante", type text},
         {"Observações", type text},
         {"Inspecionado em", type date},
         {"Próxima inspeção", type date},
         {"Setpoint (°C)", type number},
         {"Corrente T (A)", type number},
         {"Corrente S (A)", type number},
         {"Corrente R (A)", type number},
         {"Tensão (V)", type number},
         {"Capacidade(BTU/h)", type number}
      }
   )
in
   chagedType