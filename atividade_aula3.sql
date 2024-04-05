-- PARA ESTA ATIVIDADE, EFETUE AS SEGUINTES ETAPAS:
--	1. EFETUE A CRIAÇÃO DAS TABELAS, LINHAS 12 A 64
-- 	2. EFETUE A INSERÇÃO DOS REGISTROS, LINAS 67 A 115
-- 	3. EFETUE A CRIAÇÃO DE FUNÇÕES PARA CADA UM DOS EXERCICIOS A PARTIR DA LINHA 118

/* clinica veterinaria */
SELECT schema_name FROM information_schema.schemata;
SHOW search_path;
CREATE SCHEMA clinica_vet;
SET search_path = clinica_vet;

CREATE TABLE Endereco (
    cod serial PRIMARY KEY,
    logradouro varchar(100),
    numero integer,
    complemento varchar(50),
    cep varchar(12),
    cidade varchar(50),
    uf varchar(2)
);

CREATE TABLE Responsavel (
    cod serial PRIMARY KEY,
    nome varchar(100) NOT NULL,
    cpf varchar(12) NOT NULL,
    fone varchar(50) NOT NULL,
    email varchar(100) NOT NULL,
    cod_end integer,
    UNIQUE (cpf, email),
    FOREIGN KEY (cod_end) REFERENCES Endereco (cod) 
);

CREATE TABLE Pet (
    cod serial PRIMARY KEY,
    nome varchar(100),
    raca varchar(50),
    peso decimal(5,2),
    data_nasc date,
    cod_resp integer,
    FOREIGN KEY (cod_resp) REFERENCES Responsavel (cod) 
);

CREATE TABLE Veterinario (
    cod serial PRIMARY KEY,
    nome varchar(100),
    crmv numeric(10),
    especialidade varchar(50),
    fone varchar(50),
    email varchar(100),
    cod_end integer,
	FOREIGN KEY (cod_end) REFERENCES Endereco (cod) 
);

CREATE TABLE Consulta (
    cod serial PRIMARY KEY,
    dt date,
    horario time,
    cod_vet integer,
    cod_pet integer,
    FOREIGN KEY (cod_vet) REFERENCES Veterinario (cod), 
    FOREIGN KEY (cod_pet) REFERENCES Pet (cod) 
	ON UPDATE CASCADE
    ON DELETE CASCADE
);

-- inserindo enderecos
INSERT INTO endereco(cod,logradouro,numero,complemento,cep,cidade,uf) 
	VALUES 	(1, 'Rua Tenente-Coronel Cardoso', '501', 'ap 1001','28035042','Campos dos Goytacazes','RJ'),
			(2, 'Rua Serra de Bragança', '980', null,'03318000','São Paulo','SP'),
			(3, 'Rua Barão de Vitória', '50', 'loja A','09961660','Diadema','SP'),
			(4, 'Rua Pereira Estéfano', '700', 'ap 202 a','04144070','São Paulo','SP'),
			(5, 'Avenida Afonso Pena', '60', null,'30130005','São Paulo','SP'),
			(6, 'Rua das Fiandeiras', '123', 'Sala 501','04545005','São Paulo','SP'),
			(7, 'Rua Cristiano Olsen', '2549', 'ap 506','16015244','Araçatuba','SP'),
			(8, 'Avenida Desembargador Moreira', '908', 'Ap 405','60170001','Fortaleza','CE'),
			(9, 'Avenida Almirante Maximiano Fonseca', '362', null,'88113350','Rio Grande','RS'),
			(10, 'Rua Arlindo Nogueira', '219', 'ap 104','64000290','Teresina','PI');

