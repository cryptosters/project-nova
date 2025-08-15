# Looping Calculator with basic validation + exit

print("=== Simpleng Calculator (Loop) ===")
print("Opsyon: +  -  *  /   |  type 'exit' para lumabas\n")

while True:
    op = input("Pili ng operation (+, -, *, / o exit): ").strip().lower()
    if op == "exit":
        print("Salamat! Bye 👋")
        break

    if op not in {"+", "-", "*", "/"}:
        print("❗ Invalid operation. Subukan ulit.\n")
        continue

    # Kunin ang dalawang numero na may validation
    try:
        num1 = float(input("Ilagay ang unang numero: "))
        num2 = float(input("Ilagay ang pangalawang numero: "))
    except ValueError:
        print("❗ Dapat numero ang ilagay. Subukan ulit.\n")
        continue

    # Compute
    if op == "+":
        result = num1 + num2
    elif op == "-":
        result = num1 - num2
    elif op == "*":
        result = num1 * num2
    else:  # "/"
        if num2 == 0:
            print("❗ Error: hindi puwedeng mag-divide sa zero.\n")
            continue
        result = num1 / num2

    print("Resulta:", result, "\n")
