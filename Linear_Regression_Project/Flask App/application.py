import pickle

from flask import Flask, jsonify, render_template, request
from sklearn.preprocessing import StandardScaler

import numpy as np
import pandas as pd

application = Flask(__name__)
app=application

## import ridge regressor and standard scaler pickle
ridge_model = pickle.load(open('Models/ridgle.pkl','rb'))
standard_scaler = pickle.load(open('Models/scaler.pkl','rb'))







@app.route("/")
def index():
    return render_template('index.html')

@app.route('/predictdata',methods=['GET','POST'])
def predict_datapoint():
    if request.method=='POST':
        try:
            Temperature = float(request.form.get('Temperature'))
            RH = float(request.form.get('RH'))
            Ws = float(request.form.get('Ws'))
            Rain = float(request.form.get('Rain'))
            FFMC = float(request.form.get('FFMC'))
            DMC = float(request.form.get('DMC'))
            ISI = float(request.form.get('ISI'))
            
            # Handle Classes and Region - convert text to numeric if needed
            Classes = float(request.form.get('Classes'))
            Region = float(request.form.get('Region'))

            new_data_scaled = standard_scaler.transform([[Temperature,RH,Ws,Rain,FFMC,DMC,ISI,Classes,Region]])
            result = ridge_model.predict(new_data_scaled)

            return render_template('home.html', results=result[0])
            
        except ValueError as e:
            return render_template('home.html', error=f"Invalid input: {str(e)}")
        except Exception as e:
            return render_template('home.html', error=f"Prediction error: {str(e)}")
    else:
        return render_template('home.html')


if __name__ == "__main__":
    app.run(host='0.0.0.0')