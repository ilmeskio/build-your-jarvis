# Step 3B — TODO con Data Tables: /list

Questa guida ci serve per leggere i TODO salvati e mostrarli in chat con il comando `/list`.

---

## 1) Aggiungiamo il comando `/list`

Nel menu comandi del bot (BotFather → /setcommands) abbiamo già aggiunto:

```
list - Mostra la lista dei TODO
```

se no ricordiamo di aggiungere tutti i comandi se no vengono cancellati.

---

## 2) Lettura dalla Data Table

Aggiungiamo un ramo per `/list` nel nostro workflow dove abbiamo fatto l'estrazione del comando

1. **Function / Switch**
   - Se il testo inizia con `/list`, passa al nodo Data Table.
2. **Data Table (Get/Select)**
   - Tabella: `todos`
   - Filtri (deve rispettare tutte le condizioni):
     - `user_id = {{ $('Telegram Trigger').item.json.message.from.username }}`
     - `is_done = false`
3. **Function** (costruiamo il testo della lista)
   - Incolliamo questo snippet:
   ```js
    // Prendiamo tutti gli items in ingresso (uno per TODO)
    const items = $input.all();

    if (items.length === 0) {
        return { reply: "Nessun TODO ancora 🎉" };
    }

    // Costruiamo le righe della lista
    const lines = items.map(item => {
        const row = item.json;
        return `#${row.id} — ${row.text}`;
    });

    return { reply: lines.join('\n') };
   ```
4. **Telegram Send Message**
   - Testo: `{{ $json.reply }}`
   - chat id: `{{ $('Telegram Trigger').first().json.message.chat.id}}`

---

## 3) Test rapido

- Inviamo `/list`.
- Controlliamo che la risposta mostri solo i TODO non completati.
