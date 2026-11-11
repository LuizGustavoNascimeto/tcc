# Feedback de conteúdo — capítulos 1 e 2

## Veredito geral

**Precisa de revisão substancial antes de aprovação em TCC1.**

A critérios de sucesso ausentes e a um objetivo de segurança sem método, gera perguntas difíceis de banca já em TCC1.

Recomendação: não aprovar sem revisão de conteúdo. A revisão é viável sem trocar o tema, desde que o escopo seja delimitado e o Capítulo 2 ganhe as seções que faltam.

## Problemas críticos

### C2. Fundamentação não cobre os conceitos que a Introdução promete usar

=================esperar revisão do Campiolo

- **Evidência:** A Introdução invoca Istio/Envoy e balanceamento/criptografia/observabilidade (`capitulos/cap-introducao.tex:30-33`), retries e circuit breakers (`capitulos/cap-introducao.tex:44-47`, `:56-57`), malha de serviço como objetivo (`capitulos/cap-introducao.tex:74-75`) e segurança como objetivo (`capitulos/cap-introducao.tex:82-84`). No Capítulo 2, porém, não há seção nem parágrafo substantivo sobre HTTP/2, service mesh, Envoy/sidecar, TLS/mTLS, retries, timeout, circuit breaker, descoberta de serviço, balanceamento de carga, observabilidade, Kubernetes ou injeção de falhas. A única menção a Istio no Capítulo 2 é lateral, dentro de trabalhos relacionados (`capitulos/cap-conceitos.tex:107-109`).
- **Por que importa:** Fundamentação teórica, em banca, é o contrato do que o leitor precisa saber para julgar proposta e resultados. Se retries, circuit breaker e mTLS aparecem no experimento sem definição prévia, qualquer resultado posterior fica sem base interpretativa. É a lacuna mais provável de reprovação ou de exigência de reestruturação.
- **O que fazer:** Adicionar subseções ao Capítulo 2, antes de Trabalhos Relacionados, cobrindo no mínimo: HTTP/2 e transporte do gRPC; modos de streaming e deadline/cancelamento; service mesh, plano de dados/controle, sidecar Envoy e Istio; segurança com TLS/mTLS, autenticação/autorização; resiliência com timeout, retry, backoff, circuit breaker e idempotência; métricas e disponibilidade. Detalhe na seção "Lacunas de fundamentação" abaixo.

### C5. Problema de pesquisa não é operacionalizável: sem baseline, sem variáveis, sem delimitação do sistema

- **Evidência:** A pergunta é "como se comporta um sistema de microsserviços construído com gRPC quando avaliado simultaneamente quanto ao desempenho, à disponibilidade, à segurança e à tolerância a falhas, e até que ponto de carga ele mantém esse comportamento?" (`capitulos/cap-introducao.tex:61-63`). O objetivo geral repete a vagueza: "avaliar empiricamente o gRPC em um cenário de marketplace" (`capitulos/cap-introducao.tex:67`). Em nenhum ponto dos dois capítulos se declara: quais serviços do marketplace; quais operações serão exercitadas; comparação contra quê (sem Istio × com Istio? sem mTLS × com mTLS? sem retry × com retry?); modelo de carga (taxa aberta ou fechada, duração, aquecimento); ambiente (Kubernetes local, nuvem, hardware).
- **Por que importa:** Sem contraste experimental, "avaliar o gRPC" degenera em "medir um sistema específico em Go com Istio" — os efeitos de linguagem, malha, orquestrador e hardware ficam confundidos com o efeito do protocolo. A banca perguntará: "o que exatamente você está comparando, e o que contaria como o gRPC se comportar bem ou mal?" O texto hoje não responde.
- **O que fazer:** Delimitar em TCC1, mesmo que o detalhamento vá ao capítulo de proposta: (a) cenários comparados, idealmente fatorial mínimo — base sem malha, com Istio, com Istio+mTLS, com/sem mecanismos de resiliência; (b) variáveis independentes (carga, cenário, tipo de falha) e dependentes (p50/p90/p99, vazão, erro, CPU/memória, tempo de recuperação); (c) serviços e operações do marketplace no escopo; (d) hipótese ou expectativa orientadora, ainda que qualitativa. Sem isso, objetivos específicos não são verificáveis.

### C6. Objetivo de segurança não tem método, métrica nem fundamentação

