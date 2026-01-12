# Step 3C — TODO con Data Tables: /complete

Questa guida ci serve per segnare un TODO come completato usando `/complete <id>`.

---

## 1) Aggiungiamo il comando `/complete`

Nel menu comandi del bot (BotFather → /setcommands) aggiungiamo:

```
complete - Segna come completato un TODO tramite ID
```

---

## 2) Verifichiamo che il TODO esista

Prima di aggiornare, controlliamo se c’è davvero una riga con quell’`id`.

1. **Function / Switch**
   - Se il testo inizia con `/complete`, estraiamo l’`id`.
2. **Data Table (Get/Select)**
   - Tabella: `todos`
   - Filtro: `id = <id passato dal comando>`
3. **IF**
   - Condizione: `{{$items().length === 0}}`
   - **True** → **Telegram Send Message** con “ID non trovato”.
   - **False** → proseguiamo con l’update.

---

## 3) Update nella Data Table

Aggiungiamo un ramo per `/complete` nel workflow.

1. **Data Table (Update)**
   - Tabella: `todos`
   - Filtro: `id = <id passato dal comando>`
   - Set: `is_done = true`
2. **Telegram Send Message**
   - Conferma completamento.

---

## 4) Test rapido

- Inviamo `/complete <id>` (usiamo l’id visto in `/list`).
- Inviamo di nuovo `/list` e verifichiamo che il TODO non compaia più.
