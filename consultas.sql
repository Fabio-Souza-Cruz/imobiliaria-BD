--Consultas
set search_path to 'imobiliaria';

/*1. Consulta que retorna o cÃ³digo, bairro, cidade, Estado, valor do imÃ³vel.
No qual o bairro comece com Jardim, e que estÃ£o disponÃ­veis para venda, ordenados pelo 
nome do bairro.*/

SELECT imocod AS Codigo, imobairro AS Bairro,
imocidade AS Cidade, imoestado AS Estado, imovalor AS Valor 
FROM imovel
WHERE imodisp ilike'venda'
AND imobairro ilike'Jardim%'
ORDER BY imobairro ASC;



/*2. Consulta que retorna todos os imÃ³veis disponÃ­veis para venda ou aluguel.
Mostra o cÃ³digo do imÃ³vel, tipo do imÃ³vel (casa, apartamento, terreno ou sala comercial)
e o valor do imÃ³vel. Ordenados pelo tipo, e o valor decrescente. */

SELECT imocod as codigo, (
	SELECT 'casa' AS tipo
	FROM casa 
	where casaimocod = imocod	
	UNION
	SELECT 'apartamento' AS tipo  
	FROM apartamento
	where aptimocod = imocod	
	UNION
	SELECT 'terreno' as tipo
	FROM terreno
	where terimocod = imocod	
	UNION
	SELECT 'sala' as tipo
	FROM salacomercial
	where sComImoCod = imocod	
), imovalor AS valor
FROM imovel
WHERE imodisp NOT ILIKE 'indisponivel'
ORDER BY tipo asc, valor desc;


/*3. Consulta que retorna a quantidade por tipo de imÃ³veis que estÃ£o disponÃ­veis para venda
ou aluguel, ordenados pela quantidade de imÃ³veis por tipo de forma decrescente e pelo tipo
do imÃ³vel de forma crescente.*/

select tipo.tipo as tipo_imovel, count(tipo.tipo) AS quantidade from imovel i
join (SELECT casaimocod as imocod, 'casa' AS tipo
	FROM casa 	
	UNION
	SELECT aptimocod as imocod, 'apartamento' AS tipo  
	FROM apartamento	
	UNION
	SELECT terImoCod as imocod, 'terreno' as tipo
	FROM terreno		
	UNION
	SELECT sComImoCod as imocod, 'sala' as tipo
	FROM salacomercial) as tipo on tipo.imocod = i.imocod
	where i.imodisp not ilike 'indisponivel'
group by tipo.tipo
order by count(tipo.tipo) DESC, tipo.tipo ASC;

/*4. Consulta que retorna o total de comissÃ£o ganha de um funcionÃ¡rio(corretor ou gerente)
cadastrado na imobiliÃ¡ria que realizou venda ou aluguel. Ordenados pelo total de comissÃµes.*/  

SELECT p.pesnome, COALESCE (sum(v.vendacomissao),0) 
+ COALESCE(sum(a.aluguelcomissao),0) as total_comissao
FROM funcionario f
JOIN pessoa p ON p.pescpf = f.funpescpf 
LEFT JOIN venda v ON v.vendafunccpf = f.funpescpf
LEFT JOIN aluguel a ON a.aluguelfunccpf = f.funpescpf
WHERE f.funcargo = 1 OR f.funcargo = 3
GROUP BY p.pesnome
ORDER BY total_comissao DESC, p.pesnome ASC;

/*5. Busca que retorna o cpf, nome, cargo, salÃ¡rio do cargo, a soma das comissÃµes do mÃªs
de cada funcionÃ¡rio e o salÃ¡rio mensal(comissÃ£o + salÃ¡rio cargo) de todos os funcionÃ¡rios
da imobiliÃ¡ria.*/

-- MÃ©todo 1: 

select pescpf, pesnome, cargonome, cargosalario, somacomissao, somacomissao + cargosalario as "salario funcionario" from pessoa
join funcionario on funpescpf = pescpf
join (SELECT f.funpescpf as cpfcomisfunc, COALESCE (sum(case when(extract(month from v.vendadata) = extract(month from current_date)
													and extract(year from v.vendadata) = extract(year from current_date))then v.vendacomissao else 0 end),0) 
	+ COALESCE(sum(case when(extract(month from a.alugueldata) = extract(month from current_date)
													and extract(year from a.alugueldata) = extract(year from current_date))then a.aluguelcomissao else 0 end),0) as somacomissao
	FROM funcionario f
	JOIN pessoa p ON p.pescpf = f.funpescpf 
	LEFT JOIN venda v ON v.vendafunccpf = f.funpescpf
	LEFT JOIN aluguel a ON a.aluguelfunccpf = f.funpescpf	
	GROUP BY f.funpescpf) as totalcomissao on cpfcomisfunc = pescpf
join cargo on cargocod = funcargo
order by "salario funcionario" desc, pesnome asc;

-- MÃ©todo 2:

