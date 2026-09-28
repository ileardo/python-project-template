# Benvenuto nel template Python — Guida di configurazione per l'AI

Questo file è il punto di ingresso per configurare un nuovo progetto Python a partire dal template.
Leggilo interamente prima di fare qualsiasi altra cosa, poi seguilo passo per passo insieme all'utente.

---

## Contesto

Hai ricevuto un template Python generico. Il template contiene tutti i file infrastrutturali di un
progetto Python moderno:

- Makefile con output colorato e target standard
- `pyproject.toml` con hatchling, Ruff e pytest preconfigurati
- GitHub Actions CI (lint + test)
- Claude Code: comandi slash (`/add-and-commit`, `/pr`, `/release`, `/write-test`) e skills
- `CLAUDE.md` con convenzioni di codice obbligatorie e gestione versioni
- `CHANGELOG.md` in formato Keep-a-Changelog
- `.env.example` e `.gitignore` completo

Tutti i valori specifici del progetto sono rappresentati da segnaposto nella forma `{{TOKEN_NAME}}`.
Il tuo compito è guidare l'utente nella configurazione iniziale, sostituire i segnaposto, e costruire
la struttura del progetto in modo corretto e completo.

Insieme a questo file, l'utente potrebbe averti passato anche `project-context.md`: un file in cui
ha scritto in linguaggio naturale ciò che già sa sul progetto. Se esiste, leggilo prima di iniziare
la Fase 1 — vedi le istruzioni all'inizio di quella fase.

---

## Fase 1 — Raccolta requisiti

Se `project-context.md` esiste nella root del progetto, leggilo per primo. Usa le informazioni
che contiene per rispondere autonomamente alle domande sotto, dove possibile. Se non esiste,
considera tutte le domande aperte.

Prima di modificare qualsiasi file, poni all'utente in un unico messaggio solo le domande rimaste
aperte o ambigue — non chiedere di nuovo ciò a cui `project-context.md` ha già risposto in modo
chiaro. Aspetta la risposta completa prima di procedere alla Fase 2.

1. **Nome del progetto** — Come si chiama il progetto?
   Sarà il nome in `pyproject.toml` e nell'intestazione di `CLAUDE.md`.
   Formato consigliato: `parole-separate-da-trattini` (es. `invoice-extractor`, `cv-training-pipeline`).

2. **Nome del package Python** — Come si chiama il package importabile?
   Deve essere `snake_case` senza trattini (es. `invoice_extractor`, `cv_pipeline`).
   Di solito è il nome del progetto con `_` al posto di `-`.

3. **Descrizione** — Una frase che descrive il progetto.
   Esempio: `"REST API for invoice processing with OCR and LLM extraction"`.

4. **Versione Python minima** — Quale versione minima di Python richiede il progetto?
   Esempio: `3.11`, `3.12`. Default consigliato: `3.12`.

5. **Dipendenze principali** — Elenca le librerie da aggiungere in `dependencies` in `pyproject.toml`.
   Esempio: `fastapi`, `torch`, `openai`, `sqlalchemy`, `opencv-python`.
   Non includere le dev deps (`pytest`, `ruff`) — quelle ci sono già.

6. **Struttura dei moduli** — Quali sottomoduli avrà il package?
   Per ciascuno indica nome e responsabilità.
   Esempio:
   - `api` → route FastAPI e middleware
   - `models` → schemi Pydantic e dataclass
   - `services` → logica di business
   - `db` → connessione e query al database

7. **Servizi opzionali** — Il progetto ha bisogno di un database, Docker, broker di messaggi, o altri
   servizi esterni? Se sì, quali? (Questo determina se aggiungere `docker-compose.yml` e target
   extra al Makefile.)

8. **Ambiente virtuale** — Che virtual environment usa questo progetto (conda, venv, altro)?
   Indica nome dell'env e comando di attivazione, es. `conda activate invoice-extractor` o
   `source .venv/bin/activate`. Questa informazione va in `CLAUDE.md` così Claude sa quando un
   comando richiede l'ambiente attivato e quando invece deve limitarsi a scriverlo per l'utente.

---

## Fase 2 — Operazioni da eseguire

Esegui questi passaggi **nell'ordine indicato**. Notifica l'utente al completamento di ogni fase.
Non saltare passaggi anche se sembrano ovvi.

### 2.1 — Sostituire i segnaposto

In tutti i file del template, sostituisci i token con i valori forniti dall'utente:

