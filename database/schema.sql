-- 1. Estrutura Territorial (Preparada para IBGE)
CREATE TABLE estados (
    id_estado INT PRIMARY KEY, -- Ex: 29 (Código IBGE da Bahia)
    sigla CHAR(2) NOT NULL UNIQUE, -- Ex: 'BA'
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE cidades (
    id_cidade INT PRIMARY KEY, -- Ex: 2933307 (Código IBGE de Vitória da Conquista)
    nome VARCHAR(150) NOT NULL,
    id_estado INT NOT NULL,
    FOREIGN KEY (id_estado) REFERENCES estados(id_estado) ON DELETE RESTRICT
);

CREATE TABLE enderecos (
    id_endereco SERIAL PRIMARY KEY,
    rua VARCHAR(255) NOT NULL,
    cep VARCHAR(10) NOT NULL,
    id_cidade INT NOT NULL,
    FOREIGN KEY (id_cidade) REFERENCES cidades(id_cidade) ON DELETE RESTRICT
);

-- 2. Clientes
CREATE TABLE clientes (
    id_cliente INT PRIMARY KEY, -- Pode ser SERIAL se o banco for gerar, mas mantido INT conforme o JSON
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    telefone VARCHAR(20)
);

-- 3. Catálogo de Produtos
CREATE TABLE categorias (
    id_categoria INT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL
);

CREATE TABLE produtos (
    id_produto INT PRIMARY KEY,
    nome VARCHAR(200) NOT NULL,
    id_categoria INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria) ON DELETE RESTRICT
);

-- 4. Vendas e Pagamentos
CREATE TABLE vendas (
    id_venda INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    id_endereco_entrega INT NOT NULL,
    data_venda TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL, -- Ex: 'CONCLUIDO', 'CANCELADO'
    valor_total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente) ON DELETE RESTRICT,
    FOREIGN KEY (id_endereco_entrega) REFERENCES enderecos(id_endereco) ON DELETE RESTRICT
);

CREATE TABLE pagamentos (
    id_pagamento SERIAL PRIMARY KEY,
    id_venda INT NOT NULL UNIQUE, -- Relação 1:1 com venda
    metodo VARCHAR(50) NOT NULL, -- Ex: 'BOLETO', 'PIX', 'CARTAO_CREDITO'
    status VARCHAR(50) NOT NULL, -- Ex: 'APROVADO', 'RECUSADO'
    parcelas INT DEFAULT 1,
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda) ON DELETE CASCADE
);

-- 5. Itens da Venda
CREATE TABLE itens_venda (
    id_venda INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL CHECK (quantidade > 0),
    preco_unitario DECIMAL(10, 2) NOT NULL, -- Gravado no momento da venda para evitar alterações retroativas
    PRIMARY KEY (id_venda, id_produto), -- Chave primária composta
    FOREIGN KEY (id_venda) REFERENCES vendas(id_venda) ON DELETE CASCADE,
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto) ON DELETE RESTRICT
);