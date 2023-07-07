module structs

pub struct Custom_variable {
	pub mut:
		name string
		variable_type string
		value string
}

fn print_normal(value string, bl Block) (int, string){
	mut end_value := value
	if value.split(' ').len == 1 { end_value = bl.variables[value].value }
	print(end_value)
	return 0, ''
}

fn print_line(value string, bl Block) (int, string) {
	mut end_value := value
	if value.split(' ').len == 1 { end_value = bl.variables[value].value }
	print('${end_value}\n')
	return 0, ''
}

fn terminate(value string, bl Block) (int, string) {
	exit(1)
	return 0, ''
}

pub fn check_if_method_exists(method_name string, bl Block, value string) (int, string) {
	mut code := 0
	mut msg := ''

	avail_methods := {
		'end': terminate,
		// Print section
		'print': print_normal, 'println': print_line
	}

	code, msg = avail_methods[method_name](value, bl)
	return code, msg
}
