import numpy as np

def generate_text(model, start_string, char_to_index, index_to_char, gen_length=100, seq_length=10):
    generated = start_string
    sentence = start_string
    for _ in range(gen_length):
        # Prepare the input
        x_pred = np.zeros((1, seq_length, len(char_to_index)))
        for t, char in enumerate(sentence):
            x_pred[0, t, char_to_index[char]] = 1

        # Predict the next character
        preds = model.predict(x_pred, verbose=0)[0]
        next_index = np.random.choice(range(len(char_to_index)), p=preds)
        next_char = index_to_char[next_index]

        # Update the sentence
        sentence = sentence[1:] + next_char
        generated += next_char

    return generated
