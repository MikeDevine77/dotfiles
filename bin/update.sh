#!/usr/bin/env bash
#
# update.sh - Safely update the local dotfiles repository.
#
# Intended to be safe for unattended execution.
#

set -Eeuo pipefail

readonly REPO="${DOTFILES_DIR:-$HOME/dev/dotfiles}"

log() {
    printf '%s: %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

die() {
    log "ERROR: $*" >&2
    exit 1
}

# ---------------------------------------------------------------------------
# Validate repository
# ---------------------------------------------------------------------------

[[ -d "$REPO" ]] ||
    die "Repository does not exist: $REPO"

git -C "$REPO" rev-parse --is-inside-work-tree >/dev/null 2>&1 ||
    die "Not a Git repository: $REPO"

# ---------------------------------------------------------------------------
# Never interfere with local changes
# ---------------------------------------------------------------------------

if ! git -C "$REPO" diff --quiet ||
   ! git -C "$REPO" diff --cached --quiet ||
   [[ -n "$(git -C "$REPO" ls-files --others --exclude-standard)" ]]; then
    die "Repository contains local changes; update skipped"
fi

# ---------------------------------------------------------------------------
# Determine current branch/upstream
# ---------------------------------------------------------------------------

branch="$(git -C "$REPO" symbolic-ref --quiet --short HEAD)" ||
    die "Repository is in detached HEAD state; update skipped"

upstream="$(git -C "$REPO" rev-parse \
    --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null)" ||
    die "Branch '$branch' has no upstream configured"

log "Checking $branch against $upstream"

# ---------------------------------------------------------------------------
# Fetch
# ---------------------------------------------------------------------------

if ! git -C "$REPO" fetch --quiet --prune; then
    die "Unable to fetch remote repository"
fi

local_commit="$(git -C "$REPO" rev-parse HEAD)"
remote_commit="$(git -C "$REPO" rev-parse '@{upstream}')"
base_commit="$(git -C "$REPO" merge-base HEAD '@{upstream}')"

# ---------------------------------------------------------------------------
# Determine relationship with upstream
# ---------------------------------------------------------------------------

if [[ "$local_commit" == "$remote_commit" ]]; then
    log "Already up to date"
    exit 0
fi

if [[ "$local_commit" == "$base_commit" ]]; then
    log "Update available"

    git -C "$REPO" merge --ff-only '@{upstream}' ||
        die "Fast-forward update failed"

    log "Successfully updated to $(git -C "$REPO" rev-parse --short HEAD)"
    exit 0
fi

if [[ "$remote_commit" == "$base_commit" ]]; then
    die "Local branch contains commits not present upstream; update skipped"
fi

die "Local and upstream branches have diverged; update skipped"

