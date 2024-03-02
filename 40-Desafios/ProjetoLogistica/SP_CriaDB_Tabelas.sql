/*
Data....: 13/04/2023
Autor...: ROGERIIO TONINI
Objetivo: Criação de DB e Tabelas diversas. 
			 Esta SP poderá ser utilizada em qualquer implantação de sistema.
*/
USE [master]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[SP_Cria_Database_Tabelas]
AS
BEGIN
	-- Declaração das variáveis
	DECLARE	@ARQLOGICO	 NVARCHAR(20),			-- Nome Arquivo lógico
				@PASTA			 NVARCHAR(80),			-- Pasta onde será criado o Bando de Dados
				@DATABASE		 NVARCHAR(20),			-- Nome do Banco de Dados
				@CMD_SQL		 NVARCHAR(MAX),			-- Variável que contém comando a ser executado

            @QTDTABELAS		 INT,					-- Quantidade Total de Tabelas a serem criadas
			   @NUM_TABELA		 INT,					-- Numero da Tabela
				@TB_NOME			 NVARCHAR(30),		-- Nome da Tabela a ser criada
				@PK_NOME			 NVARCHAR(80),		-- Nome da Chave da Tabela a ser criada
				@NOME_DEF_CAMPO NVARCHAR(MAX),		-- Definição dos Campos na Tabela Virtual @LSTCAMPOS
				@TB_CONSTRAINT  NVARCHAR(MAX)

	-- Criação do Bando de Dados
	SET @ARQLOGICO = 'GerMultasFrota'
	SET @PASTA     = 'D:\SGBD\MS-SQL-Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\'
	SET @DATABASE  = 'DB_GerMultasFrota'

	IF (NOT EXISTS(SELECT TOP(1) * FROM sys.databases WHERE [name] = @DATABASE))
		BEGIN
			SET @CMD_SQL = 
					'CREATE DATABASE ' + @DATABASE + 	' ON 
					( NAME = ''' + @ARQLOGICO + '_Data''
					, FILENAME = ''' + @PASTA + @DATABASE + '.mdf''
					, SIZE = 5MB
					, MAXSIZE = 25MB
					, FILEGROWTH = 15% )
				LOG ON
					( NAME = ''' + @ARQLOGICO +  + '_Log''
					, FILENAME = ''' + @PASTA + @DATABASE + '_log.ldf''
					, SIZE = 5MB
					, MAXSIZE = 25MB
					, FILEGROWTH = 5MB )'
			
			EXEC sp_executesql @CMD_SQL		-- Executa o comando armazenado na var. @COMANDO 
			IF @@ERROR = 0
				PRINT 'Banco de dados: ' + @DATABASE + ' criado com sucesso!'
			ELSE
				BEGIN
					PRINT 'NÃO foi possível criar o Banco de dados: ' + @DATABASE + '. Favor verificar com o Responsável.'
					RETURN 99
				END
		END
	ELSE
		PRINT 'Banco de dados: ' + @DATABASE + ' já EXISTE!'

	-- Relação das Tabelas: Virtual e no DB --
	DECLARE @LST_TABELAS TABLE(ID_Tabela int, NomeTabela VARCHAR(60), NomeIndice VARCHAR(100))
	INSERT INTO @LST_TABELAS VALUES
		( 1, 'T_Empresa',							 'PK_T_Empresa_NUM_INDEX'),
		( 2, 'T_Empresa_Atividades',			 'PK_T_Empresa_Atividades_NUM_INDEX'),
		( 3, 'T_Funcionarios',					 'PK_T_Funcionarios_NUM_INDEX'),
		( 4, 'T_Funcionarios_Fones',			 'PK_T_Funcionarios_Fones_NUM_INDEX'),
		( 5, 'T_Telefones_Tipos',				 'PK_T_Funcionarios_Tipos_NUM_INDEX'),
		( 6, 'T_Fabricantes',						 'PK_T_Fabricantes_NUM_INDEX'),
		( 7, 'T_Veiculos',							 'PK_T_Veiculos_NUM_INDEX'),
		( 8, 'T_Veiculos_Tipos',					 'PK_T_Veiculos_Tipos_NUM_INDEX'),
		( 9, 'T_Veiculos_Detalhes',				 'PK_T_Veiculos_Detalhes_NUM_INDEX'),				-- T_Veiculos_Infs
		(10, 'T_Veiculos_ANTT',					 'PK_T_Veiculos_ANTT_NUM_INDEX'),
		(11, 'T_Veiculos_Motorista',			 'PK_T_Veiculos_Motorista_NUM_INDEX'),
		(12, 'T_Circulacao_Horario',			 'PK_T_Circulacao_Horario_NUM_INDEX'),
		(13, 'T_Circulacao_Zona',				 'PK_T_Circulacao_Zona_NUM_INDEX'),
		(14, 'T_Circulacao_Zona_Horario',		 'PK_T_Circulacao_Horario_Zona_NUM_INDEX'),
		(15, 'T_Licenca_Trafego',				 'PK_T_Licenca_Trafego_NUM_INDEX'),
		(16, 'T_Licenca_Trafego_Veiculos',	 'PK_T_Licenca_Trafego_Veiculos_NUM_INDEX'),
		(17, 'T_Licenca_Trafego_Veic_Zona',  'PK_T_Licenca_Trafego_Veic_Zona_NUM_INDEX'),
		(18, 'T_Orgao_Emissor_Autuacao',		 'PK_T_Orgao_Emissor_Autuacao_NUM_INDEX'),
		(19, 'T_Infracoes_Descricao',			 'PK_T_Infracoes_Descricao_NUM_INDEX'),
		(20, 'T_Infracoes_Veic_Autuacao',		 'PK_T_Infracoes_Veiculos_NUM_INDEX'),
		(21, 'T_Infracoes_Veic_Condutor',    'PK_T_Infracoes_Veic_Condutor_NUM_INDEX'),
		(22, 'T_Infracoes_Veic_Boleto',		 'PK_T_Infracoes_Veic_Boleto_NUM_INDEX'),
		(23, 'T_Infracoes_Veic_Baixa',			 'PK_T_Infracoes_Veic_Baixa_NUM_INDEX'),
		(24, 'T_Infracoes_Veic_Div_Ativa',	 'PK_T_Infracoes_Veic__Div_Ativa_NUM_INDEX'),
		(25, 'T_Infracoes_Veic_Ocorrencias', 'PK_T_Infracoes_Veic_Ocorrencias_NUM_INDEX'),
		(26, 'T_Infracoes_Veic_Docs',			 'PK_T_Infracoes_Veic_Docs_NUM_INDEX'),
		(27, 'T_Infracoes_Veic_EnvioECT',		 'PK_T_Infracoes_Veic_EnvioECT_NUM_INDEX'),
		(28, 'T_Infracoes_Veic_Recursos',    'PK_T_Infracoes_Veic_Recursos_NUM_INDEX'),
		(29, 'T_Infracoes_Veic_NIC',			 'PK_T_Infracoes_Veic_NIC_NUM_INDEX')				-- Reincidencia de Autuacao

	IF @@ERROR = 0
		PRINT 'Tabela Virtual : Relação das Tabelas criada com sucesso!'
	ELSE
		BEGIN
			PRINT 'NÃO foi possível criar Tabela Virtual : Relação das Tabelas. Favor verificar com o Responsável.'
			RETURN 99
		END

	SET @NUM_TABELA = 1
	SELECT @QTDTABELAS = COUNT(*) FROM @LST_TABELAS

	-- Relação dos campos das Tabelas
	DECLARE @LST_CAMPOS TABLE(ID_TabelaCampo INT, Nome_DefCampo NVARCHAR(MAX))
	INSERT INTO @LST_CAMPOS VALUES
		( 1, '[NUM_INDEX]	   [int]          IDENTITY(1, 1) NOT NULL, ' +
			  '[CNPJEmpresa]  [nvarchar](15) NOT NULL, ' +
			  '[NomeEmpresa]  [nvarchar](50) NOT NULL, ' +
			  '[NomeFantasia] [nvarchar](40) NOT NULL, ' +
			  '[DataAbertura] [datetime2](0) NULL, ' +
			  '[Num_IE]		   [nvarchar](15) NULL,'),

		( 2, '[NUM_INDEX]		   [int]           IDENTITY(1,1) NOT NULL, ' +
			  '[CNPJEmpresaAtiv] [nvarchar](15)  NOT NULL, ' +
			  '[TipoAtividade]   [smallint]      NOT NULL, ' +
			  '[CodAtividade]	   [nvarchar](7)   NOT NULL, ' +
			  '[DescrAtividade]	[nvarchar](200) NOT NULL, '),

		( 3, '[NUM_INDEX]		  [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[CNPJEmpresa]	  [nvarchar](18) NOT NULL, ' +
			  '[CodFuncionario] [smallint]	     NOT NULL, ' +
			  '[NomeFunc]		  [nvarchar](50) NOT NULL, ' +
			  '[ApelidoFunc]	  [nvarchar](20) NULL, ' +
			  '[EnderecoFunc]	  [nvarchar](50) NOT NULL, ' +
			  '[NumEndFunc]	     [smallint]		  NOT NULL, ' +
			  '[ComplEndFunc]	  [nvarchar](30) NULL, ' +
			  '[BairroEndFunc]  [nvarchar](30) NOT NULL, ' +
			  '[CEP_Func]		  [nvarchar](9)	  NOT NULL, ' +
			  '[CidadeEndFunc]  [nvarchar](20) NOT NULL, ' +
			  '[UFEndFunc]		  [nvarchar](2)	  NOT NULL, ' +
			  '[RG_Num]			  [nvarchar](10) NOT NULL, ' +
			  '[RG_DtExpedicao] [datetime2](0) NOT NULL, ' +
			  '[RG_OrgEmissor]  [nvarchar](6)	  NULL, ' +
			  '[CPF_Num]			  [nvarchar](14) NOT NULL, ' +
			  '[CNH_Num]			  [nvarchar](16) NULL, ' +
			  '[CNH_Categoria]  [nvarchar](2)	  NULL, ' +
			  '[CNH_DtVencto]	  [datetime2](0) NULL, ' +
			  '[CargoFunc]		  [nvarchar](20) NOT NULL, ' +
			  '[QtdHorasSem]    [smallint]		  NOT NULL, ' +
			  '[DataAdmissao]	  [datetime2](0) NOT NULL, '),

		( 4, '[NUM_INDEX]   [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[CodFuncFone] [smallint]		  NOT NULL, ' +
			  '[TipoFone]    [tinyint]		  NOT NULL, ' +
			  '[Fone_Num]	  [nvarchar](13) NOT NULL, '),
				 
		( 5, '[NUM_INDEX]   [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[CodTpFone]	  [tinyint]      NOT NULL, ' +
			  '[DescrTpFone] [nvarchar](20) NOT NULL, '),

		( 6, '[NUM_INDEX]  [int]			     IDENTITY(1,1) NOT NULL, ' +
			  '[Fabricante] [nvarchar](40)  NOT NULL, ' +
			  '[SiglaFabr]  [nvarchar](4)	  NOT NULL, '),

		( 7, '[NUM_INDEX]		     [int]	         IDENTITY(1,1) NOT NULL, ' +
			  '[CNPJEmpresa]       [nvarchar](18)  NOT NULL, ' +
			  '[PlacaVeiculo]      [nvarchar](8)   NOT NULL, ' +
			  '[RENAVAM]				  [float]			   NULL, ' +
			  '[CodFrabricante]	  [int]				NULL, ' +
			  '[Modelo]			     [nvarchar](255) NULL, ' +
			  '[AnoFabricacao]		  [float]			   NULL, ' +
			  '[AnoModelo]			  [float]			   NULL, ' +
			  '[UF]					  [nvarchar](255) NULL, ' +
			  '[CHASSI]				  [nvarchar](255) NULL, ' +
			  '[Mes_Licenciamento] [nvarchar](11)  NOT NULL, ' +
			  '[Data Cadastro]		  [datetime2](0)  NULL, '),

		( 8, '[NUM_INDEX]    [int]				IDENTITY(1,1) NOT NULL, ' +
			  '[CodTpVeiculo] [int]			   NOT NULL, ' +
			  '[TipoVeiculo]  [nvarchar](40) NOT NULL, '),

		( 9, '[NUM_INDEX]			  [int]				IDENTITY(1,1) NOT NULL, ' +
			  '[PlacaVeiculo]		  [nvarchar](8)	   NOT NULL, ' + 
			  '[Mes_Licenciamento] [int]				NOT NULL, ' +
			  '[Capacidade_Ton]	  [float]			   NULL, ' + 
			  '[Cor]					  [nvarchar](255) NULL, ' +
			  '[Altura]				  [float]			   NULL, ' +
			  '[Largura]				  [float]			   NULL, ' +
			  '[Comprimento]		  [float]			   NULL, ' +
			  '[CodTpVeiculo]		  [int]				NULL, ' +
			  '[Categoria]			  [nvarchar](12)  NOT NULL, ' +
			  '[Faixa_IPVA]			  [int]				NULL, ' +
			  '[DiaRodizio]			  [nvarchar](7)   NULL, ' +
			  '[Licenca_CET]		  [bit]				NULL, '),

		(10, '[NUM_INDEX]		[int]				IDENTITY(1,1) NOT NULL, ' +
			  '[PlacaVeiculo] [nvarchar](8)	NOT NULL, ' +
			  '[Num_CRNTRC]	   [int]				NOT NULL, ' +
			  '[DtCadastro]	   [datetime2](0) NOT NULL, ' +
			  '[DtValidade]   [datetime2](0) NOT NULL, ' +
			  '[DtCadTabela]  [datetime2](0) NOT NULL, '),

		(11, '[NUM_INDEX]		  [int]				IDENTITY(1,1) NOT NULL, ' +
			  '[PlacaVeiculo]	  [nvarchar](8)	   NOT NULL, ' +
			  '[CodFuncionario] [smallint]	      NOT NULL, ' +
			  '[DataSaida]		  [datetime2](0)  NOT NULL, ' +
			  '[HorarioSaida]	  [datetime2](0)  NULL, ' +
			  '[DataRetorno]	  [datetime2](0)  NULL, ' +
			  '[HorarioRetorno] [datetime2](0)  NULL, ' +
			  '[Observacoes]	  [nvarchar](100) NULL, '),

		(12, '[NUM_INDEX]         [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[CodZonaHorario]    [int]		     NOT NULL, ' +
			  '[DiaSemana-Horario] [nvarchar](50) NOT NULL, ' +
			  '[HoraInicio]        [datetime2](0) NULL, ' +
			  '[HoraFinal]			  [datetime2](0) NULL, '),

		(13, '[NUM_INDEX]         [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[CodZonaCirculacao] [int]			  NOT NULL, ' +
			  '[DescrZonaCirc]	     [nvarchar](50) NOT NULL, '),		-- Nome da Zona de Circulação

		(14, '[NUM_INDEX]         [int] IDENTITY(1,1) NOT NULL, ' +
			  '[CodZonaCirculacao] [int] NOT NULL, ' +
			  '[CodHorCircculacao] [int] NOT NULL, '),

		(15, '[NUM_INDEX]			  [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[NumeroProtocolo]	  [int]			  NOT NULL, ' +
			  '[DataRequerimento]  [datetime2](0) NULL, ' +
			  '[CPNJ_Requerente]	  [nvarchar](18) NOT NULL, ' +
			  '[DtInicio_Validade] [datetime2](0) NULL, ' +
			  '[DtFinal_Validade]  [datetime2](0) NULL, ' +
			  '[Deferido]			  [bit]			  NULL, '),

		(16, '[NUM_INDEX]			  [int]			 IDENTITY(1,1) NOT NULL, ' +
			  '[NumeroProtocolo]	  [int]			 NOT NULL, ' +
			  '[NumeroAutorizacao] [int]			 NULL, ' +
			  '[PlacaVeiculo]		  [nvarchar](8) NOT NULL, ' +
			  '[ExigeCartao]		  [bit]			 NULL, '),

		(17, '[NUM_INDEX]		 [int]			    IDENTITY(1,1) NOT NULL, ' +
			  '[DescrZonaCirc] [nvarchar](50) NOT NULL, '),

		(18, '[NUM_INDEX]		[int]				IDENTITY(1,1) NOT NULL, ' +
			  '[SiglaEmissor] [nvarchar](10) NOT NULL, ' +
			  '[OrgaoEmissor] [nvarchar](30) NOT NULL, '),

		(19, '[NUM_INDEX]		  [int]			   IDENTITY(1,1) NOT NULL, ' +
			  '[DescrInfracao]	  [nvarchar](120) NOT NULL, ' +
			  '[CodigoInfracao] [int]			   NULL, ' +
			  '[Infracao]		  [nvarchar](9)   NOT NULL, '),

		(20, '[NUM_INDEX]		 [int]				  IDENTITY(1,1) NOT NULL, ' +
			  '[PlacaVeiculo]	 [nvarchar](8)	  NOT NULL, ' +
			  '[OrgaoEmissor]	 [int]			     NOT NULL, ' +
			  '[NumAIT]			 [nvarchar](11)  NOT NULL, ' +
			  '[CodInfracao]	 [int]			     NOT NULL, ' +
			  '[DataInfracao]  [datetime2](0)  NULL, ' +
			  '[HoraInfracao]  [datetime2](0)  NULL, ' +
			  '[LocalInfracao] [nvarchar](255) NULL, ' +
			  '[InfracaoAtiva] [bit]			     NULL, ' +
			  '[DividaAtiva]   [bit]			     NULL, ' +
			  '[DataCadastro]  [datetime2](0)  NULL, '),

		(21, '[NUM_INDEX]   [int]		      IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT]		  [nvarchar](11)  NOT NULL, ' +
			  '[CodFunc01]   [smallint]		   NOT NULL, ' +
			  '[CodFunc02]   [smallint]	      NULL, ' +
			  '[QtdePontos]  [nvarchar](255) NULL, ' +
			  '[Observacoes] [nvarchar](150) NULL, '),

		(22, '[NUM_INDEX]		  [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[NumNotificacao] [float]			  NULL, ' +
			  '[NumAIT]			  [nvarchar](11) NOT NULL, ' +
			  '[DataVencimento] [datetime2](0) NOT NULL, ' +
			  '[ValorInfracao]	  [float]			  NOT NULL, ' +
			  '[DataCadastro]   [datetime2](0) NULL, '),

		(23, '[NUM_INDEX] [int]				 IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT]		[nvarchar](11)  NOT NULL, ' +
			  '[DataPagto]	[datetime2](0 ) NOT NULL, ' +
			  '[ValorPago]	[float]         NULL, '),

		(24, '[NUM_INDEX]			[int]				IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT]				[nvarchar](11) NOT NULL, ' +
			  '[VlrInfracaoCorr] [float]			NOT NULL, ' +
			  '[Encargos]			[float]			NULL, ' +
			  '[Vlr_a_Pagar]		[float]		   NULL, ' +
			  '[DataAtualVlr]		[datetime2](0) NOT NULL, ' +
			  '[DataCadastro]		[datetime2](0) NOT NULL, '),
	
		(25, '[NUM_INDEX]			[int]				 IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT]				[nvarchar](11)  NOT NULL, ' +
			  '[DataOcorrencia]	[datetime2](0)  NOT NULL, ' +
			  '[HoraOcorrencia]  [datetime2](0)  NOT NULL, ' +
			  '[DescrOcorrencia] [nvarchar](150) NOT NULL, '),

		(26, '[NUM_INDEX]		[int]				 IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT]			[nvarchar](11)  NOT NULL, ' +
			  '[Docs_Anexo]	   [varchar](8000) NULL, ' +
			  '[DataCadastro] [datetime2](0)  NULL, '),

		(27, '[NUM_INDEX]		 [int]			    IDENTITY(1,1) NOT NULL, ' +
			  '[Num_AIT]		    [nvarchar](11) NOT NULL, ' +
			  '[DataEnvio]		 [datetime2](0) NOT NULL, ' +
			  '[HoraEnvio]		 [datetime2](0) NULL, ' +
			  '[CodAgECT]		 [int]			    NULL, ' +
			  '[CodObjEnviado] [nvarchar](13) NOT NULL, ' +
			  '[DataCadastro]	 [datetime2](0) NULL, '),

		(28, '[NUM_INDEX]			  [int]			  IDENTITY(1,1) NOT NULL, ' +
			  '[Num_AIT]				  [nvarchar](11) NOT NULL, ' +
			  '[DataSelecao]		  [datetime2](0) NULL, ' +
			  '[DataImpressao]	     [datetime2](0) NULL, ' +
			  '[DataEntradaDETRAN] [datetime2](0) NOT NULL, ' +
			  '[Num_Processo]		  [nvarchar](17) NOT NULL, ' +
			  '[Tipo_Processo]		  [nvarchar](1)  NULL, ' +
			  '[DataJulgamento]	  [datetime2](0) NULL, ' +
			  '[Status]				  [nvarchar](1)  NOT NULL, '),

		(29, '[NUM_INDEX]			 [int]			    IDENTITY(1,1) NOT NULL, ' +
			  '[NumAIT_Origem]	    [nvarchar](11) NOT NULL, ' +
			  '[NumAIT_NIC]		    [nvarchar](11) NOT NULL , ' +
			  '[Num_Reincidencia] [smallint]	    NOT NULL, ' +
			  '[DataCadastro]		 [datetime2](0) NOT NULL, ')

	IF @@ERROR = 0
		PRINT 'Tabela Virtual : Relação dos Campos das Tabelas criada com sucesso!'
	ELSE
		BEGIN
			PRINT 'NÃO foi possível criar Tabela Virtual : Relação dos Campos das Tabelas. Favor verificar com o Responsável.'
			RETURN 99
		END

	WHILE @NUM_TABELA <= @QTDTABELAS 
		BEGIN
			SELECT TOP(1) @TB_NOME = NomeTabela, @PK_NOME = NomeIndice FROM @LST_TABELAS WHERE @NUM_TABELA = ID_Tabela

			-- Estrutura da Tabela Virtual de Campos 
			SELECT TOP(1) @NOME_DEF_CAMPO = Nome_DefCampo FROM @LST_CAMPOS WHERE @NUM_TABELA = ID_TabelaCampo

			-- Mais informações referente a clausula WITH em:
			-- https://learn.microsoft.com/pt-br/sql/t-sql/statements/alter-table-index-option-transact-sql?view=sql-server-ver16
			SET @CMD_SQL = 
				'CREATE TABLE [' + @DATABASE + '].[dbo].[' + @TB_NOME + ']' +
				' (' + 	@NOME_DEF_CAMPO +  
					'CONSTRAINT [' + @PK_NOME + '] PRIMARY KEY CLUSTERED ([NUM_INDEX] ASC) ' +
					'WITH (' +
						'PAD_INDEX = OFF, ' +
						'IGNORE_DUP_KEY	 = OFF, ' +
						'ALLOW_ROW_LOCKS = ON, ' +
						'ALLOW_PAGE_LOCKS = ON, ' +
						'STATISTICS_NORECOMPUTE = OFF, ' +
						'OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]' +
				') ON [PRIMARY]'

			PRINT ''
			PRINT 'Tabela nº ' + CAST(@num_tabela AS NVARCHAR)
			PRINT @CMD_SQL

			-- Cria a Tabela + Campos no DB
			IF (NOT EXISTS(SELECT TOP(1) * FROM DB_GerMultasFrota.sys.tables WHERE [name] = @TB_NOME))
				BEGIN
					EXEC sp_executesql @CMD_SQL	

					IF @@ERROR = 0
						PRINT 'Tabela: [' + @DATABASE + '].[dbo].[' + @TB_NOME + '] CRIADA com sucesso!'
					ELSE
						BEGIN
							PRINT 'NÃO foi possível criar Tabela: [' + @DATABASE + '].[dbo].[' + @TB_NOME + ']. Favor verificar com o Responsável.'
							RETURN 99
						END
				END
			ELSE
				PRINT 'Tabela: [' + @DATABASE + '].[dbo].[' + @TB_NOME + '] já EXISTE!'

			SET @NUM_TABELA += 1
		END
END
PRINT ''
PRINT 'Rotina executada com sucesso!'
