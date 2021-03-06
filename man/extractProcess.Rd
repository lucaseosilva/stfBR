% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/extraction.R
\name{extractProcess}
\alias{extractProcess}
\title{Capturar processos}
\usage{
extractProcess(categoria, min = 1)
}
\arguments{
\item{categoria}{O tipo de acao: ADIN, ADPF, ADCN ou ADOM}

\item{minimo}{Inicio da serie de processos a ser coletada. min = 1 e o default}

\item{maximo}{Fim da serie de processos}
}
\value{
Um dataframe com os meta-dados das acoes
}
\description{
Esta funcao captura os meta-dados de todas as acoes de controle concentrado
do Supremo Tribunal Federal (STF).
}
\details{
Os limites sao atualizados pelo autor do pacote conforme as atualizacoes do STF
}
