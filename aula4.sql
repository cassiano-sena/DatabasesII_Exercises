
-- DROP SCHEMA Biblioteca;
CREATE SCHEMA Biblioteca;

-- DROP TABLE Livros CASCADE;
CREATE TABLE Livros(
    id_livro serial NOT NULL PRIMARY KEY,
    titulo text NOT NULL,
    autor text NOT NULL,
    ano_publicacao integer,
    disponivel boolean DEFAULT true 
);

-- DROP TABLE Membros CASCADE;
CREATE TABLE Membros(
    id_membro serial NOT NULL PRIMARY KEY,
    nome text NOT NULL,
    email text UNIQUE NOT NULL,
    data_cadastro timestamp NOT NULL 
);
CREATE TABLE Emprestimos(
    id_emprestimo serial NOT NULL PRIMARY KEY,
    id_livro int,
    id_membro int,
    data_emprestimo timestamp NOT NULL,
    data_devolucao timestamp,  
    FOREIGN KEY(id_livro) REFERENCES Livros(id_livro),
    FOREIGN KEY(id_membro) REFERENCES Membros(id_membro)
);

-- • Um Livro pode estar em vários Empréstimos, mas cada Empréstimo está 
-- relacionado a um único Livro.
-- • Um Membro pode ter vários Empréstimos, mas cada Empréstimo está relacionado 
-- a um único Membro.


-- a. Trigger de Auditoria de Empréstimos: Criar um trigger que registre em uma tabela de 
-- auditoria cada vez que um empréstimo for realizado.
CREATE TABLE Emprestimos_audit(
    operation         char(1)   NOT NULL,
    stamp             timestamp NOT NULL,
    userid            text      NOT NULL,
    emprestimoid      integer   NOT NULL
);
CREATE OR REPLACE FUNCTION Emprestimos_audit() RETURNS TRIGGER AS $Emprestimos_audit$
    BEGIN
        IF (TG_OP = 'INSERT') THEN
            INSERT INTO Emprestimos_audit
                SELECT 'I', now(), current_user, n.* FROM new_table n;
        END IF;
        RETURN NULL;
    END;
$Emprestimos_audit$ LANGUAGE plpgsql;

CREATE TRIGGER Emprestimos_audit_ins AFTER UPDATE ON Emprestimos FOR EACH ROW EXECUTE FUNCTION Emprestimos_audit();

-- b. Trigger de Verificação de Disponibilidade: Antes de um empréstimo ser efetivado, 
-- verificar se o livro está disponível.
CREATE OR REPLACE FUNCTION Livros_dispon() RETURNS TRIGGER AS $Livros_dispon$
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM Livros WHERE id_livro = NEW.id_livro AND disponivel = TRUE) THEN
        RAISE EXCEPTION 'Livro em uso.';
    END IF;
    RETURN NEW;
    END;
$Livros_dispon$ LANGUAGE plpgsql;

CREATE TRIGGER Livros_dispon_trigger AFTER UPDATE ON Emprestimos FOR EACH ROW EXECUTE FUNCTION Livros_dispon();


-- c. Trigger de Atualização de Disponibilidade: Após um empréstimo ser efetivado, atualizar 
-- a disponibilidade do livro para false.
CREATE OR REPLACE FUNCTION Livros_dispon_atualizar() RETURNS TRIGGER AS $Livros_dispon_atualizar$
BEGIN
    UPDATE Livros SET disponivel = FALSE WHERE id_livro = NEW.id_livro;
    RETURN NEW;
END;
$Livros_dispon_atualizar$ LANGUAGE plpgsql;

CREATE TRIGGER Livros_dispon_atualizar_trigger AFTER INSERT ON Emprestimos FOR EACH ROW EXECUTE FUNCTION atualizar_disponibilidade();

-- d. Trigger de Devolução de Livro: Quando um livro é devolvido, atualizar a disponibilidade 
-- do livro para true.
CREATE OR REPLACE FUNCTION Livros_dispon_devolucao() RETURNS TRIGGER AS $Livros_dispon_devolucao$
BEGIN
    UPDATE Livros SET disponivel = TRUE WHERE id_livro = OLD.id_livro;
    RETURN OLD;
END;
$Livros_dispon_devolucao$ LANGUAGE plpgsql;

CREATE TRIGGER Livros_dispon_devolucao_trigger AFTER DELETE ON Emprestimos FOR EACH ROW EXECUTE FUNCTION Livros_dispon_devolucao();

-- E ANULADA
-- e. Trigger de Alerta de Atraso: Executar trigger para verificar, se há empréstimos com a 
-- data de devolução vencida e enviar um alerta (um registro em uma tabela de alertas).
-- E ANULADA


-- f. Trigger de Limite de Empréstimos: Impedir que um membro faça mais de 5 empréstimos 
-- simultâneos.
CREATE OR REPLACE FUNCTION Emprestimos_limite() RETURNS TRIGGER AS $Emprestimos_limite$
BEGIN
    IF(SELECT COUNT(*) FROM Emprestimos WHERE id_membro = NEW.id_membro)>5 THEN 
    RAISE EXCEPTION 'Não é permitido mais que 5 empréstimos.';
    END IF;
    RETURN NEW;
END;
$Emprestimos_limite$ LANGUAGE plpgsql;

CREATE TRIGGER Emprestimos_limite_trigger BEFORE INSERT ON Emprestimos FOR EACH ROW EXECUTE FUNCTION Emprestimos_limite();

-- g. Trigger de Histórico de Empréstimos: Criar um histórico de todos os empréstimos feitos 
-- por um membro.
-- DESCONSIDERAR "POR UM MEMBRO"
CREATE OR REPLACE FUNCTION Emprestimos_historico() RETURNS TRIGGER AS $Emprestimos_historico$
BEGIN
    INSERT INTO Emprestimos_historico (SELECT * FROM Emprestimos);
