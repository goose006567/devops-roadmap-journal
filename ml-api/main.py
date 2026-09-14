from fastapi import FastAPI
from joblib import load
import numpy as np
from pydantic import BaseModel

app = FastAPI()
model = load("model.joblib")


class IrisFeatures(BaseModel):
    sepal_length: float
    sepal_width: float
    petal_length: float
    petal_width: float


@app.get("/health")
def health():
    return {"status": "ok"}


@app.post("/predict")
def predict(features: IrisFeatures):
    X = np.array(
        [
            [
                features.sepal_length,
                features.sepal_width,
                features.petal_length,
                features.petal_width,
            ]
        ]
    )
    prediction = model.predict(X)[0]
    return {"class": int(prediction)}