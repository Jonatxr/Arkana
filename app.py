import requests

def main():
    print("✨ Mini Dofus App - Jenkins Build Test 🚀")
    response = requests.get("https://httpbin.org/get")
    print("Status HTTP de test :", response.status_code)

if __name__ == "__main__":
    main()
