-- Resolvido pelos alunos: Arthur Moser, Evaristo, Nathalia Greiffo
-- Banco de Dados II 2024-01
-- PARA ESTA ATIVIDADE, EFETUE AS SEGUINTES ETAPAS:
--	1. EFETUE A CRIAÇÃO DAS TABELAS, LINHAS 9 A 66
-- 	2. EFETUE A INSERÇÃO DOS REGISTROS, LINAS 69 A 117
-- 	3. EFETUE A CRIAÇÃO DE FUNÇÕES PARA CADA UM DOS EXERCICIOS A PARTIR DA LINHA 120

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
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1 Crie uma função que insira um novo registro na tabela Endereco e retorne o código do endereço inserido.

CREATE OR REPLACE FUNCTION inserir_endereco(
    logradouro varchar(100),
    numero integer,
    complemento varchar(50),
    cep varchar(12),
    cidade varchar(50),
    uf varchar(2)
) RETURNS integer AS $$
DECLARE
    endereco_id integer;
BEGIN
    INSERT INTO Endereco (logradouro, numero, complemento, cep, cidade, uf)
    VALUES (logradouro, numero, complemento, cep, cidade, uf)
    RETURNING cod INTO endereco_id;

    RETURN endereco_id;
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 2 Crie um procedimento que atualize o email de um responsável com base no seu código. - nath

CREATE OR REPLACE PROCEDURE atualizar_email_responsavel(
    IN codigo_responsavel integer,
    IN novo_email varchar(100)
)
LANGUAGE plpgsql AS $$   --COMEÇAR O MEU PROCEDIMENTO AQUI
BEGIN
    UPDATE responsavel    --atualiza
    SET email = novo_email  --novo email
    WHERE cod = codigo_responsavel; --aqui o código que a pessoa deu
END;
$$;

CALL atualizar_email_responsavel(1, 'NATHALIA.GREIFFO@EDU.UNIVALI.BR');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4 Faça um procedumento para excluir um responsável. Excluir seus pets e endereços.  -nath

CREATE OR REPLACE PROCEDURE excluir_responsavel(IN cod_responsavel INTEGER) AS $$
DECLARE
    cod_endereco_responsavel INTEGER;
BEGIN
    -- primeiro eu tenho que achar o código do endereço do responsável
    SELECT cod_end INTO cod_endereco_responsavel FROM responsavel WHERE cod = cod_responsavel;
    
    -- depois eu vou excluir os pets do responsável
    DELETE FROM pet WHERE cod_resp = cod_responsavel;
    
    -- pra enfim excluir o responsável
    DELETE FROM responsavel WHERE cod = cod_responsavel;

    -- em seguida eu preciso excluir o endereço do responsável
    DELETE FROM endereco WHERE cod = cod_endereco_responsavel;

END;
$$ LANGUAGE plpgsql;

CALL excluir_responsavel(2); 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5 Faça uma função que liste todas as consultas agendadas para uma data específica.Deve retornar uma tabela com os campos data da consulta, nome do responsavel, nome do pet, telefone do responsavel e nome do veterinario 

CREATE OR REPLACE FUNCTION listar_consultas_por_data(
    data_consulta_p date
) RETURNS TABLE (
    data_consulta date,
    nome_responsavel varchar(100),
    nome_pet varchar(100),
    telefone_responsavel varchar(50),
    nome_veterinario varchar(100)
) AS $$
BEGIN
    RETURN QUERY 
    SELECT c.dt, r.nome, p.nome, r.fone, v.nome
    FROM Consulta c
    JOIN Veterinario v ON c.cod_vet = v.cod
    JOIN Pet p ON c.cod_pet = p.cod
    JOIN Responsavel r ON p.cod_resp = r.cod
    WHERE c.dt = data_consulta_p;
END;
$$ LANGUAGE plpgsql;

