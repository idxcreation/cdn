#!/usr/bin/env bash
# Ajoute tous les changements, commit (message auto ou fourni) et push sur la branche courante.
# - Ignore s'il n'y a rien à committer
# - Crée l'upstream si elle n'existe pas
# Usage :
#   ./git-auto-push.sh                # commit auto daté
#   ./git-auto-push.sh "Mon message"  # message perso

set -euo pipefail

# 1) Vérifier qu'on est bien dans un repo git
if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "❌ Ce dossier n'est pas un dépôt Git."
  exit 1
fi

# 2) Ajouter tous les changements (ajouts/suppressions/modifs)
git add -A

# 3) S'il n'y a rien à committer, on sort proprement
if ! git status --porcelain | grep -q .; then
  echo "ℹ️ Rien à committer."
  exit 0
fi

# 4) Message de commit
if [ $# -gt 0 ]; then
  commit_message="$*"
else
  commit_message="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"
fi

git commit -m "$commit_message" || {
  echo "⚠️ Commit non effectué (peut-être vide)."
  exit 0
}

# 5) Détecter la branche courante
branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "HEAD" ]; then
  echo "❌ Branche détachée (HEAD). Impossible de pousser automatiquement."
  exit 1
fi

# 6) Vérifier/Créer l’upstream si absent
if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
  # Upstream existe → push normal
  git push
else
  # Pas d’upstream → on pousse et on la crée
  git push -u origin "$branch"
fi

echo "✅ Push terminé sur '$branch' — message: $commit_message"