import string   # To generate list of alphabets without typing each of them manually
import random


def create_password() -> str:

    alphabet = list(string.ascii_letters)  # list of alphabets in both uppercase and lowercase
    number_str = list(map(lambda x: str(x), range(10)))  # list of numbers from 0 to 9 stored as strings
    symbol = ['!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '[', ']', '/']

    # ******************* The number of letters, symbols and numbers in the password are set here ***************
    count_letters = random.randint(8, 10)
    count_symbol = random.randint(3, 5)
    count_num = random.randint(4, 7)
    # ****************************************** ***********************************************************

    random_sym = random.choices(symbol, k=count_symbol)    # Generates a random list of length k from the list symbol
    random_num = random.choices(number_str, k=count_num)  # Generates a random list of length k from the list number_str
    random_alpha = random.choices(alphabet, k=count_letters)  # Generates a random list of length k from the list alphabet

    final_list = list()         # This will be the list formed by combining the above 3 randomly generated lists
    final_list.extend(random_alpha)
    final_list.extend(random_num)
    final_list.extend(random_sym)

    random.shuffle(final_list)  # Shuffles the combined list to make it totally random with regard to position of alphabets, numbers and symbols

    password = ''.join(final_list)  # Converts the list to string

    return password
