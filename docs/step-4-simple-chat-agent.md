# Step 4 — Simple Chat with Agent (memoria base)

Questa guida ci serve per fare un primo test con un agente AI in chat,
usando il **Chat Trigger** e una **memoria semplice**. L’obiettivo è
vedere subito un bot “conversazionale” prima di passare a Jarvis.

---

## 1) Workflow nuovo

Creiamo un nuovo workflow e lo chiamiamo `Simple Chat Agent`.

### Nodi da usare

1. **Chat Trigger**
2. **AI Agent**
3. **Respond to Chat**
4. **SimpleMemory (Memory Buffer Window)**
5. **AI Tool** (oggi)

Il flusso è:  
`Chat Trigger → AI Agent → Respond to Chat`  
con **SimpleMemory** collegata all’input “Memory” dell’AI Agent e
un **AI Tool** collegato all’input “Tools”.

---

## 2) Chat Trigger

- Lasciamo le impostazioni di default.
- Questo nodo crea automaticamente una chat di test nella UI di n8n.

---

## 3) Collegamento a Gemini (API key)

Prima di configurare l’agente, colleghiamo le API di Gemini:

1. Creiamo una API key su Google AI Studio: https://aistudio.google.com/api-keys
2. In n8n apriamo **Credentials** e creiamo una credenziale per **Gemini / Google AI**.
3. Incolliamo la API key e salviamo.

Da qui in poi potremo selezionare Gemini come modello nel nodo **AI Agent**.

---

## 4) AI Agent (System Message + chat input)

Configuriamo il nodo con il modello che vogliamo usare (Gemini, OpenAI, ecc.).

Qui usiamo:
- **System Message** per dare lo stile all’agente.
- **Prompt** come input della chat (non lo scriviamo a mano: arriva dal Chat Trigger).

Esempi di **System Message** e del loro effetto:

1) Prof severo ma giusto
```
Sei un professore severo ma giusto. Dai risposte brevi e precise.
```

2) Compagno di classe gasato
```
Sei un compagno di classe super gasato. Rispondi con entusiasmo e battute leggere.
```

3) Gamer coach
```
Sei un coach di videogiochi. Spiega in modo semplice e usa esempi da gaming.
```

Colleghiamo:
- **Input** dall’uscita del Chat Trigger
- **Memory** dall’uscita di SimpleMemory

---

## 5) Respond to Chat

Colleghiamo l’output dell’AI Agent al nodo **Respond to Chat**.
Questo nodo mostra la risposta direttamente nella chat di n8n.

---

## 6) Mini‑esperimento senza memoria

Prima di attivare la memoria, facciamo un test “a secco”:

1. Nella chat scriviamo: “Mi chiamo Luca”.
2. Poi chiediamo: “Come mi chiamo?”.

Senza memoria l’agente non ha accesso al messaggio precedente e
quasi sempre risponderà in modo generico o sbagliato.

Aggiungendo la memoria il modello riuscirà a estrarre informazioni dalla conversazione.

---

## 7) SimpleMemory

Questa memoria serve per mantenere il contesto dentro la stessa sessione chat.

Impostiamo una **Session ID** stabile, ad esempio:

```
{{ $json.sessionId }}
```

Così ogni conversazione ha il suo contesto separato.

---

## 8) Mini‑esperimento senza tool

Proviamo ora una domanda che richiede dati “reali”:

1. Chiediamo: “Che giorno e' oggi?”

Senza tool il modello non ha un calendario live e potrebbe inventare.

Con i tool permettiamo all'agente di interagire con il mondo esterno.

---

## 9) Tool semplice: TODAY (Code)

Creiamo un tool che risponde con la data di oggi, cosi' l’agente puo'
darci un risultato corretto.

1. Aggiungiamo un nodo **AI Tool**.
2. Nome tool: `TODAY`
3. Descrizione: “Risponde con la data di oggi in formato ISO.”
4. Come implementazione selezioniamo **Code** e incolliamo:

```
const now = new Date();

return now.toISOString().slice(0, 10);
```

---

## 10) Tool semplice: RANDOM_TEXT (Code)

Questo tool genera una stringa casuale lunga quanto richiesto dall’input.

1. Aggiungiamo un nodo **AI Tool**.
2. Nome tool: `RANDOM_TEXT`
3. Descrizione: “Genera una stringa casuale lunga N caratteri.”
4. Input schema in json schema:
   - ```json
        {
        "type": "object",
        "properties": {
            "length": {
                "type": "number",
                "description": "la lunghezza della stringa"
                }
            }
        }
    ```

5. Come implementazione selezioniamo **Code** e incolliamo:

```js
    const raw = $json.length ?? 16;
    const length = Math.max(1, Math.min(200, Number(raw) || 16));
    const alphabet = 'abcdefghijklmnopqrstuvwxyz0123456789';

    let out = '';
    for (let i = 0; i < length; i += 1) {
    out += alphabet[Math.floor(Math.random() * alphabet.length)];
    }

    return out;
```
