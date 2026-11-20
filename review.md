# Revisão de banca — TCC 1

**Documento:** Proposta de Trabalho de Conclusão de Curso  
**Título no PDF:** Desenvolvimento e avaliação de aplicações distribuídas usando gRPC  
**Autor:** Luiz Gustavo do Nascimento Ferreira  
**Orientador:** Prof. Dr. Rodrigo Campiolo  
**Curso:** Bacharelado em Ciência da Computação — UTFPR-CM  
**Revisor:** parecer no papel de membro de banca (TCC 1)  
**Base:** `capitulos/cap-introducao.tex`, `capitulos/cap-conceitos.tex`, `capitulos/cap-proposta.tex`, `main.tex`, `variaveis.tex` (estado no momento desta leitura)

Parecer: o trabalho **tem recorte e pode virar um TCC 2 experimental**, mas ainda **não está maduro para aprovação sem ajuste**. A ideia (medir *deadlines*, *retries* e *keepalive* do gRPC no mesmo sistema, sob carga, falha e tráfego abusivo) é clara. O texto, porém, promete mais do que o desenho experimental isola, mistura modelos de carga, deixa a pergunta larga demais e apresenta a organização do volume em desacordo com o que o PDF realmente contém.

Legenda usada abaixo: **Obrigatório** (bloquear ou condicionar aprovação), **Recomendado** (esperar na versão seguinte), **Pergunta de arguição**.

---

## 1. Parecer geral

O objeto não é “usar gRPC”, e sim **o custo e o benefício dos mecanismos nativos de tolerância a falhas do gRPC-Go**. Isso é um recorte de pesquisa, não um tutorial. A tabela de trabalhos relacionados (Tabela 1 da fundamentação) ajuda a defender a lacuna: quase ninguém mede desempenho, resiliência e segurança **juntos** nesses três mecanismos.

Título, pergunta, objetivo geral, palavras-chave e organização do texto foram alinhados nesta passagem. O que ainda atravessa o volume está nas seções 7 e 12: desenho experimental, critério de êxito dos objetivos específicos e o mês de março ainda concentrado.

---

## 2. Problema de pesquisa e pergunta

A motivação está correta: microsserviços tornam a chamada de rede cara e sujeita a falha parcial; o gRPC oferece mecanismos; esses mecanismos não são de graça e podem amplificar carga.

A pergunta atual é uma concatenação de quatro perguntas:

- como os mecanismos se comportam quanto a desempenho;
- quanto a tolerância a falhas;
- quanto a segurança;
- até que nível de carga isso se mantém.

**Feito.** A pergunta do texto é a sugestão desta seção: efeito de *deadlines*, *retries* e *keepalive* do gRPC-Go sobre latência, vazão e disponibilidade, e a condição em que a retransmissão prejudica o tráfego legítimo.

---

## 3. Objetivos

O objetivo geral (“avaliar empiricamente os mecanismos nativos do gRPC para tolerância a falhas em um *marketplace*”) **não cobre** desempenho nem segurança, que estão nos específicos e na pergunta.

Os específicos estão, em linha, executáveis: implementar, configurar em degraus, medir latência/vazão/saturação, injetar falha, medir amplificação. Faltam critérios de êxito. “Avaliar” não diz o que conta como resultado positivo, negativo ou inconclusivo.

**Obrigatório.**

- Reescrever o objetivo geral para caber desempenho, resiliência e o recorte de segurança que de fato será medido — ou cortar o que o geral não promete.
- Acrescentar, para cada específico, o *como se decide*: por exemplo, “considerar que o *retry* agravou o ataque se a disponibilidade do tráfego legítimo em (d) for menor que em (a) no mesmo nível de carga abusiva” (isso já está na seção de segurança; precisa subir aos objetivos).

O específico de segurança fala em “configurações sem mecanismos e com todos eles”. Isso abandona (b) e (c). Se a pergunta é o efeito **de cada** mecanismo, a banca vai perguntar por que a segurança só compara os extremos.

**Feito em parte.** O objetivo geral e o específico de segurança foram reescritos em cima da pergunta. Os específicos ainda não dizem, um a um, o que conta como resultado positivo, negativo ou inconclusivo. Esse ponto continua aberto.

