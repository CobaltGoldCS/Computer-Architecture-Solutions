
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
