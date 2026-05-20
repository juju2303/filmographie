SELECT film.titre, categorie.nom
FROM film
JOIN categorie
ON film.id_categorie = categorie.id_categorie;

SELECT film.titre, AVG(commentaire.note)
FROM commentaire
JOIN film
ON commentaire.id_film = film.id_film
GROUP BY film.titre;

SELECT film.titre, personne.pseudo, commentaire.note
FROM commentaire
JOIN film
ON commentaire.id_film = film.id_film
JOIN personne
ON commentaire.id_personne = personne.id_personne;

SELECT film.titre, acteur.nom, acteur.prenom
FROM jouer
JOIN film
ON jouer.id_film = film.id_film
JOIN acteur
ON jouer.id_acteur = acteur.id_acteur;
