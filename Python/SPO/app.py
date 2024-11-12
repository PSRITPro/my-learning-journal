import os
from flask import Flask, render_template, redirect, url_for, session
import msal
import requests

from flask import Flask, render_template, redirect, url_for, session, request


app = Flask(__name__)
app.secret_key = os.urandom(24)  # Set a secret key for session management

# Azure AD configuration
CLIENT_ID = "bb9ff170-f79f-40fa-8d86-d6a4d3a3e91e"
TENANT_ID = "c518f592-d3fe-405a-b17d-456bcf93a271"
AUTHORITY = f"https://login.microsoftonline.com/{TENANT_ID}"
SCOPE = ["https://graph.microsoft.com/.default"]

# Create an MSAL application instance
msal_app = msal.ConfidentialClientApplication(CLIENT_ID, authority=AUTHORITY)

@app.route("/")
def index():
    if "user" in session:
        return redirect(url_for("home"))
    return render_template("index.html")

@app.route("/login")
def login():
    session["flow"] = msal_app.initiate_auth_code_flow(
        scopes=SCOPE, redirect_uri=url_for("authorized", _external=True)
    )
    return redirect(session["flow"]["auth_uri"])

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index"))

@app.route("/authorized")
def authorized():
    if "error" in request.args:  # Authentication error
        return "Error: " + request.args["error"]
    
    # Exchange code for token
    result = msal_app.acquire_token_by_auth_code_flow(session["flow"], request.args)
    if "access_token" in result:
        session["user"] = result.get("id_token_claims")
        session["access_token"] = result["access_token"]
        return redirect(url_for("home"))
    
    return "Error acquiring token."

@app.route("/home")
def home():
    if "access_token" not in session:
        return redirect(url_for("index"))
    
    # Fetch the sites
    headers = {
        'Authorization': f'Bearer {session["access_token"]}',
        'Content-Type': 'application/json'
    }
    url = "https://graph.microsoft.com/v1.0/sites?search=*"  # Get all sites
    response = requests.get(url, headers=headers)
    
    sites = response.json().get("value", [])
    return render_template("home.html", sites=sites)

@app.route("/connect_site", methods=["POST"])
def connect_site():
    selected_site_id = request.form["site_id"]
    headers = {
        'Authorization': f'Bearer {session["access_token"]}',
        'Content-Type': 'application/json'
    }
    url = f"https://graph.microsoft.com/v1.0/sites/{selected_site_id}/sites"
    
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return f"Successfully connected to site {selected_site_id}: {response.json()}"
    else:
        return f"Error accessing site {selected_site_id}: {response.status_code} - {response.text}"

if __name__ == "__main__":
    app.run(debug=True)
