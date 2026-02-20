# Step 3A — Pokedex Tool: aggiungi Pokemon (Simple Tables)

Iniziamo i tool del nostro agente: salviamo Pokemon in un Pokedex usando **Simple Tables**.

---

## Obiettivo

- Creare la tabella `pokedex`.
- Aggiungere un tool `POKEDEX_ADD` collegato all'AI Agent.

---

## 1) Crea la Simple Table `pokedex`

Colonne consigliate:

| colonna      | tipo | note |
| ------------ | ---- | ---- |
| pokemon_name | text | nome normalizzato (es: pikachu) |
| type_1       | text | tipo principale |
| type_2       | text | tipo secondario opzionale |

---

## 2) Crea il tool `POKEDEX_ADD`

1. Aggiungi un nodo **AI Tool**.
2. Nome: `POKEDEX_ADD`
3. Descrizione: `Aggiunge un Pokemon al Pokedex personale`.
4. Input schema (esempio):

```json
{
  "type": "object",
  "properties": {
    "pokemon_name": { "type": "string" },
    "type_1": { "type": "string" },
    "type_2": { "type": "string" }
  },
  "required": ["pokemon_name"]
}
```

5. Collega il tool a un nodo `Simple Table` in modalità **Create Row**.
6. Mapping minimo:
   - `pokemon_name = {{ ($json.pokemon_name || '').toLowerCase().trim() }}`
   - `type_1 = {{ $json.type_1 }}`
   - `type_2 = {{ $json.type_2 }}`

---

## 3) Prompt suggerito per l'agent

Nel System Message aggiungi una regola:

```text
Quando l'utente chiede di aggiungere un Pokemon al Pokedex, usa il tool POKEDEX_ADD.
```

---

## 4) Test rapido

Messaggio test:

```text
Aggiungi Pikachu al mio pokedex
```

Verifica che appaia una nuova riga nella tabella `pokedex`.
