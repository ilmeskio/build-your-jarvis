# README — Eseguire n8n in GitHub Codespaces con Docker

## 🎯 Obiettivi del progetto

Questo progetto ha un unico scopo: **avviare un'istanza di n8n dentro un GitHub Codespace usando Docker**, in modo da poterla raggiungere tramite l’**URL pubblico di anteprima del Codespace**.

### Obiettivi principali

- 🐳 Eseguire **n8n** come container Docker dentro un **GitHub Codespace**.  
- 🌐 Esporre l’interfaccia web di n8n sulla **porta 5678**, accessibile tramite l’URL generato da Codespaces.  
- 🧩 Non usare altre tecnologie o strumenti (niente Node, Compose, o altro).  
- ⚙️ Configurare gli **environment variables** necessari per far funzionare correttamente l’istanza n8n nel contesto del Codespace.  
- 🔐 Supportare il protocollo HTTPS nativo di Codespaces.  

### Risultato atteso

Al termine della configurazione:
- n8n sarà eseguito come container Docker nel Codespace.  
- Sarà raggiungibile via browser all’indirizzo del codespace
- I dati (workflow, credenziali, configurazioni) non resteranno salvati anche dopo il riavvio ma va bene così

---

## 📦 Scopo del repository

Questo repository serve come **base minima** per:

- Testare e sviluppare workflow n8n direttamente in Codespaces.  
- Usare n8n come ambiente di automazione temporaneo o di prova.  
- Avere un setup riproducibile e isolato, senza installazioni locali.

---

## 🚀 Prossimi passi

1. Preparare un `Dockerfile` o un comando `docker run` per eseguire l’immagine ufficiale di n8n (`n8nio/n8n:latest`).  
2. Definire le variabili d’ambiente che collegano l’istanza n8n all’URL del Codespace.  
3. Esporre la porta `5678` e impostarla come **Public** nel pannello **Ports**.  
4. Verificare che l’interfaccia web di n8n sia accessibile dall’URL generato.  

---

## 🧩 Suggerimenti di espansione (facoltativi)

- Aggiungere uno script di avvio automatico (`devcontainer.json` o `postAttachCommand`) per lanciare il container all’apertura del Codespace.  
- Configurare volumi persistenti o backup automatici.  
- Integrare n8n con API o risorse interne del progetto.  

---

## 🔚 In sintesi

> Il progetto mira solo a fornire un ambiente Codespace con Docker in grado di eseguire **n8n** e renderlo accessibile tramite l’**URL pubblico del Codespace**, senza alcuna tecnologia aggiuntiva.