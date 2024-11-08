# Notes But Better

A Flutter-based mobile note-taking app with Firebase integration that allows users to create, update, and delete notes with added functionalities such as voice-to-text with language translation and authentication.

## Features
- User authentication (register and login)
- Create, update, and delete notes
- voice-to-text with language translation
- User-specific data saved in Firebase Firestore (user name)
- Simple and intuitive user interface

## Technologies Used
- **Flutter**: For building the app
- **Firebase Authentication**: For user registration and login
- **Firebase Firestore**: For saving and retrieving user notes
- **Provider**: For state management

## Screenshots

### Register Page
<img src="assets/Notes_but_better_screenshot/Register_note.png" alt="Register Page" width="300" />

The register page where new users can create an account by entering their name, email, password, and confirming the password.

### Register Error
<img src="assets/Notes_but_better_screenshot/Register_error_note.png" alt="Register Error" width="300" />

Displays validation errors if required fields are left blank or input format is incorrect.

### Login Page
<img src="assets/Notes_but_better_screenshot/Login_note.png" alt="Login Page" width="300" />

The login page for existing users to access their accounts by entering their email and password.

### Login Error
<img src="assets/Notes_but_better_screenshot/Login_error_note.png" alt="Login Error" width="300" />

Displays error messages if login credentials are incorrect or fields are left empty.

### Main Page (Empty State)
<img src="assets/Notes_but_better_screenshot/Main_empty_page.png" alt="Main Page Empty" width="300" />

The main page when no notes are available. Encourages users to add notes using the + button.

### Main Page with Notes
<img src="assets/Notes_but_better_screenshot/Main_page.png" alt="Main Page with Notes" width="300" />

Shows the main dashboard where users can view all their created notes.

### New Note
<img src="assets/Notes_but_better_screenshot/new_note.png" alt="New Note" width="300" />

The interface for creating a new note. Users can enter a title and content for their note. Additionally, the page includes a microphone icon, allowing users to speak instead of typing. When the user taps the microphone and begins speaking, the app detects their speech, transcribes it, and translates it to the language of their choice using the integrated Google Translate API. This feature makes it easy for users to create multilingual notes quickly and efficiently.

### Edit Note
<img src="assets/Notes_but_better_screenshot/edit_note.png" alt="Edit Note" width="300" />

Allows users to edit the contents of an existing note.

### Translation Feature - Language Selection
<img src="assets/Notes_but_better_screenshot/translate_feature_choose_language.png" alt="Translate Feature" width="300" />

The translation feature where users can select languages for translating their notes.

### Logout Confirmation
<img src="assets/Notes_but_better_screenshot/log_out.png" alt="Logout Confirmation" width="300" />

Confirmation dialog that prompts the user to confirm logout action.


## Installation
Follow these steps to set up and run the app on your local machine:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/RobertGoat/note-taking-app-flutter.git
    cd note-taking-app
    ```

2. **Install dependencies**:
    ```bash
    flutter pub get
    ```

3. **Run the app**:
    ```bash
    flutter run
    ```

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
