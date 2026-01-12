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
- Ritmi diversi, stesso obiettivo: chi è avanti può continuare con la speedrunner ([docs/speedrunner.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/speedrunner.md)).
- Collaborazione: aiutare un compagno significa imparare due volte.
- Rispetto delle risorse comuni: API key personali, nessun uso improprio.

---

## **Requisiti per l’Accesso al Workshop**

### **1. Software necessario**

- Docker Desktop (o Docker Engine)
- n8n tramite Docker Compose (file fornito)
- Editor di testo semplice (VSCode o altro, opzionale)

---
class: slide-compact
---

### **2. Setup dell'ambiente locale**

1. [**Forka e clona il repository**](https://github.com/ilmeskio/build-your-jarvis/fork)

2. **Verifica che Docker sia attivo**

3. **Avvia tutto con lo script unico**
   - Dalla root del progetto esegui:
   ```bash
   ./scripts/start
   ```
   - Lo script gestisce n8n, tunnel e variabili `.env`

4. **Apri n8n dal link dello script**
   - Dopo l’avvio vedrai una riga tipo: `SUCCESS! Tunnel is accessible at: https://...trycloudflare.com`
   - Usa quell’URL e completa l'onboarding (creazione utente admin).
   - Attiva la licenza gratuita.

5. **Ferma o resetta l'ambiente quando serve**
   ```bash
   ./scripts/stop
   ```

---

# **Step 1 — Chat Echo Bot: primi passi in n8n**

Creiamo un mini bot di chat direttamente in n8n per capire il flusso base senza dipendenze esterne.

> Il nostro obiettivo: scrivere un messaggio nella chat di n8n e ricevere la stessa risposta.
>
> Un eco.

---

## Principi base di n8n

- Un **workflow** è una sequenza di nodi collegati.
- Ogni workflow parte da un **trigger** (evento che scatena un innesco del workflow) e finisce con una o più **azioni**.
- I dati viaggiano tra i nodi in formato **JSON**: ogni nodo può leggere e trasformare questi dati.
- Ogni volta che arriva un evento del **trigger**, n8n esegue il workflow e crea una nuova **execution**.

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

# **Step 3 — TODO con Data Tables (panoramica)**

In questo blocco trasformiamo il bot in qualcosa di utile: una lista TODO persistente.
Useremo i comandi di Telegram per aggiungere, vedere e completare i TODO.

---

# **Step 3A — TODO con Data Tables: crea tabella + /add**

Mettiamo i TODO dentro le **Data Tables** di n8n e iniziamo ad aggiungerli.

## Cosa facciamo

- Creiamo la tabella `todos`
- Aggiungiamo un TODO con `/add <testo>`

## Mini‑guida nel repo

- [docs/step-3a-todo-add.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3a-todo-add.md)

---

# **Step 3B — TODO con Data Tables: /list**

Ora mostriamo la lista dei TODO.

## Cosa facciamo

- Recuperiamo i TODO della nostra chat
- Rispondiamo con una lista leggibile

## Mini‑guida nel repo

- [docs/step-3b-todo-list.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3b-todo-list.md)

---

# **Step 3C — TODO con Data Tables: /complete**

Chiudiamo il ciclo segnando un TODO come completato.

## Cosa facciamo

- Aggiorniamo `is_done = true` con `/complete <id>`
- Verifichiamo che sparisca dalla lista

<!--
Competenze raggiunte (non da presentare):
- Creazione Data Table `todos`
- Operazioni CRUD con Data Tables
- Routing tramite comandi Telegram
-->

## Mini‑guida nel repo

- [docs/step-3c-todo-complete.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3c-todo-complete.md)

---

# **Step 4 — Simple Chat with Agent**

## Descrizione

Prima di passare a Jarvis, facciamo un mini‑setup per parlare con un agente AI
in chat usando **Chat Trigger** e una **memoria semplice**.

## Cosa facciamo

- Creiamo un workflow “chat‑only” con **Chat Trigger**
- Colleghiamo **AI Agent** e **SimpleMemory**
- Verifichiamo che il bot ricordi il contesto nella conversazione

## Mini‑guida nel repo

- [docs/step-4-simple-chat-agent.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-4-simple-chat-agent.md)

---

# **Step 5 — AI Agent (Jarvis) con SimpleMemory**

## Descrizione

Introduce l’AI Agent Gemini di n8n.  
Jarvis comprende il linguaggio naturale e decide quale tool usare.

Prima di iniziare, creiamo la Gemini API key (la useremo nelle credenziali del nodo): https://aistudio.google.com/api-keys

## Cosa facciamo

- Partiamo da un workflow Telegram e lo trasformiamo in un agente “Jarvis”
- Colleghiamo i nostri tool TODO per creare/listare/aggiornare
- Diamo all’agente una memoria breve per riferimenti contestuali

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

## Nodi principali da usare

- **Telegram Trigger** → riceve il messaggio
- **AI Agent** → interpreta la richiesta e decide il tool
- **AI Tool** (uno per ogni azione: add/list/update)
- **SimpleMemory** → conserva contesto breve della chat
- **Telegram Send Message** → risponde all’utente

## Mini‑guida nel repo

- [docs/step-5-ai-agent-simplememory.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-5-ai-agent-simplememory.md)

---

# **Ricapitolo step**

- Step 1 — Chat Echo Bot (n8n base)
- Step 2 — Telegram Echo Bot
- Step 3A — TODO con Data Tables: crea tabella + /add
- Step 3B — TODO con Data Tables: /list
- Step 3C — TODO con Data Tables: /complete
- Step 4 — Simple Chat with Agent (memoria base)
- Step 5 — AI Agent (Jarvis) con SimpleMemory

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