- **Evidência:** "Analisar a segurança do sistema, considerando a superfície de ataque, a exposição a riscos e as vulnerabilidades conhecidas nas tecnologias empregadas" (`capitulos/cap-introducao.tex:82-84`). Não há definição de modelo de ameaças, técnica (modelagem de ameaças, varredura de CVEs, teste de configuração mTLS/autorização), nem critério de sucesso. O Capítulo 2 não contém nenhuma linha substantiva sobre TLS, mTLS, autenticação, autorização ou superfície de ataque.
- **Por que importa:** "Segurança" avaliada sem método vira opinião. É o objetivo com maior risco de a banca declarar inviável ou retórico. Também há tensão com a justificativa, que invoca "dados sensíveis de clientes e pagamentos" (`capitulos/cap-introducao.tex:91-94`): um marketplace experimental sem pagamentos reais não sustenta essa retórica sem delimitação.
- **O que fazer:** Reduzir o objetivo ao que é mensurável neste TCC. Sugestão de reformulação de escopo: avaliar (i) custo de desempenho do mTLS ligado/desligado e (ii) verificação de configuração — por exemplo, tráfego entre serviços cifrado e autenticado quando a política está ativa, com evidência observável. Se não houver capacidade para modelagem de ameaças e varredura de vulnerabilidades, remover "superfície de ataque/vulnerabilidades conhecidas" do objetivo ou rebaixar para trabalho futuro. Adicionar fundamentação de TLS/mTLS no Capítulo 2.

### C7. Disponibilidade é medida com instrumento de resiliência/recuperação

- **Evidência:** "Avaliar a disponibilidade e a tolerância a falhas [...] por meio do tempo médio de recuperação (MTTR) e da taxa de erros observada durante a falha" (`capitulos/cap-introducao.tex:79-81`). MTTR mede rapidez de recuperação após falha; taxa de erros durante falha mede degradação. Nenhum dos dois, isoladamente, é disponibilidade, que exige proporção de tempo/operações bem-sucedidas em janela definida (e, em formulações clássicas, relação com MTBF).
- **Por que importa:** Confundir disponibilidade com recuperação é erro conceitual clássico e provável pergunta de banca ("qual a diferença entre disponibilidade, confiabilidade e resiliência?"). Se o capítulo de resultados reportar MTTR chamando-o de disponibilidade, a conclusão fica tecnicamente incorreta.
- **O que fazer:** Separar os construtos na fundamentação e nos objetivos: disponibilidade = disponibilidade observada na janela do experimento (requisições bem-sucedidas/total, ou tempo disponível/tempo total); tolerância a falhas/resiliência = taxa de erros durante a falha, degradação de latência e tempo de recuperação, com definição operacional de início (injeção/detecção) e fim (retorno ao critério) da recuperação.

### C8. Ponto de ruptura é circular: depende de critérios que nunca são definidos

- **Evidência:** "Encontrar o ponto de ruptura do sistema, ou seja, o nível de carga em que ele deixa de atender aos critérios de desempenho e disponibilidade definidos para o experimento" (`capitulos/cap-introducao.tex:85-87`). Nenhum critério quantitativo aparece nos dois capítulos: não há limiar de p99, taxa de erro máxima, vazão mínima ou janela de sustentação.
- **Por que importa:** Sem limiar prévio, "ruptura" será o que o gráfico sugerir a posteriori — viés de confirmação e impossibilidade de replicação. É também a segunda metade da pergunta de pesquisa ("até que ponto de carga ele mantém esse comportamento?", `capitulos/cap-introducao.tex:61-63`), portanto a pergunta fica sem resposta possível.
- **O que fazer:** Definir já em TCC1, nem que revisável na proposta: por exemplo, ruptura = menor carga sustentada em que p99 > X ms ou taxa de erros > Y% por Z minutos, com X/Y/Z justificados (referência, requisito fictício do marketplace ou convenção declarada). Declarar também modelo de carga e passo de incremento.


=================esperar revisão do Campiolo
### C9. Deadline é promovido a "base dos mecanismos de tolerância a falhas" — e os mecanismos nunca chegam

- **Evidência:** Não há discussão adiante: o Capítulo 2 termina em trabalhos relacionados sem tratar de timeout versus deadline, propagação de deadline entre chamadas encadeadas, cancelamento, retry, backoff ou circuit breaker.
- **Por que importa:** Retry sem idempotência pode duplicar efeitos, e circuit breaker é mecanismo distinto, tipicamente no cliente ou no proxy. A banca pode pedir: "explique como deadline, isolado, tolera falha" — não tolera; apenas falha rápido.
- **O que fazer:** Escrever a seção de resiliência prometida, incluindo: deadline versus timeout por tentativa; propagação em cadeias A→B→C; retry com backoff e jitter; risco de retry storm; circuit breaker (estados fechado/aberto/meio-aberto); idempotência e semântica de entrega (no máximo uma vez / pelo menos uma vez), sem a qual retry não é seguro de recomendar.

