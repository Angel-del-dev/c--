module kernel
import structs { Fn, Block }

fn check_fn_in_result(block_name string, result []Fn) int {
	for i := 0 ; i < result.len ; i++{
		r := result[i]
		if r.name == block_name { return i }
	}
	return -1
}
pub fn blocks_to_fn(str_blocks []string) []Fn {
	mut result := []Fn{}

	for block in str_blocks {
		b_arr := block.split(':')
		fn_definition := b_arr[0]
		split_definition := fn_definition.split(' ')
		index := check_fn_in_result(split_definition[1], result)

		if index < 0 {
			result << Fn{
					name: split_definition[1]
					blocks: [
						Block {
							code: b_arr[1],
							return_type: split_definition[0]
						}
					]
			}
			continue
		}
		result[index].blocks << Block {
			code: b_arr[1],
			return_type: split_definition[0]
		}
	}
	return result
}
