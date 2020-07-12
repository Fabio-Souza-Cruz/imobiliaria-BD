CREATE DATABASE trabalho;

CREATE SCHEMA imobiliaria;

set search_path to 'imobiliaria';

CREATE TABLE imovel (
	imoCod int NOT NULL PRIMARY KEY,
	imoDisp varchar(255) NOT NULL,
	imoDataConst date NOT NULL,
	imoBairro varchar(255) NOT NULL,
	imoLogradouro varchar(255) NOT NULL,
	imoNumero int NOT NULL,
	imoCidade varchar(255) NOT NULL,
	imoEstado varchar(2) NOT NULL,
	imoCep varchar(8),
	imoValor decimal(10,2) NOT NULL,
	imoDataDisp date NOT NULL,
	imoArea decimal(10,2) NOT NULL
);

CREATE TABLE foto (
	fotoNomeArq varchar(255) PRIMARY KEY,
	fotoImoCod int,
	CONSTRAINT fotoImoCod_fk FOREIGN KEY (fotoImoCod) REFERENCES imovel(imoCod)
);

CREATE TABLE casa (
	casaImoCod int PRIMARY KEY,
	casaQtdQuartos int NOT NULL,
	casaQtdSuites int NOT NULL,
	casaQtdSalaEstar int NOT NULL,
	casaQtdSalaJantar int NOT NULL,
	casaVagaGaragem int NOT NULL,	
	casaArmEmb varchar(10) NOT NULL,
	casaDesc varchar(255) NOT NULL	
);

CREATE TABLE apartamento (
	aptImoCod int PRIMARY KEY,
	aptQtdQuartos int NOT NULL,
	aptQtdSuites int NOT NULL,
	aptSalaEstar int NOT NULL,
	aptSalaJantar int NOT NULL,
	aptVagaGaragem int NOT NULL,	
	aptArmEmb varchar(20) NOT NULL,
	aptDesc varchar(255) NOT NULL,
	aptAndar int NOT NULL,
	aptValorCond real NOT NULL,
	aptPortHr varchar(20) NOT NULL,
	CONSTRAINT aptImoCod_fk FOREIGN KEY (aptImoCod) REFERENCES imovel(imoCod)
);

CREATE TABLE terreno (
	terImoCod int PRIMARY KEY,
	terLargura decimal(10,2) NOT NULL,
	terComprimento decimal(10,2) NOT NULL,
	terAclDecl varchar(20) NOT NULL, 
	CONSTRAINT terImoCod_fk FOREIGN KEY (terImoCod) REFERENCES imovel(imoCod)
);

CREATE TABLE salaComercial (
	sComImoCod int PRIMARY KEY,	
	sComQtdBanheiro int NOT NULL,
	sComComodo int NOT NULL,
	CONSTRAINT sComImoCod_fk FOREIGN KEY (sComImoCod) REFERENCES imovel(imoCod)
);

CREATE TABLE pessoa (
	pesCpf varchar(15) PRIMARY KEY,
	pesNome varchar(255) NOT NULL,
	pesDataNasc date NOT NULL,
	pesLogradouro varchar(255) NOT NULL,
	pesNum int NOT NULL,
	pesBairro varchar(255) NOT NULL,
	pesCidade varchar(255) NOT NULL,
	pesEstado varchar(2) NOT NULL,
	pesCep varchar(8) NOT NULL,
	pesEstadoCivil varchar(20) NOT NULL,
	pesSexo char(1) NOT NULL,
	pesTelefone varchar(20) NOT NULL,
	pesCelular varchar(20) NOT NULL
	
);

CREATE TABLE cliente (
	cliPesCpf varchar(15) PRIMARY KEY,
	cliProfissao varchar(255) NOT NULL,
	cliEmail varchar(255) NOT NULL,
	CONSTRAINT cliPesCpf_fk FOREIGN KEY (cliPesCpf) REFERENCES pessoa(pesCpf)
);

