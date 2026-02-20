# Speedrunner — estensioni extra del flusso Pokemon

Questa guida e' per chi ha gia' completato il percorso base:
1) Chat Echo Bot
2) Simple Chat Agent
3) Tool Pokedex (add/list/remove)
4) Lookup da PokeAPI

---

## Parte A — Evoluzioni e abilita'

### Obiettivo

Arricchire `POKEMON_LOOKUP` con:
- abilita' principali
- catena evolutiva

### Suggerimento tecnico

- Endpoint specie: `https://pokeapi.co/api/v2/pokemon-species/{id}`
- Endpoint evoluzioni (dal campo `evolution_chain.url`)

---

## Parte B — Filtri nel Pokedex

### Obiettivo

Aggiungere tool di ricerca locale sulla Simple Table:
- filtro per tipo (`type_1` / `type_2`)
- filtro per intervallo ID

Esempi richieste:
- `Mostrami solo Pokemon di tipo acqua`
- `Quali Pokemon ho tra #1 e #151?`

---

## Parte C — Team Builder (max 6)

### Obiettivo

Creare una seconda tabella `team` e tool dedicati:
- `TEAM_ADD`
- `TEAM_REMOVE`
- `TEAM_LIST`

Regola: massimo 6 Pokemon nel team.

---

## Parte D — Immagini Pokemon

### Obiettivo

Rispondere con sprite ufficiale usando URL forniti da PokeAPI.

- campo utile: `sprites.front_default`

Puoi restituire link o inviarlo in canali esterni se integri altri connettori.

---

## Parte E — Persistenza esterna con Supabase

Se vuoi una persistenza condivisa tra piu' ambienti, migra da Simple Tables a Supabase.
Mantieni gli stessi tool (`POKEDEX_ADD/LIST/REMOVE`) cambiando solo il backend.

---

## Parte F — Multi-agent

Separa ruoli in due agenti:
- `Dex Agent`: CRUD Pokedex
- `Research Agent`: lookup API avanzato

Un orchestratore decide quale agente chiamare.
