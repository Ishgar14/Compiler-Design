from re import split

def quadruple(fname: str) -> list[tuple[str, str, str, str]]:
    lines = []

    with open(fname) as file:
        for line in file.readlines():
            line = line.replace(" ", "").strip()

            if not line:
                continue

            result, _, parts = line.partition('=')
            arg1 = arg2 = operation = ''
            
            parts = split('[^\da-zA-Z]', parts)
            
            if len(parts) == 2:
                arg1, arg2 = parts
            elif len(parts) == 1:
                arg1 = parts[0]

            operation = split('[\da-zA-Z]', line.partition('=')[2])
            operation = [op for op in operation if op]
            if operation:
                operation = operation[0]

            lines.append((
                operation or '=',
                arg1,
                arg2,
                result
            ))

    return lines


def display_table(table):
    if len(table) == 0:
        print("Empty Table")
        return

    print("-"*40)
    print("SrNo Operation Arg1 Arg2 Result")
    print("-"*40)

    for i, line in enumerate(table):
        print(
            f"{(i + 1):<4} {line[0]:<10} {line[1]:<4} {line[2]:<4} {line[3]} ")


def start(tab: list[tuple[str, str, str, str]]):
    mapping = {}
    # TODO: Confirm whether we dont have to use temporary variables from video lectures

    i = 0
    while i < len(tab):
        _operation, arg1, arg2, result = tab[i]
        arg1 = mapping.get(arg1, arg1)
        arg2 = mapping.get(arg2, arg2)

        if arg1.isnumeric():
            if arg2.isnumeric():
                mapping[result] = str(int(arg1) + int(arg2))
            else:
                mapping[result] = arg1

        if result in mapping:
            tab[i] = ('=', mapping[result], '', result)
        else:
            tab[i] = ('=', arg1, arg2, result)
        i += 1

    return mapping


def main() -> None:
    quadtable = quadruple('./folding.txt')

    optimised_table = quadtable.copy()
    start(optimised_table)

    print(" Input ".center(40, '='))
    display_table(quadtable)
    print("\n\n\n", " Output ".center(40, '='), sep='')
    display_table(optimised_table)


if __name__ == '__main__':
    main()
