# Step 4 — Pokedex Agent completo (memoria + tool)

Ora colleghiamo in un solo workflow tutto quello fatto finora:
- chat nativa
- memoria
- tool Pokedex (`ADD`, `LIST`, `REMOVE`, `LOOKUP`)

---

## Obiettivo

Avere un agente che capisca richieste naturali come:
- `Aggiungi bulbasaur al pokedex`
- `Rimuovi pikachu`
- `Cerca informazioni su eevee`
- `Mostrami il pokedex`

---

## 1) Workflow consigliato

Schema:

```text
Chat Trigger -> AI Agent -> Respond to Chat
                 | Memory: Simple Memory
                 | Tools: POKEDEX_ADD, POKEDEX_LIST, POKEDEX_REMOVE, POKEMON_LOOKUP
```

---

## 2) Prompt di sistema suggerito

```text
Sei un assistente Pokemon.
Usa i tool disponibili invece di inventare dati.
Se un Pokemon non esiste o l'API risponde errore, avvisa chiaramente l'utente.
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

1. `Cerca squirtle`
2. `Aggiungilo al pokedex`
3. `Fammi vedere il pokedex`
4. `Rimuovi squirtle`
5. `Mostrami di nuovo il pokedex`

Se il flusso è corretto vedrai lookup, insert, list e delete funzionare senza passare da comandi slash.
