from pathlib import Path
from typing import Any


class SplitBase:
    def get_document_id(self, file_path: str | Path) -> str:
        """Return the document id from a file name."""
        return Path(file_path).stem

    def normalize_file_path(self, file_path: str | Path) -> Path:
        """Return a Path and validate that the file exists."""
        path = Path(file_path)

        if not path.exists():
            raise FileNotFoundError(f"no existe el archivo: {path}")

        return path

    def validate_extension(self, file_path: Path, supported_extensions: list[str]) -> str:
        """Validate a file extension and return it normalized."""
        extension = file_path.suffix.lower()

        if extension not in supported_extensions:
            raise ValueError(f"formato no soportado: {extension}")

        return extension

    def get_chunk_id(self, document_id: str, modality: str, chunk_index: int) -> str:
        """Build the common chunk id used by the split pipeline."""
        return f"{document_id}_{modality}_{chunk_index}"

    def build_chunk(self, document_id: str, modality: str, chunk_index: int, content: Any,
                    metadata: dict[str, Any],extra_fields: dict[str, Any] | None = None) -> dict[str, Any]:
        """Build the common chunk dictionary returned by every splitter."""
        chunk = {
            "chunk_id": self.get_chunk_id(document_id, modality, chunk_index),
            "document_id": document_id,
            "modality": modality,
            "chunk_index": chunk_index,
            "content": content,
            "metadata": metadata,
        }

        if extra_fields:
            chunk.update(extra_fields)

        return chunk