### C10. Lacuna da literatura é afirmada a partir de seis trabalhos, sem método de busca

- **Evidência:** "Nenhum avalia, em um mesmo sistema, desempenho, disponibilidade, segurança e tolerância a falhas, nem o impacto de uma malha de serviço completa ou o ponto de ruptura. É nessa lacuna que este trabalho se posiciona" (`capitulos/cap-conceitos.tex:118-121`). A revisão cobre apenas seis trabalhos (`capitulos/cap-conceitos.tex:94-116`), nenhum deles sobre segurança/mTLS, e não declara bases consultadas, termos de busca, período ou critérios de inclusão/exclusão.
- **Por que importa:** Afirmação universal ("nenhum") a partir de amostra pequena e enviesada é o tipo de frase que banca ataca primeiro. Note ainda: existe na bibliografia uma avaliação de service mesh não citada em nenhum dos dois capítulos (`ServiceMesh-Evaluation:2022`, `main.bib:80-89`), o que enfraquece a alegação de que malha completa não foi avaliada por outros.
- **O que fazer:** Rebaixar para "entre os trabalhos revisados, nenhum..." e declarar o procedimento de busca (bases, strings, data, critérios), mesmo que breve. Incluir ao menos um trabalho sobre custo de mTLS/service mesh — a entrada já presente na bibliografia é ponto de partida, mas deve ser lida e citada de fato, ou removida. Adicionar uma tabela comparativa dos trabalhos relacionados (dimensões avaliadas × este trabalho) torna a lacuna visualmente verificável em vez de declaratória.

---

## Problemas médios

=================esperar revisão do Campiolo
### M1. HTTP/2 é citado como transporte, mas nunca explicado

A Introdução afirma que o gRPC "utiliza o HTTP/2 como protocolo de transporte" (`capitulos/cap-introducao.tex:27-29`), e o Capítulo 2 não volta ao tema. Sem multiplexação, frames binários, compressão de cabeçalhos (HPACK), controle de fluxo e streams sobre uma única conexão TCP, o leitor não tem como entender por que gRPC diferiria de RPC sobre HTTP/1.1, nem de onde vêm ganhos e limitações (por exemplo, head-of-line blocking em nível TCP). Seção curta resolve.

=================esperar revisão do Campiolo
### M2. Protocol Buffers é definido, mas seu mecanismo e suas consequências não

O Capítulo 2 diz o que Protobuf é e que `.proto` é contrato (`capitulos/cap-conceitos.tex:81-90`), mas não explica: codificação binária e números de campo; por que tende a ser menor/mais rápido que JSON (e que isso depende de payload e implementação); regras de evolução de esquema (adicionar/remover campos, compatibilidade); versionamento. Como a reputação de eficiência do gRPC é o mote do problema (`capitulos/cap-introducao.tex:38-40`), a fundamentação precisa dar ao leitor o mecanismo causal, não só a definição. Incluir um exemplo mínimo de `.proto` de um serviço do marketplace (três a seis linhas comentadas) teria alto valor didático por custo baixo.

### M4. Consistência e segurança são anunciadas como desafios e depois abandonadas

A Introdução lista "latência, falhas parciais, consistência de dados e segurança na comunicação" como desafios trazidos pela distribuição (`capitulos/cap-introducao.tex:18-20`). O Capítulo 2 desenvolve só os dois primeiros (`capitulos/cap-conceitos.tex:26-36`) e declara que essas são "duas consequências centrais para este trabalho" — sem dizer o que acontece com consistência e segurança. Se consistência está fora do escopo (provável e legítimo), declarar explicitamente a exclusão e o motivo. Silêncio vira cobrança.

### M7. Escopo grande demais para um TCC sem recorte visível

Quatro atributos de qualidade × sistema de marketplace implementado × Istio × injeção de falhas × ponto de ruptura é escopo de dissertação enxuta. Os dois capítulos não mostram recorte: quantos serviços, quantas operações, quantos cenários fatoriais. Cada cenário adicional multiplica execuções (carga × falha × configuração). A banca de TCC1 deve exigir a matriz de experimentos, ainda que preliminar, e o plano de redução: por exemplo, segurança restrita ao custo do mTLS (ver C6), streaming fora do escopo (ver C4), consistência fora do escopo (ver M4).


