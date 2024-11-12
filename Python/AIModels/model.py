import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
from data import prepare_data

def create_model(input_shape, num_chars):
    model = keras.Sequential()
    model.add(layers.LSTM(128, input_shape=input_shape))
    model.add(layers.Dense(num_chars, activation='softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='adam')
    return model

def train_model(model, X, y, epochs=50, batch_size=1):
    model.fit(X, y, batch_size=batch_size, epochs=epochs)
