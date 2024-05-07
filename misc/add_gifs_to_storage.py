import json
import requests
from firebase_admin import credentials, initialize_app, storage

cred = credentials.Certificate('creds.json')
initialize_app(cred, {'storageBucket': 'pulse-pro-dev.appspot.com'})
bucket = storage.bucket()

file_path = './exercises_training_data.jsonl'

iteration = 0

def download_and_upload(url, file_path):
    response = requests.get(url)
    if response.status_code == 200:
        blob = bucket.blob(file_path)
        blob.upload_from_string(response.content, content_type='image/gif')
        print(f'Uploaded {file_path}, iteration {iteration}')
    else:
        print(f'Failed to download {url}')

with open(file_path, 'r') as file:
    for line in file:
        iteration += 1
        exercise = json.loads(line)
        gif_url = exercise['gifUrl']
        storage_path = f'gifs/{exercise["id"]}'
        download_and_upload(gif_url, storage_path)

print("All GIFs uploaded successfully.")