# Workshop: Costruisci il tuo Jarvis con n8n, Telegram, Gemini e Supabase

---

## **Abstract del Workshop**
In questo workshop di 3 ore gli studenti costruiranno il proprio **Jarvis personale**, un assistente digitale basato su **n8n**, **Telegram**, **Gemini** e **Supabase**. Attraverso una serie di attività progressive, gli studenti impareranno a creare automazioni, gestire dati strutturati, utilizzare API esterne e integrare un AI Agent capace di comprendere il linguaggio naturale.  
Il risultato finale sarà un assistente capace di gestire TODO, recuperare informazioni tramite API, cercare immagini e rispondere in modo intelligente.

---

## **Patto d'Aula**
- L’obiettivo principale è **imparare facendo**.  
- Non serve conoscere tutto subito: si procede **per passi**, ogni step aggiunge un pezzo.  
- Gli errori sono parte del processo: si risolvono insieme.  
- Ognuno ha il proprio ritmo: alcune sezioni sono **facoltative** per chi è più veloce.  
- Collaborazione: aiutare un compagno significa imparare due volte.  
- Rispetto delle risorse comuni: API key personali, nessun uso improprio.

---

## **Requisiti per l’Accesso al Workshop**

### **1. Software necessario**
- Docker Desktop (o Docker Engine)
- n8n tramite Docker Compose (file fornito)
- Editor di testo semplice (VSCode o altro)

### **2. Account & API key necessari**
- Account Telegram + app installata
- Bot Telegram creato tramite **BotFather**  
  → ottenimento del **Bot Token**
- **Gemini API Key** (gratuita): https://ai.google.dev  
- **Account Supabase** + progetto vuoto creato in anticipo  
- **Pixabay API Key**: https://pixabay.com/api/docs/  
- **OpenWeatherMap API Key**: https://openweathermap.org/api  

### **3. Materiale fornito dal docente**
- `docker-compose.yml`
- eventuali workflow base da importare in n8n

---

# **Struttura del Workshop**

---

# **Step 1 — Telegram Echo Bot**

## Descrizione
Configurazione iniziale del bot Telegram collegato a n8n.  
Lo studente invia un messaggio e il bot risponde con un semplice *echo*.

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
