SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i, empresax.tb_estoque e
WHERE i.id_item = e.id_item;

SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i LEFT JOIN empresax.tb_estoque e
ON i.id_item = e.id_item;

SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i RIGHT JOIN empresax.tb_estoque e
ON i.id_item = e.id_item;

SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i INNER JOIN empresax.tb_estoque e
ON i.id_item = e.id_item;

SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i LEFT JOIN empresax.tb_estoque e
ON i.id_item = e.id_item where e.id_item is null

-- recuperar clientes que fizeram pedidos
SELECT p.id_pedido, c.id_cliente, c.nome, c.sobrenome FROM empresax.tb_cliente c
INNER JOIN empresax.tb_pedido p ON p.id_cliente = c.id_cliente

-- recuperar clientes que não fizeram pedidos
SELECT p.id_pedido, c.id_cliente, c.nome, c.sobrenome FROM empresax.tb_cliente c
LEFT JOIN empresax.tb_pedido p ON p.id_cliente = c.id_cliente where p.id_cliente is NULL 

SELECT id_cliente, nome, sobrenome FROM 
empresax.tb_cliente c 
WHERE EXISTS 
(SELECT 1 FROM empresax.tb_pedido p WHERE p.id_cliente = c.id_cliente) ORDER BY id_cliente;

select id_cliente from empresax.tb_cliente tc 

select 1 from empresax.tb_pedido p, empresax.tb_cliente c where p.id_cliente = c.id_cliente 


--SELECT c.id_cliente, c.nome, c.sobrenome FROM empresax.tb_cliente c
--RIGHT JOIN empresax.tb_pedido p ON p.id_cliente = c.id_cliente

-- mostrando todos os pedidos que um cliente realizou
SELECT p.id_pedido, c.id_cliente, c.nome, it.id_item, i.ds_item, it.quantidade, 
i.preco_venda * it.quantidade AS Valor_Total
FROM empresax.tb_pedido p INNER JOIN empresax.tb_item_pedido it ON p.id_pedido = it.id_pedido
INNER JOIN empresax.tb_cliente c ON p.id_cliente = c.id_cliente 
INNER JOIN empresax.tb_item i ON it.id_item = i.id_item 


SELECT c.id_cliente, c.nome,  
SUM(i.preco_venda * it.quantidade) AS Valor_Total, COUNT(p.id_pedido)
FROM empresax.tb_pedido p INNER JOIN empresax.tb_item_pedido it ON p.id_pedido = it.id_pedido
INNER JOIN empresax.tb_cliente c ON p.id_cliente = c.id_cliente 
INNER JOIN empresax.tb_item i ON it.id_item = i.id_item GROUP BY c.id_cliente


-- Recuperar o total do pedido e o nome do cliente
SELECT p.id_pedido, p.id_cliente, 
(SELECT c.nome FROM empresax.tb_cliente c WHERE c.id_cliente = p.id_cliente),
(SELECT SUM(ip.quantidade * i.preco_venda) AS "Total_Pedido"
FROM empresax.tb_item_pedido ip, empresax.tb_item i WHERE ip.id_item = i.id_item AND p.id_pedido = ip.id_pedido 
GROUP BY ip.id_pedido ORDER BY ip.id_pedido)
FROM empresax.tb_pedido p, empresax.tb_cliente c WHERE p.id_cliente = c.id_cliente

create temporary table tb_teste (
id_pedido integer,
id_cliente integer,
nome varchar(50),
valor numeric(10,2)
)

insert into tb_teste values (1,1,'Fulano',12.55)
select * from tb_teste 

CREATE TABLE empresax.tb_cidades(
nome TEXT,
populacao FLOAT,
altitude INT);
select * from empresax.tb_cidades
alter table empresax.tb_cidades add column tamanho integer
alter table empresax.tb_cidades drop column tamanho

CREATE TABLE empresax.capitais(
uf CHAR(2)
)INHERITS (empresax.tb_cidades);
select * from empresax.capitais

create table empresax.tb_capitais02(
UF char(2),
like empresax.tb_cidades
)
select * from empresax.tb_capitais02

create or replace view empresax.status_estoque as
SELECT i.id_item, i.ds_item, i.preco_custo, e.quantidade FROM empresax.tb_item i LEFT JOIN empresax.tb_estoque e
ON i.id_item = e.id_item

drop view empresax.status_estoque -- alterou a estrutura, drop neles

select * from empresax.tb_item ti 

select * from empresax.status_estoque 




drop table tb_teste











