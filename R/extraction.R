#' Capturar processos
#'
#' Esta função captura os meta-dados de todas as ações de controle concentrado
#' do Supremo Tribunal Federal (STF). Para isso, o usuário precisa especificar
#' apenas a categoria da ação (ADIN, ADPF, ADCN ou ADOM) e o tamanho mínimo da série
#' de processos que ele deseja (min = 1 é o default, com isso coleta todas as ações
#' uma categoria)
#'
#' @param infile O tipo de ação e o intervalo mínimo
#' @return Um dataframe com os meta-dados das ações  
#' @export
#' 
extractProcess <- function(categoria = cat, min = 1){
  
  processos <- data.frame()
  
  url_base <- "http://www.stf.jus.br/portal/peticaoInicial/verPeticaoInicial.asp?base=TIPO&s1=%20$%20&processo=NUM"
  
  
  # valores atualizados em 06 de julho de 2017 - 10:00
  switch(categoria,
         ADIN={max=5740},
         ADPF={max=471},
         ADCN={max=46},
         ADOM={max=41}
  )
  
  j=min
  i=min
  while(j<=max){
    while(i>=min){
      url_peticao <- gsub("TIPO",categoria,url_base)
      url_peticao <- gsub("NUM",i,url_peticao)
      
      pagina_peticao <- GET(url_peticao) %>% read_html(options = "HUGE") 
      
      check <- pagina_peticao %>% 
        html_nodes(xpath = '//*[@id="corpo"]/div[2]/text()') %>%
        html_text()
      check<-str_replace_all(check, "[\r\n\t]" , "")
      ifelse(!is.na(check[3]), ifelse(str_detect(check[3],"Nenhum resultado foi encontrado !"), break, no = "" ), no = "")
      
      tipo <- categoria
      num <- i
      titulo <- pagina_peticao %>% 
        html_node(xpath = '//*[@id="divImpressao"]/div/h3/strong') %>%
        html_text()
      
      cabecalho1 <- pagina_peticao %>%
        html_nodes(xpath = '//table//strong') %>%
        html_text()
      cabecalho1 <- str_replace_all(cabecalho1, "[\r\n\t]" , "")
      
      corpo1 <- pagina_peticao %>% 
        html_nodes(xpath = '///*[@id="divImpressao"]/pre') %>%
        html_text()
      
      informacoes_corpo <- str_replace_all(corpo1, "[\r\n\t]" , "")
      
      link_acompanhamento <- pagina_peticao %>% 
        html_node(xpath = '//*[@id="divNaoImprimir"]/div[2]/a') %>%
        html_attr("href")
      link_acompanhamento <- str_replace(link_acompanhamento, "..", "http://www.stf.jus.br/portal")
      
      informacao <- pagina_peticao %>% 
        html_nodes(xpath = '///*[@id="divImpressao"]/b') %>%
        html_text()
      
      dispositivo <- informacoes_corpo[grepl("Dispositivo Legal Questionado",informacao)]   
      fundamentacao <- informacoes_corpo[grepl("Fundamentação Constitucional",informacao)]
      resultado_liminar <- informacoes_corpo[grepl("Resultado da Liminar",informacao)]
      decisao_plenario_liminar <- informacoes_corpo[grepl("Decisão Plenária da Liminar",informacao)]
      data_plenario_liminar <- informacoes_corpo[grepl("Data de Julgamento Plenário da Liminar",informacao)]
      data_publicacao_liminar <- informacoes_corpo[grepl("Data de Publicação da Liminar",informacao)]
      resultado_final <- informacoes_corpo[grepl("Resultado Final",informacao)]
      decisao_final <- informacoes_corpo[grepl("Decisão Final",informacao)]
      data_julgamento_final <- informacoes_corpo[grepl("Data de Julgamento Final",informacao)]
      data_publicacao_final <- informacoes_corpo[grepl("Data de Publicação da Decisão Final",informacao)]
      decisao_mono_final <- informacoes_corpo[grepl("Decisão Monocrática Final",informacao)]  
      decisao_mono_liminar <- informacoes_corpo[grepl("Decisão Monocrática da Liminar",informacao)] 
      incidentes <- informacoes_corpo[grepl("Incidentes",informacao)]
      ementa <- informacoes_corpo[grepl("Ementa",informacao)]
      indexacao <- informacoes_corpo[grepl("Indexação",informacao)]
      
      dispositivo <- ifelse(length(dispositivo) == 0, NA, dispositivo)
      fundamentacao <- ifelse(length(fundamentacao) == 0, NA, fundamentacao)
      resultado_liminar <- ifelse(length(resultado_liminar) == 0, NA, resultado_liminar)
      decisao_plenario_liminar <- ifelse(length(decisao_plenario_liminar) == 0, NA, decisao_plenario_liminar)
      data_plenario_liminar <- ifelse(length(data_plenario_liminar) == 0, NA, data_plenario_liminar)
      data_publicacao_liminar <- ifelse(length(data_publicacao_liminar) == 0, NA, data_publicacao_liminar)
      resultado_final <- ifelse(length(resultado_final) == 0, NA, resultado_final)
      decisao_final <- ifelse(length(decisao_final) == 0, NA, decisao_final)
      data_julgamento_final <- ifelse(length(data_julgamento_final) == 0, NA, data_julgamento_final)
      data_publicacao_final <- ifelse(length(data_publicacao_final) == 0, NA, data_publicacao_final)
      decisao_mono_final <- ifelse(length(decisao_mono_final) == 0, NA, decisao_mono_final)   
      incidentes <- ifelse(length(incidentes) == 0, NA, incidentes)
      decisao_mono_liminar <- ifelse(length(decisao_mono_liminar) == 0, NA, decisao_mono_liminar)
      ementa <- ifelse(length(ementa) == 0, NA, ementa)
      indexacao <- ifelse(length(indexacao) == 0, NA, indexacao)
      
      processo <- data.frame(tipo = tipo,
                             num_acao = num,
                             url_peticao = url_peticao,
                             url_acompanhamento = link_acompanhamento,
                             nome_completo = titulo,
                             origem = cabecalho1[1],
                             relator = cabecalho1[3],
                             partes = cabecalho1[5],
                             entrada = cabecalho1[2],
                             distribuido = cabecalho1[4],
                             dispositivo = dispositivo,   
                             fundamentacao = fundamentacao,
                             resultado_liminar = resultado_liminar, 
                             decisao_plenario_liminar = decisao_plenario_liminar, 
                             data_plenario_liminar = data_plenario_liminar, 
                             data_publicacao_liminar = data_publicacao_liminar, 
                             resultado_final = resultado_final , 
                             decisao_final = decisao_final, 
                             data_julgamento_final = data_julgamento_final, 
                             data_publicacao_final = data_publicacao_final, 
                             decisao_mono_final = decisao_mono_final, 
                             decisao_mono_liminar = decisao_mono_liminar,
                             incidentes = incidentes,
                             ementa = ementa,
                             indexacao = indexacao, stringsAsFactors = F)
      
      processo <- separate(processo, partes, c('requerente', 'requerido'), sep='Requerido :', remove=T)
      processo$requerente <- gsub("Requerente: ","",processo$requerente)
      processos <- bind_rows(processos, processo)
      i=i+1
      j=j+1
    }
    i=i+1
    j=j+1
  }
  return(processos)
}