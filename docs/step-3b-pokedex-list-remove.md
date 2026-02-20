# Step 3B — Pokedex Tool: lista e rimozione Pokemon

In questo step completiamo la gestione base del Pokedex: visualizzazione e rimozione.

---

## Obiettivo

- Creare `POKEDEX_LIST` per vedere i Pokemon salvati.
- Creare `POKEDEX_REMOVE` per rimuovere un Pokemon.

---

## 1) Tool `POKEDEX_LIST`

1. Aggiungi un nodo **AI Tool** con nome `POKEDEX_LIST`.
2. Descrizione: `Mostra i Pokemon salvati nel Pokedex`.
3. Collega a `Simple Table` in modalità **Get Many Rows**.
4. Non aggiungere nodi `Code`: lascia passare l'output raw della tabella.
5. Sara' l'agente a leggere le righe restituite e formattare la risposta all'utente.

---

## 2) Tool `POKEDEX_REMOVE`

1. Aggiungi un nodo **AI Tool** con nome `POKEDEX_REMOVE`.
2. Input schema:

```json
{
  "type": "object",
  "properties": {
    "pokemon_name": { "type": "string" }
  },
  "required": ["pokemon_name"]
}
```

3. Collega a `Simple Table` in modalità **Delete Row(s)** con filtro:

```text
pokemon_name = {{ ($json.pokemon_name || '').toLowerCase().trim() }}
```

---

## 3) Prompt suggerito per l'agent

```text
Se l'utente chiede cosa c'e' nel Pokedex usa POKEDEX_LIST.
Se chiede di togliere/rimuovere un Pokemon usa POKEDEX_REMOVE.
```

---

## 4) Test rapido

- `Quali pokemon ho nel pokedex?`
- `Rimuovi pikachu dal pokedex`
- `Fammi rivedere la lista`