PROPOSTA
### M8. Metodologia de medição não é sequer esboçada

Nada nos dois capítulos indica: ferramenta de geração de carga; número de repetições; aquecimento (warm-up); descarte de transientes; intervalos de confiança ou dispersão; sincronização de relógios, se relevante; especificação de hardware/ambiente; como CPU/memória serão atribuídas (processo, contêiner, nó). Percentis sem esses cuidados são frágeis — p99 com poucas amostras é ruído. Não se exige o protocolo completo em TCC1, mas exige-se reconhecer as ameaças à validade e apontar onde serão tratadas.

### M9. Figura única, sem contrapartida visual para os conceitos centrais do experimento

O Capítulo 2 tem uma só figura, o diagrama de RPC adaptado (`capitulos/cap-conceitos.tex:46-54`). Faltam, e a banca tende a pedir: (a) diagrama de arquitetura monolito × microsserviços ou do caminho de uma chamada com sidecar (cliente → Envoy → serviço → Envoy → serviço), que tornaria concreto o "custo por chamada"; (b) tabela comparativa — candidatos: modos de comunicação (REST/JSON, gRPC, mensageria) ou trabalhos relacionados × dimensões avaliadas (ver C10). A legenda "setas tracejadas indicam comunicação interna enquanto as setas sólidas indicam comunicação via rede" (`capitulos/cap-conceitos.tex:62-64`) deve ser conferida contra a figura real: se a convenção visual não for exatamente essa, o texto descreve outra figura.

=================esperar revisão do Campiolo
### M10. Organização do texto promete estrutura que deve ser conferida contra o sumário final

A Introdução declara cinco capítulos e funde proposta+avaliação em um capítulo (`capitulos/cap-introducao.tex:106-114`). Isso é aceitável, mas, dado o volume de método envolvido (ambiente, carga, falhas, métricas), a fusão pode espremer a metodologia. A banca pode sugerir capítulo próprio de metodologia/experimentos. Decisão estrutural a tomar já, não na véspera.

---

## Melhorias menores / oportunidades

1. **"Apenas quando o sistema é grande o bastante"** (`capitulos/cap-introducao.tex:20-22`) é vago e sem citação: grande em quê — usuários, equipes, taxa de requisições? Ou quantificar/orientar por critério conhecido, ou suavizar para uma frase sobre trade-off sem limiar implícito.
2. **"Em geral em máquinas diferentes"** (`capitulos/cap-conceitos.tex:20-21`): microsserviços podem coexistir no mesmo nó (contêineres/pods distintos). "Processos distintos, frequentemente em máquinas diferentes" é mais preciso e mantém o argumento.
3. **"Servidor em outra máquina"** na definição de gRPC (`capitulos/cap-conceitos.tex:71-73`): mesma ressalva — pode ser outro processo na mesma máquina. A definição da documentação citada não exige máquinas distintas.
4. **Exemplo Java/Go/Python** (`capitulos/cap-conceitos.tex:87-89`) é bom, mas o experimento é em Go (`capitulos/cap-introducao.tex:71-73`): vale dizer que, neste trabalho, cliente e servidor são Go, e a poliglossia é propriedade da tecnologia, não do experimento — evita expectativa errada.
5. **Siglas e símbolos:** a lista de acrônimos cobre CPU, gRPC, HTTP/2, MTTR e RPC (`PreTexto/lista-acronimos.tex:10-16`), mas o texto já usa ou usará TLS/mTLS, REST, API e possivelmente SLO, que deverão entrar na lista quando a fundamentação for expandida. A lista de símbolos define p50/p90/p99 apenas como "latência no percentil" (`PreTexto/lista-simbolos.tex:10-15`); a fundamentação deve explicar por que percentis, e não média — média esconde cauda, e é a cauda que o usuário percebe em cadeias de chamadas.
6. **Referências a "cenário realista"** (`capitulos/cap-introducao.tex:41`, `:52`) aparecem duas vezes sem definição. Realista em quê: topologia, mistura de operações, distribuição de carga, dados? Definir ou trocar por "cenário experimental inspirado em marketplace", que é o que o objetivo de fato promete (`capitulos/cap-introducao.tex:71-73`).
7. **Oportunidade:** uma frase de hipótese qualitativa ao fim do problema ("espera-se que mTLS e retries elevem p99 e reduzam vazão máxima, deslocando o ponto de ruptura para cargas menores") tornaria os resultados falsificáveis e daria à conclusão algo para confirmar ou refutar. O gabarito do próprio capítulo menciona formulação de hipóteses entre os itens esperados de uma introdução.

