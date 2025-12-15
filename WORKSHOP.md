---
title: Build Your Jarvis
theme: default
layout: cover
---

# Build Your Jarvis

## n8n · Telegram · Gemini · Supabase

### Workshop

---

## Abstract del Workshop

In questo workshop di 3 ore gli studenti costruiranno il proprio **Jarvis personale**, un assistente digitale basato su **n8n**, **Telegram**, **Gemini** e **Supabase**.

Attraverso una serie di attività progressive, impareremo a creare automazioni, gestire dati strutturati, utilizzare API esterne e integrare un AI Agent capace di comprendere il linguaggio naturale.  

Il risultato finale sarà un assistente capace di gestire TODO, recuperare informazioni tramite API, cercare immagini e rispondere in modo intelligente che potremo mano a mano rendere più complesso a seconda delle nostre necessità.

---

## **Patto d'Aula**

- L’obiettivo principale è **imparare facendo**.
- Non serve conoscere tutto subito: si procede **per passi**, ogni step aggiunge un pezzo.
- Gli errori sono parte del processo: si risolvono insieme.
- Ognuno ha il proprio ritmo: alcune sezioni sono **facoltative** per chi è più veloce.
- Collaborazione: aiutare un compagno significa imparare due volte.
- Rispetto delle risorse comuni: API key personali, nessun uso improprio.
- Usate pure ChatGPT, ma fate attenzione...

---

## Come usare l'AI in maniera furba

Quello che genera ChatGPT spesso non è aggiornato o non completamente funzionante. Rischiate di perdere più tempo a capire come mai è sbagliato senza tirar fuori niente.

  - **Usala come tutor**: chiedi perché una cosa funziona, non solo cosa scrivere.
  - **Parti dalla doc**: incolla uno snippet delle API n8n e fatti spiegare “cosa fa ogni campo” + casi d’uso.
  - **Chiedi esperimenti:** “dammi 3 micro-esercizi” (facile/medio/difficile) e una checklist di cosa devo osservare.
  - **Fai debug guidato**: incolla errore + input/output, fatti proporre ipotesi e prove per confermarle.
  - **Pretendi ragionamento:** “prima dimmi il piano, poi il codice” e “spiegami le alternative”.
  - **Verifica e confronta**: chiedi “come lo controlleresti?” e poi esegui tu.
  - **Tieniti il volante**: fai scrivere all’AI solo la base; le scelte (dati, flusso, naming) le fai tu.

Così vai più veloce imparando cose nuove!

---

## **Requisiti per l’Accesso al Workshop**

### **1. Software necessario**

- Docker Desktop (o Docker Engine)
- n8n tramite Docker Compose (file fornito)
- Editor di testo semplice (VSCode o altro)

---
class: slide-compact
---

### **2. Setup dell’ambiente locale**

Questa sezione ci serve per partire tutti dallo stesso punto, ridurre i problemi di configurazione e avere un ambiente ripetibile che possiamo resettare in caso di errori.

