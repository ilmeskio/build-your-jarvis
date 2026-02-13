# Step 3C — Pokedex Tool: cerca Pokemon da API pubblica

Aggiungiamo un tool che cerca dati Pokemon da una API gratuita pubblica.
Useremo **PokeAPI**: https://pokeapi.co/

---

## Obiettivo

- Creare il tool `POKEMON_LOOKUP`.
- Cercare info base (id, nome, tipi) da API esterna.
- Usare il risultato per decidere se aggiungere il Pokemon al Pokedex.

---

## 1) Crea il tool `POKEMON_LOOKUP`

1. Aggiungi un nodo **AI Tool** con nome `POKEMON_LOOKUP`.
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

3. Collega a nodo `HTTP Request`:
   - Method: `GET`
   - URL:

```text
https://pokeapi.co/api/v2/pokemon/{{ ($json.pokemon_name || '').toLowerCase().trim() }}
```

---

## 2) Normalizza la risposta

Aggiungi un nodo `Code` dopo `HTTP Request`:

```js
const p = $json;
const types = (p.types || []).map(t => t.type?.name).filter(Boolean);

return [{
  json: {
    pokemon_id: p.id,
    pokemon_name: p.name,
    type_1: types[0] || null,
    type_2: types[1] || null,
    reply: `${p.name} (#${p.id}) - tipi: ${types.join(', ') || 'n/d'}`,
  }
}];
```

---

## 3) Prompt suggerito per l'agent

```text
Quando l'utente chiede informazioni su un Pokemon, usa POKEMON_LOOKUP.
Se poi l'utente vuole aggiungerlo al Pokedex, usa POKEDEX_ADD con i dati trovati.
```

---

## 4) Test rapido

- `Cerca charizard`
- `Aggiungilo al pokedex`
- `Mostrami la mia lista pokemon`