---

## Lacunas de fundamentação (conceitos a adicionar e onde entrariam)

Em ordem de leitura sugerida dentro do Capítulo 2, após a seção atual de RPC e dentro/ao redor da seção de gRPC, sempre antes de Trabalhos Relacionados:

| # | Conceito a adicionar | Onde entra | Por que é indispensável aqui |
|---|---|---|---|
| 1 | Comunicação síncrona × assíncrona (e justificativa da escolha) | Nova seção entre microsserviços e RPC, cumprindo `cap-conceitos.tex:10-14` | Sustenta a decisão arquitetural central (C3) |
| 2 | HTTP/2: multiplexação, frames, HPACK, controle de fluxo, conexão única TCP e seus limites | Subseção na seção gRPC | A Introdução o nomeia como transporte (`cap-introducao.tex:27-29`); sem ele, "eficiência" é slogan (M1) |
| 3 | Quatro modos de chamada gRPC + delimitação do usado | Seção gRPC, corrigindo `cap-conceitos.tex:73-76` | Corrige erro factual (C4) |
| 4 | Deadline, timeout, cancelamento e propagação de contexto | Seção gRPC ou nova seção de resiliência | Corrige C9; pré-requisito de retries em cadeia |
| 5 | Protobuf: codificação binária, números de campo, evolução de esquema; exemplo `.proto` | Seção gRPC, expandindo `cap-conceitos.tex:81-90` | Dá mecanismo causal à eficiência alegada (M2) |
| 6 | Service mesh: plano de controle × plano de dados, sidecar, Istio e Envoy; o que a malha faz e não faz | Nova seção após gRPC | Objetivo específico depende disso (`cap-introducao.tex:74-75`); corrige M5 |
| 7 | Descoberta de serviço e balanceamento de carga (cliente × proxy/L7) | Nova seção ou dentro de service mesh | Trabalhos relacionados já discutem L7 × cliente (`cap-conceitos.tex:102-104`) sem base conceitual prévia |
| 8 | Segurança: TLS, mTLS, autenticação de identidade de serviço, autorização; modelo de ameaça mínimo | Nova seção | Objetivo de segurança hoje é retórica sem base (C6) |
| 9 | Resiliência: retry com backoff/jitter, circuit breaker, bulkhead (se citado), idempotência, semântica de entrega, retry storm | Nova seção | Introdução e objetivos prometem medir isso (`cap-introducao.tex:44-47`, `:79-81`) |
| 10 | Disponibilidade × confiabilidade × resiliência; MTTR e MTBF; definição operacional adotada | Nova seção curta ou dentro de resiliência | Corrige C7 e dá régua ao objetivo de falhas |
| 11 | Latência em percentis e cauda longa; vazão; saturação e lei de Little (se for usada); ponto de ruptura/saturação | Nova seção de métricas e avaliação de desempenho | Sustenta objetivos de desempenho e ruptura (`cap-introducao.tex:76-87`); corrige C8 |
| 12 | Injeção de falhas e experimentação: tipos de falha (queda de réplica, latência induzida, erro), estado estacionário, repetições | Nova seção ou ponte para Trabalhos Relacionados | Objetivos falam em "falha induzida" (`cap-introducao.tex:79-81`) sem vocabulário definido |
| 13 | Observabilidade mínima (métricas, logs, traces) — apenas o que será usado | Dentro de service mesh | A Introdução promete observabilidade via Istio (`cap-introducao.tex:32-33`); se não for medida, delimitar como fora de escopo |

Conceitos presentes que arriscam ficar órfãos se o experimento não os usar: streaming (se só houver chamadas unárias, declarar delimitação — C4) e o exemplo poliglota de Protobuf (M4 das melhorias). Conceitos prometidos na Introdução e ausentes na fundamentação: todos os itens 2, 6, 8, 9 e 11 acima, além de consistência, que deve ser incluída ou explicitamente excluída (M4 dos problemas médios).

---

## Checagem afirmação × fonte