---

## 4. Justificativa

Um parágrafo. Diz três coisas justas: os mecanismos são usados; raramente se mede custo e efeito juntos; o *marketplace* tem cadeia de compra. Não infla. Bom para TCC 1.

Fraco: não justifica **Go / gRPC-Go / Envoy / k3s / Chaos Mesh** como *instrumento*, só o domínio. Uma frase sobre por que gRPC-Go (e não Java/gRPC-Java, onde o *hedging* existiria) evita a pergunta “você escolheu a biblioteca que não tem o mecanismo”.

[a stack foi escolhida pela famililiariedade do autor, se isso não for suficiente, deixe esse ponto aqui para ser revisado depois].

---

## 5. Fundamentação teórica

A linha monolito → microsserviço → sistema distribuído → latência e falha parcial → *saga* → RPC/gRPC → mecanismos → segurança está correta e cabe num TCC 1. Coulouris, Newman e a documentação do gRPC são fontes adequadas para conceito. Não é revisão de estado da arte; é o mínimo para a banca acompanhar o experimento. Isso é aceitável **desde que** a revisão de literatura more em Trabalhos relacionados.

Pontos a corrigir no conteúdo, não só na forma:

- *Saga* é apresentada e o fluxo de compra é classificado como *saga*. No desenho da proposta, a compra parece uma transação orquestrada com *lock* + reserva + pagamento + compensação. Diga o padrão com o nome que o texto vai usar depois, e não misture *saga* coreográfica sem voltar nela.
[vamos mudar, ao invés de usar saga, vamos usar two-pashe commit, que faz mais sentido com oq está sando mostrado na proposta. Por hora, deixar em aberto]
- **Feito.** A seção de segurança diz que TLS, mTLS, limite de mensagem e *reflection* são recomendações do ecossistema gRPC, não medidas de um experimento em gRPC-Go.

A fundamentação **não precisa crescer**. Precisa ficar legível e alinhada ao que se mede.

---

## 6. Trabalhos relacionados e lacuna