SELECT * from listar_consultas_por_data('2023-10-05');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6 Crie uma função que receba os dados do veterinario por parâmetro, armazene na tabela “veterinario” e retorne todos os dados da tabela. -- nath
CREATE OR REPLACE FUNCTION cadastrar_veterinario(
    nome_vet varchar(100),
    crmv_vet numeric(15), -- Ajustado para numeric(15) conforme a necessidade
    especialidade_vet varchar(50),
    email_vet varchar(100),
    telefone_vet varchar(50),
    cod_endereco_vet integer
)
RETURNS TABLE(
    cod integer,
    nome varchar(100),
    crmv numeric(15),
    especialidade varchar(50),
    email varchar(100),
    telefone varchar(50),
    cod_end integer
)
AS $$
BEGIN
    -- vou por os dados do veterinário na tabela
    INSERT INTO veterinario(nome, crmv, especialidade, email, fone, cod_end)
    VALUES (nome_vet, crmv_vet, especialidade_vet, email_vet, telefone_vet, cod_endereco_vet);
    
    -- vai retornar todos os dados da tabela veterinario
    RETURN QUERY SELECT * FROM veterinario;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM cadastrar_veterinario(
    'Nathália',
    55887721,
    'cachorro',
    'NATHALIA.GREIFFO@EDU.UNIVALI.BR',
    '(49) 999518859',
    7 -- eu tenho que usar o próximo código disponivel, era 6 --> logo vou usar o 7
);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 7 Crie uma função para adicionar um novo pet, associando-o a um responsável existente. -- evaristo

CREATE OR REPLACE FUNCTION adicionar_pet(
    cod_responsavel_p integer,
    nome_pet_p varchar(100),
    peso_p decimal(5,2),
    raca_p varchar(50),
    data_nasc_p date
) RETURNS VOID AS $$
BEGIN
    INSERT INTO Pet (cod_resp, nome, peso, raca, data_nasc)
    VALUES (cod_responsavel_p, nome_pet_p, peso_p, raca_p, data_nasc_p);
END;
$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 8 ARTHUR  Escreva uma função que conte quantos pets um determinado responsável possui.


CREATE OR REPLACE FUNCTION contar_pets_responsavel(
    IN responsavel_id INT
) RETURNS INT
AS $$
DECLARE
    pet_count INT;
BEGIN
    SELECT COUNT(*) INTO pet_count FROM pet WHERE cod_resp = responsavel_id;
    
    RETURN pet_count;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM contar_pets_responsavel(1);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 9 Desenvolva uma função que retorne todos os veterinários com uma determinada especialidade.   --- ARTHUR
CREATE OR REPLACE FUNCTION veterinarios_por_especialidade(
    IN especialidade_vet VARCHAR(50)
) RETURNS TABLE (
    cod INT,
    nome VARCHAR(100),
    crmv NUMERIC(10),
    especialidade VARCHAR(50),
    fone VARCHAR(50),
    email VARCHAR(100),
    cod_end INT
)
AS $$
BEGIN
    RETURN QUERY
    SELECT * FROM veterinario WHERE veterinario.especialidade = especialidade_vet;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM veterinarios_por_especialidade('dermatologista');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 10 Crie um procedimento que atualize o endereço de um veterinário. --- EVARISTO

CREATE OR REPLACE PROCEDURE atualiza_end_vet (
		cod_vet_p INTEGER,
	cod_end_p INTEGER
) AS $$
BEGIN 
	UPDATE veterinario SET cod_end = cod_end_p WHERE cod = cod_vet_p;
END;
$$ LANGUAGE plpgsql;

CALL atualiza_end_vet(1, 7)

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 11 Faça uma função que calcule a idade atual de um pet. -- NATH
CREATE OR REPLACE FUNCTION calcular_idade_pet(data_nascimento date)
RETURNS INTEGER AS $$
BEGIN
    RETURN EXTRACT(YEAR FROM AGE(current_date, data_nascimento)); --RETORNA IDADE EM ANOS
END;
$$ LANGUAGE plpgsql;

SELECT calcular_idade_pet('2010-12-20'); -- NOTA: substituir '2010-12-20' pela data de nascimento do pet que eu quero

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 12 Crie uma função que retorne todos os endereços em uma cidade específica. ---EVARISTO

