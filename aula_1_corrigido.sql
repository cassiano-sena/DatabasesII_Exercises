/* 1. Efetue a criação das tabelas e relações. */

-- Criação da tabela Cliente
CREATE TABLE Cliente (
    ID_Cliente INT PRIMARY KEY,
    Nome VARCHAR,
	Data_Nasc DATE,
    Endereco VARCHAR(255),
    Telefone VARCHAR(20),
    Email VARCHAR(100)
);

-- Criação da tabela Pedidos
CREATE TABLE Pedido (
    ID_Pedido INT PRIMARY KEY,
    DataHora TIMESTAMP WITHOUT TIME ZONE,
    ID_Cliente INT,
    Status VARCHAR(50),
    Total DECIMAL(10, 2),
    FOREIGN KEY (ID_Cliente) REFERENCES Cliente(ID_Cliente)
);

-- Criação da tabela Itens do Cardápio
CREATE TABLE Item_Cardapio (
    ID_Item INT PRIMARY KEY,
    Nome VARCHAR(100),
    Descricao TEXT,
    Preco DECIMAL(10, 2)
);

-- Criação da tabela associativa Itens_Pedido
CREATE TABLE Item_Pedido (
    ID_Pedido INT,
    ID_Item INT,
    Quantidade INT,
	PRIMARY KEY (ID_Pedido, ID_Item),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedido(ID_Pedido) ON UPDATE CASCADE ON DELETE CASCADE, 
    FOREIGN KEY (ID_Item) REFERENCES Item_Cardapio(ID_Item) ON UPDATE CASCADE ON DELETE CASCADE
);

	
/* 2.	Popule as tabelas com dados artificiais. Para a geração destes dados utilize ferramentas on-line (como o Chat-gpt). */ 
INSERT INTO Cliente 
	VALUES 	(1,'Anna Briggs','2023-11-06','Lawson Square, 13356','732-864-7316','martinpatricia@cain-smith.com'),
			(2,'Jeremy Thompson','1998-05-04','USS Medina, 21470','523-272-4776','kimberlycannon@quinn.info'),
			(3,'Dakota Lloyd','1976-10-27','Reed Ferry, 305','01-566-218-0500','wmoore@gutierrez-cole.com'),
			(4,'Danny Potter','1958-03-18','USS Gibson, 424','01-441-053-3778','joel28@thomas-rosales.org'),
			(5,'Carolyn Stevens','1948-07-07', 'Willie Walks Suite 019','001-183-448-8354','williamgreen@gmail.com'),
			(6,'Kara Perkins','1992-08-07','Esparza Pines, 86115','001-372.224.2758','melodyholt@yahoo.com'),
			(7,'Luis Evans','1968-02-23','John Island Suite, 074','+1-894-341-5025','qtucker@gmail.com'),
			(8,'Amber West','1999-07-10', 'Peters Mountain Suite, 063','(164)470-2706','rhorton@wright-reed.biz'),
			(9,'Stephanie Fox','1998-05-04','Myers Field, 385','001-391-492-3087','halljessica@yahoo.com'),
			(10,'Tamara Schwartz','2010-01-20','USNS Long, 58200','+1-942-840-1333','charlotte91@gmail.com');
			
INSERT INTO Item_Cardapio
	VALUES 	(1,'Pizza Margherita','Tradicional pizza com molho de tomate, queijo mozzarella e manjericão',44.21),
			(2,'Hambúrguer Gourmet','Hambúrguer de carne bovina com queijo, alface, tomate e molho especial',16.95),
			(3,'Salada Caesar','Salada com alface romana, croutons, queijo parmesão e molho Caesar', 47.67),
			(4,'Sushi Sashimi','Variedade de sashimi de salmão, atum e peixe branco',14.70),
			(5,'Spaghetti Carbonara','Espaguete com molho cremoso de ovos, queijo parmesão, bacon e pimenta preta',20.92),
			(6,'Frango Assado','Frango assado com ervas e especiarias, servido com vegetais',45.45),
			(7,'Tacos Mexicanos','Tacos com carne moída, alface, queijo, tomate e molho picante',19.79),
			(8,'Sorvete de Baunilha','Sorvete cremoso de baunilha com opções de cobertura',35.38),
			(9,'Lasanha à Bolonhesa','Camadas de massa, carne moída, molho de tomate e queijo',40.56),
			(10,'Pad Thai','Macarrão tailandês frito com camarões, amendoim, broto de feijão e limão',46.65);

