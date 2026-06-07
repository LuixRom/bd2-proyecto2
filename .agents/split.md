# Split — Contexto para IA

> Integrante: softkp
> Rama: feat/soft-split
> Lee primero AGENTS.md antes de continuar

## 1. Qué implementar
- **Texto**: dividir documentos en chunks/párrafos
- **Imagen**: dividir imágenes en patches/regiones
- **Audio**: dividir audio en ventanas deslizantes (sliding windows)
- **Infra**: Docker Compose + PostgreSQL + pgvector

## 2. Input que recibes (datos crudos del dataset)
```python
# Texto
str  # documento completo

# Imagen
np.ndarray  # imagen completa (H x W x C)

# Audio
np.ndarray  # señal de audio completa + sample_rate
```

## 3. Output que debes devolver (va a KarolayTamayoH — Extractor)
```python
List[dict] = [
    {
        "chunk_id": str,       # identificador único del chunk
        "content": Any,        # texto: str | imagen: np.array | audio: np.array
        "modality": str,       # "text" | "image" | "audio"
        "metadata": dict       # info adicional: posición, tamaño, duración, etc.
    }
]
```

## 4. Algoritmos a implementar

### Texto — División en párrafos/chunks
```python
# Tu tarea:
# 1. Recibir documento completo como string
# 2. Dividir en párrafos o chunks de tamaño fijo
# 3. Asignar chunk_id único a cada párrafo
# 4. Incluir en metadata: posición, número de palabras
```

### Imagen — División en patches
```python
# Tu tarea:
# 1. Recibir imagen completa como np.ndarray
# 2. Dividir en patches/regiones con o sin superposición
# 3. Asignar chunk_id único a cada patch
# 4. Incluir en metadata: posición (x, y), tamaño del patch
```

### Audio — Sliding windows
```python
# Tu tarea:
# 1. Recibir señal de audio completa
# 2. Aplicar ventana deslizante de 100-200ms con overlap
# 3. Asignar chunk_id único a cada ventana
# 4. Incluir en metadata: timestamp inicio, duración, sample_rate
```

### Infra — Docker + PostgreSQL
```yaml
# docker-compose.yml debe incluir:
# - PostgreSQL con extensión pgvector
# - Scripts de inicialización de tablas
# - Variables de entorno para conexión
```

## 5. Archivos a crear
```plaintext
backend/src/split/
├── __init__.py
├── text_splitter.py       # División en párrafos
├── image_splitter.py      # División en patches
└── audio_splitter.py      # Sliding windows

backend/tests/split/
├── __init__.py
├── test_text_splitter.py
├── test_image_splitter.py
└── test_audio_splitter.py

db/
└── schema.sql             # Tablas PostgreSQL

docker-compose.yml         # PostgreSQL + pgvector
```

## 6. Librerías recomendadas
- `numpy` → operaciones matriciales
- `librosa` → carga y procesamiento de audio
- `opencv-python` → carga y procesamiento de imagen
- `sqlalchemy` → conexión PostgreSQL

## 7. Parámetros importantes
- Tamaño de chunk de texto: configurable (default 512 palabras)
- Tamaño de patch imagen: configurable (default 64x64 px)
- Ventana de audio: 100-200ms con overlap del 50%
- `chunk_id` formato: `{modality}_{documento_id}_{indice}`