CREATE TABLE clienteProp (
	clientePropId int PRIMARY KEY,
	clientePropCliCpf varchar(15),
	clientePropImo int,
	CONSTRAINT clientePropCliCpf_fk FOREIGN KEY (clientePropCliCpf) REFERENCES cliente(cliPesCpf),
	CONSTRAINT clientePropImo_fk FOREIGN KEY (clientePropImo) REFERENCES imovel(imoCod)
);



CREATE TABLE cargo(
	cargoCod int NOT NULL PRIMARY KEY,
	cargoNome varchar(255) NOT NULL,
	cargoSalario decimal(10,2) NOT NULL
);

CREATE TABLE funcionario (
	funPesCpf varchar(15) PRIMARY KEY,
	funDataIngresso date NOT NULL,
	funCargo int,	
	funLogin varchar(255) NOT NULL,
	funSenha varchar(255) NOT NULL,
	CONSTRAINT funPesCpf_fk FOREIGN KEY (funPesCpf) REFERENCES pessoa(pesCpf),
	CONSTRAINT funCargo_fk FOREIGN KEY (funCargo) REFERENCES cargo(cargoCod)
);


CREATE TABLE pagamento(
	pagForma varchar(255) NOT NULL PRIMARY KEY,
	pagInfo varchar(255)
);

CREATE TABLE venda (
	vendaCod int NOT NULL PRIMARY KEY,
            vendaImo int,
	vendaData date NOT NULL,
	vendaValor decimal(10,2) NOT NULL,
	vendaValorImob decimal(10,2) NOT NULL,
	vendaCliUser varchar(15),
	vendaFuncCpf varchar(15),
	vendaComissao decimal(10,2) NOT NULL,
	vendaFormPag varchar(255),
            CONSTRAINT vendaImo_fk FOREIGN KEY (vendaImo) REFERENCES imovel(imoCod),
	CONSTRAINT vendaCliUser_fk FOREIGN KEY (vendaCliUser) REFERENCES cliente(cliPesCpf),
	CONSTRAINT vendaFuncCpf_fk FOREIGN KEY (vendaFuncCpf) REFERENCES funcionario(funPesCpf),
	CONSTRAINT vendaFormPag_fk FOREIGN KEY (vendaFormPag) REFERENCES pagamento(pagForma)
);

CREATE TABLE aluguel (
	aluguelCod int NOT NULL PRIMARY KEY,
    aluguelImo int,
	aluguelData date NOT NULL,
	aluguelValor decimal(10,2) NOT NULL,
	aluguelValorImob decimal(10,2) NOT NULL,
	aluguelCliUser varchar(15),
	aluguelFuncCpf varchar(15),
	aluguelComissao decimal(10,2) NOT NULL,
	aluguelFormPag varchar(255),
            CONSTRAINT aluguelImo_fk FOREIGN KEY (aluguelImo) REFERENCES imovel(imoCod),
	CONSTRAINT aluguelCliUser_fk FOREIGN KEY (aluguelCliUser) REFERENCES cliente(cliPesCpf),
	CONSTRAINT aluguelFuncCpf_fk FOREIGN KEY (aluguelFuncCpf) REFERENCES funcionario(funPesCpf),
	CONSTRAINT aluguelFormPag_fk FOREIGN KEY (aluguelFormPag) REFERENCES pagamento(pagForma)
);

CREATE TABLE indicado(
	indPesCpf varchar(15) PRIMARY KEY,
	indAlugCod int,
	CONSTRAINT indPesCpf_fk FOREIGN KEY (indPesCpf) REFERENCES pessoa(pesCpf),
	CONSTRAINT indAlugCod_fk FOREIGN KEY (indAlugCod) REFERENCES aluguel(aluguelCod)
);


CREATE TABLE fiador(
	fiadorPesCpf varchar(15) PRIMARY KEY,
	fiadorAlugCod int,
    fiadorVlrRenda decimal(10,2) NOT NULL,	
	CONSTRAINT fiadorPesCpf_fk FOREIGN KEY (fiadorPesCpf) REFERENCES pessoa(pesCpf),
	CONSTRAINT fiadorAluCod_fk FOREIGN KEY (fiadorAlugCod) REFERENCES aluguel(aluguelCod)
);

