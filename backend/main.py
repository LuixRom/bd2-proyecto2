import os

from fastapi import FastAPI


app = FastAPI(title="BD2 Proyecto 2 API")


@app.get("/health")
def health_check() -> dict[str, str]:
    """Return backend health status for Docker healthchecks."""
    return {
        "status": "ok",
        "service": "backend",
        "database": os.getenv("POSTGRES_DB", "bd2_proyecto2"),
    }
