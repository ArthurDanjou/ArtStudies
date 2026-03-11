#!/usr/bin/env python3
import re

from flask import (
    Flask,
    Response,
    redirect,
    render_template_string,
    request,
    session,
    url_for,
)

app = Flask(__name__)
app.secret_key = "super_secret_training_key_2025"
# Dictionnaire des utilisateurs : username -> password
users = {
    "user1": "aaaaa",         # 5 caractères
    "user2": "rock12",        # exemple autre mot de passe
    "user3": "secret",
    "user4": "#-1234abcd-#",   # mot de passe niveau 4
}

# Page de connexion avec sélecteur de niveau + Tailwind + Logo
login_page = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Authentification</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-50 flex items-center justify-center h-screen">
    <div class="w-full max-w-md p-8 bg-white rounded shadow">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-2xl font-bold text-center mb-4 text-blue-700">Connexion</h2>
      {% if error %}
        <p class="text-red-500 text-center">{{ error }}</p>
      {% endif %}
      <form method="POST" class="space-y-4">
         <div>
           <label class="block text-blue-700">Nom d'utilisateur :</label>
           <input type="text" name="username" class="w-full px-3 py-2 border rounded" required>
         </div>
         <div>
           <label class="block text-blue-700">Mot de passe :</label>
           <input type="password" name="password" class="w-full px-3 py-2 border rounded" required>
         </div>
         <div>
           <label class="block text-blue-700">Niveau :</label>
           <select name="level" class="w-full px-3 py-2 border rounded">
             <option value="1">Niveau 1</option>
             <option value="2">Niveau 2</option>
             <option value="3">Niveau 3</option>
             <option value="4">Niveau 4</option>
           </select>
         </div>
         <div class="text-center">
           <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
             Se connecter
           </button>
         </div>
      </form>
      <div class="text-center mt-4">
         <a href="{{ url_for('forgot') }}" class="text-blue-600 hover:underline">Mot de passe oublié ?</a>
      </div>
    </div>
  </body>
</html>
"""

# Page d'accueil Niveau 1
home_page_level1 = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Accueil Niveau 1</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded shadow-lg max-w-md text-center">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-3xl font-bold text-blue-700">Bienvenue, {{ username }} !</h2>
      <p class="mt-4 text-blue-600">Vous êtes connecté au <strong>Niveau 1</strong>.</p>
      <p class="mt-2 text-blue-600">Mot de passe de 5 caractères.</p>
      <a href="{{ url_for('logout') }}"
         class="mt-6 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
         Déconnexion
      </a>
    </div>
  </body>
</html>
"""

# Page d'accueil Niveau 2
home_page_level2 = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Accueil Niveau 2</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded shadow-lg max-w-md text-center">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-3xl font-bold text-blue-700">Bienvenue, {{ username }} !</h2>
      <p class="mt-4 text-blue-600">Vous êtes connecté au <strong>Niveau 2</strong>.</p>
      <p class="mt-2 text-blue-600">Mot de passe : "rock12".</p>
      <a href="{{ url_for('logout') }}"
         class="mt-6 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
         Déconnexion
      </a>
    </div>
  </body>
</html>
"""

# Page d'accueil Niveau 3
home_page_level3 = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Accueil Niveau 3</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded shadow-lg max-w-md text-center">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-3xl font-bold text-blue-700">Bienvenue, {{ username }} !</h2>
      <p class="mt-4 text-blue-600">Vous êtes connecté au <strong>Niveau 3</strong>.</p>
      <p class="mt-2 text-blue-600">En cas de "mot de passe oublié", le hash MD5 vous sera fourni.</p>
      <a href="{{ url_for('logout') }}"
         class="mt-6 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
         Déconnexion
      </a>
    </div>
  </body>
</html>
"""

# Page d'accueil Niveau 4
home_page_level4 = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Accueil Niveau 4</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-100 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded shadow-lg max-w-md text-center">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-3xl font-bold text-blue-700">Bienvenue, {{ username }} !</h2>
      <p class="mt-4 text-blue-600">Vous êtes connecté au <strong>Niveau 4</strong>.</p>
      <p class="mt-2 text-blue-600">Votre mot de passe doit respecter le format : "#-[0-9]{4}[a-z]{4}-#".</p>
      <a href="{{ url_for('logout') }}"
         class="mt-6 inline-block bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
         Déconnexion
      </a>
    </div>
  </body>
