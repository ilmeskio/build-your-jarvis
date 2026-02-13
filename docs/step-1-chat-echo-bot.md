# Step 1 — Chat Echo Bot (guida estesa)

Questa guida ci serve per costruire il nostro primo workflow end‑to‑end con n8n, senza dipendenze esterne.
L’idea è semplice, ma è una pietra miliare: se riusciamo a ricevere un messaggio e rispondere correttamente, allora abbiamo imparato il pattern “Trigger → Azione” che useremo per agent e tool.

## Obiettivo

- Noi scriviamo un messaggio nella chat di n8n.
- n8n riceve l’evento (trigger).
- n8n risponde nella stessa chat copiando il testo.

In pratica: un “eco”.

## Prerequisiti

- n8n avviato in locale con `docker compose up -d`
- n8n raggiungibile su `http://localhost:5678` e onboarding completato

---

## 1) I principi base (versione pratica)

Questa sezione esiste perché vogliamo un vocabolario comune prima di toccare i nodi.
Se capiamo questi concetti, gli step successivi diventano lineari.

- **Workflow**: è la mappa di nodi che descrive cosa succede.
- **Trigger**: è l’evento che fa partire il workflow.
- **Azione**: è il nodo che fa qualcosa con i dati in ingresso.
- **Execution**: è ogni singola “corsa” del workflow quando arriva un messaggio.

---

## 2) Creiamo il workflow in n8n

Qui mettiamo insieme le prime due competenze operative:
1) configurare un trigger che riceve dati; 2) leggere quei dati e usarli per una risposta.

### 2.1 Nuovo workflow

- In n8n clicchiamo **New Workflow**
- Rinominiamolo (facoltativo) in `Step 1 - Chat echo bot`

### 2.2 Nodo 1: `Chat Trigger` (riceviamo il messaggio)

Questa parte esiste perché vogliamo che n8n “ascolti” la chat interna e crei un’esecuzione ogni volta che scriviamo.

1. Clicchiamo `+` e cerchiamo **Chat Trigger**
2. Aggiungiamo un campo response mode
3. impostare con "Using Response Nodes"
4. Apriamo la chat di n8n e scriviamo un messaggio (es. `ciao`)

Se tutto è a posto, n8n cattura un evento e fa una esecuzione. Nella tab esecuzioni vediamo tutte le esecuzioni.
Il campo che ci interessa di solito è quello del testo in ingresso (es. `chatInput`).
Se non lo vediamo, controlliamo l’output del nodo e usiamo il campo reale disponibile nella nostra UI.

### 2.3 Nodo 2: `Respond to Chat`

Questa parte esiste perché, una volta ricevuto il messaggio, vogliamo rispondere nello stesso punto con una regola semplice: “rimanda indietro lo stesso testo”.

1. Aggiungiamo il nodo di risposta chat **Respond to Chat** 
2. Nel campo **Text** usiamo una *Expression* che rimanda il testo ricevuto. Possiamo trascinare la variabile oppure scrivere:
   - `{{ $json["chatInput"] }}`
3. Colleghiamo `Chat Trigger` → `Respond to Chat`

Perché usiamo *Expression*?
Perché questi valori arrivano dall’evento in ingresso: non possiamo scriverli “a mano”, vogliamo che cambino ad ogni messaggio.

### 2.4 Test e attivazione

- **Publish**: rende il workflow “sempre in ascolto” e risponde anche quando non siamo in modalità test.

Una volta che il bot risponde correttamente, clicchiamo **Publish**.