1. [**Forka e clona il repository**](https://github.com/ilmeskio/build-your-jarvis/fork)

2. **Verifica che Docker sia attivo**

3. **Avvia n8n con Docker Compose**
   - Dalla root del progetto esegui: `docker compose up -d`

4. **Controlla che n8n sia pronto**
   - Poi apri `http://localhost:5678` e completa l’onboarding (creazione utente admin e salvataggio credenziali).
   - Attiva la licenza gratuita.

5. **Ferma o resetta l’ambiente quando serve**
   - Stop dello stack: `docker compose down` (i dati restano nella cartella `./data`).
   - Reset totale: elimina `./data` e riavvia lo stack (questo cancella workflow e credenziali, quindi facciamolo solo se vogliamo ripartire da zero).

---
---

### **3. Account & API key necessari**

- Account Telegram + app installata
- Bot Telegram creato tramite [**BotFather**](https://t.me/BotFather)
  - Apri la chat con BotFather e invia `/newbot`.
  - Scegli un nome (display) e uno username che termina con `bot` (lo username deve essere **unico** su tutto telegram. Scegliete il nome che volete).
  - Copia il **Bot Token** e trattalo come una password.
  - Guida ufficiale: https://core.telegram.org/bots/tutorial#obtain-your-bot-token
- **Gemini API Key** (gratuita): https://ai.google.dev
- **Account Supabase** + progetto vuoto creato in anticipo
- **Pixabay API Key**: https://pixabay.com/api/docs/
- **OpenWeatherMap API Key**: https://openweathermap.org/api

---

# **Struttura del Workshop**

---

# **Step 1 — Telegram Echo Bot**

## Descrizione

Configurazione iniziale del bot Telegram collegato a n8n.  
Lo studente invia un messaggio e il bot risponde con un semplice _echo_.

## Obiettivo dello step

Comprendere il funzionamento dei webhook e verificare il collegamento bot ↔ n8n.

## Competenze raggiunte

- Creazione di un bot via **BotFather**
- Ottenimento del **Bot Token**
- Configurazione del nodo **Telegram Trigger**
- Invio risposta tramite **Telegram Send Message**
- Comprensione flusso “evento → risposta”

## Passaggi pratici

### **Creare un bot con BotFather**

1. Aprire Telegram → cercare **BotFather**
2. `/newbot`
3. Assegnare nome e username
4. Copiare il **Bot Token**

### **Workflow n8n minimal**

- `Telegram Trigger`
- `Telegram Send Message` (testo = `{{$json["message"]}}`)

---

# **Step 2 — TODO con Supabase (senza AI)**

## Descrizione

Creazione della tabella dei TODO su Supabase e gestione manuale tramite comandi Telegram.

## Obiettivo dello step

Capire come un bot può salvare e leggere dati persistenti da un database.

## Competenze raggiunte

- Creazione tabella su Supabase
- Operazioni CRUD con nodo Supabase
- Routing tramite comandi Telegram

## Tabella `todos` da creare in Supabase

| colonna    | tipo        | note                     |
| ---------- | ----------- | ------------------------ |
| id         | uuid (PK)   | generato automaticamente |
| user_id    | text        | id chat Telegram         |
| text       | text        | contenuto TODO           |
| priority   | text        | bassa / media / alta     |
| due_date   | timestamptz | opzionale                |
| is_done    | boolean     | default: false           |
| created_at | timestamptz | default: now()           |

### **Creare i comandi personalizzati del bot**

Per permettere la visualizzazione dei comandi nel menu del bot:

1. Aprire **BotFather**
2. `/mybots` → selezionare il bot
3. **Bot Settings**
4. **Commands** (o `/setcommands`)
5. Inserire:
   ```
   add - Aggiunge un nuovo TODO
   list - Mostra la lista dei TODO
   delete - Cancella un TODO tramite ID
   complete - Segna come completato un TODO tramite ID
   ```
6. Salvare

## Comandi da implementare (senza AI)

- `/add <testo> <priorità>`
- `/list`
- `/delete <id>`
- `/complete <id>` → aggiorna `is_done = true`

## Nodi n8n da creare per la gestione dei TODO (senza AI)

Per implementare i comandi sopra elencati, ogni comando richiede una piccola struttura di nodi.

### **1. Nodo Telegram Trigger**

- Ascolta i messaggi in arrivo.
- Recupera testo, chat_id e parametri del comando.

### **2. Nodo Function / Switch**

Serve a distinguere quale comando è stato inviato:

- `/add`
- `/list`
- `/delete`
- `/complete`

Può essere un nodo:

- **Switch** → confronto per testo che inizia con `/add`, `/list`, ecc.
- Oppure un nodo **Function** che smista il flusso.

### **3. Nodi Supabase**

Per ciascuna operazione CRUD:

#### `/add` → Inserimento TODO

- Nodo **Supabase Insert**
  - Tabella: `todos`
  - Campi richiesti:
    - `user_id = {{$json["message"]["from"]["id"]}}`
    - `text` (estratto dal messaggio)
    - `priority`
    - `due_date` (se presente)

#### `/list` → Lettura TODO

- Nodo **Supabase Select**
  - Filtri:
    - `user_id = chat_id`
    - `is_done = false`

#### `/delete` → Eliminazione TODO

- Nodo **Supabase Delete**
  - Filtro: `id = <id passato dal comando>`

#### `/complete` → Aggiornamento TODO

- Nodo **Supabase Update**
  - Set: `is_done = true`
  - Filtro: `id = <id passato dal comando>`

### **4. Nodo Telegram Send Message**

Responsabile della risposta finale:

- Conferma inserimento
- Lista dei TODO
- Conferma eliminazione
- Conferma completamento

---

# **Step 3 — Strumenti manuali (senza AI)**

## Descrizione

Aggiunta di due strumenti tramite API:

- **OpenWeatherMap** → meteo
- **Pixabay** → immagini

## Obiettivo dello step

Imparare a consumare API esterne dentro n8n.

## Competenze raggiunte

- Uso del nodo OpenWeatherMap
- Uso del nodo HTTP Request
- Mapping dei dati dall’API alla risposta Telegram

## Comandi

- `/meteo <città>`
- `/image <query>`

### Template API Pixabay:

```
GET https://pixabay.com/api?key=API_KEY&q=QUERY&image_type=photo&per_page=3
```

## Nodi n8n da creare per gli strumenti manuali

### **1. Meteo — OpenWeatherMap**

Per gestire `/meteo <città>`:

- **Telegram Trigger**  
  Riceve il messaggio con la città.

- **Function / Switch**  
  Estrarre la parola dopo `/meteo`.

- **Nodo OpenWeatherMap**
  - Modalità: Current Weather (o Forecast)
  - Input: Nome città → `{{$json["city"]}}`
  - API Key configurata nelle credenziali

- **Set / Function (opzionale)**  
  Formattazione del testo in output.

- **Telegram Send Message**  
  Risposta con temperatura, condizioni meteo, ecc.

---

### **2. Immagini — Pixabay**

Per gestire `/image <query>`:

- **Telegram Trigger**  
  Ottiene la query immagine.

- **Function / Switch**  
  Estrae ciò che segue `/image`.

- **HTTP Request (GET)**
  - URL: `https://pixabay.com/api`
  - Query params:
    - `key = {{ $env.PIXABAY_API_KEY }}`
    - `q = {{ $json["query"] }}`
    - `image_type = photo`
    - `per_page = 3`

- **Set / Function**
  - Seleziona i primi link immagine da `hits[]`
  - Prepara un output tipo:
    ```
    {
      "images": ["url1", "url2", "url3"]
    }
    ```

-- **Telegram Send Message**  
 Manda i link o le immagini direttamente.

---

### **Inviare immagini direttamente su Telegram (download da Pixabay)**

Per migliorare l’esperienza utente, invece di inviare solo il link dell’immagine, possiamo **scaricare l’immagine** da Pixabay e poi **inviarla direttamente su Telegram** come foto.

## Nodi aggiuntivi da inserire

### **1. Set / Function — Estrarre URL immagine**

Dopo il nodo HTTP Request (Pixabay), estrarre l’URL della prima immagine:

- Campo: `imageUrl`
- Valore: `{{$json["hits"][0]["largeImageURL"]}}`

### **2. HTTP Request — Download dell’immagine**

Scaricare l’immagine in formato binario.

Configurazione:

- **Method:** GET
- **URL:** `{{$json["imageUrl"]}}`
- **Response Format:** _File_
- **Binary Property:** `data`

Questo crea un file binario chiamato `data`.

### **3. Telegram Send Photo — Invio dell’immagine**

Inviare l’immagine direttamente alla chat.

Configurazione:

- **Chat ID:** `{{$json["message"]["chat"]["id"]}}`
- **Photo:** `data`
- **Caption (opzionale):** “Ecco un’immagine che ho trovato per te!”

## Flusso completo

```
Telegram Trigger
   ↓
Function / Switch (interpreta /image)
   ↓
HTTP Request (Pixabay API)
   ↓
Set (estrai imageUrl)
   ↓
HTTP Request (download → binary:data)
   ↓
Telegram Send Photo (photo=data)
```

Questo approccio rende il bot più professionale e migliora l’esperienza degli studenti, che vedranno l’immagine direttamente nel bot invece che come semplice link.

---

Questi nodi preparano correttamente il terreno per lo Step 4, in cui l’AI Agent userà automatismi per scegliere da solo quale strumento invocare.

---

# **Step 4 — AI Agent (Jarvis) con SimpleMemory**

## Descrizione

Introduce l’AI Agent Gemini di n8n.  
Jarvis comprende il linguaggio naturale e decide quale tool usare.

## Obiettivo dello step

Passare da bot basato su comandi a un assistente intelligente e autonomo.

## Competenze raggiunte

- Uso del nodo **AI Agent**
- Collega strumenti esterni come AI Tools
- Uso della **Memory Buffer Window**
- Comprensione dei concetti di tool calling

---

## Tool collegati all’AI Agent

### **TODO_ADD**

- Input: user_id, text, priority, due_date
- Azione: inserimento

### **TODO_LIST** (con filtri per data)

- Input:
  - user_id
  - date_from (opzionale)
  - date_to (opzionale)
- Supporta richieste come:
  - “Cosa devo fare oggi?”
  - “Entro venerdì?”
  - “Questa settimana?”

### **TODO_UPDATE**

- Permette di:
  - modificare text / priority
  - aggiungere una scadenza
  - segnare un TODO come completato (`is_done = true`)

### **WEATHER_GET**

Usa OpenWeatherMap per recuperare il meteo.

### **IMAGE_SEARCH**

Usa Pixabay:

```
https://pixabay.com/api?key=KEY&q=query&image_type=photo&per_page=3
```

---

## SimpleMemory (Memory Buffer Window)

Usata per:

- ricordare l’ultimo TODO creato (`last_todo`)
- interpretare riferimenti successivi:
  - “Scade domani alle 17”
  - “Cambia la priorità”

---

# **Step 5 — Moduli opzionali (per i veloci)**

### **Google Calendar**

- Creazione eventi
- Lettura calendario

### **Gmail**

- Comporre email
- Inviare email

---

# **Conclusione**

Alla fine del workshop ogni studente avrà:

- un proprio Jarvis funzionante
- un bot Telegram intelligente
- integrazione con Supabase (TODO)
- API meteo e immagini
- AI Agent con memoria conversazionale

Il workshop fornisce basi solide per future estensioni: GitHub, Notion, Google Suite, dashboard, automazioni avanzate.

<style>
:global(.slidev-layout.slide-compact) {
  font-size: 0.82em;
  line-height: 1.15;
}

:global(.slidev-layout.slide-compact h3) {
  font-size: 1.35em;
  margin: 0 0 0.3em 0;
}

:global(.slidev-layout.slide-compact p) {
  margin: 0.25em 0;
}

:global(.slidev-layout.slide-compact ol),
:global(.slidev-layout.slide-compact ul) {
  margin: 0.25em 0;
}

:global(.slidev-layout.slide-compact li) {
  margin: 0.15em 0;
}
</style>