| Afirmação (local) | Fonte citada | Respaldo suficiente? |
|---|---|---|
| Microsserviços consolidaram-se na década de 2010 como alternativa a monolitos (`cap-introducao.tex:12-14`) | Newman (2015) | **Suficiente** como enquadramento histórico; fonte é referência primária da área. |
| Decomposição traz latência, falhas parciais, consistência e segurança (`cap-introducao.tex:18-20`) | Newman (2015) | **Parcial.** Plausível e atribuível, mas o Capítulo 2 só desenvolve dois dos quatro desafios (ver M4). |
| Arquitetura "compensa apenas quando o sistema é grande o bastante" (`cap-introducao.tex:20-22`) | Nenhuma | **Insuficiente.** Afirmação com limiar implícito, sem critério nem fonte (ver Melhoria 1). |
| gRPC usa HTTP/2 e Protobuf (`cap-introducao.tex:27-30`) | `gRPC-Introduction:2026` | **Parcial.** Conteúdo correto, mas a entrada bibliográfica declara ano 2015 e autor individual para uma página institucional viva (`main.bib:127-133`); a chave diz 2026. Corrigir metadados e data de acesso. |
| Em produção, gRPC combina-se com Envoy/Istio, que adicionam balanceamento, criptografia e observabilidade (`cap-introducao.tex:30-33`) | Nenhuma | **Insuficiente.** Afirmação forte sem citação; existe fonte pertinente não usada na bibliografia (`ServiceMesh-Evaluation:2022`, `main.bib:80-89`). |
| É menos comum avaliar desempenho, disponibilidade, segurança e tolerância a falhas em conjunto (`cap-introducao.tex:40-47`, repetido em `:50-60`) | Apenas `PerformanceEvaluation:2024` para a premissa | **Insuficiente como afirmação sobre a literatura.** Sustentável apenas com método de busca declarado (ver C10). |
| Proxies adicionam latência e CPU a cada chamada (`cap-introducao.tex:53-56`) | TCC UFPE (2022) + HotOS (2025) | **Parcial.** Direção plausível; universalidade e magnitude não transferíveis sem contexto (ver M6). Fonte primária de medição é trabalho de graduação — usar como indício, não como lei. |
| Definição de sistema distribuído e consequências (latência, falhas parciais) (`cap-conceitos.tex:21-36`) | Coulouris et al. (2013) | **Suficiente.** Livro-texto clássico, adequado para fundamentos. Ressalva: é a única fonte para todo o alicerce teórico do capítulo — aceitável para conceitos estáveis, insuficiente para práticas atuais de microsserviços/nuvem. |
| Stub faz marshalling, bloqueia, faz unmarshalling (`cap-conceitos.tex:56-62`) | Coulouris et al. (2013), com figura à p. 201 | **Suficiente para RPC clássico síncrono**; incompleto para gRPC assíncrono e lado servidor (ver M3). Conferir a convenção de setas da figura (ver M9). |
| Deadline encerra a chamada com `DEADLINE_EXCEEDED` (`cap-conceitos.tex:76-78`) | Documentação gRPC | **Suficiente** quanto ao fato; **insuficiente** o corolário "base dos mecanismos de tolerância a falhas" (ver C9). Metadados da fonte com ano inconsistente (`main.bib:134-140`). |
| gRPC oferece chamadas unárias e streaming bidirecional (`cap-conceitos.tex:73-76`) | Documentação gRPC | **A fonte respalda mais do que o texto diz:** a documentação lista quatro modos. O texto está incompleto (ver C4). |
| Protobuf é neutro, extensível, para serializar dados estruturados (`cap-conceitos.tex:81-84`) | Documentação Protobuf (2026) | **Suficiente** como definição; não respalda nenhuma alegação de desempenho, que o texto, corretamente, não quantifica — mas também não explica o mecanismo (ver M2). |
| gRPC teve menores tempos e menor CPU que REST/GraphQL sob 100–500 requisições concorrentes (`cap-conceitos.tex:94-97`) | Niswar et al. (2024) | **Parcial.** Artigo em periódico, pertinente; faltam contexto metodológico (hardware, repetições, payload) e conferência do que "100 a 500" mede na fonte (concorrência? total de requisições?). Sem isso, o número não é reutilizável. |
| Migração para gRPC reduziu p50 em ~50% e aumentou vazão em 114% (`cap-conceitos.tex:97-100`) | TCC UFSC (2025), estudo de caso | **Fraco como evidência sobre gRPC** — o próprio texto admite que o efeito não é isolado (cache e outras melhorias). Manter apenas como relato de prática, nunca como suporte à eficiência do protocolo. |
| Proxy L7 adiciona ~1 ms/chamada e consome mais que balanceamento no cliente (`cap-conceitos.tex:102-104`) | TCC UFPE (2022) | **Fraco a parcial.** Medição única, de trabalho de graduação, sem contexto experimental reproduzido no texto. Não generalizar para Istio sem ressalva (ver M6). |
| Empilhamento de protocolos e sidecars são fontes de latência/CPU (`cap-conceitos.tex:104-107`) | Zhu et al., HotOS (2025) | **Suficiente como posicionamento de pesquisa** (workshop de ideias, fonte primária dos autores); não é medição neutra — é a motivação da proposta deles. Tratar como argumento, não como dado. |
| ResilienceBench automatiza avaliação de resiliência com injeção via Envoy (`cap-conceitos.tex:111-113`) | Aderaldo & Mendonça, SBES (2025) | **Suficiente** como descrição de ferramenta correlata; não respalda nada sobre o comportamento do sistema a ser construído. |
| FastFI reduz em >76% o tempo de experimentos de injeção (`cap-conceitos.tex:113-116`) | Tan et al. (2026), "Just Accepted" (`main.bib:22`) | **Parcial.** Fonte primária, porém ainda não publicada em versão final; o número descreve a ferramenta deles, não o seu experimento. Relevância para este TCC é metodológica e deve ser explicitada ou o trabalho deve sair da revisão. |
| "Nenhum avalia [as quatro dimensões] em um mesmo sistema" (`cap-conceitos.tex:118-121`) | Síntese dos seis trabalhos | **Insuficiente.** Ver C10. |

