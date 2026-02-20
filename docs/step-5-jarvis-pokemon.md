# Step 5 — Pokedex Agent: qualità e robustezza

Step finale: rendiamo il nostro agente più affidabile e "da demo".

---

## Obiettivo

- Ridurre allucinazioni.
- Gestire errori tool in modo leggibile.
- Dare risposte coerenti e brevi.

---

## 1) Regole prompt consigliate

Aggiungi queste istruzioni nel System Message:

```text
Non inventare dati sui Pokemon.
Se un tool fallisce, spiega in una frase cosa e' successo e suggerisci un retry.
Mantieni le risposte brevi.
```

---

## 2) Error handling minimo

Nel ramo `POKEDEX_REMOVE`, se non ci sono righe eliminate:
- rispondi con: `Non ho trovato quel Pokemon nel tuo Pokedex.`

---

## 3) Checklist demo

- Ricorda il contesto (`Aggiungilo`, `Rimuovilo`)
- Usa correttamente i tool
- Risponde anche a input non validi
- Pokedex persistente nella Simple Table

---

## 4) Risultato

A questo punto hai un Pokedex Agent verticale sul dominio Pokemon, pronto per essere esteso con nuovi tool.
