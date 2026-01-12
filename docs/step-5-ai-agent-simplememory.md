# Step 5 — AI Agent (Jarvis) con SimpleMemory

In questo step trasformiamo il bot “a comandi” in un assistente capace di
capire richieste in linguaggio naturale e decidere quale azione fare.

Useremo l’**AI Agent** con una **memoria breve** e i tool TODO costruiti negli step precedenti.

---

## 0) Prerequisiti

- I comandi TODO devono funzionare (add, list, complete).
- Abbiamo già una API key di Gemini (o altro provider) nelle credenziali.

---

## 1) Workflow base

Creiamo un nuovo workflow chiamato `Jarvis Agent`.

### Nodi da usare

1. **Telegram Trigger**
2. **AI Agent**
3. **SimpleMemory (Memory Buffer Window)**
4. **AI Tool** (uno per ogni azione TODO)
5. **Telegram Send Message**

Flusso consigliato:
`Telegram Trigger → AI Agent → Telegram Send Message`  
e **SimpleMemory** collegata all’input “Memory” dell’AI Agent.

---

## 2) Telegram Trigger

- Selezioniamo le credenziali del bot Telegram.
- Questo nodo riceve il testo dell’utente.

Per la memoria ci servirà un identificatore stabile della chat, ad esempio:

```
{{ $json.message.chat.id }}
```

---

## 3) SimpleMemory

Impostiamo:

- **Session ID**: `{{ $('Telegram Trigger').item.json.message.chat.id }}`
- **Window size**: lasciare un valore basso (es. 6–10 messaggi)

La memoria serve a capire riferimenti come “fai quello di prima” o
“cambiamolo”.

---

## 4) AI Agent

Configuriamo il modello (Gemini, OpenAI, ecc.) e un prompt semplice, per esempio:

```
Sei Jarvis, un assistente personale. Rispondi in italiano in modo breve.
Quando l’utente chiede di gestire i TODO, usa i tool disponibili.
```

Colleghiamo:
- **Input** dal Telegram Trigger
- **Memory** da SimpleMemory
- **Tools** dai nodi AI Tool (uno per azione)

---

## 5) AI Tool: TODO_ADD

Creiamo un nodo **AI Tool** che richiama il nostro workflow “/add”.
Input tipici:

- `user_id`
- `text`
- `priority` (opzionale)
- `due_date` (opzionale)

Il tool deve restituire un testo di conferma (es. “TODO creato ✅”).

---

## 6) AI Tool: TODO_LIST

Nodo **AI Tool** collegato al workflow che legge i TODO.
Input utili:

- `user_id`
- `date_from` (opzionale)
- `date_to` (opzionale)

Così il modello può rispondere a richieste tipo “cosa ho questa settimana?”.

---

## 7) AI Tool: TODO_UPDATE / COMPLETE

Creiamo un tool per:

- cambiare testo/priorità/scadenza
- segnare un TODO come completato

Anche qui, risposta breve di conferma.

---

## 8) Telegram Send Message

Usiamo:

- **Text**: `{{ $json.output || $json.reply || $json.text }}`
- **Chat ID**: `{{ $('Telegram Trigger').item.json.message.chat.id }}`

In questo modo qualunque risposta dell’agent o dei tool verrà inviata correttamente.

---

## 9) Test rapido

Proviamo messaggi del tipo:

- “Aggiungi comprare il latte”
- “Mostrami cosa devo fare oggi”
- “Segna come fatto il TODO 3”
- “Cambia la priorità del primo”

Se la memoria è attiva, Jarvis deve capire riferimenti come “quello di prima”.