END;
$Emprestimos_historico$ LANGUAGE plpgsql;

CREATE TRIGGER Emprestimos_historico_trigger AFTER INSERT ON Emprestimos FOR EACH ROW EXECUTE FUNCTION Emprestimos_historico();

-- h. Trigger de Atualização de Livros: Sempre que as informações de um livro forem 
-- atualizadas, registrar a alteração em uma tabela de histórico.
CREATE TABLE Livros_auditar(
    id_livro serial NOT NULL PRIMARY KEY,
    titulo text NOT NULL,
    autor text NOT NULL,
    ano_publicacao integer,
    disponivel boolean DEFAULT true,
    data_atualizacao timestamp NOT NULL
);
CREATE OR REPLACE FUNCTION Livros_auditar() RETURNS TRIGGER AS $Livros_auditar$
BEGIN
    INSERT INTO Livros_auditar(id_livro,titulo,autor,ano_publicacao,disponivel,data_atualizacao) 
    VALUES (NEW.id_livro,OLD.titulo,OLD.autor,OLD.ano_publicacao,OLD.disponivel,CURRENT_TIMESTAMP);
    RETURN NEW;
END;
$Livros_auditar$ LANGUAGE plpgsql;

CREATE TRIGGER Livros_auditar_trigger AFTER UPDATE ON Livros FOR EACH ROW EXECUTE FUNCTION Livros_auditar();

-- i. Trigger de Exclusão de Membro: Quando um membro for excluído, verificar se todos os 
-- livros foram devolvidos antes de permitir a exclusão.
CREATE OR REPLACE FUNCTION Membros_delete_devolucao() RETURNS TRIGGER AS $Membros_delete_devolucao$
BEGIN
    IF EXISTS (SELECT 1 FROM Emprestimos WHERE id_membro = OLD.id_membro AND data_devolucao IS NOT NULL) then
    raise EXCEPTION 'Não é possível excluir um membro com livros não devolvidos.';
    END IF;
    RETURN OLD; 
END;
$Membros_delete_devolucao$ LANGUAGE plpgsql;

CREATE TRIGGER Membros_delete_devolucao_trigger BEFORE DELETE ON Membros FOR EACH ROW EXECUTE FUNCTION Membros_delete_devolucao();

-- j. Trigger de Verificação de E-mail Único: Assegurar que o e-mail cadastrado para um 
-- novo membro seja único. Como o atributo já está definido como UNIQUE, faça uma 
-- trigger para emitir uma mensagem indicando que o Email está duplicado e a que 
-- membro ele pertence.
CREATE OR REPLACE FUNCTION Membros_email_unico() RETURNS TRIGGER AS $Membros_email_unico$
BEGIN
    IF EXISTS(SELECT * FROM Membros WHERE email = NEW.email AND id_membro != NEW.id_membro) THEN
    RAISE EXCEPTION 'Email duplicado';
    END IF;
    RETURN NEW;
END;
$Membros_email_unico$ LANGUAGE plpgsql;

CREATE TRIGGER Membros_email_unico_trigger BEFORE INSERT OR UPDATE ON Membros FOR EACH ROW EXECUTE FUNCTION Membros_email_unico();


INSERT INTO Livros(titulo,autor,ano_publicacao) VALUES
('Dom Quixote', 'Miguel de Cervantes', 1605),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943),
('Hamlet', 'William Shakespeare', 1603),
('Cem Anos de Solidão', 'Gabriel Garcia Márquez', 1967),
('Orgulho e Preconceito', 'Jane Austen', 1813),
('1984', 'George Orwell', 1949),
('O Senhor dos Anéis', 'J.R.R. Tolkien', 1954),
('A Divina Comédia', 'Dante Alighieri', 1320);

INSERT INTO Membros(nome,email,data_cadastro) VALUES
('Ana Silva', 'ana.silva@example.com', '2022-01-10'),
('Bruno Gomes', 'bruno.gomes@example.com', '2022-02-15'),
('Carlos Eduardo', 'carlos.eduardo@example.com', '2022-03-20'),
('Daniela Rocha', 'daniela.rocha@example.com', '2022-05-05'),
('Eduardo Lima', 'eduardo.lima@example.com', '2022-06-10'),
('Fernanda Martins', 'fernanda.martins@example.com', '2022-07-15'),
('Gustavo Henrique', 'gustavo.henrique@example.com', '2022-08-20'),
('Helena Souza', 'helena.souza@example.com', '2022-09-25');


INSERT INTO Emprestimos(id_livro,id_membro,data_emprestimo,data_devolucao) VALUES
(1, 1, '2022-04-01', NULL),
(2, 2, '2022-04-03', '2022-04-10'),
(3, 3, '2022-04-05', NULL),
(4, 4, '2022-10-01', NULL),
(5, 5, '2022-10-03', '2022-10-17'),
(2, 3, '2022-10-06', NULL),
(1, 2, '2022-10-08', '2022-10-15'),
(3, 1, '2022-10-10', NULL),
(3, 2, '2022-11-01', NULL),
(2, 3, '2022-11-03', NULL),
(1, 4, '2022-11-05', NULL),
(5, 1, '2022-11-07', '2022-11-21'),
(4, 5, '2022-11-09', '2022-11-23'),
(2, 1, '2022-11-12', NULL),
(3, 4, '2022-11-14', '2022-11-28'),
(1, 3, '2022-11-16', NULL),
(5, 2, '2022-11-18', '2022-11-25'),
(4, 1, '2022-11-20', '2022-12-04');