-- inserindo responsaveis
INSERT INTO responsavel(cod,nome,cpf,email,fone,cod_end) 
	VALUES 	(1, 'Márcia Luna Duarte', '1111111111', 'marcia.luna.duarte@deere.com','(63) 2980-8765',1),
			(2, 'Benício Meyer Azevedo','23101771056', 'beniciomeyer@gmail.com.br','(63) 99931-8289',2),
			(3, 'Ana Beatriz Albergaria Bochimpani Trindade','61426227400','anabeatriz@ohms.com.br', '(87) 2743-5198',3),
			(4, 'Thiago Edson das Neves','31716341124','thiago_edson_dasneves@paulistadovale.org.br','(85) 3635-5560',4),
			(5, 'Luna Cecília Alves','79107398','luna_alves@orthoi.com.br','(67) 2738-7166',5);

-- inserindo veterinarios
INSERT INTO veterinario(cod,nome,crmv,especialidade,email,fone,cod_end) 
	VALUES 	(1, 'Renan Bruno Diego Oliveira','35062','clinico geral','renanbrunooliveira@edu.uniso.br','(67) 99203-9967',6),
			(2, 'Clara Bárbara da Cruz','64121','dermatologista','clarabarbaradacruz@band.com.br','(63) 3973-7873',7),
			(3, 'Heloise Cristiane Emilly Moreira','80079','clinico geral','heloisemoreira@igoralcantara.com.br','(69) 2799-7715',8),
			(4, 'Laís Elaine Catarina Costa','62025','animais selvagens','lais-costa84@campanati.com.br','(79) 98607-4656',9),
			(5, 'Juliana Andrea Cardoso','00491','dermatologista','juliana_cardoso@br.ibn.com','(87) 98439-9604',10);

-- inserindo animais
INSERT INTO pet(cod,cod_resp,nome,peso,raca,data_nasc) 
	VALUES 	(1, 1, 'Mike', 12, 'pincher', '2010-12-20'),
			(2, 1, 'Nike', 20, 'pincher', '2010-12-20'),
			(3, 2, 'Bombom', 10, 'shitzu', '2022-07-15'),
 			(4, 3, 'Niro', 70, 'pastor alemao', '2018-10-12'),
			(5, 4, 'Milorde', 5, 'doberman', '2019-11-16'),
 			(6, 4, 'Laide', 4, 'coker spaniel','2018-02-27'),
 			(7, 4, 'Lorde', 3, 'dogue alemão', '2019-05-15'),
			(8, 5, 'Joe', 50, 'indefinido', '2020-01-01'),
			(9, 5, 'Felicia', 5, 'indefinido', '2017-06-07');

-- inserindo consultas
INSERT INTO consulta(cod,cod_pet, cod_vet, horario, dt) 
	VALUES 	(1,2,1,'14:30','2023-10-05'),
			(2,4,1,'15:00','2023-10-05'),
			(3,5,5,'16:30','2023-10-15'),
			(4,3,4,'14:30','2023-10-12'),
			(5,2,3,'18:00','2023-10-17'),
			(6,5,3,'14:10','2023-10-20'),
			(7,5,3,'10:30','2023-10-28');
			
			
-- EXERCÍCIOS:
CREATE OR REPLACE FUNCTION primeira_pl() RETURNS INTEGER AS $$ 
	DECLARE
		-- sequencia de variáveis
	BEGIN
		-- sequencia de comandos
    	RETURN 1;
	END
$$ LANGUAGE plpgsql;

SELECT primeira_pl();
DROP FUNCTION primeira_pl;

-- 1 Crie uma função que insira um novo registro na tabela Endereco e 
--   retorne o código do endereço inserido.
CREATE OR REPLACE FUNCTION insere_retorna_endereco(
    logradouro varchar(100),
    numero integer,
    complemento varchar(50),
    cep varchar(12),
    cidade varchar(50),
    uf varchar(2)
) RETURNS INTEGER AS $$ 
	DECLARE
		cod_endereco integer;
	BEGIN
		INSERT INTO endereco(logradouro,numero,complemento,cep,cidade,uf) VALUES (logradouro,numero,complemento,cep,cidade,uf)
        RETURNING cod INTO cod_endereco;
		RETURN cod_endereco;
	END
