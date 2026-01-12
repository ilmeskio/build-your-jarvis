# Step 2 — Telegram Echo Bot (mini‑guida)

Questa mini‑guida ci aiuta a portare l’eco fuori da n8n e dentro Telegram, riusando lo stesso schema Trigger → Azione.

---

## 1) Creiamo il bot con BotFather

Questa sezione esiste perché Telegram richiede un token per autenticare le chiamate API del bot. Noi lo useremo in n8n come credenziale.

1. Apriamo BotFather: https://t.me/BotFather
2. Scriviamo `/newbot`
3. Scegliamo:
   - un **nome** (quello che vedremo in chat)
   - uno **username** (deve finire con `bot`, es. `JarvisBot`, e non deve essere usato da qualcun altro) 
4. Copiamo il **Bot Token** (è una stringa lunga, trattiamola come un segreto)
5. Apriamo la chat con il bot appena creato e mandiamo `/start`


---

## 2) Creiamo il workflow in n8n

Qui replichiamo il flusso visto nello Step 1, ma con nodi Telegram.

1. Aggiungiamo un **Telegram Trigger** (evento **On Message**)
2. Creiamo una credenziale Telegram e incolliamo il **Bot Token**


Clicchiamo su execute step e mandiamo un messaggio sul bot e vedremo il messaggio sulla destra.

Pinniamo i dati!


---

## 3) Rispondiamo

3. Aggiungiamo un **Telegram Send a Text Message**
4. Impostiamo:
   - **Chat ID** → `{{ $json["message"]["chat"]["id"] }}`
   - **Text** → `{{ $json["message"]["text"] }}`
5. Colleghiamo i nodi ed eseguiamo lo step con i dati pinnati
6. Aggiungiamo un field "Append n8n attribution" e disattiviamolo