INSERT INTO Pedido
	VALUES 	(1,'2024-02-14 03:53:23.704596',4,'Cancelado',45.76),
			(2,'2024-01-31 19:50:23.704699',10,'Finalizado',57.11),
			(3,'2024-01-28 11:32:23.704728',4,'Finalizado',25.19),
			(4,'2024-02-20 10:08:23.704749',2,'Cancelado',88.64),
			(5,'2024-02-11 10:40:23.704769',3,'Finalizado',54.01),
			(6,'2024-02-10 02:06:23.704789',5,'Pendente',63.14),
			(7,'2024-02-13 10:44:23.704807',10,'Finalizado',33.45),
			(8,'2024-02-01 07:15:23.704826',3,'Pendente',20.43),
			(9,'2024-02-01 02:02:23.704845',9,'Pendente',87.72),
			(10,'2024-02-04 04:23:23.704864',2,'Cancelado',21.87);

INSERT INTO Item_Pedido
	VALUES 	(1,8,2),(2,1,5),(3,2,1),(4,6,4),(5,1,5),(6,1,5),(7,6,1),
			(8,3,1),(9,9,2),(10,4,1),(2,2,3),(2,7,2),(5,2,3),(5,7,3),
			(7,5,2),(7,10,4),(8,5,3),(8,10,5),(8,9,1),(7,4,1);


/* 3.Efetue a criação das seguintes queries: */ 
-- a. Apresentar todos os clientes em ordem alfabética;
SELECT * FROM Cliente ORDER BY Nome;

-- b. Torne a coluna Telefone como não nula e unica.
ALTER TABLE Cliente
	ADD CONSTRAINT naoNulaeUnica UNIQUE (Telefone),
	ALTER COLUMN telefone SET NOT NULL;

-- c. Apresentar os itens do cardápio que não contém “queijo”.
SELECT * FROM Item_Cardapio WHERE Descricao NOT LIKE '%queijo%';

-- d. Exibir todos os pedidos, incluindo os nomes dos respectivos clientes;
SELECT P.ID_Pedido, C.Nome, P.Total
	FROM Pedido P
	JOIN Cliente C ON P.ID_Cliente = C.ID_Cliente;
	
-- e. delete o pedido número 
DELETE FROM Pedido WHERE ID_Pedido = 5;

-- f. Calcular a idade de cada cliente, e apresentá-los de forma crescente.
SELECT ID_Cliente, Nome, Data_Nasc, AGE(Data_Nasc) AS Idade FROM Cliente
	ORDER BY Idade;

-- g. Excluir clientes menores de 18anos.
DELETE FROM Cliente
	WHERE AGE(CURRENT_DATE, Data_Nasc) < INTERVAL '18 years';

-- h. Crie a coluna Data_Cadastro na tabela Cliente, usando como valor Deafult a data atual
ALTER TABLE Cliente
	ADD COLUMN Data_Cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
	
-- i. Crie a coluna "Gluten_Free" e "Is_Vegano" na tabela "Item_Cardapio", defina ambas as colunas como False.
ALTER TABLE Item_Cardapio
	ADD COLUMN Gluten_Free BOOLEAN DEFAULT FALSE,
	ADD COLUMN Is_Vegano BOOLEAN DEFAULT FALSE;

/* j. Apresente os pedidos, os respectivos clientes, nome do item pedido e a quatidade 
	total deste item e o valor total. O resultado deve ser ordenado pelo número do pedido.*/
