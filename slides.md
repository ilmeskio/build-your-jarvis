---
title: Build Your Jarvis
theme: default
layout: cover
transition: null
favicon: /ironman-favicon.svg
---

# Build Your Jarvis

## n8n · AI Agent · Pokedex

### Workshop hands-on

---

## Abstract

In questo workshop costruiamo un agente AI in n8n, partendo da zero:
- chat nativa di n8n
- memoria conversazionale
- tool personalizzati su Simple Tables
- integrazione con API pubblica Pokemon

Risultato: un Jarvis verticale sul dominio Pokemon.

---

## Setup ambiente

1. Fork + clone del repository
2. Avvio:

```bash
./scripts/start
```

3. Apri n8n all'URL stampata dallo script

---

## Codespaces + Cloudflare Tunnel

Nel repository il dev container esegue automaticamente:
- `postCreateCommand: scripts/start`
- `postStartCommand: scripts/start`

Per trovare il link pubblico:
- apri i log lifecycle del dev container
- cerca `SUCCESS! Tunnel is accessible at:`
- copia `https://...trycloudflare.com`

Fallback da terminale:

```bash
tail -f .tunnel/cloudflared.log
```

---

# Step 1 — Chat Echo Bot

Workflow minimo:

```text
Chat Trigger -> Respond to Chat
```

Obiettivo: capire il pattern trigger/risposta direttamente nella chat nativa di n8n.

Guida: [docs/step-1-chat-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-1-chat-echo-bot.md)

---

# Step 2 — Simple Chat Agent

Workflow:

```text
Chat Trigger -> AI Agent -> Respond to Chat
                \-> Simple Memory
```

Obiettivo: conversazione con memoria, in chat nativa n8n.

Guida: [docs/step-2-simple-chat-agent.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-2-simple-chat-agent.md)

---

# Step 3A — Tool Pokedex Add

Creiamo la Simple Table `pokedex` e il tool `POKEDEX_ADD`.

Esempio richiesta:
- `Aggiungi pikachu al mio pokedex`

Guida: [docs/step-3a-pokedex-add.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3a-pokedex-add.md)

---

# Step 3B — Tool Pokedex List/Remove

Aggiungiamo:
- `POKEDEX_LIST`
- `POKEDEX_REMOVE`

Esempi richieste:
- `Mostrami il pokedex`
- `Rimuovi pikachu`

Guida: [docs/step-3b-pokedex-list-remove.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3b-pokedex-list-remove.md)

---

# Step 3C — Tool Pokemon Lookup (API)

Tool `POKEMON_LOOKUP` via API pubblica gratuita:

```text
https://pokeapi.co/api/v2/pokemon/{name}
```

Esempio:
- `Cerca charizard`
- `Aggiungilo al pokedex`

Guida: [docs/step-3c-pokemon-lookup-api.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3c-pokemon-lookup-api.md)

---

# Step 4 — Pokedex Agent completo

Colleghiamo memoria + tutti i tool nello stesso agent.

Guida: [docs/step-4-pokedex-agent.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-4-pokedex-agent.md)

---

# Step 5 — Jarvis Pokemon robusto

Focus:
- prompt quality
- gestione errori
- demo flow stabile

Guida: [docs/step-5-jarvis-pokemon.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-5-jarvis-pokemon.md)

---

## Speedrunner

Per chi finisce prima:
- evoluzioni e abilita'
- filtri avanzati nel Pokedex
- team builder (max 6)
- sprite immagini
- persistenza su Supabase

Guida: [docs/speedrunner.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/speedrunner.md)

---

# Gabriele Consiglio

### Freelance Software Engineer

<div style="position: absolute; bottom: 1.5rem; right: 1.5rem;">
  <img
    src="https://github.com/ilmeskio.png?size=240"
    alt="Gabriele Consiglio"
    width="200"
    style="border-radius: 999px;"
  />
</div>

- GitHub: [github.com/ilmeskio](https://github.com/ilmeskio)
