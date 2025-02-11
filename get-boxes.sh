#!/bin/bash

# Liste des boîtes Vagrant à ajouter
boxes=(
    "generic/rocky9"
    "generic/debian12"
    "generic/opensuse15"
    "bento/ubuntu-22.04"
)

# Ajouter chaque boîte Vagrant
for box in "${boxes[@]}"; do
    echo "Ajout de la boîte Vagrant : $box"
    vagrant box add "$box"
done

echo "Toutes les boîtes Vagrant ont été ajoutées avec succès !"

