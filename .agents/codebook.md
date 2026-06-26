# Codebook — Contexto para IA

> Integrante: LuixRom
> Rama: feat/luix-codebook
> Lee primero AGENTS.md antes de continuar

## 1. Qué implementar
- **Texto**: Top-K palabras más frecuentes de la colección → codebook textual
- **Imagen**: K-Means sobre descriptores SIFT → visual words
- **Audio**: K-Means sobre coeficientes MFCC → acoustic words
- **Frontend**: UI en Next.js para interactuar con el sistema

## 2. Input que recibes (viene de KarolayTamayoH — Extractor)
```python
List[dict] = [
    {
        "chunk_id": str,
        "modality": str,       # "text" | "image" | "audio"
        "features": np.ndarray
        # texto: frecuencias de palabras por chunk (ya tokenizado + sin stopwords + stemmed + TF-IDF)
        # imagen: descriptores SIFT por patch
        # audio: coeficientes MFCC por ventana
    }
]
```

## 3. Output que debes devolver (va a hanksvi — Retrieval)
```python
List[dict] = [
    {
        "chunk_id": str,
        "modality": str,
        "histogram": np.ndarray  # vector de frecuencias de codewords
    }
]
```

## 4. Algoritmos a implementar

### Texto — Top-K palabras
```python
# Recibes: frecuencias TF-IDF ya procesadas por KarolayTamayoH
# Tu tarea:
# 1. Contar frecuencias globales en toda la colección
# 2. Seleccionar top-K palabras más frecuentes → codebook textual
# 3. Para cada chunk: generar histograma de frecuencias de esas K palabras
```

### Imagen — K-Means visual words
```python
# Recibes: descriptores SIFT por patch de KarolayTamayoH
# Tu tarea:
# 1. Aplicar K-Means sobre todos los descriptores → k centroides
# 2. Centroides = visual words (codebook visual)
# 3. Para cada chunk: asignar descriptor a centroide más cercano
# 4. Generar histograma de visual words por chunk
```

### Audio — K-Means acoustic words
```python
# Recibes: coeficientes MFCC de KarolayTamayoH
# Tu tarea:
# 1. Aplicar K-Means sobre todos los MFCC → k centroides
# 2. Centroides = acoustic words (codebook acústico)
# 3. Para cada chunk: asignar MFCC a centroide más cercano
# 4. Generar histograma de acoustic words por chunk
```

### Frontend — UI Next.js

Página principal: input de búsqueda multimodal (texto, imagen, audio)
Resultados: mostrar chunks recuperados con score de similitud
Conectar con endpoints FastAPI del backend
Componentes: SearchBar, ResultCard, ModalitySelector


## 5. Archivos a crear
```plaintext
backend/src/codebook/
├── __init__.py
├── base_codebook.py       # Clase base compartida
├── text_codebook.py       # Top-K palabras
├── image_codebook.py      # K-Means visual words
└── audio_codebook.py      # K-Means acoustic words

backend/tests/codebook/
├── __init__.py
├── test_text_codebook.py
├── test_image_codebook.py
└── test_audio_codebook.py

frontend/
├── app/
│   ├── page.tsx           # Página principal
│   └── search/
│       └── page.tsx       # Página de resultados
└── components/
    ├── SearchBar.tsx
    ├── ResultCard.tsx
    └── ModalitySelector.tsx
```

## 6. Librerías recomendadas
- `scikit-learn` → KMeans
- `numpy` → operaciones matriciales
- `next` → frontend
- `tailwindcss` → estilos

## 7. Parámetros importantes
- `k` = número de codewords (constante configurable)
- Inicializar K-Means con `k-means++`
- Guardar codebook entrenado en PostgreSQL para persistencia