CREATE TABLE historico (
	hisImo int,
	hisAlugVend int NOT NULL,
	hisCliCpf varchar(15) NOT NULL,
	hisFuncCpf varchar(15) NOT NULL,
	hisData date NOT NULL,
	hisPag varchar(255 ),
	CONSTRAINT hisImo_fk FOREIGN KEY (hisImo) REFERENCES imovel(imoCod)
);

CREATE TABLE autorizacao (	
	autCliPropId int,
	autVenCod int,
	CONSTRAINT autVenCod_fk FOREIGN KEY (autVenCod) REFERENCES venda(vendaCod),
	CONSTRAINT autCliPropId_fk FOREIGN KEY (autCliPropId) REFERENCES clienteprop(clientepropid)
);


-- INSERTS

insert into pessoa(pesCpf, pesNome, pesDataNasc , pesLogradouro, pesNum, pesBairro, pesCidade, pesEstado, pesCep, pesEstadoCivil, pesSexo, pesTelefone, pesCelular)
values
('23514525689','Antonio Manuel','1986-05-02','Rua Maria Alzira Leal', 123, 'Jardim das Acacias', 'Campo Grande', 'MS', '79072560', 'solteiro', 'M', '67332569', '67988796534'),
('25836578925','Milena Rafaela Nunes','1987-04-05','AV Paulista', 100, 'Jardim Aeroporto', 'Campo Grande', 'MS', '79072570', 'solteiro', 'F', '6733262370', '67988796556'),
('36425978936','Neide Alpino','1990-01-06','Rua das Amelias', 32, 'Vila Almeida', 'Terenos', 'MS', '79072580',  'casado',  'F', '6733260635', '67988796558'),
('65448936545', 'Enzo Grabriel','1984-08-08', 'Rua São Paulo', 619, 'Jardim Alto do Sao Francisco', 'Campo Grande', 'MS', '79104120', 'casado', 'M', '6733316948', '67988796559'),
('45625975623', 'Joao Miguel','1989-07-21', 'Rua Santo Antônio', 554, 'Vila Alto Sumare', 'Campo Grande', 'MS', '79104140', 'casado', 'M', '6733313652', '67988796562'),
('12345678910', 'Pedro Henrique Cardoso','1989-10-02', 'Avenida Brasil', 532, 'Jardim Anache', 'Campo Grande', 'MS', '79104151', 'casado', 'M', '6733406658', '67988796627'),
('75986514523', 'Maria Eduarda da Silva','1986-01-09', 'Rua Sao Pedro', 458, 'Jardim Aroeira', 'Sidrolandia', 'MS', '79104160', 'solteiro', 'F', '6733286078', '67988796630'),
('14536952126', 'Ana Clara Oliveira','1991-03-05', 'Rua Sao João', 455, 'Vila Beija Flor', 'Campo Grande', 'MS', '79104170', 'solteiro', 'F', '6733262474', '67988796634'),
('66783771172', 'Adriano Real Moreira','1992-11-16', 'Rua Sete de Setembro', 428, 'Bosque da Saude', 'Terenos', 'MS', '79104190', 'casado', 'M', '6733284662', '67988796635'),
('69142335191', 'Alethe Assuncao Santos','1986-04-05', 'Rua Quinze De Novembro', 394, 'Vila Barao do Rio Branco', 'Sidrolandia', 'MS', '79104200', 'casado', 'F', '6733280734', '67988796636'),
('40580598187', 'Ana Cristina Silva Mendes','1993-12-02', 'Rua Sao Sebastiao', 357, 'Vila Boa Vista', 'Sidrolandia', 'MS', '79104204', 'casado', 'F', '6733315746', '6798879656'),
('85797669153', 'Anderson Cadiotto','1993-12-25', 'Rua Santa Luzia', 343, 'Vila Bosque da Saudade', 'Campo Grande', 'MS', '79105230', 'casado', 'M', '6733280817', '67988796512'),
('54501474149', 'Andrea Almeida de Barros','1997-04-28', 'Rua Duque De Caxias', 329, 'Bosque de Avilan', 'Campo Grande', 'MS', '79105208', 'solteiro', 'F', '6733481092', '6798879663'),
('52784118134', 'Antonio Veloso Peleja Junior','1993-11-02', 'Rua Santa Catarina', 320, 'Jardim Campo Belo', 'Campo Grande', 'MS', '79105430', 'casado', 'M', '6733715648', '67988796511'),
('63164914172', 'Cristiane Padim da Silva','1986-05-13', 'Rua Espirito Santo', 298, 'Cabreuva', 'Campo Grande', 'MS', '79105440', 'solteiro', 'F', '6733282121', '67984561236'),
('37143433187', 'Paulo Alberto de Araujo','1990-06-01', 'Rua Primeiro de Maio', 272, 'California', 'Terenos', 'MS', '79105130', 'casado', 'M', '6733182625', '67981253645'),
('34371110860', 'Paulo Andrade','1989-09-13', 'Rua do Ouvidor', 500, 'Vila Jacy', 'Campo Grande', 'MS', '79235596', 'Casado', 'M', '6733245689', '67999452125'),
('40524701504', 'Arcy Araujo','1987-09-19', 'Av Republica do Chile', 123, 'Jardim America', 'Campo Grande', 'MS', '79125621', 'Solteiro', 'F', '6733212356', '67998452153'),
('03550364520', 'Adala Nascimento','1986-05-14', 'Av Atlantica', 26, 'Alves Pereira', 'Sidrolandia', 'MS', '79425126', 'Casado', 'F', '6733152358', '67992563529'),
('56297092591', 'Alzira Bagagi Alves','1995-03-29', 'Rua Joaquim Palhares', 214, 'Taquarussu', 'Terenos', 'MS', '79145238', 'Casado', 'F', '6733324563', '67993215642'),
('85856735511', 'Clodoaldo da Conceicao','1989-10-10', 'Rua Lucio Costa', 2512, 'Centro Oeste', 'Campo Grande', 'MS', '79521389', 'Casado', 'M', '6733145234', '67996321050'),
('10907926894', 'Alan uchoa Pellejero', '1992-05-02', 'Rua Afelandra', 123, 'Jardim das Hortencias', 'Campo Grande', 'MS', '79083354', 'Solteiro', 'M', '67', '67998553216'),
('54593229790', 'Adriano Sampaio', '1987-04-03', 'Av Afluente', 456, 'Rivieira Pak', 'Campo Grande', 'MS', '79096732', 'Casado', 'M', '6733214523', '67994563241'),
('11533741883', 'Amanda Gouveia', '1989-09-06', 'Rua Agrolandia', 1245, 'Jardim Aero Rancho', 'Campo Grande', 'MS', '79083650', 'Casado', 'F', '6733321542', '67998523654'),
('37909198884', 'Aline Aparecida', '1990-10-14', 'Rua Aguapei', 254, 'Santa Fe', 'Campo Grande', 'MS', '79021201', 'Casado', 'F', '6733102145', '67992365891'),
('27672903829', 'Alvaro Luis Silva', '1993-12-03', 'Rua Aina', 168, 'Coronel Antonino', 'Tres Lagoas', 'MS', '79011120', 'Casado', 'M', '6733320021', '67998632516'),
('34462183860', 'Anderson Cardoso', '1991-08-01', 'Rua Aiurvocas', 1243, 'Vila Aimore', 'Sidrolandia', 'MS', '79074130', 'Solteiro', 'M', '6733002135', '67993264182'),
('25434588321', 'Antone dos Santos', '1988-11-08', 'Rua Ajuru', 1456, 'Alphaville', 'Campo Grande', 'MS', '79035612', 'Casado', 'M', '6733320120', '67997512486'),
('36043276879', 'Armando Motosilo', '1989-04-30', 'Rua Aladim', 102, 'Estrela Sul', 'Campo Grande', 'MS', '79013130', 'Solteiro', 'M', '6733330213', '67992244123'),
('33891563809', 'Bruno Moreti', '1983-06-25', 'Rua Alamanda', 135, 'Caranda Bosque', 'Jaraguari', 'MS', '79032420', 'Casado', 'M', '6733301230', '67990202013'),
('14527912879', 'Camila Nogueira', '1992-07-24', 'Rua Alan Soares', 853, 'Jardim Campo Verde', 'Rio Negro', 'MS', '79015030', 'Solteiro', 'F', '6733201896', '67990310204'),
('25244395858', 'Anelisa Finardi', '1988-09-03', 'Rua Alba', 635, 'Bosque do Carvalho', 'Rio Negro', 'MS', '79036492', 'Casado', 'F', '6733985624', '67992103001'),
('29247183847', 'Danilo Roberto', '1990-05-05', 'Rua Alberto Teixeira', 1253, 'Ramez Tebet', 'Aquidauana', 'MS', '79073322', 'Casado', 'M', '6733124032', '67990033226');



