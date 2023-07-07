module kernel

import encoding.utf8

pub fn get_full_block(pspace_count int, c_i int, f_lines []string) (int, string) {
	mut block := f_lines[c_i]
	mut n_i := c_i
	for i := c_i +1 ; i < f_lines.len ; i++ {
		line :=  f_lines[i]
		n_i = i
		if line.replace(' ', '').len == 0 { continue }
		mut space_count := 0
		for ch in line.runes() {
			if utf8.is_space(ch) {
				space_count+= 1
				continue
			}
			break
		}
		if space_count == pspace_count { break }
		block += line
	}

	return n_i, block
}
pub fn parse(contents string) (int, []string){
	// If for ch in contents{}, the character codes will be display, so runes need to be used
	f_lines := contents.split('\n')

	mut blocks := []string{}
	for i := 0 ; i < f_lines.len ; i++ {
		line :=  f_lines[i]
		if line.len == 0 { continue }
		mut space_count := 0
		mut block := ''
		for ch in line.runes() {
			if ch.str() == ' ' {
				space_count++
				continue
			}
			break
		}
		i, block = get_full_block(space_count, i, f_lines)
		// Subtracting one to the index because in get_full_block we add one to get the next line
		i = i-1
		blocks << block
	}
	return 0, blocks
}
