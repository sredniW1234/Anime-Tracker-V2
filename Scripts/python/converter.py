import json
import time
from datetime import datetime


def format_date(old_date: str, label: str) -> str:
    """
    Converts 'mm/dd/yyyy' -> 'Label: mm/dd/yyyy'
    Returns 'Select Start/End Date' if empty or invalid.
    """
    if not old_date or not isinstance(old_date, str):
        return f"Select {label} Date"

    old_date = old_date.strip()

    # Very light validation (keeps you flexible)
    if "/" not in old_date:
        return f"Select {label} Date"

    return f"{label}: {old_date}"


def split_key(key: str):
    # "Item Name^3" -> ("Item Name", 3)
    name, idx = key.rsplit("^", 1)
    return name, int(idx)


def parse_segment(segment: str):
    # "3/12" -> (3, 12)
    try:
        cur, total = segment.split("/")
        return int(cur), int(total)
    except Exception:
        return 0, 0


def parse_rating(rating: str):
    # "7/10" -> 7.0
    try:
        return float(rating.split("/")[0])
    except Exception:
        return 0.0


def convert_item(key, src):
    def normalize_status(old_status: str) -> str:
        match old_status:
            case "complete":
                return "completed"
            case "started":
                return "watching"
            case _:
                return old_status

    item_name, index = split_key(key)
    status = normalize_status(src.get("Status", ""))
    cur_ep, total_ep = parse_segment(src.get("Segment", "0/0"))

    data = {
        "item_name": item_name,
        "type": "movie" if src.get("Movie", 0) else "season",
        "status": status,
        "icon": src.get("Icon", ""),
        "is_favorite": src.get("Favorite", False),
        "genres": [],
        "current_episode": cur_ep,
        "total_episodes": total_ep,
        "rating": parse_rating(src.get("Rating", "0/10")),
        "notes": src.get("Notes", ""),
        "episodes_rewatched": src.get("Rewatches", 0),
        "date_started": format_date(src.get("Date Started", ""), "Date Started"),
        "date_ended": format_date(src.get("Date Ended", ""), "Date Ended"),
        "date_modified": int(time.time()),
        "auto_track": True,
    }

    # Ongoing-only fields (mirror new export exactly)
    if status == "ongoing":
        data.update(
            {
                "release_schedule": "",
                "date_release_started": "",
                "max_episodes": total_ep,
            }
        )

    # Children
    if "Children" in src:
        children = {}
        for child_key, child_src in src["Children"].items():
            _, child_idx = split_key(child_key)
            children[str(child_idx)] = convert_item(child_key, child_src)

        if children:
            data["children"] = dict(sorted(children.items(), key=lambda x: int(x[0])))

    return data


def convert_save(old_save):
    new_save = {"list_name": old_save.get("List Name", ""), "tree": {}}

    for key, value in old_save.get("List Data", {}).items():
        _, idx = split_key(key)
        new_save["tree"][str(idx)] = convert_item(key, value)

    new_save["tree"] = dict(sorted(new_save["tree"].items(), key=lambda x: int(x[0])))

    return new_save


if __name__ == "__main__":
    with open("My Anime List - Test.alt", "r", encoding="utf-8") as f:
        old_data = json.load(f)

    new_data = convert_save(old_data)

    with open("new_save.at2", "w", encoding="utf-8") as f:
        json.dump(new_data, f, indent=4, ensure_ascii=False)

    print("Save successfully converted.")
