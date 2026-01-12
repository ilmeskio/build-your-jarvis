# Step 1 — Chat Echo Bot (guida estesa)

Questa guida ci serve per costruire il nostro primo workflow end‑to‑end con n8n, senza dipendenze esterne.
L’idea è semplice, ma è una pietra miliare: se riusciamo a ricevere un messaggio e rispondere correttamente, allora abbiamo imparato il pattern “Trigger → Azione” che useremo per TODO e AI.

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
2. Lasciamo le impostazioni di default
3. Avviamo l’ascolto con **Listen for test event**
4. Apriamo la chat di n8n e scriviamo un messaggio (es. `ciao`)

Se tutto è a posto, n8n cattura un evento e fa una esecuzione. Nella tab esecuzioni vediamo tutte le esecuzioni.
Il campo che ci interessa di solito è quello del testo in ingresso (es. `chatInput`).
Se non lo vediamo, controlliamo l’output del nodo e usiamo il campo reale disponibile nella nostra UI.

### 2.3 Nodo 2: `Respond to Chat` / `Chat Respond` (rispondiamo)

Questa parte esiste perché, una volta ricevuto il messaggio, vogliamo rispondere nello stesso punto con una regola semplice: “rimanda indietro lo stesso testo”.

1. Aggiungiamo il nodo di risposta chat (nome può variare: **Respond to Chat** o **Chat Respond**)
2. Nel campo **Text** usiamo una *Expression* che rimanda il testo ricevuto, ad esempio:
   - `{{ $json["chatInput"] }}`
3. Colleghiamo `Chat Trigger` → `Respond to Chat`

Perché usiamo *Expression*?
Perché questi valori arrivano dall’evento in ingresso: non possiamo scriverli “a mano”, vogliamo che cambino ad ogni messaggio.

### 2.4 Test e attivazione

Qui separiamo due modalità, così sappiamo cosa aspettarci quando facciamo debug:

- **Test / Execute workflow**: esegue con un evento di test e ci fa vedere i dati nodo per nodo.
- **Activate**: rende il workflow “sempre in ascolto” e risponde anche quando non siamo in modalità test.

Una volta che il bot risponde correttamente, clicchiamo **Activate**.

---

## Troubleshooting (i problemi più comuni)

### Non arriva nessun evento al `Chat Trigger`

- Verifichiamo che il workflow sia in modalità **Listen for test event**.
- Controlliamo che stiamo usando la chat integrata di n8n (non un’altra finestra).
- Se ancora non arriva nulla, stoppiamo e riavviamo l’ascolto.

### Il trigger riceve, ma la risposta non arriva

- Controlliamo che il nodo di risposta sia collegato al trigger.
- Verifichiamo che **Text** sia in modalità *Expression*.
- Apriamo l’output del trigger e usiamo il campo reale del testo (es. `chatInput`).

### Risposte duplicate

- Di solito succede quando abbiamo più workflow attivi che ascoltano la chat.
  Disattiviamo gli altri workflow e teniamo attivo solo `Step 1 - Chat echo bot`.