| Token | Valore |
|---|---|
| `{{PROJECT_NAME}}` | Nome del progetto (es. `invoice-extractor`) |
| `{{PACKAGE_NAME}}` | Nome del package Python (es. `invoice_extractor`) |
| `{{DESCRIPTION}}` | Descrizione del progetto |
| `{{PYTHON_MIN_VERSION}}` | Versione Python minima (es. `3.12`) |
| `{{ENV_SETUP_NOTE}}` | Nome env e comando di attivazione (es. `conda activate my-project`) |

File da aggiornare (controlla ogni occorrenza):
- `pyproject.toml` — `name`, `description`, `requires-python`, `packages`, `--cov`
- `CLAUDE.md` — Project Overview, Version Management, Environment
- `Makefile` — intestazione del target `help`, variabile `PACKAGE_NAME`
- `.github/workflows/ci.yml` — `python-version`
- `.claude/commands/write-test.md` — tutte le occorrenze di `{{PACKAGE_NAME}}`
- `.claude/commands/release.md` — occorrenze di `{{PACKAGE_NAME}}`
- `CHANGELOG.md` — voce `[0.1.0]`

### 2.2 — Rinominare la directory del package

Rinomina `src/{{PACKAGE_NAME}}/` con il nome reale del package.
Aggiorna anche il contenuto di `__init__.py` sostituendo i token.

### 2.3 — Aggiungere le dipendenze

In `pyproject.toml`, nella sezione `[project] dependencies`, aggiungi le librerie elencate
dall'utente con un vincolo di versione minima appropriato.
Usa le versioni stabili più recenti disponibili su PyPI.

Esempio:
```toml
dependencies = [
    "python-dotenv>=1.0.0",
    "fastapi>=0.110.0",
    "sqlalchemy>=2.0.0",
]
```

### 2.4 — Creare la struttura delle directory

Crea le directory standard del progetto:

```
src/<package_name>/     # già presente
tests/
data/
scripts/
```

Per ogni modulo indicato dall'utente, crea la sottodirectory:

```
src/<package_name>/
├── __init__.py          (già presente)
├── <modulo_1>/
│   └── __init__.py
├── <modulo_2>/
│   └── __init__.py
└── ...
```

E le corrispondenti directory di test:

```
tests/
├── __init__.py
├── conftest.py
└── <modulo_1>/
    └── __init__.py
```

### 2.5 — Creare gli stub `__init__.py`

Per ogni modulo creato, scrivi un `__init__.py` con:
- Docstring Google-style che descrive la responsabilità del modulo
- Nessuna importazione per ora (da aggiungere quando i moduli vengono implementati)

Template:
```python
"""<package_name>.<module_name> — <responsabilità del modulo>.

Exports:
    (populate when implemented)
"""
```

### 2.6 — Creare `tests/conftest.py`

Crea un `conftest.py` minimale:

```python
"""Shared pytest fixtures for the <package_name> test suite."""
```

### 2.7 — Aggiornare `CLAUDE.md` con stack e module map reali

Sostituisci le sezioni segnaposto in `CLAUDE.md`:

1. **Stack** — lista le tecnologie effettive (framework, DB, LLM, librerie principali)
2. **Module Map** — tabella con i moduli reali e le loro responsabilità

Se `project-context.md` esiste, usalo come fonte primaria per compilare queste sezioni (insieme
alle risposte di Fase 1): `project-context.md` non verrà versionato (vedi step 2.11), quindi le
informazioni durature che contiene vanno travasate qui, in `CLAUDE.md`, che è invece tracciato.

### 2.8 — Aggiornare `CHANGELOG.md`

Nella sezione `[0.1.0]`:
- Sostituisci `YYYY-MM-DD` con la data odierna
- Aggiorna le voci `Added` con la lista reale dei moduli e file creati

### 2.9 — Gestione servizi opzionali (solo se richiesti alla domanda 7)

Se il progetto richiede un database o Docker:

1. Crea un `docker-compose.yml` appropriato per il servizio richiesto
2. Aggiungi al Makefile i target specifici (es. `db-up`, `db-down`, `db-status`)
3. Aggiorna `.env.example` con le variabili di connessione necessarie
4. Documenta i nuovi target nella sezione `Common Commands` di `CLAUDE.md`
5. Ricordati di aggiungere i nuovi target alla riga `.PHONY` del Makefile

### 2.10 — Verifica finale

Esegui questi comandi in ordine e correggi qualsiasi errore prima di dichiarare la configurazione
completata:

```bash
make install    # deve terminare senza errori
make version    # deve stampare [PASS] Versions are synchronized
make lint       # deve terminare senza errori
make test       # deve terminare (con 0 test raccolti è normale all'inizio)
```

Riporta all'utente l'output di ogni comando.

