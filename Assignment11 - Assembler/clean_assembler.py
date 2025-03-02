from encode_helpers import *

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

    label_mapping = dict([["0",0]])
    data_value_list = [0]

    while not current_line.startswith(".data") or current_line.startswith(".text"):
        index += 1
        current_line = lines[index]

        if (index + 1 == len(lines)):
            return (label_mapping, data_value_list, lines) # Handle no .data or .text
    
    # Reserve address 0 and label "0" of the data.hex file for being able to set things to zero
    data_index = 1
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
    label_table = dict() # Automatically reserve the "0" label in this assembler for the 0 value

    for index, line in enumerate(lines):
        if not line.endswith(":"):
            return_lines.append(line)
            continue
        
        label_table[line[:-1]] = index - len(label_table.keys())

    return (label_table, return_lines)




def encode_program(lines: list[str], label_table: dict[str, int], data_table: dict[str, int]) -> list[str]:
    line_number = 0
    encoded_lines: list[str] = []
    for line in lines:
        preencoded_lines = encode_instruction(line, line_number, label_table, data_table)
        # Handle pseudo-instructions that balloon to multiple lines
        line_number += len(preencoded_lines)
        encoded_lines.extend(preencoded_lines)
    return encoded_lines

        
def encode_instruction(line: str, line_number: int,  label_table: dict[str, int], data_table: dict[str, int]) -> list[str]:
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
        case instruction:
            return encode_pseudo_instruction(
                instruction,
                arguments,
                line_number,
                label_table,
                data_table
            )
        
    return [f"{op}{encoded_args}{funct}"]

def encode_pseudo_instruction(instruction: str, args: str, line_number: int,  label_table: dict[str, int], data_table: dict[str, int]) -> list[str]:
    return_lines = []
    match instruction:
        case "li":
            dest, value = [item.strip() for item in args.split(",")]
            return_lines.extend(encode_instruction(f"addi {dest}, R0, {value}", line_number, label_table, data_table))
        case "move":
            dest, src = [item.strip() for item in args.split(",")]
            return_lines.extend(encode_instruction(f"add {dest}, R0, {src}", line_number, label_table, data_table))
        case invalid_instruction:
            raise NotImplementedError(f"Unsupported Instruction '{invalid_instruction}'")
        
    return return_lines


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