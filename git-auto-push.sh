#!/bin/bash
# Script pour ajouter, committer et pousser automatiquement

# Aller dans le dossier du projet (optionnel)
# cd /chemin/vers/ton/projet

# Ajouter tous les changements
git add .

# Message de commit avec date/heure
commit_message="Auto-commit: $(date '+%Y-%m-%d %H:%M:%S')"

# Faire le commit
git commit -m "$commit_message"

# Pousser sur la branche actuelle
git push