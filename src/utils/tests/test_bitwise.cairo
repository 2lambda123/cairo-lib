use cairo_lib::utils::bitwise::left_shift;

#[test]
#[available_gas(999999)]
fn test_left_shift() {
    assert(left_shift(1_u32, 0_u32) == 1, '1 << 0');
    assert(left_shift(1_u32, 1_u32) == 2, '1 << 1');
    assert(left_shift(1_u32, 2_u32) == 4, '1 << 2');
    assert(left_shift(1_u32, 8_u32) == 256, '1 << 8');
    assert(left_shift(2_u32, 8_u32) == 512, '2 << 8');
    assert(left_shift(255_u32, 8_u32) == 65280, '255 << 8');
} 