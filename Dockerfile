# EXEMPLE SIMPLE DE DOCKERFILE
# 1. LE CONTENEUR SE CREE A PARTIR DE L'IMAGE DE PYTHON VERSION 3.11.9 = PAS DE PROBLEME DE VERSION
FROM python:3.11.9-slim

# 2. CREATION DU REPERTOIRE DE TRAVAIL DANS LE CONTENEUR

WORKDIR /app
# 3. COPIE DE TOUS LES FICHIERS DU REPERTOIRE COURANT (OU SE TROUVE LE DOCKERFILE)
COPY . .

# 4. COPIE SPECIFIQUEMENT LE FICHIER CONTENANT TOUTES LES DEPENDANCES PYTHON POUR LE BON FONCTIONNEMENT DE L'APPLICATION
COPY requirements.txt .

# 5. INSTALLATION DE TOUTES LES DEPENDANCES, NOUS N'AVONS PLUS A LE FAIRE MANUELLEMENT
RUN pip3 install -r requirements.txt

# 6. BONNES PRATIQUES
#   6.1 commandes RUN combinées 
RUN apt-get update && apt-get install -y

# 6.2 VSupprimer les caches de package :
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# 6.3 Supprimer les fichiers temporaires :
RUN rm -rf /tmp/*

# 6.4 Supprimer les logs :
RUN rm -rf /var/log/*

# 6.5 Supprimer les caches de langage
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* \ /var/cache/apt/archives/* /tmp/* /var/tmp/*


# 7. LE CONTENEUR ECOUTE LE PORT DEFINI
EXPOSE 5000

# 8. MECANISME DOCKER DE SURVEILLANCE DE LA SANTE DU CONTENEUR. SI LA REQUETE ECHOUE LE CONTENEUR DEVIENDRA "UNHEALTHY".
HEALTHCHECK CMD curl --fail http://localhost:5000/health || exit 1

# 9. LANCEMENT DE L'APPLICATION
#   9.1. LANCE STREAMLIT
#   9.2. EXECUTE MY_APP.PY
#   9.3. CONFIGURE LE PORT 8501
#   9.4. CONFIGURE L'ADRESSE 0.0.0.0 (SEUL MOYEN D'ACCEDER A L'APPLICATION DEPUIS L'EXTERIEUR DU CONTENEUR)

ENTRYPOINT ["python","app_flask/app.py"]