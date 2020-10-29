SELECT version(); -- versão do PostgreSQL
SELECT date_trunc('second', current_timestamp - pg_postmaster_start_time()) as uptime; -- quanto tempo o servidor subiu
SELECT current_timestamp - pg_postmaster_start_time();
select * from pg_database; -- mostrando todas as base de dados que estão no banco
SELECT * FROM information_schema.tables;
SELECT * FROM information_schema.tables WHERE table_schema NOT IN ('information_schema','pg_catalog'); -- pegando todas as tabelas do banco

SELECT pg_database_size(current_database()); -- espaço que a base de dados está ocupando em bytes
SELECT sum(pg_database_size(datname)) from pg_database; -- espaço do banco

select pg_relation_size('tb_cliente'); -- tamanho de uma tabela no banco

/*
Dados para gerar dados
*/
SELECT * FROM generate_series(1,5); 
SELECT DATE(generate_series(now(),now()+'1 month','1 day')); -- gera data
select now() + '1 year'
SELECT (random()* (3*10))::INTEGER
SELECT (random()* (2*10^3))::BIGINT;
SELECT (random()* (2*10^1))::FLOAT;
SELECT (random()* 100)::NUMERIC(4,2);

SELECT repeat('a',(random()*40)::INTEGER);
SELECT substr('abcdefghijklmnopqrstuvwxyz',1,(random()*26)::INTEGER);

/*
Selecionando os clientes da tabela cliente
*/
SELECT * FROM empresax.tb_cliente;
SELECT COUNT(*) FROM empresax.tb_cliente; -- contando quantos clientes tem na tabela
SELECT COUNT(*) FROM empresax.tb_cliente WHERE cidade = 'Sertãozinho'; -- quantos
SELECT nome FROM empresax.tb_cliente WHERE cidade = 'Sertãozinho'; -- quem
SELECT COUNT(*),cidade FROM empresax.tb_cliente GROUP BY cidade;
SELECT COUNT(*),cidade FROM empresax.tb_cliente GROUP BY cidade HAVING COUNT(*) > 5; -- quantos clientes por cidade com mais de 5
SELECT DISTINCT (sobrenome) from empresax.tb_cliente;

SELECT COUNT(DISTINCT (sobrenome)) AS sobrenomes_unicos, COUNT(sobrenome) 
AS sobrenomes_com_duplicidade from empresax.tb_cliente; -- contar quantos sobrenomes são duplicados

SELECT ds_item, preco_custo FROM empresax.tb_item WHERE preco_custo = (SELECT MIN(preco_custo) FROM empresax.tb_item);
SELECT * FROM empresax.tb_item;
SELECT * FROM empresax.tb_item WHERE preco_custo > (SELECT AVG(preco_custo) FROM empresax.tb_item);

SELECT * FROM empresax.tb_item WHERE preco_custo > (SELECT AVG(preco_custo) FROM empresax.tb_item) 
AND preco_venda < (SELECT AVG(preco_venda) FROM empresax.tb_item);

-- Exemplo: Recuperar as datas dos pedidos realizados pelo cliente "Alex"
SELECT p.dt_compra FROM empresax.tb_pedido p 
WHERE p.id_cliente = (SELECT c.id_cliente FROM empresax.tb_cliente c WHERE c.id_cliente = p.id_cliente AND c.nome = 'Alex')

-- recuperando o nome dos clientes que estão na tabela de pedidos
SELECT * FROM empresax.tb_pedido p, (SELECT id_cliente, nome FROM empresax.tb_cliente) c 
WHERE c.id_cliente = p.id_cliente;


-- Recuperar todas as encomendas do cliente cujo o nome é Anna
SELECT * FROM empresax.tb_pedido p, (SELECT id_cliente, nome FROM empresax.tb_cliente WHERE nome = 'Anna') c WHERE c.id_cliente = p.id_cliente;

-- Listar todos os clientes que realizaram algum tipo de pedido.
SELECT id_cliente, nome, sobrenome FROM empresax.tb_cliente c WHERE EXISTS (SELECT 1 FROM empresax.tb_pedido p WHERE p.id_cliente = c.id_cliente) ORDER BY id_cliente;


-- As consultas podem ser utilizadas para combinar informações agrupadas com informações não agrupadas na mesma
-- consulta
SELECT
(SELECT MIN(preco_venda) FROM empresax.tb_item) AS Menor,
(SELECT MAX(preco_venda) FROM empresax.tb_item) AS Maior,
(SELECT AVG(preco_venda) FROM empresax.tb_item) AS Media

-- Exemplo 01
-- Listar todos os itens disponíveis para venda, indicando a quantidade em estoque
-- Temos duas tabelas (TB_ITENS e TB_ESTOQUE)
-- Realizando a junção entre duas tabelas
SELECT i.id_item, i.ds_item, e.quantidade FROM empresax.tb_item i, empresax.tb_estoque e 
WHERE i.id_item = e.id_item;

-- Todos os itens que não possuem estoque
SELECT i.id_item, i.ds_item FROM empresax.tb_item i WHERE i.id_item NOT IN(SELECT i.id_item FROM empresax.tb_item i, empresax.tb_estoque e 
WHERE i.id_item = e.id_item)

-- Encontrando as tuplas ausentes na consulta anterior por meio da cláusula IN
SELECT i.id_item, i.ds_item FROM empresax.tb_item i WHERE i.id_item NOT IN(SELECT i.id_item FROM empresax.tb_item i, empresax.tb_estoque e 
WHERE i.id_item = e.id_item)

-- Recuperar o pedido, o cliente e o nome
SELECT p.id_pedido, p.id_cliente, c.nome
FROM empresax.tb_pedido p, empresax.tb_cliente c WHERE p.id_cliente = c.id_cliente

SELECT c.id_cliente, c.nome FROM empresax.tb_cliente c 
where c.id_cliente not in (SELECT p.id_cliente 
FROM empresax.tb_pedido p, empresax.tb_cliente c WHERE p.id_cliente = c.id_cliente
)

-- Recuperar os itens dos pedidos, decricao dos produtos e o valor de cada item
SELECT ip.id_pedido, ip.id_item, i.ds_item, ip.quantidade, i.preco_venda, ip.quantidade * i.preco_venda AS "Total_Item"
FROM empresax.tb_item_pedido ip, empresax.tb_item i WHERE ip.id_item = i.id_item

SELECT ip.id_pedido, SUM(ip.quantidade * i.preco_venda) AS "Total_Pedido"
FROM empresax.tb_item_pedido ip, empresax.tb_item i WHERE ip.id_item = i.id_item 
GROUP BY ip.id_pedido ORDER BY ip.id_pedido

-- Recuperar o total do pedido e o nome do cliente
SELECT p.id_pedido, p.id_cliente, (SELECT c.nome FROM aulas.tb_cliente c WHERE c.id_cliente = p.id_cliente),
(SELECT SUM(ip.quantidade * i.preco_venda) AS "Total_Pedido"
FROM empresax.tb_item_pedido ip, empresax.tb_item i WHERE ip.id_item = i.id_item AND p.id_pedido = ip.id_pedido 
GROUP BY ip.id_pedido ORDER BY ip.id_pedido)
FROM empresax.tb_pedido p, empresax.tb_cliente c WHERE p.id_cliente = c.id_cliente
