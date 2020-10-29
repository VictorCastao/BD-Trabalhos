/*
Gabarito da criação das tabelas
*/

CREATE TABLE empresax.tb_cliente (
  id_cliente 	INTEGER,
  titulo 	CHAR(4),
  nome 		VARCHAR(32) CONSTRAINT nn_nome 		NOT NULL,
  sobrenome 	VARCHAR(32) CONSTRAINT nn_sobrenome 	NOT NULL,
  endereco	VARCHAR(62) CONSTRAINT nn_endereco 	NOT NULL,
  numero	VARCHAR(5)  CONSTRAINT nn_numero 	NOT NULL, 
  complemento	VARCHAR(62),
  cep		VARCHAR(10),
  cidade	VARCHAR(62) CONSTRAINT nn_cidade 	NOT NULL,
  estado	CHAR(2)     CONSTRAINT nn_estado 	NOT NULL,
  fone_fixo	VARCHAR(15) CONSTRAINT nn_fone_fixo 	NOT NULL,
  fone_movel	VARCHAR(15) CONSTRAINT nn_fone_movel 	NOT NULL,
  fg_ativo 	INTEGER,
  CONSTRAINT pk_id_cliente PRIMARY KEY(id_cliente)
);

-- Criação da tb_item
CREATE TABLE empresax.tb_item (
  id_item 	INTEGER,
  ds_item 	VARCHAR(64) CONSTRAINT nn_ds_item NOT NULL,
  preco_custo 	NUMERIC(7,2),
  preco_venda 	NUMERIC(7,2),
  fg_ativo 	INTEGER,
  CONSTRAINT pk_id_item PRIMARY KEY(id_item)
);

-- Criação da tb_pedido
CREATE TABLE empresax.tb_pedido (
  id_pedido 	INTEGER ,
  id_cliente 	INTEGER CONSTRAINT nn_id_cliente NOT NULL,
  dt_compra 	TIMESTAMP,
  dt_entrega 	TIMESTAMP,
  valor 	NUMERIC(7,2),
  fg_ativo 	INTEGER ,
  CONSTRAINT pk_id_pedido PRIMARY KEY(id_pedido),
  CONSTRAINT fk_ped_id_cliente FOREIGN KEY(id_cliente) 
    REFERENCES empresax.tb_cliente(id_cliente));

-- Criação da tb_item_pedido

CREATE TABLE empresax.tb_item_pedido (
  id_item 	INTEGER,
  id_pedido 	INTEGER,
  quantidade 	INTEGER,
  CONSTRAINT pk_item_pedido PRIMARY KEY(id_item, id_pedido),
  CONSTRAINT fk_ped_id_item FOREIGN KEY(id_item) 
    REFERENCES empresax.tb_item(id_item),
  CONSTRAINT fk_ped_id_pedido FOREIGN KEY(id_pedido) 
    REFERENCES empresax.tb_pedido(id_pedido));

-- Criação da tb_codigo_barras
CREATE TABLE empresax.tb_codigo_barras (
  codigo_barras 	INTEGER CONSTRAINT nn_codigo_barras NOT NULL,
  id_item 		INTEGER CONSTRAINT nn_id_item NOT NULL,
  CONSTRAINT fk_cod_id_item FOREIGN KEY(id_item) 
     REFERENCES empresax.tb_item(id_item)
);

-- Criação da tb_estoque
CREATE TABLE empresax.tb_estoque (
  id_item 	INTEGER,
  quantidade 	INTEGER,
  CONSTRAINT pk_est_id_item PRIMARY KEY(id_item),
  CONSTRAINT fk_est_id_item FOREIGN KEY(id_item) 
    REFERENCES empresax.tb_item(id_item)
);