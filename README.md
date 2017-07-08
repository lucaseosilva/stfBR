stfBR package
================
Lucas E. O. Silva

Sobre o pacote
--------------

O pacote `stfBR` extrai todos os meta-dados referentes às Ações de Controle Concentrado de Constitucionalidade do [Supremo Tribunal Federal (STF)](http://www.stf.jus.br/portal/peticaoInicial/pesquisarPeticaoInicial.asp).

Como funciona
-------------

A extração é realizada através da função `extractProcess()`. Nela, o usuário precisará informar três parâmetros: `categoria`, `minimo` e `maximo`.

1.  `categoria`: se refere ao tipo de ação desejada (ADIN, ADPF, ADCN, ADOM);
2.  `minimo`: se refere ao valor de início do intervalo desejado (por default, `minimo`=1);
3.  `maximo`: se refere ao limite do intervalo desejado. Caso não seja informado, será assumido o valor das últimas ações presentes no site do STF no dia 06 de julho de 2017 (ADIN = 5740, ADPF = 471, ADCN = 46 e ADOM = 41).

Retorno
-------

Ao fim do procedimento, a função retorna um dataframe com 26 variáveis com as especificações de cada ação:

1.  tipo;
2.  num\_acao;
3.  url\_peticao;
4.  url\_acompanhamento;
5.  nome\_completo;
6.  origem;
7.  relator;
8.  requerente;
9.  requerido;
10. entrada;
11. distribuido;
12. dispositivo;
13. fundamentacao;
14. resultado\_liminar;
15. decisao\_plenario\_liminar;
16. data\_plenario\_liminar;
17. data\_publicacao\_liminar;
18. resultado\_final;
19. decisao\_final;
20. data\_julgamento\_final;
21. data\_publicacao\_final;
22. decisao\_mono\_final;
23. decisao\_mono\_liminar;
24. incidentes;
25. ementa;
26. indexacao.
