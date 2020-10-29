-- Criação da tb_cliente
CREATE TABLE empresax.tb_cliente (
  id_cliente 	INTEGER,
  titulo 	CHAR(4),
  nome 	VARCHAR(32) CONSTRAINT nn_nome 	NOT NULL,
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

-- Criação da tb_pedido
CREATE TABLE empresax.tb_pedido (
  id_pedido 	INTEGER ,
  id_cliente 	INTEGER CONSTRAINT nn_id_cliente NOT NULL,
  dt_compra 	TIMESTAMP,
  dt_entrega 	TIMESTAMP,
  valor 	NUMERIC(7,2),
  fg_ativo 	INTEGER ,
  CONSTRAINT pk_id_pedido PRIMARY KEY(id_pedido),
  CONSTRAINT fk_ped_id_cliente FOREIGN KEY(id_cliente) REFERENCES empresax.tb_cliente(id_cliente));
