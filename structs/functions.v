module structs

pub struct Block {
	pub:
		code string
		return_type string
		return_value string
		params []string
	pub mut:
			variables map[string]Custom_variable
}
pub struct Fn {
	pub:
		name string
	pub mut:
		blocks []Block
}
