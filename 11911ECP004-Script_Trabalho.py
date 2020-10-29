import csv, psycopg2  # Bibliotecas a serem utilizadas
from psycopg2.extensions import ISOLATION_LEVEL_AUTOCOMMIT


# Criação da base de dados
def criar_database():
    conexao = psycopg2.connect(dbname='base_2020_02', user='postgres', password='banco', host='localhost', port='5432')
    conexao.set_isolation_level(ISOLATION_LEVEL_AUTOCOMMIT)
    cur = conexao.cursor()
    cur.execute("create database base_correios")
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Criação do schema
def criar_schema():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    cur.execute("create schema dados_ceps")
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Tabela principal, contendo dados dos CEPs
def criar_tabela_1():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = " ".join([
        'create table dados_ceps.informacoes_gerais(',
        'id_cep varchar(10) constraint nn_id_cep not null,',
        'uf varchar(2) constraint nn_uf not null,',
        'cidade varchar(100) constraint nn_cidade not null,',
        'bairro varchar(100),',
        'endereco varchar(100) constraint nn_endereco not null,',
        'constraint pk_id_cep primary key (id_cep)',
        ');'
    ])
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Tabela contendo clientes cadastrados
def criar_tabela_2():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = " ".join([
        'create table dados_ceps.cadastro_cliente(',
        'cpf varchar(11) constraint nn_cpf not null,',
        'nome varchar(20) constraint nn_nome not null,',
        'sobrenome varchar(50) constraint nn_sobrenome not null,',
        'cep varchar(10) constraint nn_cep not null,',
        'numero varchar(5),',
        'complemento varchar(10),',
        'telefone varchar(12),',
        'constraint pk_cpf primary key (cpf),',
        'constraint fk_cep foreign key (cep) references dados_ceps.informacoes_gerais (id_cep)',
        ');'
    ])
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Tabela contendo empresas cadastradas
def criar_tabela_3():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = " ".join([
        'create table dados_ceps.cadastro_empresa(',
        'cnpj varchar(14) constraint nn_cnpj not null,',
        'nome varchar(100) constraint nn_nome not null,',
        'cep varchar(10) constraint nn_cep not null,',
        'numero varchar(5),',
        'complemento varchar(10),',
        'telefone varchar(12),',
        'constraint pk_cnpj primary key (cnpj),',
        'constraint fk_cep foreign key (cep) references dados_ceps.informacoes_gerais (id_cep)',
        ');'
    ])
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Tabela contendo encomendas cadastradas
def criar_tabela_4():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = " ".join([
        'create table dados_ceps.cadastro_encomendas(',
        'id_encomendas integer constraint nn_id_encomendas not null,',
        'descricao varchar(100) constraint nn_descricao not null,',
        'valor numeric(8,2) constraint nn_valor not null,',
        'cnpj_entregador varchar(14) constraint nn_cnpj_entregador not null,',
        'cpf_destinatario varchar(11) constraint nn_cpf_destinatario not null,',
        'constraint pk_id_encomendas primary key (id_encomendas),',
        'constraint fk_cnpj_entregador foreign key (cnpj_entregador) references dados_ceps.cadastro_empresa (cnpj),',
        'constraint fk_cpf_destinatario foreign key (cpf_destinatario) references dados_ceps.cadastro_cliente (cpf)',
        ');'
    ])
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Função auxiliar do processo de inserção dos CEPs via arquivo csv
def correcao_string(texto):
    resp = ""
    for c in texto:
        resp += c
        if c == "'":
            resp += "'"
    return resp


# Inserção de CEPs via arquivo csv
def inserir_dados_cep():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    with open('utfcepos.csv', newline='') as arquivo:
        leitura = csv.DictReader(arquivo)
        for tupla in leitura:
            t_cep = tupla['CEP']
            t_uf = tupla['UF']
            t_cidade = tupla['CIDADE']
            if "'" in t_cidade:
                t_cidade = correcao_string(t_cidade)
            t_bairro = tupla['BAIRRO']
            if "'" in t_bairro:
                t_bairro = correcao_string(t_bairro)
            t_endereco = tupla['ENDERECO']
            if "'" in t_endereco:
                t_endereco = correcao_string(t_endereco)
            comando = "" + \
                      "insert into dados_ceps.informacoes_gerais (id_cep, uf, cidade, bairro, endereco)" + \
                      " values ('" + \
                      str(t_cep) + "', '" + \
                      str(t_uf) + "', '" + \
                      str(t_cidade) + "', '" + \
                      str(t_bairro) + "', '" + \
                      str(t_endereco) + "'" + \
                      ');'
            cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Preenchendo tabelas criadas (exceto a dos CEPs)
