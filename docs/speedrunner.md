# Speedrunner — estensioni extra del flusso Pokemon

Questa guida e' per chi ha gia' completato il percorso base:
1) Chat Echo Bot
2) Simple Chat Agent
3) Tool Pokedex (add/list/remove)

---

## Parte A — Filtri nel Pokedex

### Obiettivo

Aggiungere tool di ricerca locale sulla Simple Table:
- filtro per tipo (`type_1` / `type_2`)
- filtro per prefisso nome

Esempi richieste:
- `Mostrami solo Pokemon di tipo acqua`
- `Mostrami i Pokemon che iniziano per char`

---

## Parte B — Team Builder (max 6)

### Obiettivo

Creare una seconda tabella `team` e tool dedicati:
- `TEAM_ADD`
- `TEAM_REMOVE`
- `TEAM_LIST`

Regola: massimo 6 Pokemon nel team.

---

## Parte C — Immagini Pokemon

### Obiettivo

Salvare e mostrare un campo `sprite_url` nei record del Pokedex.

Puoi restituire link o inviarlo in canali esterni se integri altri connettori.

---

## Parte D — Persistenza esterna con Supabase

Se vuoi una persistenza condivisa tra piu' ambienti, migra da Simple Tables a Supabase.
Mantieni gli stessi tool (`POKEDEX_ADD/LIST/REMOVE`) cambiando solo il backend.

---

## Parte E — Multi-agent

Separa ruoli in due agenti:
- `Dex Agent`: CRUD Pokedex
- `Coach Agent`: suggerimenti su team e strategie

Un orchestratore decide quale agente chiamare.
