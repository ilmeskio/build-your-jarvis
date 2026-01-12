# Step 3B — TODO con Data Tables: /list

Questa guida ci serve per leggere i TODO salvati e mostrarli in chat con il comando `/list`.

---

## 1) Aggiungiamo il comando `/list`

Nel menu comandi del bot (BotFather → /setcommands) aggiungiamo:

```
list - Mostra la lista dei TODO
```

---

## 2) Lettura dalla Data Table

Aggiungiamo un ramo per `/list` nel nostro workflow.

1. **Function / Switch**
   - Se il testo inizia con `/list`, passa al nodo Data Table.
2. **Data Table (Get/Select)**
   - Tabella: `todos`
   - Filtri:
     - `user_id = {{ $json["message"]["from"]["id"] }}`
     - `is_done = false`
3. **Set / Function**
   - Formattiamo una lista leggibile (meglio includere l’`id`).
4. **Telegram Send Message**
   - Inviamo la lista al bot.

---

## 3) Test rapido

- Inviamo `/list`.
- Controlliamo che la risposta mostri solo i TODO non completati.
