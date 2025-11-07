# README — Build Your Jarvis con n8n in Docker Compose

## 🚀 Come iniziare il workshop Build Your Jarvis

1. **Forka questo repository su GitHub**: il workshop parte sempre da un tuo repo personale così puoi lavorare in uno spazio individuale e tenerlo allineato con gli altri partecipanti.
2. **Clona il fork in locale**: ti basta una macchina con Docker e Docker Compose installati; non servono altri prerequisiti.  
3. **Avvia Docker Compose**:  
   - Esegui `docker compose up -d` nella root del progetto per scaricare l’immagine ufficiale `docker.n8n.io/n8nio/n8n:latest` e pubblicare la porta `5678`.  
   - Controlla i log con `docker compose logs -f n8n` finché non compare il messaggio `Editor is now accessible` e poi interrompi con `Ctrl+C`.  
   - Tutto ciò che fai dentro n8n viene salvato nella cartella `./data`, così puoi esportare workflow o azzerare l’ambiente eliminando quella directory.  
4. **Apri l’URL locale**: attendi che n8n completi il bootstrap (di solito < 30s) e visita `http://localhost:5678` per seguire l’onboarding guidato, creare l’utente amministratore e salvare le credenziali. Se vuoi approfondire, segui anche la guida ufficiale “Your first workflow” nella documentazione n8n.  
   - Documentazione: [https://docs.n8n.io/try-it-out/tutorial-first-workflow/](https://docs.n8n.io/try-it-out/tutorial-first-workflow/)

### 🔁 Comandi utili

- `docker compose ps` — mostra lo stato del container n8n.
- `docker compose logs -f n8n` — controlla i log dell’applicazione.
- `docker compose down` — spegne lo stack e libera la porta quando hai finito.