def preencher_tabelas():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "" + \
              "insert into dados_ceps.cadastro_cliente (cpf, nome, sobrenome, cep, numero, telefone) " + \
              "values ('44212321398','Valter','Barreto','14177230','529','16988345567'); " + \
              "insert into dados_ceps.cadastro_cliente (cpf, nome, sobrenome, cep, numero, telefone) " + \
              "values ('12345678910','Pedro','da Silva','11010200','59','11988763232'); " + \
              "insert into dados_ceps.cadastro_cliente (cpf, nome, sobrenome, cep, numero, telefone) " + \
              "values ('54334512312','Sérgio','Pacheco','13455806','300','14993074287'); " + \
              "insert into dados_ceps.cadastro_cliente (cpf, nome, sobrenome, cep, numero, telefone) " + \
              "values ('23412985673','Carlos','Sanchez','33120120','08','34992013243'); " + \
              "insert into dados_ceps.cadastro_cliente (cpf, nome, sobrenome, cep, numero, telefone) " + \
              "values ('76512324867','Roberto','de Aquino','35701259','1231','37988520345'); " + \
              "insert into dados_ceps.cadastro_empresa (cnpj, nome, cep, numero, telefone) " + \
              "values ('11222333000159','Colombianas S.A','35701263','402','37998520311'); " + \
              "insert into dados_ceps.cadastro_empresa (cnpj, nome, cep, numero, telefone) " + \
              "values ('22333444000121','Casas Ceará LTDA','60750280','45','34998450311'); " + \
              "insert into dados_ceps.cadastro_empresa (cnpj, nome, cep, numero, telefone) " + \
              "values ('55444213000197','Minas Shop LTDA','38073065','978','3739524359'); " + \
              "insert into dados_ceps.cadastro_empresa (cnpj, nome, cep, numero, telefone) " + \
              "values ('99222111000134','São Luís Modas','65048730','48','4139756545'); " + \
              "insert into dados_ceps.cadastro_empresa (cnpj, nome, cep, numero, telefone) " + \
              "values ('44777888000121','Pedra Bonita Presentes','68740100','S/N','6534569877'); " + \
              "insert into dados_ceps.cadastro_encomendas (id_encomendas, descricao, valor, cnpj_entregador, cpf_destinatario) " + \
              "values (1,'Notebook i3 4gb RAM',1950.00,'55444213000197','54334512312'); " + \
              "insert into dados_ceps.cadastro_encomendas (id_encomendas, descricao, valor, cnpj_entregador, cpf_destinatario) " + \
              "values (2,'Tênis Nike Dart XII',250.00,'99222111000134','23412985673'); " + \
              "insert into dados_ceps.cadastro_encomendas (id_encomendas, descricao, valor, cnpj_entregador, cpf_destinatario) " + \
              "values (3,'Relógio Digital Casio',234.90,'44777888000121','76512324867'); " + \
              "insert into dados_ceps.cadastro_encomendas (id_encomendas, descricao, valor, cnpj_entregador, cpf_destinatario) " + \
              "values (4,'Tv 32 Polegadas',1799.90,'22333444000121','44212321398'); " + \
              "insert into dados_ceps.cadastro_encomendas (id_encomendas, descricao, valor, cnpj_entregador, cpf_destinatario) " + \
              "values (5,'Geladeira Electrolux',2399.98,'22333444000121','54334512312');"
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# View criada para mostrar endereços de SP
def criar_views_1():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "" + \
              "create or replace view dados_ceps.ruas_sp as " + \
              "select endereco from dados_ceps.informacoes_gerais " + \
              "where uf = 'SP';"
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# View criada para mostrar cidades de MG
def criar_views_2():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "" + \
              "create or replace view dados_ceps.cidades_mg as " + \
              "select cidade from dados_ceps.informacoes_gerais " + \
              "where uf = 'MG' " + \
              "group by (cidade);"
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# View criada para mostrar a quantidade de cidades cadastradas, por estado
def criar_views_3():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "" + \
              "create or replace view dados_ceps.contador_cidades as " + \
              "select count(distinct(cidade)), uf from dados_ceps.informacoes_gerais " + \
              "group by (uf);"
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# View criada para exibir dados das encomendas (id, cnpj_entregador e cpf_destinatario)
def criar_views_4():
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "" + \
              "create or replace view dados_ceps.encomendas as " + \
              "select id_encomendas, cnpj_entregador, cpf_destinatario from dados_ceps.cadastro_encomendas;"
    cur.execute(comando)
    conexao.commit()
    cur.close()
    conexao.close()
    return 1


# Exibir views no terminal
def view(nome):
    conexao = psycopg2.connect(dbname='base_correios', user='postgres', password='banco', host='localhost', port='5432')
    cur = conexao.cursor()
    comando = "select * from dados_ceps." + str(nome) + ";"
    cur.execute(comando)
    tupla = cur.fetchall()
    for campo in tupla:
        for info in campo:
            print(info, end=' ')
        print()
    conexao.commit()
    cur.close()
    conexao.close()
    return 1

# Os passos a seguir representam a sequência das funções utilizadas para construir a base de dados
passo1 = criar_database()
passo2 = criar_schema()
passo3 = criar_tabela_1()
passo4 = criar_tabela_2()
passo5 = criar_tabela_3()
passo6 = criar_tabela_4()
passo7 = inserir_dados_cep()
passo8 = preencher_tabelas()
passo9 = criar_views_1()
passo10 = criar_views_2()
passo11 = criar_views_3()
passo12 = criar_views_4()
passo13 = view('ruas_sp')
passo14 = view('cidades_mg')
passo15 = view('contador_cidades')
passo16 = view('encomendas')
