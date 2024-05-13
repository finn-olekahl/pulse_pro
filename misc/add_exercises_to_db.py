import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore

cred = credentials.Certificate('creds.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

file_path = './exercises.jsonl'
iteration = 0

with open(file_path, 'r') as file:
    for line in file:
        exercise = json.loads(line)
        doc_ref = db.collection('exercises').document(exercise['id'])
        _id = exercise['id']
        del exercise['id']
        doc_ref.set(exercise)
        iteration += 1
        print(f"pushed {_id} to database, iteration {iteration}")

print("Data uploaded successfully.")