CREATE OR REPLACE FUNCTION listar_enderecos_por_cidade(
    nome_cidade varchar
) RETURNS TABLE (
    logradouro VARCHAR,
    numero INTEGER,
    complemento VARCHAR,
    cep VARCHAR,
    uf VARCHAR
) AS $$
BEGIN
    RETURN QUERY SELECT E.logradouro, E.numero, E.complemento, E.cep, E.uf FROM endereco E WHERE E.cidade = nome_cidade;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM listar_enderecos_por_cidade('São Paulo');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 13 Desenvolva um procedimento que associe um pet existente a um novo responsável. -- ARTHUR
CREATE OR REPLACE PROCEDURE pet_a_responsavel(
    IN pet_id INT,
    IN novo_responsavel_id INT
)
AS $$
BEGIN
    UPDATE pet SET cod_resp = novo_responsavel_id WHERE cod = pet_id;
END;
$$ LANGUAGE plpgsql;

CALL pet_a_responsavel(2, 1);

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 14 Elabore uma função que retorne todas as consultas agendadas de um determinado veterinário. - NATH
CREATE OR REPLACE FUNCTION consultar_consultas_agendadas(vet_id integer)
RETURNS TABLE (
    cod_consulta integer,
    data_consulta date,
    horario_consulta time,
    cod_pet integer,
    nome_pet varchar(100),
    raca_pet varchar(50),
    peso_pet decimal(5,2),
    data_nasc_pet date,
    nome_responsavel varchar(100),
    email_responsavel varchar(100),
    fone_responsavel varchar(50)
)
AS $$
BEGIN
    RETURN QUERY 
    SELECT
        con.cod AS cod_consulta,
        con.dt AS data_consulta,
        con.horario AS horario_consulta,
        pet.cod AS cod_pet,
        pet.nome AS nome_pet,
        pet.raca AS raca_pet,
        pet.peso AS peso_pet,
        pet.data_nasc AS data_nasc_pet,
        resp.nome AS nome_responsavel,
        resp.email AS email_responsavel,
        resp.fone AS fone_responsavel
    FROM
        consulta con
    INNER JOIN
        pet ON con.cod_pet = pet.cod
    INNER JOIN
        responsavel resp ON pet.cod_resp = resp.cod
    WHERE
        con.cod_vet = vet_id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM consultar_consultas_agendadas(1); 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 15 Função para Buscar Responsável pelo Nome do Pet: Desenvolva uma função que retorne o nome do responsável pelo nome do pet.

CREATE OR REPLACE FUNCTION veterinario_por_nome_pet(
    IN pet_name VARCHAR(100)
) RETURNS VARCHAR(100)
AS $$
DECLARE
    responsavel_nome VARCHAR(100);
BEGIN

    SELECT r.nome INTO responsavel_nome
    FROM pet p
    JOIN responsavel r ON p.cod_resp = r.cod
    WHERE p.nome = pet_name;
    
    RETURN responsavel_nome;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM veterinario_por_nome_pet('Nike');
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 16 Desenvolva uma função que recebe o CPF de um responsável e retorna seu nome se ele existir na base de dados; caso contrário, retorna uma mensagem "Responsável não encontrado".
	
CREATE OR REPLACE FUNCTION buscar_nome_responsavel_pelo_cpf(
    cpf_responsavel varchar
) RETURNS VARCHAR AS $$
DECLARE
    nome_responsavel VARCHAR;
BEGIN
    SELECT nome INTO nome_responsavel FROM responsavel WHERE cpf = cpf_responsavel;
    IF FOUND THEN
        RETURN nome_responsavel;
    ELSE
        RETURN 'Responsável não encontrado';
    END IF;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM buscar_nome_responsavel_pelo_cpf('1111111112');

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 17 Crie uma função que receba um código de veterinário e retorne o total de consultas realizadas por ele, utilizando um loop FOR EACH.

CREATE OR REPLACE FUNCTION total_consultas_veterinario(cod_vet INTEGER)
RETURNS INTEGER AS $$
DECLARE
    total_consultas INTEGER := 0;
    consulta RECORD;
BEGIN
    FOR consulta IN SELECT * FROM Consulta WHERE cod_vet = cod_vet
    LOOP
        total_consultas := total_consultas + 1;
    END LOOP;

    RETURN total_consultas;
END;
$$ LANGUAGE plpgsql;


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