insert into cliente(cliPesCpf, cliProfissao, cliEmail) 
values('23514525689', 'Administrador', 'antoniomanuel@email.com'),
	('65448936545', 'Advogado', 'enzoalpino@email.com'),
	('12345678910', 'Arquiteto', 'pedrohenrique@email.com'),
	('14536952126', 'Biologo', 'anaclaraoliveira@email.com'),
	('69142335191', 'Dentista', 'aletheassuncao@email.com'),
	('85797669153', 'Mestre de obras', 'andersoncadiotto@email.com'),
	('54501474149', 'Auxiliar de escritorio', 'andreabarros@email.com'),
	('37143433187', 'Farmaceutico', 'pauloalberto@email.com'),
	('45625975623', 'Analista de Sistemas', 'joaomiguel@email.com'),
	('52784118134', 'Programador', 'antonioveloso@email.com'),
	('10907926894', 'Biologo', 'alanuchoa@email.com'),
	('54593229790', 'Engenheiro', 'adrianoSampaio@email.com'),
	('11533741883', 'Farmaceutico', 'AmandaGouveia@email.com'),
	('37909198884', 'Professor', 'alineaparecida@email.com'),
	('27672903829', 'Jornalista', 'alvaroluis@email.com'),
	('34462183860', 'Professor', 'andersoncardoso@email.com'),
	('25434588321', 'Administrador', 'antonesantos@email.com'),
	('36043276879', 'Medico', 'armandomotosilo@email.com'),
	('33891563809', 'Programador', 'brunomoreti@email.com'),
	('14527912879', 'Analista de Sistemas', 'camilanogueira@email.com'),
	('25244395858', 'Farmaceutico', 'anelisafinardi@email.com'),
	('29247183847', 'Professor', 'daniloroberto@email.com');


