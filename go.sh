go-pseudo-version() {
  local commit_hash="$1"
  local base_version="v0.0.0" # Use vX.Y.Z-0 if a base semver tag exists

  # Fetch UTC timestamp from the commit
  local commit_time
  commit_time=$(git show -s --format=%ct "$commit_hash" | xargs -I{} date -u -d @{} +%Y%m%d%H%M%S)

  # Get 12-character short hash
  local short_hash
  short_hash=$(git rev-parse --short=12 "$commit_hash")

  # Output the official Go mod pseudo-version format
  echo "${base_version}-${commit_time}-${short_hash}"
}