Este é o trecho mais útil do volume. A leitura em quatro blocos (desempenho, custo de *proxy*, resiliência/*fault injection*, segurança) e a tabela comparativa mostram que o aluno leu com pergunta na cabeça, não fez recorte de artigos.

Limites que a banca vai explorar:

**Feito.** O fechamento da seção diz que Aderaldo e Mendonça medem *retry* em outra *stack*, que FastFI e ResilienceBench avaliam a ferramenta de injeção, e que este trabalho pretende medir os três mecanismos em gRPC-Go sob carga, falha injetada e amplificação. A linha “Este trabalho” continua fora da tabela. A frase de lacuna ficou curta, sem promessa de impacto.

---

## 7. Proposta e método experimental

### 7.1 Sistema

Seis serviços + *gateway* + Envoy + PostgreSQL + MongoDB + Redis + k3s + Chaos Mesh + k6 + Prometheus + Grafana, em duas VPS de 4 vCPU / 8 GB, **um nó**. Para TCC, é um protótipo ambicioso. A banca não pede um *marketplace* de produção; pede um sistema **suficiente** para a cadeia de compra e para os mecanismos.

**Recomendado.** Defenda por escrito por que seis serviços e não três (por exemplo auth, inventário, compra). Cada serviço a mais é um *pod* a mais no mesmo nó, competindo por CPU com o objeto medido.

O Envoy com *retry*/*timeout*/*circuit breaking* desligados é a decisão experimental mais importante da arquitetura. Está dita. Precisa virar procedimento de verificação.
[]

Inconsistência de protocolo: o k6 “suporta gRPC”, mas o cliente fala com o *gateway*, e só “do *gateway* para baixo” há mTLS. **Pergunta de arguição.** A carga do k6 entra em HTTP/JSON, gRPC ou ambos? Isso muda o que se está medindo (só o interior, ou também o *gateway*).

[Agente: por hora manter o k6]

O diagrama de sequência em 25 passos lineares, com desfechos 13–21 como alternativas, é difícil de ler. A lista no texto replica a figura. **Recomendado:** figura com *alt/opt* e no texto só o caminho feliz + um parágrafo de compensação. Passos 16–18 e 19–21 são o mesmo *rollback* com gatilhos diferentes.

### 7.2 Fatores, níveis e desfechos

Quatro configurações em degrau (nada → *deadline* → *retry* → *keepalive*) é o desenho certo para atribuir efeito. Hipótese: mecanismos ajudam resiliência e disponibilidade, com custo variável. Ainda **não está operacionalizada** (não diz que diferença mínima, em que métrica, em que cenário, conta como apoio à hipótese).

Problemas de desenho:

- *Keepalive* “também é variado nos cenários de falha de conexão”, mas a tabela só tem ligado/desligado na config (d). Ou existe um fator extra, ou a frase sobra.

- *Retry* só em `UNAVAILABLE`. *Deadline* estourado vira `DEADLINE_EXCEEDED`, que **não** retenta. Isso pode ser correto; tem de ser consciente. Caso contrário, o degrau (c) não exercita o que a falha de latência produz.
- Valores (*deadline* = 2× média, 4 tentativas, *backoff* 100 ms–1 s, *maxTokens* 10) são “iniciais e podem ser ajustados”. Para a banca, isso soa a *tuning* até aparecer o gráfico bonito. **Obrigatório:** ou fixa agora e trata ajuste como ameaça à validade, ou define o procedimento de ajuste *antes* de ver os desfechos (por exemplo, só com a config (a) em *warm-up*, sem olhar (d)).
- Modelo de carga: “fechado (usuários concorrentes)” na avaliação de desempenho e “rampa de 100 requisições por segundo” no ponto de ruptura. Isso é modelo **aberto**. **Obrigatório:** não misturar. Diga qual é o fator de carga em cada experimento (VUs vs req/s).
- 90% leitura / 10% escrita: a cadeia profunda é a compra (escrita). Essa mistura pode **subexercitar** o objeto. Justifique com a carga de um *marketplace* ou reserve um cenário só de compra.
- “Serviços periféricos” para injeção de falha. Autenticação está no caminho crítico da compra e das rotas privadas. Se auth for “periférico”, a falha não pega o objeto; se não for, o texto mente. **Obrigatório:** nomear os alvos (inventário, pagamento, auth — sim ou não) por tipo de falha.
- Disponibilidade é definida duas vezes. Primeiro: proporção de sucesso no total. Depois: a mesma coisa, porém separada em públicas vs protegidas, porque o total esconderia falha de auth. Fique só com a segunda. A primeira frase, sozinha, contradiz o argumento.

### 7.3 Métricas e análise

Latência p50/p90/p99, vazão, CPU, memória, MTTR, taxa de erro, fator de amplificação: conjunto razoável. Falta:

- número de **repetições** e semente;
- o que entra no intervalo de confiança (execução? usuário? requisição?);
- se o p99 é da requisição de ponta a ponta no k6 ou de cada RPC;
- definição operacional do MTTR (limiar “a partir do pico” é circular: pico de quê, em qual config?).

Ponto de ruptura (p99 > 500 ms ou erro > 1%) é um critério. Diga por que 500 ms (SLO de *marketplace*? literatura?). Senão é número redondo.

Análise “por médias e intervalos de confiança” sem *n* e sem teste (ou sem dizer que não haverá teste, só descritivo) é vago demais para a seção de método.

### 7.4 Segurança

O recorte “não caçar CVE; medir se o *retry* afunda o tráfego legítimo” é o único recorte de segurança que este TCC consegue defender. Está bom. Não chame isso de “análise de segurança do sistema”. Chame de **efeito dos mecanismos sob carga abusiva**.

Ainda há dois estímulos misturados: “tráfego abusivo de intensidade crescente” e “requisições não autorizadas” (objetivo específico). São ataques diferentes (volume vs. 401/permissão). **Obrigatório:** um só, com procedimento.

Comparar só (a) e (d) não deixa ver se o culpado é o *retry* ou o *keepalive*. Se o tempo apertar, compare (a) e (c), que é onde a amplificação mora.

---

## 8. Viabilidade, cronograma e ameaças à validade

**Feito em parte.** A instrumentação passou para fevereiro, junto do fim da implementação. Experimentos continuam só em março, e a escrita do TCC 2 em abril. O fatorial não foi enxugado. Março segue apertado.

**Feito.** A proposta ganhou a subseção “Ameaças à viabilidade” (prazo e tamanho do sistema). As ameaças à validade do desenho (nó único, Envoy no caminho, parâmetros ajustáveis, saturação do gerador) continuam em aberto: não eram o pedido desta passagem.

**Feito.** Versões no texto: Go 1.26.11 (último patch da linha 1.26; a linha atual é a 1.27), gRPC-Go 1.85.0, Envoy 1.40.2, k3s 1.37.2, Chaos Mesh 2.8.8, k6 2.4.0 e Prometheus 3.13.5 (série de suporte longo; a última estável é a 3.16.0).

---

## 9. Coerência interna

| Trecho | Diz | O documento faz |
|---|---|---|
| Configurações | Quatro degraus para isolar efeito | Segurança e ruptura usam só (a) e (d) |
| Carga | Modelo fechado | Ruptura em req/s (aberto) |

Organização, objetivo geral, título e palavras-chave saíram desta tabela: foram alinhados nesta passagem.

---

## 10. Apresentação, língua e normas

A prosa, fora o parágrafo quebrado, está acima da média de TCC 1: frases curtas, pouco *marketing*, pouca repetição. Preserve isso quando corrigir.

---

## 11. Pontos fortes (manter)

- Recorte de mecanismos nativos, com Envoy **sem** as próprias políticas, para não confundir o fator.
- Degraus (a)–(d) em vez de “com gRPC vs sem gRPC”.
- Compra como transação distribuída com *lock* + idempotência — o objeto tem onde doer.
- Separar disponibilidade de rotas públicas e protegidas, se a redação ficar só com essa definição.
- Não vender a análise de segurança como *pentest*.
- Tabela de trabalhos relacionados com coluna “mecanismos nativos”.
- Duas VPS (carga fora da máquina do sistema).

---

## 12. Correções obrigatórias antes de nova submissão

1. Tornar a hipótese e os objetivos específicos **decidíveis** (critério por métrica e por cenário). O objetivo geral já foi reescrito.
2. Desfazer a mistura **carga fechada vs rampa em req/s**.
3. Nomear **alvos de falha**; não usar “periféricos” como coringa.
4. Uma só definição de **disponibilidade** na proposta. O objetivo de segurança já não mistura tráfego abusivo com requisições não autorizadas.
5. Fixar ou pré-registrar o **ajuste de parâmetros**.
6. Enxugar o **fatorial de março**. A instrumentação já foi para fevereiro; os experimentos continuam em um mês só.

---

## 13. Perguntas para a arguição

1. Se o *deadline* gera `DEADLINE_EXCEEDED` e o *retry* só olha `UNAVAILABLE`, o degrau (c) reage à falha de latência ou só à queda de *pod*?
2. Por que o k6 não fala gRPC direto no Envoy, sem *gateway*? O *gateway* é fator ou ruído?
3. Em um único nó k3s, como se separa saturação do mecanismo da saturação do *kube-proxy*/Envoy/disco?
4. Qual é o *n* de repetições que cabe em março, e o que se faz se o IC de (b) e (c) se sobrepuser?
5. A chave de idempotência não mascara o custo do *retry* nas escritas, exatamente o efeito que se quer ver?
6. Se (d) for pior que (a) no tráfego abusivo, o trabalho conclui “não use *retry* em produção” ou “use *throttling* e teto de tentativas”? O texto de segurança já aponta a leitura; a conclusão precisa nascer daí, não de um “depende” genérico.

[vamos melhorar isso aqui depois]
---

## 14. Conclusão da banca (TCC 1)

**Condicionado a revisão.** Há pesquisa. Não há, ainda, um plano experimental fechado o bastante para o aluno passar oito meses medindo a coisa certa. Ajuste o recorte (pergunta e objetivos), feche o desenho (carga, alvos de falha, parâmetros, *n*) e faça o PDF coincidir com o que está incluído. Com isso, o TCC 2 tem chão. Sem isso, o risco é implementar um *marketplace* inteiro e não conseguir atribuir nenhum gráfico aos três mecanismos que justificam o trabalho.
 
[Agente: ter isso em mente]
