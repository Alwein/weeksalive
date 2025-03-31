#!/bin/bash

### USAGE
# sh ./scripts/generate_launcher_icons.sh

# Copier les fichiers dans la racine du projet
cp assets_generation/flutter_launcher_icons.yaml ./flutter_launcher_icons.yaml

# Exécuter la commande pour générer les icônes
flutter pub run flutter_launcher_icons

# Supprimer les fichiers déplacés
rm ./flutter_launcher_icons.yaml