SELECT p.pescpf, p.pesnome, c.cargonome, c.cargosalario, COALESCE (sum( 
case when (EXTRACT (MONTH FROM v.vendadata) =  EXTRACT (MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM v.vendadata) =  EXTRACT (YEAR FROM CURRENT_DATE))
then v.vendacomissao else 0 end ),0) 
+ COALESCE (sum( 
case when (EXTRACT (MONTH FROM a.alugueldata) =  EXTRACT (MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM a.alugueldata) =  EXTRACT (YEAR FROM CURRENT_DATE))
then a.aluguelcomissao else 0 end ),0) as total_comissao, 
c.cargosalario + COALESCE (sum( 
case when (EXTRACT (MONTH FROM v.vendadata) =  EXTRACT (MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM v.vendadata) =  EXTRACT (YEAR FROM CURRENT_DATE))
then v.vendacomissao else 0 end ),0) 
+ COALESCE (sum( 
case when (EXTRACT (MONTH FROM a.alugueldata) =  EXTRACT (MONTH FROM CURRENT_DATE)
AND EXTRACT(YEAR FROM a.alugueldata) =  EXTRACT (YEAR FROM CURRENT_DATE))
then a.aluguelcomissao else 0 end ),0) as salario_mensal
FROM funcionario f
JOIN pessoa p ON p.pescpf = f.funpescpf 
JOIN cargo c ON f.funcargo = c.cargocod
LEFT JOIN venda v ON v.vendafunccpf = f.funpescpf
LEFT JOIN aluguel a ON a.aluguelfunccpf = f.funpescpf
GROUP BY p.pescpf, p.pesnome,c.cargonome, c.cargosalario
ORDER BY salario_mensal DESC, p.pesnome ASC;

/*6. Consulta que retorna todas as transaÃ§Ãµes(aluguel ou venda) de casas ou apartamentos.
Retorna o nÃºmero do contrato, o cÃ³digo do imÃ³vel, o valor total da transaÃ§Ã£o, o valor que
serÃ¡ passado para a imobiliÃ¡ria e a forma de pagamento utilizada.*/

SELECT a.aluguelcod as Contrato, a.aluguelimo as imovel, a.aluguelvalor as valor_total,
a.aluguelvalorimob as valor_para_imobiliaria, a.aluguelformpag as forma_pagamento
from aluguel a
join imovel im on im.imocod = a.aluguelimo
join casa ca on im.imocod = ca.casaimocod
union
SELECT a.aluguelcod, a.aluguelimo, a.aluguelvalor,
a.aluguelvalorimob, a.aluguelformpag
from aluguel a
join imovel i on i.imocod = a.aluguelimo
join apartamento apt on i.imocod = apt.aptimocod
union 
SELECT v.vendacod, v.vendaimo , v.vendavalor ,
v.vendavalorimob, v.vendaformpag as forma_pagamento  
from venda v
join imovel i on i.imocod = v.vendaimo
join casa c on i.imocod = c.casaimocod 
union
SELECT v.vendacod, v.vendaimo , v.vendavalor ,
v.vendavalorimob, v.vendaformpag as forma_pagamento  
from venda v
join imovel i on i.imocod = v.vendaimo
join apartamento a on a.aptimocod = i.imocod;



/*7.Consulta que retorna os clientes proprietÃ¡rios que possuem mais de um imÃ³vel.
Mostrar o nome, cpf, bairro e a quantidade de imÃ³veis.*/

select pesnome, pescpf, pesbairro as "endereco proprietario", count(pescpf) as "quantidade imovel" from pessoa
join clienteprop on clientepropclicpf = pescpf
group by pescpf
having count(pescpf) > 1
order by pesnome asc;

/*8.Consulta que retorna a quantidade de imÃ³veis que nÃ£o foram cadastrados nesse ano e
que ainda estÃ£o disponÃ­veis para venda ou aluguel. Agrupados por bairro e mostrando a 
quantidade de imÃ³veis.*/

SELECT imobairro, count(imobairro) AS "quantidade imovel" 
FROM imovel
WHERE imovel.imodisp NOT ILIKE 'indisponivel'
AND extract (year from imodatadisp) < extract (year from current_date)
GROUP BY imobairro
ORDER BY count(imobairro) DESC;

/*9. Consulta que retorna o cliente que realizou um aluguel e as suas indicaÃ§Ãµes.
Mostra o cÃ³digo do aluguel, o nome do cliente, celular do cliente, nome do indicado, 
celular do indicado.*/

CREATE OR REPLACE VIEW vw_indicados AS SELECT indalugcod, pesnome, indpescpf, pescelular
FROM indicado
JOIN pessoa ON indpescpf = pescpf;

SELECT aluguelcod as contrato, p.pesnome as cliente, p.pescelular as "celular cliente",
       i.pesnome as indicado, i.pescelular as "celular indicacao"
FROM aluguel
JOIN cliente ON aluguelcliuser = clipescpf
JOIN pessoa p ON clipescpf = p.pescpf
JOIN vw_indicados i ON aluguelcod = i.indalugcod;


/*10. Consulta que retorna as pessoas cadastradas no sistema e a quantidade de compra ou
locaÃ§Ã£o realizada, excluindo as pessoas que sÃ£o funcionÃ¡rios da imobiliÃ¡ria. Mostra o nome,
celular e a quantidade.*/

CREATE OR REPLACE VIEW vw_compradores AS 
SELECT pesnome as compradornome, pescpf as compradorcpf, vendacod as contrato
FROM venda
JOIN cliente on vendacliuser = clipescpf
JOIN pessoa on clipescpf = pescpf
union
SELECT pesnome, pescpf, aluguelcod 
FROM aluguel
JOIN cliente on aluguelcliuser = clipescpf
JOIN pessoa on clipescpf = pescpf;

SELECT pesnome, pescelular, count(compradornome) as comprou_alugou
from pessoa
left join vw_compradores ON compradorcpf = pescpf
where pescpf not in(select funpescpf from funcionario)
group by pesnome, pescelular
order by count(compradornome) DESC;
