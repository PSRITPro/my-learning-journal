import numpy as np

def prepare_data(text, seq_length=10, step=1):
    # Create a set of unique characters
    chars = sorted(list(set(text)))
    char_to_index = {c: i for i, c in enumerate(chars)}
    index_to_char = {i: c for i, c in enumerate(chars)}

    # Create input and output sequences
    sentences = []
    next_chars = []

    for i in range(0, len(text) - seq_length, step):
        sentences.append(text[i: i + seq_length])
        next_chars.append(text[i + seq_length])

    # Vectorization
    X = np.zeros((len(sentences), seq_length, len(chars)), dtype=np.bool)
    y = np.zeros((len(sentences), len(chars)), dtype=np.bool)

    for i, sentence in enumerate(sentences):
        for t, char in enumerate(sentence):
            X[i, t, char_to_index[char]] = 1
        y[i, char_to_index[next_chars[i]]] = 1

    return X, y, char_to_index, index_to_char
