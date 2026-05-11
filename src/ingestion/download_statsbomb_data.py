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

Scope:
    FIFA World Cup 2022
"""

import json
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


# -----------------------------------------------------------------------------
# Manifest builders
# -----------------------------------------------------------------------------

def build_base_manifest() -> dict[str, str]:
    """
    Builds the base file manifest required for the Bronze layer.

    Returns:
        Dictionary containing logical entity names and source URLs.
    """

    return {
        "competitions": f"{BASE_URL}/competitions.json",
        f"matches_{SELECTED_COMPETITION_ID}_{SELECTED_SEASON_ID}": (
            f"{BASE_URL}/matches/{SELECTED_COMPETITION_ID}/{SELECTED_SEASON_ID}.json"
        ),
    }


def get_world_cup_match_ids() -> list[int]:
    """
    Reads the downloaded FIFA World Cup 2022 matches file and extracts match IDs.

    This avoids hardcoding individual match IDs and allows the ingestion process
    to scale automatically to all matches available in the selected competition
    and season.

    Returns:
        List of match IDs available in the downloaded matches JSON file.
    """

    matches_file = Path(
        f"{VOLUME_PATH}/matches_{SELECTED_COMPETITION_ID}_{SELECTED_SEASON_ID}/"
        f"matches_{SELECTED_COMPETITION_ID}_{SELECTED_SEASON_ID}.json"
    )

    if not matches_file.exists():
        raise FileNotFoundError(
            f"Matches file not found: {matches_file}. "
            "Run the base ingestion first to download the matches file."
        )

    with matches_file.open("r", encoding="utf-8") as file:
        matches = json.load(file)

    return sorted({int(match["match_id"]) for match in matches})


def build_match_level_manifest(match_ids: list[int]) -> dict[str, str]:
    """
    Builds the match-level file manifest for events and lineups.

    Args:
        match_ids:
            List of match IDs to ingest.

    Returns:
        Dictionary containing logical entity names and source URLs.
    """

    manifest = {}

    for match_id in match_ids:
        manifest[f"events_{match_id}"] = f"{BASE_URL}/events/{match_id}.json"
        manifest[f"lineups_{match_id}"] = f"{BASE_URL}/lineups/{match_id}.json"

    return manifest


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

    Downloads base files first, then derives all available match IDs from the
    matches file and downloads events and lineups for each match.
    """

    # Download competition and match metadata first.
    base_manifest = build_base_manifest()

    for entity_name, source_url in base_manifest.items():
        download_file(entity_name, source_url)

    # Build match-level manifest dynamically from the downloaded matches file.
    match_ids = get_world_cup_match_ids()
    match_level_manifest = build_match_level_manifest(match_ids)

    for entity_name, source_url in match_level_manifest.items():
        download_file(entity_name, source_url)


# Script entrypoint.
if __name__ == "__main__":
    main()