insert into cargo(cargoCod, cargoNome, cargoSalario)
values(1, 'Corretor', 2500.00),
	(2, 'Documentalista', 1600.00),
	(3, 'Gerente', 3200.00),
	(4, 'Recepcionista', 1500.00),
	(5, 'Secretaria', 1500.00),
	(6, 'Office boy', 1600.00),
	(7, 'Auxliar Administrativo', 1500.00);

insert into funcionario(funPesCpf, funDataIngresso, funCargo, funLogin, funSenha)
values('25836578925', '2010-06-01', 1, 'milenarafaela@email.com', md5('123456')),
	('36425978936', '2011-04-03', 2, 'neidealpino@email.com', md5('456789')),
	('75986514523', '2009-02-01', 1, 'mariaeduarda@email.com', md5('789456')),
	('66783771172', '2010-03-05', 3, 'adrianoReal@email.com', md5('456123')),
	('63164914172', '2012-01-03', 4, 'cristianepadim@email.com', md5('147852'));

insert into imovel(imoCod, imoDisp, imoDataConst, imoBairro, imoLogradouro, imoNumero, imoCidade, imoEstado, imoCep, imoValor, imoDataDisp, imoArea)
values(1, 'Indisponivel', '1998-02-21', 'Caranda', 'Rua Retiro', 32, 'Campo Grande', 'MS', '79034490', 125000.00, '2019-08-25', 120.00),
	(2, 'Indisponivel', '2000-03-28', 'Amambai', 'Rua Sao Heladio', 56, 'Campo Grande', 'MS', '79118736', 200000.00, '2020-01-24', 150.00),
	(3, 'Indisponivel', '2008-05-13', 'Amambai', 'Rua Santa Lucia', 1523, 'Campo Grande', 'MS', '79118735', 800.00, '2019-12-15', 150.00),
	(4, 'Indisponivel', '2001-04-02', 'Cohafama', 'Rua Arpoador', 145, 'Campo Grande', 'MS', '79006040', 122000.00, '2020-02-07', 120.00),
	(5, 'Venda', '1990-06-13', 'Jardim Balsamo', 'Rua Adelia Amado', 235, 'Campo Grande', 'MS', '79043111', 321000.00, '2020-01-03', 150.00),
	(6, 'Aluguel', '1995-02-04', 'Jardim Aero Rancho', 'Rua Aero Rancho', 789, 'Campo Grande', 'MS', '79086240', 900.00, '2019-11-05', 120.00),
	(7, 'Indisponivel', '1998-06-08', 'Santa Fe', 'Travessa Acara', 620, 'Campo Grande', 'MS', '79021051', 1000.00, '2020-03-15', 120.00),
	(8, 'Venda', '2005-10-25', 'Jardim Carioca', 'Rua Acco', 123, 'Campo Grande', 'MS', '79105525', 153000.00, '2020-04-28', 150.00),
	(9, 'Indisponivel', '2010-11-06', 'Jardim Santa Emilia', 'Rua Acreuna', 214, 'Campo Grande', 'MS', '79093330', 650.00, '2018-03-09', 80.00),
	(10, 'Venda', '2007-08-04', 'Jardim Noroeste', 'Rua Acuri', 456, 'Campo Grande', 'MS', '79045250', 140000.00, '2020-05-26', 120.00),
	(11, 'Indisponivel', '2000-09-13', 'Jardim Noroeste', 'Rua Adventor Divino de Almeida', 785, 'Campo Grande', 'MS', '79045070', 18000.00, '2020-04-01', 150.00),
	(12, 'Aluguel', '1995-10-20', 'Jardim Balsamo', 'Rua Adelia Salomao', 236, 'Campo Grande', 'MS', '79073693', 1200.00, '2020-06-01', 150.00);

