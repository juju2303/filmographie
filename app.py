from flask import Flask
import mysql.connector

app = Flask(__name__)

db = mysql.connector.connect(
    host="localhost",
    user="filmuser",
    password="1234",
    database="filmographie"
)

@app.route("/")
def accueil():
    cursor = db.cursor()

    cursor.execute("""
        SELECT titre
        FROM film
    """)

    films = cursor.fetchall()

    html = "<h1>Liste des films</h1>"

    for film in films:
        html += f"<p>{film[0]}</p>"

    return html

@app.route("/commentaires")
def commentaires():

    cursor = db.cursor()

    cursor.execute("""
        SELECT personne.pseudo, commentaire.note, commentaire.commentaire
        FROM commentaire
        JOIN personne
        ON commentaire.id_personne = personne.id_personne
    """)

    commentaires = cursor.fetchall()

    html = "<h1>Commentaires</h1>"

    for c in commentaires:
        html += f"<p>{c[0]} - {c[1]}/10 : {c[2]}</p>"

    return html


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
