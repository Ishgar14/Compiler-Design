def quadruple(fname: str) -> list[tuple[str, str, str, str]]:
    lines = []
    counter = 1
    
    with open(fname) as file:
        for line in file.readlines():
            line = line.replace(" ", "").strip()

            if not line:
                continue

            lines.append((
                line[3],        # Operation
                line[2],        # arg1
                line[4],        # arg2
                f"t{counter}",  # result
            ))

            lines.append((
                line[1],        # Operation
                f"t{counter}",  # arg1
                "",             # arg2
                line[0],        # result
            ))

            counter += 1

    return lines


def display_table(table):
    if len(table) == 0:
        print("Empty Table")
        return
    
    print("-"*40)
    print("SrNo Operation Arg1 Arg2 Result")
    print("-"*40)

    for i, line in enumerate(table):
        print(f"{(i + 1):<4} {line[0]:<10} {line[1]:<4} {line[2]:<4} {line[3]} ")


def optimise(quadtable: list):
    mapping = {}

    i = 0
    while i < len(quadtable):
        operation, arg1, arg2, result = quadtable[i]
        expr = f"{operation}{arg1}{arg2}"

        if operation == '=' and result in expr:
            del mapping[expr]

        if expr in mapping:
            quadtable.pop(i)
            quadtable[i] = (quadtable[i][0], mapping[expr], *quadtable[i][2:])
            
            # If the expression is mutated remove it from mapping
            if quadtable[i][0] == '=' and quadtable[i][3] in expr:
                del mapping[expr]

            continue

        if not ('t' in arg1 or 't' in arg2) and expr not in mapping:
            mapping[expr] = result

        i += 1


def main() -> None: 
    quad = quadruple('./cse.txt')
    optimised = quad.copy()
    optimise(optimised)

    print(" Input ".center(40, '='))
    display_table(quad)
    print("\n\n\n", " Output ".center(40, '='), sep='')
    display_table(optimised)

if __name__ == '__main__':
    main()