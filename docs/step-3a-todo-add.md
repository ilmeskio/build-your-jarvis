# Step 3A — TODO con Data Tables: crea tabella + /add

Questa guida ci serve per creare la tabella `todos` e aggiungere il primo TODO con `/add`.

---

## 1) Creiamo la Data Table `todos`

Questa tabella esiste per separare i TODO di ogni persona e tenere traccia di cosa è fatto e cosa no.

Colonne minime:

| colonna | tipo    | note                                                       |
| ------- | ------- | ---------------------------------------------------------- |
| text    | text    | contenuto TODO                                             |
| user_id | text    | id chat Telegram (serve a non mischiare i TODO tra utenti) |
| is_done | boolean | default: false                                             |

---

## 2) Aggiungiamo il comando `/add`

Nel menu comandi del bot (BotFather → /setcommands) inseriamo:

```
add - Aggiunge un nuovo TODO
list - Mostra la lista dei TODO
complete - Segna come completato un TODO tramite ID
```

(ci servono tutti subito per semplicità)

---

## 3) Workflow minimo per `/add`

Qui lavoriamo su uno schema semplice: Trigger → Smistamento → Inserimento → Risposta.

1. **Telegram Trigger**
   - Riceve il messaggio e il `chat_id`.
2. **Function** (estrai comando + testo)
   - Incolliamo questo snippet:
   ```js
    const text = ($input.first().json.message.text || '').trim();

    const [command, ...rest] = text.split(/\s+/);
    const body = rest.join(' ').trim();

    return {
        command,  // es: "/add"
        body      // es: "compra pane"
    };
   ```
3. **Switch** 
   - Se il testo inizia con `/add`, segue la route dedicata 
   - possiamo rinominare l'output /add per semplicità
4. **Data Table (Create/Insert)**
   - Tabella: `todos`
   - Mapping:
     - `user_id = {{ $('Telegram Trigger').item.json.message.from.username }}`
     - `text = {{ $json.body }}`
     - `is_done = false`
5. **Telegram Send Message**
   - Risponde con una conferma (“TODO aggiunto”).

---

## 4) Test rapido

- Inviamo `/add compra pane`.
- Verifichiamo che la riga appaia nella Data Table.
