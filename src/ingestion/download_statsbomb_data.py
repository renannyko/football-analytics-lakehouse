"""
StatsBomb Open Data ingestion utility.

This script downloads selected StatsBomb Open Data JSON files from GitHub
and stores them in a Unity Catalog Volume landing zone.

Project: Football Analytics Lakehouse
Layer: Bronze
Source: StatsBomb Open Data
"""

from pathlib import Path
from urllib.request import urlretrieve


BASE_URL = "https://raw.githubusercontent.com/statsbomb/open-data/master/data"
VOLUME_PATH = "/Volumes/football_dev/bronze/raw_files/statsbomb"


FILES_TO_DOWNLOAD = {
    "competitions": f"{BASE_URL}/competitions.json"
}


def download_file(entity_name: str, source_url: str) -> None:
    target_dir = Path(f"{VOLUME_PATH}/{entity_name}")
    target_dir.mkdir(parents=True, exist_ok=True)

    target_file = target_dir / f"{entity_name}.json"

    print(f"Downloading {entity_name} from {source_url}")
    urlretrieve(source_url, target_file)

    print(f"Saved to {target_file}")


def main() -> None:
    for entity_name, source_url in FILES_TO_DOWNLOAD.items():
        download_file(entity_name, source_url)


if __name__ == "__main__":
    main()