insert into casa(casaImoCod, casaQtdQuartos, casaQtdSuites, casaQtdSalaEstar, casaQtdSalaJantar, casaVagaGaragem,  casaArmEmb, casaDesc)
values(1, 3, 1, 1, 1, 2, 's', 'Possui area de inverno'),
	(3, 2, 1, 1, 1, 2, 'n', 'Area de serviço coberto'),
	(5, 3, 2, 2, 1, 4, 's', 'Possui Piscina');


insert into apartamento(aptImoCod, aptQtdQuartos, aptQtdSuites, aptSalaEstar, aptSalaJantar, aptVagaGaragem, aptArmEmb, aptDesc, aptAndar, aptValorCond, aptPortHr)
values(2, 3, 2, 1, 1, 1, 's', 'Roupeiro embutido', 3, 300.00, 's'),
	(6, 2, 1, 1, 1, 1, 'n', 'Piso Porcelanato', 2, 200.00, 's'),
	(9, 2, 0, 1, 0, 1, 'n', 'Janela com grades', 1, 80.00, 'n');

insert into salaComercial(sComImoCod, sComQtdBanheiro, sComComodo)
values(4, 2, 4),
	(7, 2, 3),
	(12, 2, 3);

insert into terreno(terImoCod, terLargura, terComprimento, terAclDecl)
values(8, 10.00, 15.00, 'Aclive'),
	(10, 10.00, 12.00, 'Declive'),
	(11, 10.00, 15.00, 'Aclive');

