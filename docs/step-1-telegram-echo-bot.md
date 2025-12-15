# Step 1 — Telegram Echo Bot (guida estesa)

Questa guida ci serve per costruire il nostro primo workflow end‑to‑end con n8n e Telegram.
L’idea è semplice, ma è una pietra miliare: se riusciamo a ricevere un messaggio e rispondere correttamente, allora abbiamo imparato il pattern “Trigger → Azione” che useremo per TODO, AI e integrazioni API.

## Obiettivo

- Noi scriviamo un messaggio al bot su Telegram.
- n8n riceve l’evento (trigger).
- n8n risponde sulla stessa chat copiando il testo (send message).

In pratica: un “eco”.

## Prerequisiti

- n8n avviato in locale con `docker compose up -d`
- n8n raggiungibile su `http://localhost:5678` e onboarding completato
- App Telegram installata (mobile o desktop)

> Nota: nel nostro `compose.yml` n8n parte con `start --tunnel`.
> Questo ci aiuta perché Telegram può chiamare il webhook anche se noi siamo in locale.

---

## 1) Creiamo il bot con BotFather

Questa sezione esiste perché Telegram ci richiede un “bot token” per autenticare le chiamate API.
Noi lo useremo in n8n come credenziale, così non dobbiamo “incollare token” dentro ai workflow.

1. Apriamo BotFather: https://t.me/BotFather
2. Scriviamo `/newbot`
3. Scegliamo:
   - un **nome** (quello che vedremo in chat)
   - uno **username** (deve finire con `bot`, es. `MyWorkshopEchoBot`)
4. Copiamo il **Bot Token** (è una stringa lunga, trattiamola come un segreto)
5. Apriamo la chat con il bot appena creato e mandiamo `/start`

Perché facciamo `/start`?
Perché così Telegram “apre” la chat e noi siamo sicuri di avere un contesto reale per ricevere eventi e rispondere.

---

## 2) Creiamo il workflow in n8n

Qui mettiamo insieme le prime due competenze operative:
1) configurare un trigger che riceve dati; 2) leggere quei dati e usarli per una risposta.

### 2.1 Nuovo workflow

- In n8n clicchiamo **New Workflow**
- Rinominiamolo (facoltativo) in `Step 1 - Echo bot`

### 2.2 Nodo 1: `Telegram Trigger` (riceviamo il messaggio)

Questa parte esiste perché vogliamo che n8n “ascolti” Telegram e crei un’esecuzione ogni volta che arriva un messaggio al bot.

1. Clicchiamo `+` e cerchiamo **Telegram Trigger**
2. Selezioniamo l’evento **On Message** (in alcune UI può chiamarsi “Message”)
3. In **Credentials** creiamo una nuova credenziale Telegram e incolliamo il **Bot Token** dentro il campo Access Token
4. Attiviamo il workflow di telegram (dato che siamo in configurazione locale non possiamo usare il trigger di test)
5. Torniamo su Telegram e scriviamo un messaggio al bot (es. `ciao`)

Se tutto è a posto, n8n cattura un evento e fa una esecuzione. Nella tab esecuzioni vediamo tutte le esecuzioni.
I campi che ci interessano di solito sono:

- `message.text` → il testo del messaggio
- `message.chat.id` → l’identificatore della chat dove dobbiamo rispondere

Se non vediamo dati, saltiamo alla sezione “Troubleshooting”.

### 2.3 Nodo 2: `Telegram Send Message` (rispondiamo)

Questa parte esiste perché, una volta ricevuto il messaggio, vogliamo rispondere nello stesso punto (stessa chat) con una regola semplice: “rimanda indietro lo stesso testo”.

1. Aggiungiamo un nodo **Telegram**
2. Selezioniamo l’azione **Send Message**
3. Riutilizziamo le **stesse credenziali** del trigger (lo stesso bot)
4. Compiliamo i campi principali:
   - **Chat ID** → impostiamo *Expression* e usiamo: `{{ $json["message"]["chat"]["id"] }}`
   - **Text** → impostiamo *Expression* e usiamo: `{{ $json["message"]["text"] }}`
5. Colleghiamo `Telegram Trigger` → `Telegram Send Message`

Perché usiamo *Expression*?
Perché questi valori arrivano dall’evento in ingresso: non possiamo scriverli “a mano”, vogliamo che cambino ad ogni messaggio.

### 2.4 Test e attivazione

Qui separiamo due modalità, così sappiamo cosa aspettarci quando facciamo debug:

- **Test / Execute workflow**: esegue con un evento di test e ci fa vedere i dati nodo per nodo.
- **Activate**: rende il workflow “sempre in ascolto” e risponde anche quando non siamo in modalità test.

Una volta che il bot risponde correttamente, clicchiamo **Activate**.

> Nota: se fermiamo e riavviamo n8n, a volte serve riattivare il workflow per riallineare il webhook (dipende dal tunnel e da come n8n rigenera gli URL).

---

## Troubleshooting (i problemi più comuni)

### Non arriva nessun evento al `Telegram Trigger`

- Verifichiamo di aver scritto al bot in chat (e non solo creato il bot).
- Rifacciamo `/start` e riproviamo **Listen for test event**.
- Controlliamo che il **Bot Token** sia corretto (nessuno spazio extra).
- Controlliamo che n8n sia in esecuzione (`docker compose ps`) e che l’Editor sia raggiungibile.

### Il trigger riceve, ma `Send Message` non risponde

- Controlliamo che **Chat ID** e **Text** siano in modalità *Expression*.
- Verifichiamo che i path siano corretti per il nostro evento (aprendo l’output del trigger):
  - se il testo non è in `message.text`, aggiorniamo l’expression usando i campi reali dell’evento.

### Messaggi “duplicati” o risposte strane

- Di solito succede quando abbiamo più workflow attivi sullo stesso bot.
  Disattiviamo gli altri workflow e teniamo attivo solo `Step 1 - Echo bot`.

