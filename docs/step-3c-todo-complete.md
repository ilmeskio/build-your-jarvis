# Step 3C — TODO con Data Tables: /complete

Questa guida ci serve per segnare un TODO come completato usando `/complete <id>`.

---

## 1) Aggiungiamo il comando `/complete`

Nel menu comandi del bot (BotFather → /setcommands) aggiungiamo:

```
complete - Segna come completato un TODO tramite ID
```

---

## 2) Update nella Data Table

Aggiungiamo un ramo per `/complete` nel workflow.

1. **Function / Switch**
   - Se il testo inizia con `/complete`, estraiamo l’`id`.
2. **Data Table (Update)**
   - Tabella: `todos`
   - Filtro: `id = <id passato dal comando>`
   - Set: `is_done = true`
3. **Telegram Send Message**
   - Conferma completamento.

---

## 3) Test rapido

- Inviamo `/complete <id>` (usiamo l’id visto in `/list`).
- Inviamo di nuovo `/list` e verifichiamo che il TODO non compaia più.
