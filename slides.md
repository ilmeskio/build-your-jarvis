---
title: Build Your Jarvis
theme: default
layout: cover
transition: null
---

# Build Your Jarvis

## n8n · Telegram · Gemini · Supabase

### Workshop

---

## Abstract del Workshop

In questo workshop di 3 ore gli studenti costruiranno il proprio **Jarvis personale**, un assistente digitale basato su **n8n**, **Telegram**, **Gemini** e **Supabase**.

Attraverso una serie di attività progressive, impareremo a creare automazioni, gestire dati strutturati, utilizzare API esterne e integrare un AI Agent capace di comprendere il linguaggio naturale.

Il risultato finale sarà un assistente capace di gestire TODO, recuperare informazioni meteo e rispondere in modo intelligente che potremo mano a mano rendere più complesso a seconda delle nostre necessità.

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
- cloudflared ([download](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/downloads/))
- n8n tramite Docker Compose (file fornito)
- Editor di testo semplice (VSCode o altro, opzionale)

---
class: slide-compact
---

### **2. Setup dell'ambiente locale**

Questa sezione ci serve per partire tutti dallo stesso punto, ridurre i problemi di configurazione e avere un ambiente ripetibile che possiamo resettare in caso di errori.

1. [**Forka e clona il repository**](https://github.com/ilmeskio/build-your-jarvis/fork)

2. **Verifica che Docker sia attivo**

3. **Avvia n8n con Docker Compose**
   - Dalla root del progetto esegui: `docker compose up -d`
   - Controlla i log: `docker compose logs -f n8n` (attendi "Editor is now accessible")

4. **Apri n8n localmente**
   - Vai su `http://localhost:5678` e completa l'onboarding (creazione utente admin).
   - Attiva la licenza gratuita.

5. **Esponi n8n via Cloudflare Tunnel (necessario per Telegram webhook)**
   - Avvia: `cloudflared tunnel --url http://localhost:5678`
   - Copia l'URL `https://...trycloudflare.com` che appare nel terminale
   - Aggiorna `.env`: `N8N_PUBLIC_URL=https://random.trycloudflare.com` (senza slash finale!)
   - Ricrea il container: `docker compose up -d --force-recreate`

6. **Ferma o resetta l'ambiente quando serve**
   - Stop dello stack: `docker compose down` (i dati restano in `./data`).
   - Reset totale: elimina `./data` e riavvia lo stack.

---

### **3. Account & API key necessari**

- Un account Google (ci servirà per creare la Gemini API key quando arriviamo allo step AI).
- Un account Telegram con app installata (meglio anche Telegram Desktop, così copiare/incollare è più comodo).

---

# **Step 1 — Telegram Echo Bot**

Configuriamo un bot Telegram collegato a n8n.

> Il nostro obiettivo: Inviare un messaggio e il bot risponde con lo stesso messaggio che inviamo.
>
> Un eco.

## Cosa facciamo (in breve)

1. Creiamo un bot con BotFather e copiamo il **Bot Token**
2. In n8n creiamo un workflow con:
   - `Telegram Trigger` (evento **On Message**) per ricevere i messaggi
   - `Telegram Send Message` per rispondere nella stessa chat
3. Testiamo e poi **Activate** per renderlo sempre attivo

## Guida estesa nel repo

Per i passaggi dettagliati (trigger, credenziali, expression, troubleshooting) usiamo:

- [docs/step-1-telegram-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-1-telegram-echo-bot.md)

---

# **Step 2 — TODO con Supabase (senza AI)**

## Descrizione

Creazione della tabella dei TODO su Supabase e gestione manuale tramite comandi Telegram.

## Setup Supabase (quando arriviamo a questo step)

- Crea (o apri) un progetto Supabase da qui: https://database.new
- Ci serviranno **Project URL** e **anon key** per configurare le credenziali in n8n.

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
   meteo - Mostra il meteo per una città
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

# **Step 3 — API Meteo con OpenWeatherMap**

## Descrizione

Integrazione con OpenWeatherMap per recuperare informazioni meteo tramite Telegram.

## Obiettivo dello step

Imparare a consumare API esterne dentro n8n usando sia nodi nativi che HTTP Request.

## Competenze raggiunte

- Uso del nodo OpenWeatherMap (nodo nativo n8n)
- Parsing dei dati JSON dall'API
- Formattazione della risposta per l'utente
- Gestione delle API key nelle credenziali

## Comando

- `/meteo <città>`

### Endpoint API:

```
GET https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric
```

**Free tier**: 1,000 chiamate/giorno, 60 chiamate/minuto

---

## Setup OpenWeatherMap

Per usare l'API:

1. **Crea l'account**: https://home.openweathermap.org/users/sign_up
2. **Recupera la API key**: https://home.openweathermap.org/api_keys
3. **Configura le credenziali in n8n** con la tua API key

---

## Nodi n8n da creare

Per gestire `/meteo <città>`:

- **Telegram Trigger**
  Riceve il messaggio con la città.

- **Function / Switch**
  Estrae la città dopo `/meteo`.

- **OpenWeatherMap** (nodo nativo)
  - Operation: Current Weather
  - Location: `{{$json["city"]}}`
  - Units: Metric
  - Credentials: La tua API key

- **Set / Function** (opzionale)
  Formatta la risposta:
  - Temperatura: `{{$json["main"]["temp"]}}°C`
  - Condizioni: `{{$json["weather"][0]["description"]}}`
  - Umidità: `{{$json["main"]["humidity"]}}%`

- **Telegram Send Message**
  Invia la risposta formattata all'utente

---

# **Step 4 — AI Agent (Jarvis) con SimpleMemory**

## Descrizione

Introduce l’AI Agent Gemini di n8n.  
Jarvis comprende il linguaggio naturale e decide quale tool usare.

Prima di iniziare, creiamo la Gemini API key (la useremo nelle credenziali del nodo): https://aistudio.google.com/api-keys

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

Usa OpenWeatherMap per recuperare il meteo (collegato allo Step 3).

---

## SimpleMemory (Memory Buffer Window)

Usata per:

- ricordare l’ultimo TODO creato (`last_todo`)
- interpretare riferimenti successivi:
  - “Scade domani alle 17”
  - “Cambia la priorità”

---

# **Step 5 — Moduli opzionali (per i veloci)**

Questi moduli sono pensati per chi completa i primi 4 step velocemente e vuole esplorare ulteriori integrazioni.

---

## **1. Ricerca Immagini con Pixabay**

### Setup

- Crea l'account: https://pixabay.com/api/docs/
- Recupera la API key (in alto nella documentazione)

### Comando

- `/image <query>`

### Endpoint API

```
GET https://pixabay.com/api?key=API_KEY&q=QUERY&image_type=photo&per_page=3
```

### Nodi da creare

- **HTTP Request** per chiamare l'API Pixabay
- **Set/Function** per estrarre URL immagini da `hits[]`
- **HTTP Request (binary)** per scaricare l'immagine
- **Telegram Send Photo** per inviare l'immagine direttamente

### Tool per AI Agent

Crea `IMAGE_SEARCH` tool che l'AI può invocare automaticamente quando l'utente chiede immagini.

---

## **2. Google Calendar**

- Creazione eventi da richieste in linguaggio naturale
- Lettura calendario per controllare disponibilità
- Integrazione con TODO (es. "crea evento per questo TODO")

---

## **3. Gmail**

- Comporre email con l'AI
- Inviare email
- Lettura inbox (opzionale)

---

# **Conclusione**

Alla fine del workshop ogni studente avrà:

- Un proprio Jarvis funzionante
- Un bot Telegram intelligente
- Integrazione con Supabase (gestione TODO persistenti)
- API esterna per informazioni meteo
- AI Agent con memoria conversazionale
- (Opzionale) Ricerca immagini, Google Calendar, Gmail

Il workshop fornisce basi solide per future estensioni: GitHub, Notion, altre API, dashboard, automazioni avanzate e molto altro.

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
