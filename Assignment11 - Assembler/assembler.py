

def handle_r_type(argument_string: str):
    reg_dest, reg_1, reg_2 = [int(instruction.strip()[1:]) for instruction in argument_string.split(",")]    

    return f"{format(reg_1, '03b')}{format(reg_2, '03b')}{format(reg_dest, '03b')}" 

def handle_i_type(argument_string: str, line_num: int, label_table: dict[str,int]):
    if "(" in argument_string:
        reg_dest, address = [instruction.strip() for instruction in argument_string.split(",")]
        value, reg_1 = address.split("(")
        reg_1 = reg_1[:-1]
    else:
        reg_dest, reg_1, value = [instruction.strip() for instruction in argument_string.split(",")]
        if not is_int(value): # This must be a label
            value = handle_label(value, line_num, label_table)
        

    return f"{format(int(reg_1[1:]), '03b')}{format(int(reg_dest[1:]), '03b')}{decimal_to_binary(int(value), 6)}" 

def handle_j_type(argument_string: str, label_table: dict[str, int], line_number: int):  

    return f"{decimal_to_binary(label_table[argument_string.strip()], 12)}"

def handle_ls_type(argument_string: str, line_num: int, label_table: dict[str, int], data_table: dict[str, any]):
    if "(" in argument_string:
        return handle_i_type(argument_string, line_num, label_table)
    
    reg_dest, label = [instruction.strip() for instruction in argument_string.split(",")]
    return f"000{format(int(reg_dest[1:]), '03b')}{decimal_to_binary(data_table[label], 6)}"


def handle_label(label_name: str, line_num: int, label_table: dict[str, int]) -> str:
    label_num = label_table[label_name]

    relative_jump_num = label_num - line_num - 1 # Minus one because the program counter will move us down one no matter what

    return str(relative_jump_num)

def decimal_to_binary(val: int, bits: int):
    """compute the 2's complement of int value val"""
    if val < 0:
        val = (1 << bits) + val
    return format(val, f'0{bits}b')
    
def is_int(s: str):
    try:
        int(s)
        return True
    except ValueError:
        return False

def preprocess_lines(lines: list[str]) -> list[str]:
    preprocessed_lines = []
    for line in lines:
        line = line.strip()
        
        processed_line =""
        for char in line:
            if char == "#": # Remove comments
                break
            processed_line += char
        
        stripped_line = processed_line.strip()
        if (len(stripped_line) == 0): # Remove Empty Lines
            continue
        preprocessed_lines.append(stripped_line)
    return preprocessed_lines


def build_data_table(lines: list[str]) -> tuple[dict, list[any], list[str]]:
    index = 0
    current_line = lines[index]

    label_mapping = dict()
    data_value_list = []

    while not current_line.startswith(".data") or current_line.startswith(".text"):
        index += 1
        current_line = lines[index]

        if (index + 1 == len(lines)):
            return (label_mapping, data_value_list, lines) # Handle no .data or .text
    
    data_index = 0
    if current_line.startswith(".data"):
        index += 1
        current_line = lines[index]
    
    while not current_line.startswith(".text"):
        key,value = [element.strip() for element in current_line.split(":")]

        if (value.isnumeric):
            value = int(value)

        label_mapping[key] = data_index
        data_value_list.append(value)
        index += 1
        data_index += 1
        current_line = lines[index]
        
    return (label_mapping, data_value_list, lines[index+1:])

def create_label_table(lines: list[str]) -> tuple[dict[str, int], list[str]]:
    return_lines = list()
    label_table = dict()

    for index, line in enumerate(lines):
        if not line.endswith(":"):
            return_lines.append(line)
            continue
        
        label_table[line[:-1]] = index - len(label_table.keys())

    return (label_table, return_lines)




def encode_program(lines: list[str], label_table: dict[str, int], data_table: dict[str, int]) -> list[str]:
    return [encode_instruction(line, num, label_table, data_table) for num, line in enumerate(lines)]

        
def encode_instruction(line: str, line_number: int,  label_table: dict[str, int], data_table: dict[str, int]) -> str:
    if " " in line:
        instruction, arguments = [element.strip() for element in line.split(" ", maxsplit=1)]
    else:
        instruction = line.strip()
        arguments = ""
    op: str
    funct: str = ""
    encoded_args: str
    match instruction:
        case "add":
            op = "0000"
            funct = "010"
            encoded_args = handle_r_type(arguments)
        case "sub":
            op = "0000"
            funct = "110"
            encoded_args = handle_r_type(arguments)
        case "and":
            op = "0000"
            funct = "000"
            encoded_args = handle_r_type(arguments)
        case "or":
            op = "0000"
            funct = "001"
            encoded_args = handle_r_type(arguments)
        case "slt":
            op = "0000"
            funct = "111"
            encoded_args = handle_r_type(arguments)
        case "display":
            op = "1111"
            funct = "000"
            encoded_args = "000000000"
        case "addi":
            op = "0101"
            encoded_args = handle_i_type(arguments, line_number, label_table)
        case "beq":
            op = "0011"
            encoded_args = handle_i_type(arguments, line_number, label_table)
        case "bne":
            op = "0110"
            encoded_args = handle_i_type(arguments, line_number, label_table)
        case "lw":
            op = "0001"
            encoded_args = handle_ls_type(arguments, line_number, label_table, data_table)
        case "sw":
            op = "0010"
            encoded_args = handle_ls_type(arguments, line_number, label_table, data_table)
        case "j":
            op = "0100"
            encoded_args = handle_j_type(arguments, label_table, line_number)
        case "jr":
            op = "0111"
            encoded_args = f"{decimal_to_binary(int(arguments[1:]), 3)}000000000"

        case "jal":
            op = "1000"
            encoded_args = handle_j_type(arguments, label_table, line_number)
        case invalid_instruction:
            raise ValueError(f"Invalid instruction '{invalid_instruction}' ")
        
    return f"{op}{encoded_args}{funct}"

def post_process(binary_lines: list[str]) -> list[str]:
    hex_strings = list()
    for binary_line in binary_lines:
        num_as_int = int(binary_line, 2)
        hex_strings.append(f"{num_as_int:04x} ")
    
    return hex_strings

def main():

    # USAGE: python assembler.py [assembly file]
    from sys import argv
    # Read all lines from the assembly file, and store them in a list
    with open(argv[1], "r") as infile:
        lines = infile.readlines()

    # Step 1: Preprocess the lines to remove comments and whitespace
    lines = preprocess_lines(lines)

    # Step 2: Use the preprocessed program to build data table
    data_table, data_list, lines = build_data_table(lines)

    # Step 3: Build a label table and strip out the labels from the code
    label_table, lines = create_label_table(lines)

    # Step 4: Encode the program into a list of binary strings
    encoded_program = encode_program(lines, label_table, data_table)

    # Step 5: Convert the strings to hexadecimal and write them to a file
    hex_program = post_process(encoded_program)
    with open("output.hex", "w") as outfile:
        outfile.write("v3.0 hex words addressed\n00: ")
        outfile.writelines(hex_program)

    # Step 6: Convert the data list to hexadecimal and write it to a file
    with open("data.hex", "w") as outfile:
        outfile.write("v3.0 hex words addressed\n00: ")
        outfile.writelines([f"{d:04x} " for d in data_list])


if __name__ == "__main__":
    main()