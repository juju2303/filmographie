from django.urls import path
from . import views

urlpatterns = [
    path('', views.accueil, name='accueil'),
    path('films/', views.liste_films, name='liste_films'),
    path('film/<int:id_film>/', views.detail_film, name='detail_film'),

    path('categories/', views.categories, name='categories'),
    path('categorie/<int:id_categorie>/', views.films_par_categorie, name='films_par_categorie'),
    path('top-films/', views.top_films, name='top_films'),

    path('film/ajouter/', views.ajouter_film, name='ajouter_film'),
    path('film/modifier/<int:id_film>/', views.modifier_film, name='modifier_film'),
    path('film/supprimer/<int:id_film>/', views.supprimer_film, name='supprimer_film'),

    path('commentaire/ajouter/<int:id_film>/', views.ajouter_commentaire, name='ajouter_commentaire'),
    path('commentaire/supprimer/<int:id_commentaire>/', views.supprimer_commentaire, name='supprimer_commentaire'),

    path('connexion/', views.connexion, name='connexion'),
    path('inscription/', views.inscription, name='inscription'),
    path('deconnexion/', views.deconnexion, name='deconnexion'),
    path('admin-panel/', views.admin_panel, name='admin_panel'),
]
