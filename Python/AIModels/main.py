from data import prepare_data
from model import create_model, train_model
from generate import generate_text

if __name__ == "__main__":
    text = "hello world. this is a simple generative AI model. enjoy creating!"

    # Prepare data
    X, y, char_to_index, index_to_char = prepare_data(text)

    # Create and train model
    model = create_model(input_shape=(X.shape[1], X.shape[2]), num_chars=len(char_to_index))
    train_model(model, X, y)

    # Generate text
    start_string = "hello"
    generated_text = generate_text(model, start_string, char_to_index, index_to_char)
    print(generated_text)