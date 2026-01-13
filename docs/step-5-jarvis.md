# Step 5 — AI Agent (Jarvis) con SimpleMemory

In questo step mettiamo insieme tutto quello che abbiamo già costruito:
Telegram (step 2), le azioni sulla tabella TODO (step 3) e l’AI Agent con
memoria (step 4). Non aggiungiamo nuovi mattoni, li colleghiamo per
ottenere un assistente capace di capire richieste in linguaggio naturale
e scegliere l’azione corretta.

Useremo l’**AI Agent** con una **memoria breve** e i tool TODO già costruiti
negli step precedenti. Per accelerare, riutilizziamo il workflow di
`docs/step-3a-todo-add.md` e copiamo qui il lavoro fatto in
`docs/step-4-simple-chat-agent.md`, oppure seguiamo gli stessi passaggi
per il Telegram Trigger e l’Agent.

---

## 0) Prerequisiti (già coperti)

- Telegram è già configurato (step 2).
- I comandi TODO devono funzionare (add, list, complete) (step 3).
- L’AI Agent con SimpleMemory è già pronto (step 4).
- Abbiamo già una API key di Gemini (o altro provider) nelle credenziali.

---

## 1) Workflow base (assemblaggio)

Duplichiamo lo step 4 e lo chiamiamo `Jarvis Agent`. Poi aggiungiamo i tool
TODO creati nello step 3. Qui non ricostruiamo i singoli nodi: li riusiamo
esattamente com’erano.

### In pratica

1. **Prendi lo schema dello step 4**: `Telegram Trigger → AI Agent → Telegram Send Message`, con **SimpleMemory** collegata alla memoria dell’agent.
2. **Aggiungi i tool TODO** dello step 3 (**TODO_ADD**, **TODO_LIST**, **TODO_UPDATE/COMPLETE**) e collegali all’AI Agent.
3. **Non cambiare il resto**: credenziali Telegram, prompt e session ID restano quelli già configurati.

Se vuoi un controllo veloce, i riferimenti chiave sono:

- **Session ID**: `{{ $('Telegram Trigger').item.json.message.chat.id }}`
- **Text reply**: `{{ $json.output || $json.reply || $json.text }}`

---

## 2) Test rapido

Proviamo messaggi del tipo:

- “Aggiungi comprare il latte”
- “Mostrami cosa devo fare oggi”
- “Segna come fatto il TODO 3”
- "ho comprato il latte"


Se la memoria è attiva, Jarvis deve capire riferimenti come “quello di prima”.
