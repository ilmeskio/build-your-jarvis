# Speedrunner — moduli extra per chi va veloce

Questa guida è pensata per chi ha finito i primi step e vuole estendere il workshop con una scaletta di difficoltà crescente.
Oltre ai comandi Telegram, possiamo integrare questi passi direttamente con l’AI Agent.

Ecco l’ordine suggerito:
- TODO con priorità e date di scadenza in Data Tables
- Esperimenti con comandi Telegram
- Meteo via OpenWeatherMap con chiamata API esterna
- Ricerca immagini con Pixabay
- TODO persistenti su Supabase (alternativa alle Data Tables)
- Google Calendar
- Gmail

---

## Parte A — TODO con priorità e date di scadenza (Data Tables)

### Obiettivo

Estendere i TODO per gestire priorità e scadenze senza cambiare l’infrastruttura.

### Cosa aggiungiamo

- `priority` (bassa / media / alta)
- `due_date` (opzionale)

### Note operative

- Estendiamo il comando `/add` per accettare priorità e scadenza (anche opzionali).
- Aggiorniamo la risposta di `/list` per mostrare priorità e scadenza.

---

## Parte B — Esperimenti con comandi Telegram

### Obiettivo

Sperimentare con parsing e UX dei comandi per rendere il bot più usabile.

### Idee rapide

- `/delete <id>` per rimuovere TODO (Data Table in modalità **Delete**).
- `/help` per stampare la lista dei comandi disponibili.
- `/start` con messaggio di onboarding.

---

## Parte C — Meteo con OpenWeatherMap

### Obiettivo

Integrare un’API esterna per recuperare il meteo e rispondere su Telegram.

### Setup OpenWeatherMap

1. Crea l’account: https://home.openweathermap.org/users/sign_up
2. Recupera la API key: https://home.openweathermap.org/api_keys
3. Configura le credenziali in n8n

### Comando

- `/meteo <città>`

### Endpoint API

```
GET https://api.openweathermap.org/data/2.5/weather?q={city}&appid={API_KEY}&units=metric
```

### Nodi n8n da creare

- **Telegram Trigger** → riceve il messaggio con la città
- **Function / Switch** → estrae la città dopo `/meteo`
- **OpenWeatherMap** (nodo nativo) **oppure** **HTTP Request** verso l’endpoint
- **Set / Function** → formatta la risposta (temp, condizioni, umidità)
- **Telegram Send Message** → invia la risposta all’utente

---

## Parte D — Ricerca Immagini con Pixabay

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

## Parte E — TODO su Supabase (alternativa a Data Tables)

### Obiettivo

Spostare la persistenza dei TODO su un database esterno, mantenendo gli stessi comandi Telegram.

### Setup Supabase

1. Crea (o apri) un progetto Supabase: https://database.new
2. Recupera **Project URL** e **anon key** (serviranno per le credenziali in n8n)

### Tabella `todos` da creare in Supabase

| colonna    | tipo        | note                     |
| ---------- | ----------- | ------------------------ |
| id         | uuid (PK)   | generato automaticamente |
| user_id    | text        | id chat Telegram         |
| text       | text        | contenuto TODO           |
| priority   | text        | bassa / media / alta     |
| due_date   | timestamptz | opzionale                |
| is_done    | boolean     | default: false           |
| created_at | timestamptz | default: now()           |

### Nodi n8n consigliati (CRUD)

- **Supabase Insert** → `/add`
- **Supabase Select** → `/list` (filtra `user_id` e `is_done = false`)
- **Supabase Delete** → `/delete`
- **Supabase Update** → `/complete`

---

## Parte F — Google Calendar

- Creazione eventi da richieste in linguaggio naturale
- Lettura calendario per controllare disponibilità
- Integrazione con TODO (es. "crea evento per questo TODO")

---

## Parte G — Gmail

- Comporre email con l'AI
- Inviare email
- Lettura inbox (opzionale)
