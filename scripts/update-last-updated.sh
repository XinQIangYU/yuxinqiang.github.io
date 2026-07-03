#!/usr/bin/env bash
set -euo pipefail

repo_root="$(git rev-parse --show-toplevel)"
target_file="$repo_root/index.html"
updated_date="$(LC_TIME=C date '+%B %-d, %Y')"

UPDATED_DATE="$updated_date" TARGET_FILE="$target_file" python3 <<'PY'
import os
import re
from pathlib import Path

target_file = Path(os.environ["TARGET_FILE"])
updated_date = os.environ["UPDATED_DATE"]

html = target_file.read_text(encoding="utf-8")
pattern = re.compile(r"(<br>\s*Last updated: )[A-Za-z]+ \d{1,2}, \d{4}")
updated_html, replacements = pattern.subn(rf"\g<1>{updated_date}", html, count=1)

if replacements != 1:
    raise SystemExit(f"Could not find exactly one Last updated line in {target_file}")

target_file.write_text(updated_html, encoding="utf-8")
PY