Observações transversais de citação: (i) concentração excessiva em Coulouris (2013) para todo o fundamento distribuído — incluir ao menos uma referência contemporânea de microsserviços/engenharia de sistemas em nuvem para práticas pós-2013; (ii) duas fontes de trabalhos relacionados são TCCs de graduação — legítimos como correlatos nacionais, frágeis como base de afirmações quantitativas; (iii) as chaves `gRPC-Introduction:2026` e `gRPC-Documentation:2026` apontam para entradas com `year = {2015}` (`main.bib:130`, `main.bib:137`) — a referência renderizada não dirá 2026, e a atribuição de autoria individual a documentação institucional deve ser revista; (iv) `FastFI:2026` está marcado "Just Accepted" (`main.bib:22`) — citar com essa ressalva ou aguardar publicação; (v) entradas nunca citadas nos dois capítulos (`ServiceMesh-Evaluation:2022`, `SDInterview:2022`) devem ser usadas onde pertinentes ou removidas da bibliografia final.

---

## Perguntas prováveis de banca

1. **"O que você está comparando? Avaliar o gRPC em relação a quê?"** — O texto hoje não responde (C5). Resposta esperada: matriz de cenários (sem malha × Istio × Istio+mTLS × resiliência ligada/desligada) e declaração do que é atribuível ao protocolo versus à malha, à linguagem e ao ambiente.
2. **"Quais são seus critérios de sucesso e de ruptura, numericamente?"** — O texto hoje não responde (C8). Resposta esperada: limiares pré-registrados de p99, taxa de erros e tempo de sustentação, com justificativa.
3. **"MTTR é disponibilidade?"** — Não; o texto hoje sugere que sim (C7). Resposta esperada: distinguir disponibilidade, confiabilidade e resiliência, e redefinir as métricas de cada objetivo.
4. **"Como deadline tolera falhas? E retry em operação não idempotente, o que acontece?"** — O texto hoje não responde e ainda promete discussão que não existe (C9). Resposta esperada: deadline/cancelamento propagado, backoff com jitter, circuit breaker, idempotência e risco de tempestade de retries.
5. **"Quais são os quatro modos de chamada do gRPC e qual você usa?"** — O texto hoje lista dois (C4). Resposta esperada: os quatro modos e a delimitação do experimento.
6. **"Por que HTTP/2 importa para o gRPC? Onde está o gargalo: multiplexação resolve tudo?"** — O texto hoje não responde (M1). Resposta esperada: multiplexação, HPACK, controle de fluxo e o limite do head-of-line blocking em TCP.
7. **"Como você avaliou segurança? Qual seu modelo de ameaças?"** — O texto hoje não responde (C6). Resposta esperada: escopo reduzido e verificável (custo do mTLS + verificação de configuração) ou método explícito.
8. **"Sua lacuna é 'nenhum trabalho avalia tudo junto'. Quantos trabalhos você revisou e como buscou?"** — O texto hoje sustenta a frase com seis trabalhos (C10). Resposta esperada: procedimento de busca e frase rebaixada para o corpus revisado, com tabela comparativa.
9. **"O 1 ms do proxy e os 50%/114% do estudo de caso valem para o seu cenário?"** — O texto hoje transporta os números sem contexto (M6). Resposta esperada: condições originais das medições e por que são indício, não premissa.
10. **"Por que comunicação síncrona, e não mensageria, no marketplace?"** — Prometido e não entregue (C3). Resposta esperada: trade-offs de acoplamento, latência e consistência, e o recorte adotado.
11. **"O que é o marketplace do experimento: serviços, operações, dados, carga?"** — Ausente dos dois capítulos (C5/M7). Resposta esperada: recorte mínimo nomeado já em TCC1.
12. **"Quantas repetições, qual aquecimento, qual ambiente? Seu p99 tem quantas amostras?"** — Ausente (M8). Resposta esperada: protocolo de medição e ameaças à validade reconhecidas.

