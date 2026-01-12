# Step 2 — Telegram Echo Bot (mini‑guida)

Questa mini‑guida ci aiuta a portare l’eco fuori da n8n e dentro Telegram, riusando lo stesso schema Trigger → Azione.

---

## 1) Creiamo il bot con BotFather

Questa sezione esiste perché Telegram richiede un token per autenticare le chiamate API del bot. Noi lo useremo in n8n come credenziale.

1. Apriamo BotFather: https://t.me/BotFather
2. Scriviamo `/newbot`
3. Scegliamo:
   - un **nome** (quello che vedremo in chat)
   - uno **username** (deve finire con `bot`, es. `MyWorkshopEchoBot`)
4. Copiamo il **Bot Token** (è una stringa lunga, trattiamola come un segreto)
5. Apriamo la chat con il bot appena creato e mandiamo `/start`

Perché facciamo `/start`?
Perché così Telegram “apre” la chat e noi siamo sicuri di avere un contesto reale per ricevere eventi e rispondere.

---

## 2) Creiamo il workflow in n8n

Qui replichiamo il flusso visto nello Step 1, ma con nodi Telegram.

1. Aggiungiamo un **Telegram Trigger** (evento **On Message**)
2. Creiamo una credenziale Telegram e incolliamo il **Bot Token**
3. Aggiungiamo un **Telegram Send Message**
4. Impostiamo:
   - **Chat ID** → `{{ $json["message"]["chat"]["id"] }}`
   - **Text** → `{{ $json["message"]["text"] }}`
5. Colleghiamo i nodi e attiviamo il workflow

---

## 3) Test veloce

- Scriviamo al bot su Telegram.
- Se il tunnel è attivo e il workflow è attivo, dovremmo ricevere l’eco.
- Se non arriva nulla, controlliamo che:
  - il workflow sia **Activate**
  - il tunnel sia in esecuzione
  - il bot token sia corretto
