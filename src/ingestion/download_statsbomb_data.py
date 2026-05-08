"""
StatsBomb Open Data ingestion utility.

This script downloads selected StatsBomb Open Data JSON files from GitHub
and stores them inside a Unity Catalog Volume to support the Bronze layer
of the Football Analytics Lakehouse project.

Architecture:
GitHub Raw Files -> Unity Catalog Volume -> Bronze Streaming Tables

Project:
    Football Analytics Lakehouse

Layer:
    Bronze

Source:
    StatsBomb Open Data

Initial Scope:
    FIFA World Cup 2022
    Final Match: Argentina vs France
"""

from pathlib import Path
from urllib.request import urlretrieve


# -----------------------------------------------------------------------------
# Source configuration
# -----------------------------------------------------------------------------

# Base URL for the StatsBomb Open Data GitHub repository.
BASE_URL = "https://raw.githubusercontent.com/statsbomb/open-data/master/data"

# Unity Catalog Volume path used as the Bronze landing zone.
VOLUME_PATH = "/Volumes/football_dev/bronze/raw_files/statsbomb"


# -----------------------------------------------------------------------------
# Project scope configuration
# -----------------------------------------------------------------------------

# Competition and season selected for the first project scope:
# FIFA World Cup 2022.
SELECTED_COMPETITION_ID = 43
SELECTED_SEASON_ID = 106

# Match selected for the first controlled ingestion batch:
# FIFA World Cup 2022 Final — Argentina vs France.
SELECTED_MATCH_IDS = [
    3869685,
]


# -----------------------------------------------------------------------------
# File manifest
# -----------------------------------------------------------------------------

# Base entities required to start the Bronze layer.
FILES_TO_DOWNLOAD = {
    "competitions": f"{BASE_URL}/competitions.json",
    f"matches_{SELECTED_COMPETITION_ID}_{SELECTED_SEASON_ID}": (
        f"{BASE_URL}/matches/{SELECTED_COMPETITION_ID}/{SELECTED_SEASON_ID}.json"
    ),
}

# Match-level entities. These files are generated dynamically based on the
# selected match IDs to keep the ingestion scope controlled in Databricks Free.
for match_id in SELECTED_MATCH_IDS:
    FILES_TO_DOWNLOAD[f"events_{match_id}"] = f"{BASE_URL}/events/{match_id}.json"
    FILES_TO_DOWNLOAD[f"lineups_{match_id}"] = f"{BASE_URL}/lineups/{match_id}.json"


# -----------------------------------------------------------------------------
# Ingestion functions
# -----------------------------------------------------------------------------

def download_file(entity_name: str, source_url: str) -> None:
    """
    Downloads a JSON file from StatsBomb Open Data into the Unity Catalog Volume.

    The function is idempotent:
    - If the target file already exists, the download is skipped.
    - If the file does not exist, it is downloaded and stored.

    Args:
        entity_name:
            Logical entity identifier used to organize files in the landing zone.

        source_url:
            Public GitHub raw URL containing the source JSON file.
    """

    # Create entity-specific directory inside the Bronze landing zone.
    target_dir = Path(f"{VOLUME_PATH}/{entity_name}")
    target_dir.mkdir(parents=True, exist_ok=True)

    # Standardized target filename used by downstream Bronze pipelines.
    target_file = target_dir / f"{entity_name}.json"

    # Prevent unnecessary downloads and reprocessing in Databricks Free.
    if target_file.exists():
        print(f"File already exists. Skipping download: {target_file}")
        return

    # Download source file from GitHub.
    print(f"Downloading {entity_name} from {source_url}")
    urlretrieve(source_url, target_file)

    # Log successful ingestion.
    print(f"Saved to {target_file}")


def main() -> None:
    """
    Main orchestration function.

    Iterates through all configured source entities and triggers ingestion.
    """

    for entity_name, source_url in FILES_TO_DOWNLOAD.items():
        download_file(entity_name, source_url)


# Script entrypoint.
if __name__ == "__main__":
    main()