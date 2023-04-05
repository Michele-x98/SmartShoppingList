# **Shopping Item Classification App**

<div align=center>
<img src="https://github.com/Michele-x98/SmartShoppingList/blob/main/assets/home.png" height=600>
<img src="https://github.com/Michele-x98/SmartShoppingList/blob/main/assets/classification.png" height=600>
</div>

This is a mobile application that uses a Python backend with a zero-shot classification model to classify shopping items into categories during the adding process. The app is designed to make it easier for users to organize their shopping list by automatically classifying items into their respective categories, such as fruits, vegetables, dairy, etc.

## **Getting Started - Python Venv**

To get started with the Python backend, you will need to set up a virtual environment and install the necessary dependencies. Here are the steps:

1. Clone the repository to your local machine.
2. Navigate to the root directory of the project.
3. Create a new virtual environment by running the command **`python3 -m venv venv`**.
4. Activate the virtual environment by running the command **`source venv/bin/activate`** (for Mac/Linux) or **`.\venv\Scripts\activate`** (for Windows).
5. Install the required Python packages by running the command **`pip install -r requirements.txt`**.

Once you have completed these steps, you can start the Python backend by running the command **`flask --app main.py run`**. The server will start running on **`http://localhost:5000`**.

## **Getting Started - Flutter**

To get started with the Flutter app, you will need to set up your development environment and install the necessary dependencies. Here are the steps:

1. Install Flutter by following the **[official documentation](https://flutter.dev/docs/get-started/install)**.
2. Clone the repository to your local machine.
3. Navigate to the **`smart-shopping-list`** directory.
4. Run the command **`flutter pub get`** to install the required packages.
5. Run the command **`flutter run`** to start the app on your connected device or emulator.

## **How to Contribute**

If you want to contribute to this project, you can start by forking the repository and creating a new branch for your changes. Once you have made your changes, you can create a pull request to merge your changes into the main branch.

Here are some ways you can contribute to the project:

- Improve the classification model by adding more categories or improving the accuracy of the existing categories.
- Write tests to ensure the stability and reliability of the codebase.
- Fix any bugs or issues that you encounter while using the app.
