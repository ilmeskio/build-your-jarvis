# README — Build Your Jarvis con n8n in Docker Compose

Repository: https://github.com/ilmeskio/build-your-jarvis

## 🌐 URL pubblico HTTPS con Cloudflare Tunnel

L’obiettivo è far girare n8n sulla porta `5678` e ottenere un URL pubblico in HTTPS tramite Cloudflare Tunnel.
Così possiamo condividere un link “pronto” durante il workshop senza dover esporre porte direttamente.

1. **Avvia n8n**: `docker compose up -d`
2. **Apri un tunnel HTTPS pubblico**:
   - Avvia: `cloudflared tunnel --url http://localhost:5678`
   - Copia l’URL `https://...` che cloudflared stampa e aprilo nel browser.
3. **Imposta l’hostname per i webhook (necessario per integrazioni)**:
   - Se usi un *Quick Tunnel*, l’URL cambia a ogni avvio: dopo aver visto l’URL `https://...`, imposta `N8N_PUBLIC_URL` con quel valore e ricrea il container.
   - Se vuoi un hostname stabile, crea un *Named Tunnel* con un tuo dominio su Cloudflare (rimane gratuito) e imposta `N8N_PUBLIC_URL` una sola volta.

Esempio (Quick Tunnel, dopo aver ottenuto `https://random.trycloudflare.com`):
```
cat > .env <<'EOF'
N8N_PUBLIC_URL=https://random.trycloudflare.com
EOF

docker compose up -d --force-recreate
```

### 🔧 Configurazione (versione n8n 2.0 e override)

- Config: `.env` (già incluso nel repo per il workshop).
  - `N8N_IMAGE` è impostata di default a `docker.n8n.io/n8nio/n8n:2.0.2`.
  - Per far generare URL corretti: imposta `N8N_PUBLIC_URL=https://<hostname>` (senza slash finale) e ricrea il container.
- Nota: se vuoi usare i Task Runners in modalità “external”, da n8n 2.0 non sono più inclusi nell’immagine `n8nio/n8n` e serve un container separato `n8nio/runners`.

### 🔍 Debug veloce

- Log container: `docker compose logs -f n8n`
- Healthcheck manuale: `curl -fsS http://localhost:5678 >/dev/null && echo OK`
- Tunnel manuale: `cloudflared tunnel --url http://localhost:5678`

## 🚀 Come iniziare il workshop Build Your Jarvis

1. **Forka questo repository su GitHub**: il workshop parte sempre da un tuo repo personale così puoi lavorare in uno spazio individuale e tenerlo allineato con gli altri partecipanti.
2. **Clona il fork in locale**: ti basta una macchina con Docker e Docker Compose installati; non servono altri prerequisiti.  
3. **Avvia Docker Compose**:  
   - Esegui `docker compose up -d` nella root del progetto per scaricare l’immagine ufficiale `docker.n8n.io/n8nio/n8n:2.0.2` e pubblicare la porta `5678`.  
   - Controlla i log con `docker compose logs -f n8n` finché non compare il messaggio `Editor is now accessible` e poi interrompi con `Ctrl+C`.  
   - Tutto ciò che fai dentro n8n viene salvato in `./data`, così puoi esportare workflow o azzerare l’ambiente eliminando quella directory.  
4. **Apri l’URL locale**: attendi che n8n completi il bootstrap (di solito < 30s) e visita `http://localhost:5678` per seguire l’onboarding guidato, creare l’utente amministratore e salvare le credenziali. Se vuoi approfondire, segui anche la guida ufficiale “Your first workflow” nella documentazione n8n.  
   - Documentazione: [https://docs.n8n.io/try-it-out/tutorial-first-workflow/](https://docs.n8n.io/try-it-out/tutorial-first-workflow/)

### 🔁 Comandi utili

- `docker compose ps` — mostra lo stato del container n8n.
- `docker compose logs -f n8n` — controlla i log dell’applicazione.
- `docker compose down` — spegne lo stack e libera la porta quando hai finito.

### 🖥️ Slide del workshop (Slidev)

- Sorgente: `slides.md`
- Avvio in locale: `pnpm install` poi `pnpm slides:dev`
- Build statico (per GitHub Pages): `pnpm slides:build`
- Format (Prettier + plugin Slidev): `pnpm format:slides`
- VS Code: estensione Slidev consigliata (apri Extensions e installa “Slidev”).

### 📚 Guide estese (repo)

- Step 1 (Telegram Echo Bot): [docs/step-1-telegram-echo-bot.md](https://github.com/ilmeskio/build-your-jarvis/blob/main/docs/step-1-telegram-echo-bot.md)
