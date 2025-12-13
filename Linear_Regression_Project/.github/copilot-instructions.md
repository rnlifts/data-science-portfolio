<!-- .github/copilot-instructions.md -->
# Copilot / AI agent instructions — Linear Regression Flask App

Summary
- This repository is a small Flask web app that loads a trained Ridge regression model and a StandardScaler from `Models/` and exposes two routes: `/` (renders `index.html`) and `/predictdata` (accepts form POST, scales inputs, returns prediction in `home.html`).

What to edit and what to preserve
- Preserve the model artefacts in `Models/` (`ridgle.pkl`, `scaler.pkl`) unless you are explicitly updating the model and also updating any deployment/run instructions.
- Do not rename the Flask app variables: the file defines `application = Flask(__name__)` with `app = application`. Changes that remove this alias may break invocation patterns or WSGI hosting.

Key files and patterns (quick references)
- `application.py`: single-file Flask app, model loading via `pickle.load('Models/ridgle.pkl')`, scaling via `standard_scaler.transform(...)` and prediction via `ridge_model.predict(...)`.
- `Models/`: holds pickled model and scaler. The app expects 9 features in this exact order: `Temperature, RH, Ws, Rain, FFMC, DMC, ISI, Classes, Region`.
- `templates/index.html` and `templates/home.html`: simple Jinja templates; `home.html` is used to display either `results` (prediction float) or `error` messages passed from the view.

Run / dev commands (how the project is executed)
- Run locally (cmd.exe):
  - `python application.py` — runs Flask via the `if __name__ == "__main__"` guard and binds to `0.0.0.0`.
- The app is not configured for `flask run` by default (no `FLASK_APP` export is required), but you can set `FLASK_APP=application.py` and use `flask run` if you prefer.

Dependencies
- The app imports: `flask`, `numpy`, `pandas`, `scikit-learn` (StandardScaler and model), and `pickle` (stdlib). Confirm these in `requirements.txt` when making changes.

Data / I/O conventions
- Input form fields are retrieved via `request.form.get(...)` and immediately cast to `float`. Agents should follow this type conversion pattern and preserve the order of features passed to `standard_scaler.transform`.
- When changing feature order or number, update both training code (outside this repo) and the ordering in `application.py` to keep compatibility with saved `scaler.pkl` and `ridgle.pkl`.

Common edit guidance for agents
- When modifying routes or templates, keep the POST handler name `/predictdata` and the render context keys `results` and `error` unless you update the templates accordingly.
- If replacing pickles with a different model format (joblib, ONNX, etc.), add a short migration note in this file and update `application.py` with minimal, clearly-scoped changes and tests.
- Add defensive checks around model/scaler loading only if needed: the current app assumes `Models/*.pkl` exist at startup. If adding checks, surface a clear error page that uses the same `home.html` pattern.

Examples from the codebase
- Model load example (from `application.py`):
  - `ridge_model = pickle.load(open('Models/ridgle.pkl','rb'))`
  - `standard_scaler = pickle.load(open('Models/scaler.pkl','rb'))`
- Feature transform + predict (from `application.py`):
  - `new_data_scaled = standard_scaler.transform([[Temperature,RH,Ws,Rain,FFMC,DMC,ISI,Classes,Region]])`
  - `result = ridge_model.predict(new_data_scaled)`

What the agent should not do automatically
- Do not retrain models or overwrite `Models/*.pkl` unless the change explicitly states the source training code and updated artifacts.
- Avoid large refactors of `application.py` for small changes — keep surface changes minimal and clearly documented in commit messages.

If something is unclear
- Ask for: (a) the training script that produced `ridgle.pkl` and `scaler.pkl`, (b) target environment for deployment (dev vs prod), or (c) whether to add a `requirements.txt` or a small CI job for lint/tests.

Contact
- Leave a short note in PR descriptions explaining how you validated any runtime changes (manual form test, curl example, or unit test).

End of instructions