module main
import os { input }
import kernel {
	read, check_file_exists,
	parse, blocks_to_fn
}

import structs { Fn, Block, Custom_variable, check_if_method_exists }

fn create_assignation(mut bl Block, instruction string) (int, string) {
	instruction_array := instruction.trim(' ').split('=')
	definition:= instruction_array[0].trim(' ').split(' ')
	value := instruction_array[1].trim(' ')
	bl.variables[definition[1]] = Custom_variable {
		name: definition[1],
		variable_type: definition[0]
		value: value.replace("'", '').replace('"', '')
	}
	return 0, ''
}

fn call_custom_fn(bl Block, instruction string) (int, string){
	instruction_array := instruction.replace(')', '').split('(')
	function := instruction_array[0].replace(' ', '')
	value := instruction_array[1].replace('"', '').replace("'", '')

	code, msg := check_if_method_exists(function, bl, value)
	return code, msg
}
fn parse_body(mut block Block) (int, string){
	code := block.code.split(';')
	mut code_err, mut msg := 0, ''
	for instruction in code {
		if instruction == '' { continue }
		inst_arr := instruction.split('')
		if inst_arr.contains('=') { code_err, msg = create_assignation(mut &block, instruction) }
		if inst_arr.contains('(') && inst_arr.contains(')') { code_err, msg = call_custom_fn(&block, instruction) }
	}
	return code_err, msg
}
fn exec_main(functions []Fn) (int, string) {
	for x in functions {
		mut f := x
		if f.name.to_lower() == 'main' {
			amount_main := f.blocks.len
			if amount_main > 1 { return 1, 'It can only exist 1 main function, $amount_main found' }

			return parse_body( mut f.blocks[0])
		}
	}
	return 1, "Main function wasn't found"
}

fn main_form(args_os []string) (int, string) {
	length := args_os.len
	if length != 2 { return 1, 'No file was provided' }

	splited := args_os[1].split('/')
	file := splited[splited.len - 1]
	split_file := file.split('.')
	if split_file.len < 2 || split_file[1] != 'cmm' { return 1, 'File extension is not valid, must provide a file with "cmm" extension' }

	is_valid := check_file_exists(splited[0], file)
	path := args_os[1]
	if !is_valid { return 1, 'File "$path" does not exist' }
	code, block := read(path)
	if code != 0 { return code, block }
	b_code, blocks := parse(block)
	if b_code != 0 { return code, 'Could not determine the program blocks' }

	mut fn_blocks := blocks_to_fn(blocks)
	fn_code, fn_string := exec_main(fn_blocks)
	if fn_code != 0 { return fn_code, fn_string }

	return 0, ''
}

fn main() {
	code, msg  := main_form(os.args)
	if code != 0 { print(msg) }
}
