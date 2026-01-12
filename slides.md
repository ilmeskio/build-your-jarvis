---
title: Build Your Jarvis
theme: default
layout: cover
transition: null
---

# Build Your Jarvis

## n8n · Telegram · Gemini

### Workshop

---

## Abstract del Workshop

In questo workshop di 3 ore gli studenti costruiranno il proprio **Jarvis personale**, un assistente digitale basato su **n8n**, **Telegram** e **Gemini**.

Attraverso una serie di attività progressive, impareremo a creare automazioni, gestire dati strutturati con le **Data Tables** di n8n e integrare un AI Agent capace di comprendere il linguaggio naturale.

Il risultato finale sarà un assistente capace di gestire TODO e rispondere in modo intelligente che potremo mano a mano rendere più complesso a seconda delle nostre necessità.

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

   Metodo automatico (raccomandato):

   ```bash
   chmod +x scripts/start
   ./scripts/start
   ```

   Al termine vedrai: `SUCCESS! Tunnel is accessible at: https://...trycloudflare.com`

   Usa questo link!

6. **Ferma o resetta l'ambiente quando serve**
   ```bash
   chmod +x scripts/stop
   ./scripts/stop
   ```

---

# **Step 1 — Chat Echo Bot: primi passi in n8n**

Creiamo un mini bot di chat direttamente in n8n per capire il flusso base senza dipendenze esterne.

> Il nostro obiettivo: scrivere un messaggio nella chat di n8n e ricevere la stessa risposta.
>
> Un eco.

---

## Principi base di n8n (in 3 minuti)

- Un **workflow** è una sequenza di nodi collegati.
- Ogni workflow parte da un **trigger** (evento) e finisce con una o più **azioni**.
- I dati viaggiano tra i nodi in **JSON**: ogni nodo può leggere e trasformare questi dati.
- Le **execution** sono le “corse” del workflow: ogni messaggio genera una nuova esecuzione.

---

## Cosa facciamo (in breve)

1. Creiamo un workflow con `Chat Trigger`
2. Aggiungiamo `Chat Respond` per rispondere con lo stesso testo
3. Testiamo e poi **Activate** per renderlo sempre attivo

## Guida estesa nel repo

Per i passaggi dettagliati (nodi, mapping, troubleshooting) usiamo:

- [docs/step-1-chat-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-1-chat-echo-bot.md)

---

# **Step 2 — Telegram Echo Bot**

Portiamo lo stesso flusso dell’eco fuori da n8n, collegandolo a Telegram.

## Cosa facciamo (in breve)

1. Creiamo un bot con BotFather e copiamo il **Bot Token**
2. Riutilizziamo la stessa logica dello Step 1 ma con i nodi Telegram:
   - `Telegram Trigger` (evento **On Message**) per ricevere i messaggi
   - `Telegram Send Message` per rispondere nella stessa chat
3. Verifichiamo il webhook (tunnel attivo) e poi **Activate** per renderlo sempre attivo

## Mini‑guida nel repo

- [docs/step-2-telegram-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-2-telegram-echo-bot.md)

---

# **Step 3 — TODO con Data Tables (senza AI)**

## Descrizione

Creazione della tabella dei TODO con **Data Tables** di n8n e gestione manuale tramite comandi Telegram.

## Obiettivo dello step

Capire come un bot può salvare e leggere dati persistenti usando lo storage nativo di n8n.

## Competenze raggiunte

- Creazione Data Table `todos`
- Operazioni CRUD con Data Tables
- Routing tramite comandi Telegram

## Struttura della tabella `todos`

| colonna    | tipo      | note                     |
| ---------- | --------- | ------------------------ |
| id         | text/uuid | generato automaticamente |
| user_id    | text      | id chat Telegram         |
| text       | text      | contenuto TODO           |
| priority   | text      | bassa / media / alta     |
| due_date   | datetime  | opzionale                |
| is_done    | boolean   | default: false           |
| created_at | datetime  | default: now()           |

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

### **3. Nodi Data Tables**

Per ciascuna operazione CRUD:

#### `/add` → Inserimento TODO

- Nodo **Data Table** (Create/Insert)
  - Tabella: `todos`
  - Campi richiesti:
    - `user_id = {{$json["message"]["from"]["id"]}}`
    - `text` (estratto dal messaggio)
    - `priority`
    - `due_date` (se presente)

#### `/list` → Lettura TODO

- Nodo **Data Table** (Get/Select)
  - Filtri:
    - `user_id = chat_id`
    - `is_done = false`

#### `/delete` → Eliminazione TODO

- Nodo **Data Table** (Delete)
  - Filtro: `id = <id passato dal comando>`

#### `/complete` → Aggiornamento TODO

- Nodo **Data Table** (Update)
  - Set: `is_done = true`
  - Filtro: `id = <id passato dal comando>`

### **4. Nodo Telegram Send Message**

Responsabile della risposta finale:

- Conferma inserimento
- Lista dei TODO
- Conferma eliminazione
- Conferma completamento

---

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

---

## SimpleMemory (Memory Buffer Window)

Usata per:

- ricordare l’ultimo TODO creato (`last_todo`)
- interpretare riferimenti successivi:
  - “Scade domani alle 17”
  - “Cambia la priorità”

---

# **Step 5 — Moduli opzionali (per i veloci)**

I moduli opzionali sono stati spostati nella doc speedrunner:

👉 [docs/speedrunner.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/speedrunner.md)

---

# **Conclusione**

Alla fine del workshop ogni studente avrà:

- Un proprio Jarvis funzionante
- Un bot Telegram intelligente
- TODO persistenti con Data Tables
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
