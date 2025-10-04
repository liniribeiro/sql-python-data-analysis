import os

import pandas as pd

DATASET_URL = "hf://datasets/liniribeiro/synthetic-user-sessions/user_sessions.csv"
DATASET_LOCAL_PATH = "../data/user_sessions.csv"

def extract_data():
    """Load covid dataset, if not present locally, download it."""
    if os.path.exists(DATASET_LOCAL_PATH):
        df = pd.read_csv(DATASET_LOCAL_PATH)
    else:
        # If the file does not exist locally, download it
        df = pd.read_csv(DATASET_URL)
        df.to_csv(DATASET_LOCAL_PATH, index=False)
    return df


extract_data()