SELECT P.ID_Pedido, C.Nome, IC.Nome, IP.Quantidade, IP.Quantidade * IC.Preco AS Total_Item
	FROM Pedido P
	JOIN Cliente C ON C.Id_Cliente = P.ID_Cliente
	JOIN Item_Pedido IP ON P.ID_Pedido = IP.ID_Pedido
	JOIN Item_Cardapio IC ON IC.ID_Item = IP.ID_Item
	ORDER BY P.ID_Pedido;
	
-- k. Altere o nome da coluna "Data_Cadastro" da tabela "Cliente" para "Dt_Cadastro".
ALTER TABLE Cliente
	RENAME COLUMN Data_Cadastro TO Dt_Cadastro;

-- l. Atualizar o campo total da tabela pedido, com base no valor dos itens do pedido multiplicados pela quantidade
UPDATE Pedido
SET Total = (
    SELECT SUM(Item_Cardapio.Preco * Item_Pedido.Quantidade)
    FROM Item_Pedido
    JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item
    WHERE Item_Pedido.ID_Pedido = Pedido.ID_Pedido
)
WHERE EXISTS (
    SELECT *
    FROM Item_Pedido
    WHERE Item_Pedido.ID_Pedido = Pedido.ID_Pedido
);

/* m. Apresentar o número de pedidos de cada cliente, apresetando os atributos 
   código do cliente, nome do cliente, numero de pedidos e o valor total dos pedidos. 
   Apresente o resultado ordenado decrescente por gastos. */
SELECT Cliente.ID_Cliente, Cliente.Nome,
		COUNT(Pedido.ID_Pedido) AS NumeroDePedidos, 
		SUM(Pedido.Total) AS ValorTotalPedidos
	FROM Cliente
		JOIN Pedido ON Cliente.ID_Cliente = Pedido.ID_Cliente
		GROUP BY Cliente.ID_Cliente, Cliente.Nome
		ORDER BY ValorTotalPedidos DESC;

-- n. Listar todos os itens de cada pedido, incluindo o nome do item e a quantidade;
SELECT Pedido.ID_Pedido, Item_Cardapio.Nome, Item_Pedido.Quantidade
	FROM Item_Pedido
	JOIN Pedido ON Item_Pedido.ID_Pedido = Pedido.ID_Pedido
	JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item
	ORDER BY Pedido.ID_Pedido;

/* o. Apresentar os clientes que fizeram mais de 1 pedidos, mostrando o numero total 
	de pedidos e o valor total correspondente */
SELECT Cliente.ID_Cliente, Cliente.Nome, SUM(Pedido.Total) AS ValorTotalPedidos
	FROM Cliente
		JOIN Pedido ON Cliente.ID_Cliente = Pedido.ID_Cliente
	GROUP BY Cliente.ID_Cliente, Cliente.Nome
	HAVING COUNT(Pedido.ID_Pedido) > 1;

/* 4.	Criar a view VisaoDetalhesPedidos. A view VisaoDetalhesPedidos deve combinar dados das tabelas Clientes, 
		Pedidos, ItensCardapio e Itens_Pedido. Para cada pedido, a view deve 
		mostrar o nome do cliente, a data e hora do pedido, o total do pedido, 
		e detalhes de cada item do pedido (nome do item e quantidade). A View 
		deve ter as seguintes colunas: Nome_Cliente (nome do cliente), 
		Data_Hora (data e hora do pedido), total (total do pedido), 
		Item (nome do item) e Quantidade (quantidade do item).*/
		
CREATE VIEW VisaoDetalhesPedidos AS
	SELECT 	Cliente.Nome AS NomeCliente,
    		Pedido.DataHora,
    		Pedido.Total,
    		Item_Cardapio.Nome AS NomeItem,
    		Item_Pedido.Quantidade
	FROM Pedido
		JOIN Cliente ON Pedido.ID_Cliente = Cliente.ID_Cliente
		JOIN Item_Pedido ON Pedido.ID_Pedido = Item_Pedido.ID_Pedido
		JOIN Item_Cardapio ON Item_Pedido.ID_Item = Item_Cardapio.ID_Item;

SELECT * FROM VisaoDetalhesPedidos;