$$ LANGUAGE plpgsql;

SELECT insere_retorna_endereco('Rua Tenente-Coronel Cardoso', '501', 'ap 1001','28035042','Campos dos Goytacazes','RJ');
DROP FUNCTION insere_retorna_endereco;

-- 2 Crie um procedimento que atualize o email de um responsável com base no seu código.
CREATE OR REPLACE FUNCTION atualizar_email(
    cod integer,
    email varchar(100),
) RETURNS VARCHAR AS $$ 
	DECLARE
		-- sequencia de variáveis
	BEGIN
		UPDATE FROM responsavel SET email = email WHERE cod = cod;
		RETURN cod_endereco;
	END
$$ LANGUAGE plpgsql;

SELECT atualizar_email();
DROP FUNCTION atualizar_email;

-- 4 Faça um procedumento para excluir um responsável. 
--	 Excluir seus pets e endereços.

-- 5 Faça uma função que liste todas as consultas agendadas para uma data específica.
--   Deve retornar uma tabela com os campos data da consulta, nome do responsavel, 
--   nome do pet, telefone do responsavel e nome do veterinario 

-- 6 Crie uma função que receba os dados do veterinario por parâmetro, armazene na tabela “veterinario” e retorne todos os dados da tabela.
CREATE OR REPLACE FUNCTION insere_retorna_veterinario(
    nome varchar(100),
    crmv numeric(10),
    especialidade varchar(50),
    fone varchar(50),
    email varchar(100),
    cod_end integer
) RETURNS RECORD AS $$ 
	DECLARE
		cod_veterinario integer;
	BEGIN
		INSERT INTO veterinario(nome,crmv,especialidade,email,fone,cod_end) VALUES (nome,crmv,especialidade,email,fone,cod_end) 
        RETURNING cod INTO cod_veterinario;
		SELECT * FROM veterinario;
        --RETURN cod_veterinario,nome,crmv,especialidade,email,fone,cod_end;
	END
$$ LANGUAGE plpgsql;

SELECT insere_retorna_veterinario('Renan Bruno Diego Oliveira','35062','clinico geral','renanbrunooliveira@edu.uniso.br','(67) 99203-9967',6);
DROP FUNCTION insere_retorna_veterinario;


-- 7 Crie uma função para adicionar um novo pet, associando-o a um responsável existente.

-- 8 Escreva uma função que conte quantos pets um determinado responsável possui.

-- 9 Desenvolva uma função que retorne todos os veterinários com uma determinada especialidade.
CREATE OR REPLACE FUNCTION especialidade_veterinario(
    especialidade varchar(50)
) RETURNS INTEGER AS $$ 
	DECLARE
		-- sequencia de variáveis
	BEGIN
    	RETURN * FROM veterinario WHERE especialidade = especialidade;
	END
$$ LANGUAGE plpgsql;

SELECT especialidade_veterinario('clinico geral');
DROP FUNCTION especialidade_veterinario;


-- 10 Crie um procedimento que atualize o endereço de um veterinário.

-- 11 Faça uma função que calcule a idade atual de um pet.

-- 12 Crie uma função que retorne todos os endereços em uma cidade específica.

-- 13 Desenvolva um procedimento que associe um pet existente a um novo responsável.

-- 14 Elabore uma função que retorne todas as consultas agendadas de um determinado veterinário.

-- 15 Função para Buscar Responsável pelo Nome do Pet: Desenvolva uma função que retorne o nome do responsável pelo nome do pet.

-- 16 Desenvolva uma função que recebe o CPF de um responsável e retorna seu nome se ele existir na base de dados; caso contrário, retorna uma mensagem "Responsável não encontrado".

-- 17 Crie uma função que receba um código de veterinário e retorne o total de consultas realizadas por ele, utilizando um loop WHILE.

