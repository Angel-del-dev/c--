module structs

pub struct Custom_error {
	pub:
		text 			string
		row 			int
		col 			int
		complementary 	string
}

pub fn (e Custom_error) to_string() string {
	return '${e.text}\n in row ${e.row} at col ${e.col}\n${e.complementary}'
}