### 2.11 — Spostamento file di contesto e pulizia

Ultimo passaggio, da eseguire solo dopo che la verifica 2.10 è andata a buon fine:

1. Crea la cartella `documents/` nella root del progetto, se non esiste già.
2. Se `project-context.md` esiste, spostalo dentro `documents/`.
3. Cancella `setup.md` (questo file).
4. Conferma all'utente che `documents/` è già presente in `.gitignore` e quindi non verrà
   versionata.

---

## Struttura del template — cosa c'è e perché

| File / Directory | Scopo |
|---|---|
| `.claude/settings.local.json` | Whitelist dei comandi Bash che Claude Code può eseguire automaticamente senza chiedere conferma. Limita l'accesso a `make`, `git`, `pip`, `pytest`, `ruff`. |
| `.claude/commands/add-and-commit.md` | Slash command `/add-and-commit`: mette in staging i file, scrive un commit message in formato Conventional Commits, esegue il commit. Argomento opzionale `verbose` per includere il body. |
| `.claude/commands/pr.md` | Slash command `/pr`: apre una Pull Request su GitHub con titolo e sommario generati automaticamente dalla lista dei commit. |
| `.claude/commands/release.md` | Slash command `/release`: guida il bump di versione, aggiorna CHANGELOG, crea il tag git e fa push. |
| `.claude/commands/write-test.md` | Slash command `/write-test <module>`: genera i test per un modulo seguendo le convenzioni del progetto. |
| `.claude/skills/commit/SKILL.md` | Skill di basso livello richiamata dalla UI di Claude Code per il flusso di commit. |
| `.claude/skills/release/SKILL.md` | Skill di basso livello per il flusso di release. |
| `.github/workflows/ci.yml` | Pipeline GitHub Actions con due job: `lint` (Ruff) e `test` (pytest). Si attiva su push e PR verso `main`. |
| `Makefile` | Automazione locale con output colorato. Target obbligatori: `help`, `install`, `setup`, `test`, `lint`, `version`. Parametrizzato con `PACKAGE_NAME` e `SRC_DIR`. |
| `pyproject.toml` | Configurazione del progetto Python: dipendenze, hatchling build backend, Ruff (line-length 100, single quotes, E/F/I/UP), pytest con coverage. |
| `src/{{PACKAGE_NAME}}/__init__.py` | Entry point del package con `__version__ = '0.1.0'` e docstring. |
| `CHANGELOG.md` | Registro delle modifiche in formato Keep-a-Changelog. Aggiornato ad ogni release. |
| `CLAUDE.md` | Guida per Claude Code: panoramica del progetto, standard di codice obbligatori (English only, type hints, docstrings, single quotes), gestione versioni semver, comandi comuni. |
| `.env.example` | Template delle variabili d'ambiente. Copiato in `.env` da `make setup`. |
| `.gitignore` | Gitignore completo per progetti Python: cache, venv, .env, editor, OS, Jupyter, packaging tools. |
| `setup.md` | Questo file — guida onboarding per l'AI. Non viene incluso nel wheel Python. Viene cancellato da Claude al termine del setup (step 2.11). |
| `project-context.md` | File opzionale compilato dall'utente con informazioni note sul progetto, letto in Fase 1. Alla fine del setup viene spostato in `documents/` (gitignored). |

---

## Regole per l'AI durante la configurazione

1. **Non commettere segreti** — `.env` non va mai in git. Controlla sempre prima di ogni commit.

2. **Usa sempre `.env` + `python-dotenv`** — nessun valore sensibile deve apparire hardcoded nel codice.

3. **Rispetta le convenzioni di `CLAUDE.md`** — tutti i file generati (stub, conftest, test) devono
   seguire gli standard obbligatori: English only, type hints, single quotes, Google-style docstrings.

4. **Non aggiungere dipendenze non richieste** — aggiungi solo le librerie esplicitamente elencate
   dall'utente. Nuove dipendenze si aggiungono in seguito con una MINOR bump di versione.

5. **Conventional Commits** — tutti i commit devono seguire `<type>(<scope>): <description>`.
   Nessun footer `Co-Authored-By` o riferimento a strumenti AI.

6. **Verifica sempre la consistenza delle versioni** — dopo qualsiasi modifica a `pyproject.toml`
   o `__init__.py`, esegui `make version` e assicurati che stampi `[PASS]`.

7. **Non modificare questo file durante la configurazione** — `setup.md` è la guida di onboarding
   e il suo contenuto non va alterato mentre segui le fasi. Viene cancellato solo alla fine, come
   ultima azione dello step 2.11.
