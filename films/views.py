from django.shortcuts import render, redirect
from django.db import connection
from django.contrib.auth import authenticate, login, logout
from django.contrib.auth.models import User
from django.contrib.auth.decorators import login_required, user_passes_test
from datetime import date


def est_admin(user):
    return user.is_superuser


def accueil(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM film")
        nb_films = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM acteur")
        nb_acteurs = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM commentaire")
        nb_commentaires = cursor.fetchone()[0]

        cursor.execute("""
            SELECT film.id_film, film.titre, film.annee_sortie, categorie.nom,
                   ROUND(AVG(commentaire.note), 1), film.affiche
            FROM film
            JOIN categorie ON film.id_categorie = categorie.id_categorie
            LEFT JOIN commentaire ON film.id_film = commentaire.id_film
            GROUP BY film.id_film, film.titre, film.annee_sortie, categorie.nom, film.affiche
            ORDER BY AVG(commentaire.note) DESC
            LIMIT 6
        """)
        top_films = cursor.fetchall()

        cursor.execute("""
            SELECT id_categorie, nom, descriptif
            FROM categorie
            ORDER BY nom
        """)
        categories = cursor.fetchall()

    return render(request, "accueil.html", {
        "nb_films": nb_films,
        "nb_acteurs": nb_acteurs,
        "nb_commentaires": nb_commentaires,
        "top_films": top_films,
        "categories": categories
    })


def liste_films(request):
    recherche = request.GET.get("q", "")
    categorie = request.GET.get("categorie", "")

    requete = """
        SELECT film.id_film, film.titre, film.annee_sortie, film.realisateur,
               categorie.nom, film.affiche
        FROM film
        JOIN categorie ON film.id_categorie = categorie.id_categorie
        WHERE 1=1
    """

    params = []

    if recherche:
        requete += " AND film.titre LIKE %s"
        params.append("%" + recherche + "%")

    if categorie:
        requete += " AND categorie.id_categorie = %s"
        params.append(categorie)

    requete += " ORDER BY film.titre"

    with connection.cursor() as cursor:
        cursor.execute(requete, params)
        films = cursor.fetchall()

        cursor.execute("SELECT id_categorie, nom FROM categorie ORDER BY nom")
        categories = cursor.fetchall()

    return render(request, "films.html", {
        "films": films,
        "categories": categories,
        "recherche": recherche
    })


def detail_film(request, id_film):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT film.id_film, film.titre, film.annee_sortie, film.affiche,
                   film.realisateur, categorie.nom
            FROM film
            JOIN categorie ON film.id_categorie = categorie.id_categorie
            WHERE film.id_film = %s
        """, [id_film])
        film = cursor.fetchone()

        cursor.execute("""
            SELECT acteur.nom, acteur.prenom, acteur.age, acteur.photo
            FROM jouer
            JOIN acteur ON jouer.id_acteur = acteur.id_acteur
            WHERE jouer.id_film = %s
        """, [id_film])
        acteurs = cursor.fetchall()

        cursor.execute("""
            SELECT commentaire.id_commentaire, personne.pseudo, personne.type_personne,
                   commentaire.note, commentaire.commentaire, commentaire.date_commentaire,
                   commentaire.username
            FROM commentaire
            JOIN personne ON commentaire.id_personne = personne.id_personne
            WHERE commentaire.id_film = %s
            ORDER BY commentaire.date_commentaire DESC
        """, [id_film])
        commentaires = cursor.fetchall()

        cursor.execute("""
            SELECT personne.type_personne, ROUND(AVG(commentaire.note), 1)
            FROM commentaire
            JOIN personne ON commentaire.id_personne = personne.id_personne
            WHERE commentaire.id_film = %s
            GROUP BY personne.type_personne
        """, [id_film])
        moyennes = cursor.fetchall()

        cursor.execute("""
            SELECT ROUND(AVG(note), 1)
            FROM commentaire
            WHERE id_film = %s
        """, [id_film])
        moyenne_globale = cursor.fetchone()[0]

        cursor.execute("""
            SELECT personne.pseudo, commentaire.note, commentaire.commentaire
            FROM commentaire
            JOIN personne ON commentaire.id_personne = personne.id_personne
            WHERE commentaire.id_film = %s
            ORDER BY commentaire.note DESC
            LIMIT 1
        """, [id_film])
        meilleur = cursor.fetchone()

        cursor.execute("""
            SELECT personne.pseudo, commentaire.note, commentaire.commentaire
            FROM commentaire
            JOIN personne ON commentaire.id_personne = personne.id_personne
            WHERE commentaire.id_film = %s
            ORDER BY commentaire.note ASC
            LIMIT 1
        """, [id_film])
        pire = cursor.fetchone()

    return render(request, "detail_film.html", {
        "film": film,
        "acteurs": acteurs,
        "commentaires": commentaires,
        "moyennes": moyennes,
        "moyenne_globale": moyenne_globale,
        "meilleur": meilleur,
        "pire": pire
    })


def categories(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT categorie.id_categorie, categorie.nom, categorie.descriptif,
                   COUNT(film.id_film)
            FROM categorie
            LEFT JOIN film ON categorie.id_categorie = film.id_categorie
            GROUP BY categorie.id_categorie, categorie.nom, categorie.descriptif
            ORDER BY categorie.nom
        """)
        categories = cursor.fetchall()

    return render(request, "categories.html", {"categories": categories})


