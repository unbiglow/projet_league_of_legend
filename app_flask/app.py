from flask import Flask, request, render_template ,redirect,url_for
import os
from flask_sqlalchemy import SQLAlchemy
from dotenv import load_dotenv

# Chemin vers le .env : un dossier au-dessus de app_flask/
load_dotenv()
print("DATABASE_URL env var =", os.environ.get('DATABASE_URL'))

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
db = SQLAlchemy(app)

print("SQLALCHEMY_DATABASE_URI config =", app.config.get('SQLALCHEMY_DATABASE_URI'))

class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100), nullable=False)
    done = db.Column(db.Boolean,default=False) #Pour savoir si la tache à été effectuer ou non

@app.route('/')
def home():
    return "Bienvenue sur la page d'accueil !"

@app.route("/list",methods=["GET","POST"])
def list():

    if request.method == "POST":
        # Récupérer le titre depuis le formulaire
        title = request.form.get("title")
        if title:
            new_task = Task(title=title)
            db.session.add(new_task)
            db.session.commit()   

    user_list = Task.query.all()
    return render_template('list.html', users=user_list)

@app.route('/complete/<int:task_id>', methods=['POST'])
def button_done(task_id):
    task = Task.query.get(task_id)
    task.done = True 
    db.session.commit()

    #user_list = Task.query.all()
    #return render_template('list.html', users=user_list)

    #Plus propre 
    db.session.commit()
    return redirect(url_for('list'))
    
@app.route('/delete/<int:task_id>',methods=["POST"])

def delete_task(task_id):

    task = Task.query.get(task_id)

    if task:

        db.session.delete(task)

        db.session.commit()

        return redirect(url_for('list'))

    return "Tâche introuvable."

@app.route('/health')
def health():
    return "OK", 200


if __name__ == '__main__':
    with app.app_context():
        db.create_all()
    app.run(host='0.0.0.0', debug=True)
