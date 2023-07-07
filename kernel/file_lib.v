module kernel

import os { read_file }
import structs { Custom_error }

pub fn read(file_name string) (int, string) {

	data := read_file(file_name) or {
		error_str := Custom_error{text: 'File "$file_name" does not exist', row: 0, col: 0}
		return 1, error_str.to_string()
	}
	return 0, data
}

pub fn get_folder_contents(path string) []string {
	return os.ls(path) or {
		return []
	}
}

pub fn check_file_exists(path string, file string) bool {
	files := get_folder_contents(path)

	for f in files{
		if f == file { return true }
	}

	return false
}
