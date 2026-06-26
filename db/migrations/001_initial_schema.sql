CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS pg_trgm;

CREATE TABLE IF NOT EXISTS documents (
    document_id TEXT PRIMARY KEY,
    source_path TEXT,
    modality TEXT NOT NULL CHECK (modality IN ('text', 'image', 'audio')),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS chunks (
    chunk_id TEXT PRIMARY KEY,
    document_id TEXT NOT NULL REFERENCES documents(document_id) ON DELETE CASCADE,
    modality TEXT NOT NULL CHECK (modality IN ('text', 'image', 'audio')),
    chunk_index INTEGER NOT NULL,
    content_text TEXT,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (document_id, modality, chunk_index)
);

CREATE TABLE IF NOT EXISTS feature_vectors (
    feature_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    chunk_id TEXT NOT NULL REFERENCES chunks(chunk_id) ON DELETE CASCADE,
    modality TEXT NOT NULL CHECK (modality IN ('text', 'image', 'audio')),
    feature vector,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS codebooks (
    codebook_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    modality TEXT NOT NULL CHECK (modality IN ('text', 'image', 'audio')),
    codebook_size INTEGER NOT NULL CHECK (codebook_size > 0),
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS codebook_histograms (
    histogram_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    chunk_id TEXT NOT NULL REFERENCES chunks(chunk_id) ON DELETE CASCADE,
    codebook_id BIGINT REFERENCES codebooks(codebook_id) ON DELETE SET NULL,
    modality TEXT NOT NULL CHECK (modality IN ('text', 'image', 'audio')),
    histogram vector,
    metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS inverted_index (
    index_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    codebook_id BIGINT REFERENCES codebooks(codebook_id) ON DELETE CASCADE,
    codeword INTEGER NOT NULL,
    chunk_id TEXT NOT NULL REFERENCES chunks(chunk_id) ON DELETE CASCADE,
    weight DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE (codebook_id, codeword, chunk_id)
);

CREATE INDEX IF NOT EXISTS idx_chunks_document_id ON chunks(document_id);
CREATE INDEX IF NOT EXISTS idx_chunks_modality ON chunks(modality);
CREATE INDEX IF NOT EXISTS idx_chunks_metadata ON chunks USING GIN (metadata);
CREATE INDEX IF NOT EXISTS idx_feature_vectors_chunk_id ON feature_vectors(chunk_id);
CREATE INDEX IF NOT EXISTS idx_histograms_chunk_id ON codebook_histograms(chunk_id);
CREATE INDEX IF NOT EXISTS idx_inverted_index_codeword ON inverted_index(codebook_id, codeword);