</html>
"""

# Page "mot de passe oublié" (indice seulement si l'utilisateur est user4)
forgot_page = """
<!doctype html>
<html lang="fr">
  <head>
    <meta charset="utf-8">
    <title>Mot de passe oublié</title>
    <script src="https://cdn.tailwindcss.com"></script>
  </head>
  <body class="bg-blue-50 flex items-center justify-center h-screen">
    <div class="bg-white p-8 rounded shadow max-w-md text-center">
      <div class="flex justify-center mb-4">
        <img src="{{ url_for('static', filename='logo.png') }}" alt="Logo" class="h-16">
      </div>
      <h2 class="text-2xl font-bold text-blue-700">Mot de passe oublié</h2>
      {% if message %}
         <p class="mt-4 text-blue-600">{{ message }}</p>
      {% else %}
         <form method="POST" class="mt-4 space-y-4">
            <div>
              <label class="block text-blue-700">Nom d'utilisateur :</label>
              <input type="text" name="username" class="w-full px-3 py-2 border rounded" required>
            </div>
            <div>
              <button type="submit"
                      class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
                Valider
              </button>
            </div>
         </form>
      {% endif %}
      <div class="mt-4">
         <a href="{{ url_for('login') }}" class="text-blue-600 hover:underline">Retour à la connexion</a>
      </div>
    </div>
  </body>
</html>
"""

@app.route("/", methods=["GET", "POST"])
@app.route("/login", methods=["GET", "POST"])
def login() -> Response:
    """Page de connexion avec sélection du niveau."""
    error = None
    if request.method == "POST":
        username = request.form.get("username")
        password = request.form.get("password")
        level_str = request.form.get("level")

        # Vérifier que l'utilisateur existe
        if username in users:
            # Vérifier le mot de passe
            if users[username] == password:
                # Le niveau est choisi par l'utilisateur (pas stocké dans le dictionnaire)
                try:
                    level = int(level_str)
                except (ValueError, TypeError):
                    error = "Sélectionnez un niveau valide."
                    return render_template_string(login_page, error=error)
                # On enregistre le niveau choisi dans la session
                session["username"] = username
                session["level"] = level
                # Redirection vers la page correspondant au niveau
                if level == 1:
                    return redirect(url_for("home1"))
                if level == 2:
                    return redirect(url_for("home2"))
                if level == 3:
                    return redirect(url_for("home3"))
                if level == 4:
                    return redirect(url_for("home4"))
            else:
                error = "Mot de passe incorrect."
        else:
            error = "Utilisateur inconnu."
    return render_template_string(login_page, error=error)

@app.route("/home1")
def home1() -> Response:
    """Page d'accueil pour le niveau 1."""
    if "username" in session and session.get("level") == 1:
        return render_template_string(home_page_level1, username=session["username"])
    return redirect(url_for("login"))

@app.route("/home2")
def home2() -> Response:
    """Page d'accueil pour le niveau 2."""
    if "username" in session and session.get("level") == 2:
        return render_template_string(home_page_level2, username=session["username"])
    return redirect(url_for("login"))

@app.route("/home3")
def home3() -> Response:
    """Page d'accueil pour le niveau 3."""
    if "username" in session and session.get("level") == 3:
        return render_template_string(home_page_level3, username=session["username"])
    return redirect(url_for("login"))

@app.route("/home4")
def home4() -> str:
    """Page d'accueil pour le niveau 4."""
    if "username" in session and session.get("level") == 4:
        return render_template_string(home_page_level4, username=session["username"])
    return redirect(url_for("login"))

@app.route("/logout")
def logout() -> str:
    """Déconnexion de l'utilisateur."""
    session.pop("username", None)
    session.pop("level", None)
    return redirect(url_for("login"))

@app.route("/forgot", methods=["GET", "POST"])
def forgot() -> str:
    """Seul user4 reçoit un indice.

    Les autres utilisateurs n'ont pas d'indice.
    """
    message = None
    if request.method == "POST":
        username = request.form.get("username")
        if username in users:
            # Seul user4 a droit à un indice (puisque c'est le "niveau 4")
            if username == "user4":
                pattern = r"^#-[0-9]{4}[a-z]{4}-#$"
                if re.match(pattern, users[username]):
                    message = ("Indice : Le mot de passe respecte le format "
                               "'#-MDP 8 caractères max -#' (exemple : '#-1234abcd-#').")
                else:
                    message = "Le mot de passe ne correspond pas au format attendu (erreur)."
            else:
                message = "Aucun indice n'est disponible pour cet utilisateur."
        else:
            message = "Utilisateur non trouvé."
    return render_template_string(forgot_page, message=message)

if __name__ == "__main__":
    app.run(debug=False)
