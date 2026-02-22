#!/bin/bash
# Script pour sauvegarder automatiquement ton travail
cd /home/lukavujanovic/Caves-of-Darkness
git add -A
git commit -m "WIP: Auto-save $(date '+%Y-%m-%d %H:%M:%S')"
echo "✅ Travail sauvegardé!"
