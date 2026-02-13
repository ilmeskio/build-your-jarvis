# README — Build Your ~~Jarvis~~ Pokedex con n8n in Docker Compose

Repository: https://github.com/ilmeskio/build-your-jarvis
Slide: https://ilmeskio.github.io/build-your-jarvis/

## URL pubblico HTTPS con Cloudflare Tunnel

L'obiettivo e' far girare n8n sulla porta `5678` e ottenere un URL pubblico HTTPS tramite Cloudflare Tunnel.

### Setup automatico (raccomandato)

```bash
chmod +x scripts/start scripts/stop
./scripts/start
```

Lo script:
1. scarica `cloudflared` se manca
2. avvia tunnel in background
3. estrae URL `https://...trycloudflare.com`
4. aggiorna `.env` (`N8N_PUBLIC_URL`)
5. ricrea il container n8n
6. verifica raggiungibilita'

Per fermare tutto:

```bash
./scripts/stop
```

Comandi utili:

```bash
tail -f .tunnel/cloudflared.log
docker compose logs -f n8n
```

### Setup su GitHub Codespaces

Il repo usa:
- `postCreateCommand: scripts/start`
- `postStartCommand: scripts/start`

Quindi al bootstrap del dev container parte gia' tunnel + n8n.

Dove trovare il link pubblico nel Codespace:
1. apri i log del dev container (Output/Terminal dei lifecycle command)
2. cerca la riga `SUCCESS! Tunnel is accessible at:`
3. copia l'URL `https://...trycloudflare.com`

Se vuoi verificare da terminale dentro Codespace:

```bash
tail -f .tunnel/cloudflared.log
```

---

## Come iniziare il workshop

1. Fork del repository su GitHub.
2. Avvio locale o in Codespaces.
3. Onboarding n8n sulla URL locale o tunnel.

---

## Flusso workshop aggiornato

- Step 1: Chat Echo Bot (chat nativa n8n)
- Step 2: Simple Chat Agent (chat nativa, memoria base)
- Step 3A: Pokedex Add (Simple Table + tool `POKEDEX_ADD`)
- Step 3B: Pokedex List/Remove (tool `POKEDEX_LIST`, `POKEDEX_REMOVE`)
- Step 3C: Pokemon Lookup API (tool `POKEMON_LOOKUP` via PokeAPI)
- Step 4: Pokedex Agent completo (tool orchestration)
- Step 5: Pokedex Agent robusto (error handling e quality)
- Speedrunner: estensioni extra

Guide repo:
- Step 1: [docs/step-1-chat-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-1-chat-echo-bot.md)
- Step 2: [docs/step-2-simple-chat-agent.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-2-simple-chat-agent.md)
- Step 3A: [docs/step-3a-pokedex-add.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3a-pokedex-add.md)
- Step 3B: [docs/step-3b-pokedex-list-remove.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3b-pokedex-list-remove.md)
- Step 3C: [docs/step-3c-pokemon-lookup-api.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-3c-pokemon-lookup-api.md)
- Step 4: [docs/step-4-pokedex-agent.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-4-pokedex-agent.md)
- Step 5: [docs/step-5-jarvis-pokemon.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-5-jarvis-pokemon.md)
- Speedrunner: [docs/speedrunner.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/speedrunner.md)

---

## Slide del workshop (Slidev)

- Sorgente: `slides.md`
- Avvio locale: `pnpm install` poi `pnpm slides:dev`
- Build statico: `pnpm slides:build`
- Format: `pnpm format:slides`

---

## Sicurezza

- Non condividere segreti/API key.
- Tratta `./data` come directory sensibile (puo' contenere credenziali).
