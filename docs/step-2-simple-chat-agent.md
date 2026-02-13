# Step 2 — Simple Chat Agent (chat nativa n8n)

Dopo l'echo bot, passiamo subito a un agente AI dentro la chat nativa di n8n.
Tutto gira nel pannello chat integrato.

---

## Obiettivo

- Usare `Chat Trigger` come ingresso.
- Aggiungere `AI Agent` con memoria semplice.
- Rispondere in chat con `Respond to Chat`.

---

## 1) Crea il workflow

1. Nuovo workflow: `Step 2 - Simple Chat Agent`
2. Aggiungi i nodi:
   - `Chat Trigger`
   - `AI Agent`
   - `Respond to Chat`
   - `Simple Memory`
3. Collega: `Chat Trigger -> AI Agent -> Respond to Chat`
4. Collega `Simple Memory` alla porta **Memory** dell'agent.

---

## 2) Configura l'AI Agent

- Scegli il provider modello (Gemini/OpenAI/altri).
- Nel prompt usa il testo della chat in input.
- System Message esempio:

```text
Sei un assistente utile e conciso. Se non sai qualcosa, dillo chiaramente.
```

---

## 3) Configura la memoria

Nel nodo `Simple Memory` imposta una sessione stabile:

```text
{{ $json.sessionId }}
```

Così ogni chat mantiene il proprio contesto.

---

## 4) Test rapido

1. Scrivi: `Mi chiamo Ash`
2. Poi scrivi: `Come mi chiamo?`

Se la memoria è collegata bene, l'agente risponde correttamente.

---

## 5) Pubblica

Quando i test passano, fai **Publish** per lasciare il workflow attivo.