def films_par_categorie(request, id_categorie):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT nom, descriptif
            FROM categorie
            WHERE id_categorie = %s
        """, [id_categorie])
        categorie = cursor.fetchone()

        cursor.execute("""
            SELECT id_film, titre, annee_sortie, realisateur, affiche
            FROM film
            WHERE id_categorie = %s
            ORDER BY titre
        """, [id_categorie])
        films = cursor.fetchall()

    return render(request, "films_par_categorie.html", {
        "categorie": categorie,
        "films": films
    })


def top_films(request):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT film.id_film, film.titre, film.annee_sortie, film.realisateur,
                   categorie.nom, ROUND(AVG(commentaire.note), 1), film.affiche
            FROM film
            JOIN categorie ON film.id_categorie = categorie.id_categorie
            JOIN commentaire ON film.id_film = commentaire.id_film
            GROUP BY film.id_film, film.titre, film.annee_sortie,
                     film.realisateur, categorie.nom, film.affiche
            ORDER BY AVG(commentaire.note) DESC
        """)
        films = cursor.fetchall()

    return render(request, "top_films.html", {"films": films})


@user_passes_test(est_admin, login_url="/connexion/")
def ajouter_film(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_categorie, nom FROM categorie ORDER BY nom")
        categories = cursor.fetchall()

    if request.method == "POST":
        titre = request.POST["titre"]
        annee_sortie = request.POST["annee_sortie"]
        affiche = request.POST["affiche"]
        realisateur = request.POST["realisateur"]
        id_categorie = request.POST["id_categorie"]

        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO film (titre, annee_sortie, affiche, realisateur, id_categorie)
                VALUES (%s, %s, %s, %s, %s)
            """, [titre, annee_sortie, affiche, realisateur, id_categorie])

        return redirect("/films/")

    return render(request, "ajouter_film.html", {"categories": categories})


@user_passes_test(est_admin, login_url="/connexion/")
def modifier_film(request, id_film):
    with connection.cursor() as cursor:
        cursor.execute("SELECT id_categorie, nom FROM categorie ORDER BY nom")
        categories = cursor.fetchall()

        cursor.execute("""
            SELECT id_film, titre, annee_sortie, affiche, realisateur, id_categorie
            FROM film
            WHERE id_film = %s
        """, [id_film])
        film = cursor.fetchone()

    if request.method == "POST":
        titre = request.POST["titre"]
        annee_sortie = request.POST["annee_sortie"]
        affiche = request.POST["affiche"]
        realisateur = request.POST["realisateur"]
        id_categorie = request.POST["id_categorie"]

        with connection.cursor() as cursor:
            cursor.execute("""
                UPDATE film
                SET titre = %s,
                    annee_sortie = %s,
                    affiche = %s,
                    realisateur = %s,
                    id_categorie = %s
                WHERE id_film = %s
            """, [titre, annee_sortie, affiche, realisateur, id_categorie, id_film])

        return redirect("/films/")

    return render(request, "modifier_film.html", {
        "film": film,
        "categories": categories
    })


@user_passes_test(est_admin, login_url="/connexion/")
def supprimer_film(request, id_film):
    with connection.cursor() as cursor:
        cursor.execute("DELETE FROM film WHERE id_film = %s", [id_film])

    return redirect("/films/")


@login_required(login_url="/connexion/")
def ajouter_commentaire(request, id_film):
    if request.method == "POST":
        note = request.POST["note"]
        commentaire = request.POST["commentaire"]
        date_commentaire = date.today()
        username = request.user.username

        with connection.cursor() as cursor:
            cursor.execute("""
                INSERT INTO commentaire (id_film, id_personne, note, commentaire, date_commentaire, username)
                VALUES (%s, 1, %s, %s, %s, %s)
            """, [id_film, note, commentaire, date_commentaire, username])

        return redirect(f"/film/{id_film}/")

    return render(request, "ajouter_commentaire.html", {
        "id_film": id_film
    })


@login_required(login_url="/connexion/")
def supprimer_commentaire(request, id_commentaire):
    with connection.cursor() as cursor:
        cursor.execute("""
            SELECT id_film, username
            FROM commentaire
            WHERE id_commentaire = %s
        """, [id_commentaire])
        commentaire = cursor.fetchone()

        if commentaire:
            id_film = commentaire[0]
            auteur = commentaire[1]

            if request.user.is_superuser or request.user.username == auteur:
                cursor.execute("""
                    DELETE FROM commentaire
                    WHERE id_commentaire = %s
                """, [id_commentaire])

            return redirect(f"/film/{id_film}/")

    return redirect("/")


def connexion(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        user = authenticate(request, username=username, password=password)

        if user is not None:
            login(request, user)
            return redirect("/")
        else:
            return render(request, "connexion.html", {
                "erreur": "Identifiants incorrects"
            })

    return render(request, "connexion.html")


def inscription(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]

        if User.objects.filter(username=username).exists():
            return render(request, "inscription.html", {
                "erreur": "Ce nom utilisateur existe déjà"
            })

        User.objects.create_user(username=username, password=password)
        return redirect("/connexion/")

    return render(request, "inscription.html")


def deconnexion(request):
    logout(request)
    return redirect("/")

@user_passes_test(est_admin, login_url="/connexion/")
def admin_panel(request):
    with connection.cursor() as cursor:
        cursor.execute("SELECT COUNT(*) FROM film")
        nb_films = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM acteur")
        nb_acteurs = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM commentaire")
        nb_commentaires = cursor.fetchone()[0]

        cursor.execute("""
            SELECT id_film, titre, annee_sortie, realisateur
            FROM film
            ORDER BY titre
        """)
        films = cursor.fetchall()

        cursor.execute("""
            SELECT commentaire.id_commentaire, film.titre, personne.pseudo, commentaire.note, commentaire.commentaire
            FROM commentaire
            JOIN film ON commentaire.id_film = film.id_film
            JOIN personne ON commentaire.id_personne = personne.id_personne
            ORDER BY commentaire.date_commentaire DESC
            LIMIT 10
        """)
        commentaires = cursor.fetchall()

    users = User.objects.all().order_by("username")

    return render(request, "admin_panel.html", {
        "nb_films": nb_films,
        "nb_acteurs": nb_acteurs,
        "nb_commentaires": nb_commentaires,
        "films": films,
        "commentaires": commentaires,
        "users": users
    })
