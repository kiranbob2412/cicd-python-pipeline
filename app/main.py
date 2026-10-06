import time

def add(a, b):
    return a + b

if __name__ == "__main__":
    print("CI/CD Pipeline Application Running", flush=True)
    print("2 + 3 =", add(2, 3), flush=True)

    while True:
        time.sleep(30)
