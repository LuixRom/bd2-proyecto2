# Constitution — BD2 Proyecto 2

## 1. Ramas
- `main` → solo código estable y revisado
- `dev` → rama de integración
- `feat/<modulo>-<descripcion>` → nuevas funcionalidades
- `fix/<modulo>-<descripcion>` → correcciones

## 2. Formato de commits
[modulo] tipo: descripcion corta
**Módulos:** `init`, `split`, `extractor`, `codebook`, `index`, `api`, `frontend`, `db`, `experiments`, `docs`

**Tipos:** `feat`, `fix`, `test`, `refactor`, `docs`, `chore`

**Ejemplos:**
- `[split] feat: implement text chunking by paragraph`
- `[extractor] feat: add TF-IDF vectorizer`
- `[frontend] feat: add image search UI`
- `[index] fix: fix SPIMI memory overflow`

## 3. Pull Requests
- Todo merge a `dev` requiere al menos 1 review
- El PR debe referenciar su issue: `Closes #12`
- No hacer merge de tu propio PR

## 4. Issues
- Cada tarea tiene su issue en GitHub Projects
- Asignarse el issue antes de empezar a codear
- Cerrar el issue con el PR correspondiente

## 5. Responsabilidades
| Integrante | Módulo principal | Detalle |
|---|---|---|
| LuixRom | Pipeline Texto | Split texto + TF-IDF + SPIMI + Comparativa GIN |
| hanksvi | Pipeline Imagen + Frontend | Split imagen + SIFT + Comparativa pgvector + UI Next.js |
| KarolayTamayoH | Pipeline Audio + App 1 | Split audio + MFCC + App Búsqueda Musical |
| softkp | Backend + Infra + App 2 | PostgreSQL + Docker + FastAPI + Evaluación experimental + App 2 |

## 6. Reglas generales
- Archivos máximo 100 líneas (excepto configuración)
- No pushear directo a `main` ni a `dev`
- Correr `run_tests.sh` antes de cada PR
- Un integrante = un módulo = commits verificables