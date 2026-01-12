# Step 3A — TODO con Data Tables: crea tabella + /add

Questa guida ci serve per creare la tabella `todos` e aggiungere il primo TODO con `/add`.

---

## 1) Creiamo la Data Table `todos`

Questa tabella esiste per separare i TODO di ogni persona e tenere traccia di cosa è fatto e cosa no.

Colonne minime:

| colonna  | tipo    | note                                                         |
| ------- | ------- | ------------------------------------------------------------ |
| text    | text    | contenuto TODO                                               |
| user_id | text    | id chat Telegram (serve a non mischiare i TODO tra compagni) |
| is_done | boolean | default: false                                               |

---

## 2) Aggiungiamo il comando `/add`

Nel menu comandi del bot (BotFather → /setcommands) inseriamo:

```
add - Aggiunge un nuovo TODO
```

---

## 3) Workflow minimo per `/add`

Qui lavoriamo su uno schema semplice: Trigger → Smistamento → Inserimento → Risposta.

1. **Telegram Trigger**
   - Riceve il messaggio e il `chat_id`.
2. **Function / Switch**
   - Se il testo inizia con `/add`, passa allo step successivo.
3. **Data Table (Create/Insert)**
   - Tabella: `todos`
   - Mapping:
     - `user_id = {{ $json["message"]["from"]["id"] }}`
     - `text = <testo dopo /add>`
     - `is_done = false`
4. **Telegram Send Message**
   - Risponde con una conferma (“TODO aggiunto”).

---

## 4) Test rapido

- Inviamo `/add compra pane`.
- Verifichiamo che la riga appaia nella Data Table.
