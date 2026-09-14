from sklearn.datasets import load_iris
from sklearn.ensemble import RandomForestClassifier
from joblib import dump

X, y = load_iris(return_X_y=True)
model = RandomForestClassifier(random_state=42).fit(X, y)
dump(model, "model.joblib")
print("saved model.joblib")