---

## Plano de revisão priorizado

1. **Eliminar a duplicação do problema** (C1): fundir `cap-introducao.tex:38-60` em um único parágrafo, mantendo a versão com citações de proxy/resiliência.
2. **Delimitar problema e experimento** (C5): escrever, ainda na Introdução, cenários comparados, serviços/operações do marketplace no escopo, variáveis independentes/dependentes e expectativa/hipótese qualitativa. Sem este item, todos os demais perdem a régua.
3. **Definir critérios de sucesso e de ruptura** (C8): limiares numéricos pré-registrados para p99, erros e sustentação de carga; declarar modelo de carga.
4. **Corrigir os construtos de disponibilidade e resiliência** (C7): separar definições na fundamentação e ajustar o objetivo específico correspondente (MTTR → recuperação; disponibilidade → proporção observada em janela).
5. **Recortar o objetivo de segurança** (C6): custo de mTLS + verificação de configuração, ou método explícito; alinhar a justificativa de "pagamentos/dados sensíveis" ao que o sistema experimental realmente terá.
6. **Escrever as seções que faltam no Capítulo 2** (C2), nesta ordem: síncrono × assíncrono (C3); HTTP/2 (M1); modos de chamada e deadline/cancelamento (C4, C9); service mesh/Istio/Envoy e balanceamento (M5); TLS/mTLS (C6); resiliência — retry, backoff, circuit breaker, idempotência (C9); métricas, percentis e ponto de ruptura; injeção de falhas. Incluir diagrama do caminho da chamada com sidecar e exemplo `.proto` (M2, M9).
7. **Corrigir os erros factuais pontuais**: quatro modos de streaming (C4); deadline como pré-condição, não base (C9); "Istio provê disponibilidade" (M5); "máquinas diferentes" (Melhorias 2–3).
8. **Rebaixar e sustentar a lacuna da literatura** (C10): declarar busca, trocar "nenhum" por "entre os revisados", usar ou remover `ServiceMesh-Evaluation:2022`, e adicionar tabela comparativa trabalhos × dimensões.
9. **Contextualizar ou remover números transportados** (M6): 1 ms de proxy e 50%/114% do estudo de caso só permanecem com condições de medição e ressalva de transferibilidade.
10. **Ajustar citações e metadados**: corrigir ano/autoria das entradas de documentação gRPC (`main.bib:127-140`), ressalvar FastFI "just accepted", reduzir dependência quantitativa em TCCs de graduação e equilibrar Coulouris (2013) com referência contemporânea.
11. **Esboçar o protocolo de medição** (M8): ferramenta de carga, repetições, aquecimento, ambiente/hardware e tratamento estatístico mínimo — nem que seja um parágrafo apontando para o capítulo de proposta.
12. **Decidir a estrutura final** (M10): confirmar se proposta e avaliação cabem em um capítulo ou se metodologia/experimentos ganham capítulo próprio, e alinhar `cap-introducao.tex:106-114` ao sumário real.

---

*Escopo desta avaliação: conteúdo dos capítulos 1 e 2 (`capitulos/cap-introducao.tex`, `capitulos/cap-conceitos.tex`), com conferência de `main.bib` apenas quanto ao respaldo das afirmações e consulta pontual às listas de acrônimos e símbolos. Revisão gramatical e de forma ABNT está fora deste parecer.*
