# from flask import  Flask
from flask import Flask, request, jsonify, redirect, render_template, url_for
import os
import firebase_admin
from firebase_admin import credentials, firestore

# from model.gk import *
from model.Processing import predicted_image

app = Flask(__name__)
cred = credentials.Certificate("serviceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()


@app.route("/", methods=['GET', 'POST'])
def predict():
    # if request.method == 'POST':
    #     user_file = request.files['file']
    #     temp = request.files['file']
    #     # check if the post request has the file part
    #     if 'file' not in request.files:
    #         return "No file found"
    #
    #
    #    elif user_file.filename == "":
    #        return "file name not found …"
    #    else:
    #        path = os.path.join(os.getcwd() + '\\modules\\static\\' + user_file.filename)
    #        user_file.save(path)
    #        a = " , "
    #        return jsonify({'message': 'Hello, World!'})
    # else:
    #    return jsonify({'message': 'Hello, World!'})
    if request.method == 'POST':
        # check if the post request has the file part
        if 'file' not in request.files:
            return "someting went wrong 1"

        user_file = request.files['file']
        temp = request.files['file']
        if user_file.filename == '':
            return "file name not found ..."

        else:
            path = os.path.join(os.getcwd()+ user_file.filename)
            user_file.save(path)
            a = " , "
            doc = db.collection(u'Real').document(u'r1')
            string1= user_file.filename[0:5]
            doc.update({
                string1:(a.join(predicted_image(path))),

            })



    else:

        doc = db.collection(u'Sample').document(u's1')
        doc.update({
            u's3': "abc",

        })
        return "Ash"


if __name__ == "__main__":
    app.run()