insert into clienteProp(clientePropId , clientePropCliCpf, clientePropImo)
values(1, '10907926894', 1),
	(2, '54593229790', 2),
	(3, '10907926894', 8),
	(4, '11533741883', 1),
	(5, '37909198884', 4),
	(6, '27672903829', 5),
	(7, '34462183860', 6),
	(8, '54593229790', 4),
	(9, '34462183860', 2), 
	(10, '25434588321', 7),
	(11, '36043276879', 10),
	(12, '33891563809', 9),
	(13, '14527912879', 12),
	(14, '14527912879', 9),
	(15, '25244395858', 3),
	(16, '29247183847', 11),
	(17, '37909198884', 11);


insert into pagamento(pagForma) 
values ('dinheiro'),
('debito'),
('credito');

insert into venda(vendaCod, vendaImo, vendaData, vendaValor, vendaValorImob, vendaCliUser, vendaFuncCpf, vendaComissao, vendaFormPag) 
values
(100, 1, '2020-06-01', 130000.00, 1300.00, '23514525689', '25836578925', 650.00, 'dinheiro'),
(200, 2, '2010-05-02', 210000.00, 2100.00, '65448936545', '66783771172', 1050.00, 'debito'),
(201, 11, '2019-12-21', 200000.00, 2000.00, '12345678910', '66783771172', 1000.00, 'debito');

insert into aluguel(aluguelCod, aluguelImo, aluguelData, aluguelValor, aluguelValorImob, aluguelCliUser, aluguelFuncCpf , aluguelComissao, aluguelFormPag)
values
(101, 3, '2020-06-11', 1000.00, 100.00, '14536952126', '25836578925', 50.00, 'debito'),
(301, 7, '2019-12-28', 1400.00, 140.00, '69142335191', '75986514523', 70.00, 'credito');

insert into autorizacao(autCliPropId, autVenCod)
values(1, 100),
	(4, 100),
	(2, 200),
	(9, 200),
	(16, 201),
	(17, 201);


insert into fiador(fiadorPesCpf , fiadorAlugCod, fiadorVlrRenda)
values ('40580598187', 101, 3000.00),
	('34371110860', 101, 4000.00),
	('03550364520', 301, 4000.00);

insert into indicado(indPesCpf, indAlugCod)
values 
('56297092591', 101),
('85856735511', 101),
('11533741883', 301),
('10907926894', 301);


insert into historico (hisImo, hisAlugVend, hisCliCpf, hisFuncCpf, hisData, hisPag)
 values
(2, 200, '65448936545','66783771172','2010-05-02', 'debito'),
(11, 201, '12345678910','66783771172', '2019-12-21', 'debito'),
(7, 301, '69142335191','75986514523', '2019-12-28', 'credito'),
(1, 100, '23514525689','25836578925', '2020-06-01', 'dinheiro'),
(3, 101, '14536952126','25836578925', '2020-06-11', 'debito');

insert into foto(fotoNomeArq, fotoImoCod)
values('201908251.jpg', 1),
	('2019082501.jpg', 1),
	('20190825001.jpg', 1),
	('202001242.jpg', 2),
	('2020012402.jpg', 2),
	('201912153.jpg', 3),
	('2019121503.jpg', 3),
	('202002074.jpg', 4),
	('2020020704.jpg', 4),
	('202001035.jpg', 5),
	('201911056.jpg', 6),
	('2019110506.jpg', 6),
	('202003157.jpg', 7),
	('202004288.jpg', 8),
	('2020042808.jpg', 8),
	('20200428008.jpg', 8),
	('201803099.jpg', 9),
	('2018030909.jpg', 9),
	('20180309009.jpg', 9),
	('201803090009.jpg', 9),
	('2020052610.jpg', 10),
	('20200526010.jpg', 10),
	('2020040111.jpg', 11),
	('2020060112.jpg', 12),
	('20200601012.jpg', 12);
