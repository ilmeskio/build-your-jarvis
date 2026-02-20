# Step 4 — Pokedex Agent completo (memoria + tool)

Ora colleghiamo in un solo workflow tutto quello fatto finora:
- chat nativa
- memoria
- tool Pokedex (`ADD`, `LIST`, `REMOVE`)

---

## Obiettivo

Avere un agente che capisca richieste naturali come:
- `Aggiungi bulbasaur al pokedex`
- `Rimuovi pikachu`
- `Mostrami il pokedex`

---

## 1) Workflow consigliato

Schema:

```text
Chat Trigger -> AI Agent -> Respond to Chat
                 | Memory: Simple Memory
                 | Tools: POKEDEX_ADD, POKEDEX_LIST, POKEDEX_REMOVE
```

---

## 2) Prompt di sistema suggerito

```text
Sei un assistente Pokemon.
Usa i tool disponibili invece di inventare dati.
Quando l'utente chiede di aggiungere/rimuovere/listare Pokemon, usa i tool del Pokedex.
```

---

## 3) Sessione memoria

Nel nodo `Simple Memory` usa:

```text
{{ $json.sessionId }}
```

Così le chat restano separate per sessione.

---

## 4) Test end-to-end

Esegui questa sequenza:

1. `Aggiungi squirtle al pokedex`
2. `Fammi vedere il pokedex`
3. `Rimuovi squirtle`
4. `Mostrami di nuovo il pokedex`

Se il flusso e' corretto vedrai insert, list e delete funzionare senza passare da comandi slash.
