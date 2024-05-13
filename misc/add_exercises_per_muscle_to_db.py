import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore

# Initialize Firebase Admin
cred = credentials.Certificate('creds.json')
firebase_admin.initialize_app(cred)
db = firestore.client()

file_path = './exercises.jsonl'
exercise_summary = {}  # Dictionary to keep track of where each exercise is added
iteration = 0
exercise_count = 0  # Counter for number of exercises processed

with open(file_path, 'r') as file:
    for line in file:
        exercise = json.loads(line)
        exercise_id = exercise['id']
        # Create a unique set of muscles to avoid duplication within the same muscle collection
        muscles_involved = set([exercise['target']] + exercise['secondaryMuscles'])

        # Remove ID from the exercise dictionary to streamline document structure
        del exercise['id']

        # Initialize the summary entry for this exercise
        if exercise_id not in exercise_summary:
            exercise_summary[exercise_id] = []
            exercise_count += 1  # Increment for each new exercise processed

        # Upload the exercise to Firestore under each unique muscle involved
        for muscle in muscles_involved:
            # Ensure the exercise is uploaded only once per muscle collection
            doc_ref = db.collection(f'exercises/{muscle}/exercises').document(exercise_id)
            doc_ref.set(exercise)
            exercise_summary[exercise_id].append(muscle)
            iteration += 1
            print(f"Iteration {iteration} (Exercise {exercise_count}): Pushed {exercise_id} to database under muscle {muscle}")

# Print a summary of where each exercise has been added
print("Data uploaded successfully.")
for exercise_id, muscles in exercise_summary.items():
    print(f"Exercise {exercise_id} added to muscles: {', '.join(muscles)}")

# Print validation of total iterations
print(f"Total upload iterations completed: {iteration}")
