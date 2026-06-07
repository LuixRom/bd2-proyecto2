# Retrieval e Índices — Contexto para IA

> Integrante: hanksvi
> Rama: feat/hanks-retrieval
> Lee primero AGENTS.md antes de continuar

## 1. Qué implementar
- **Texto**: SPIMI + índice invertido
- **Imagen**: histogramas visuales + búsqueda visual
- **Audio**: histogramas acústicos + búsqueda acústica
- **Apps**: App 1 Búsqueda Musical + App 2 Búsqueda Visual E-commerce

## 2. Input que recibes (viene de LuixRom — Codebook)
```python
List[dict] = [
    {
        "chunk_id": str,
        "modality": str,
        "histogram": np.ndarray  # vector de frecuencias de codewords
    }
]
```

## 3. Output que debes devolver (va a la API — FastAPI)
```python
List[dict] = [
    {
        "chunk_id": str,
        "score": float,      # similitud con la consulta
        "metadata": dict     # info adicional del chunk
    }
]
```

## 4. Algoritmos a implementar

### Texto — SPIMI + Índice Invertido
```python
# Recibes: histogramas textuales de LuixRom
# Tu tarea:
# 1. Implementar SPIMI (Single Pass In-Memory Indexing)
#    - Procesar chunks en un solo paso
#    - Generar bloques de índice en disco cuando memoria se llena
#    - Mergear bloques en índice final
# 2. Índice invertido: mapear codeword → List[chunk_id, frecuencia]
# 3. Para consulta: calcular score por similitud coseno
# 4. Devolver top-K chunks ordenados por score
```

### Imagen — Histogramas visuales + Búsqueda
```python
# Recibes: histogramas de visual words de LuixRom
# Tu tarea:
# 1. Almacenar histogramas en PostgreSQL
# 2. Para consulta de imagen:
#    - Calcular histograma de la imagen query
#    - Comparar con histogramas almacenados (distancia L2 o coseno)
#    - Devolver top-K imágenes más similares
```

### Audio — Histogramas acústicos + Búsqueda
```python
# Recibes: histogramas de acoustic words de LuixRom
# Tu tarea:
# 1. Almacenar histogramas en PostgreSQL
# 2. Para consulta de audio:
#    - Calcular histograma del audio query
#    - Comparar con histogramas almacenados
#    - Devolver top-K audios más similares
```

### App 1 — Búsqueda Musical
```python
# Buscar canciones por:
# - Letra (texto): usar índice invertido textual
# - Similitud acústica (audio): usar histogramas acústicos
# Dataset: Spotify songs o FMA (Kaggle)
# Endpoint: POST /search/music
```

### App 2 — Búsqueda Visual E-commerce
```python
# Usuario sube foto → sistema retorna 10 productos similares
# - Similitud visual (imagen): usar histogramas visuales
# Dataset: Fashion Product Images (Kaggle, 44K imágenes)
# Endpoint: POST /search/visual
```

## 5. Archivos a crear
```plaintext
backend/src/index/
├── __init__.py
├── spimi.py               # SPIMI algorithm
├── inverted_index.py      # Índice invertido
├── visual_search.py       # Búsqueda por imagen
└── audio_search.py        # Búsqueda por audio

backend/api/
├── __init__.py
├── main.py                # FastAPI app
└── routes/
    ├── search.py          # Endpoints de búsqueda
    ├── music.py           # App 1 endpoints
    └── visual.py          # App 2 endpoints

backend/tests/index/
├── __init__.py
├── test_spimi.py
├── test_inverted_index.py
├── test_visual_search.py
└── test_audio_search.py
```

## 6. Librerías recomendadas
- `numpy` → operaciones matriciales
- `scipy` → distancias coseno y L2
- `sqlalchemy` → almacenamiento en PostgreSQL
- `fastapi` → endpoints de las apps
- `uvicorn` → servidor ASGI

## 7. Parámetros importantes
- SPIMI: tamaño de bloque en memoria configurable
- Top-K resultados: configurable (default 10)
- Métrica de similitud: coseno para texto, L2 para imagen y audio
- Guardar índice invertido en PostgreSQL para persistencia