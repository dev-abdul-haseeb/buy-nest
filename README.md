# BUYNEST
It is an ecommerce store built in Flutter using firebase and supabase.
## Getting started
1. Create a project in supabase.com
2. Get the project URL and the anon key which will be used to interact with the project
3. Go to firebase and initialize a firebase project
4. Run the specific commands given.
5. Generate SHA keys by running these commands: 1. cd android  2. gradlew signingReport 
6. Put generated SHA keys in the required fields on store.

## Packages used
The following packages are used:
1. firebase_core: ^4.4.0
2. supabase_flutter: ^2.12.0 
3. flutter_dotenv: ^6.0.0 
4. cloud_firestore: ^6.1.2 
5. firebase_auth: ^6.1.4 
6. image_picker: ^1.2.1

## Directory structure

lib
|- View
    |- Screens
|- Model
|- ViewModel

