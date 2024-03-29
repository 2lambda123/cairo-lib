use cairo_lib::utils::types::words64::{
    Words64, Words64Trait, Words64TryIntoU256LE, reverse_endianness_u64, bytes_used_u64
};

#[test]
#[available_gas(99999999)]
fn test_slice_words64_le_multiple_words_not_full() {
    let val: Words64 = array![0xabcdef1234567890, 0x7584934785943295, 0x48542576].span();

    let res = val.slice_le(5, 17);
    assert(res.len() == 3, 'Wrong len');
    assert(*res.at(0) == 0x3295abcdef123456, 'Wrong value at 0');
    assert(*res.at(1) == 0x2576758493478594, 'Wrong value at 1');
    assert(*res.at(2) == 0x54, 'Wrong value at 2');
}

#[test]
#[available_gas(99999999)]
fn test_slice_words64_le_multiple_words_full() {
    let val: Words64 = array![0xabcdef1234567890, 0x7584934785943295, 0x48542576].span();

    let gas = testing::get_available_gas();
    let res = val.slice_le(4, 16);
    assert(res.len() == 2, 'Wrong len');
    assert(*res.at(0) == 0x943295abcdef1234, 'Wrong value at 0');
    assert(*res.at(1) == 0x5425767584934785, 'Wrong value at 1');
}

#[test]
#[available_gas(99999999)]
fn test_slice_words64_le_single_word_not_full() {
    let val: Words64 = array![0xabcdef1234567890, 0x7584934785943295, 0x48542576].span();

    let res = val.slice_le(1, 5);
    assert(res.len() == 1, 'Wrong len');
    assert(*res.at(0) == 0x943295abcd, 'Wrong value at 0');
}

#[test]
#[available_gas(99999999)]
fn test_slice_words64_le_single_word_full() {
    let val: Words64 = array![0xabcdef1234567890, 0x7584934785943295, 0x48542576].span();

    let res = val.slice_le(15, 8);
    assert(res.len() == 1, 'Wrong len');
    assert(*res.at(0) == 0x7584934785943295, 'Wrong value at 0');
}

#[test]
#[should_panic]
#[available_gas(99999999)]
fn test_into_u256_le_wrong_num_words() {
    let words = array![0x83498349, 0x83479735927498, 0x12345623ff458695, 0xabcd344, 0xabcdef3345]
        .span();
    let res: u256 = words.try_into().unwrap();
}

#[test]
#[available_gas(99999999)]
fn test_into_u256_le() {
    let words = array![
        0x2e8b632605e21673, 0x480829ebcee54bc4, 0xb6f239256ff310f9, 0x09898da43a5d35f4,
    ]
        .span();

    let expected = 0x09898DA43A5D35F4B6F239256FF310F9480829EBCEE54BC42E8B632605E21673;
    assert(words.try_into().unwrap() == expected, 'Wrong value');
}

#[test]
#[available_gas(99999999)]
fn test_into_u256_le_not_full() {
    let words = array![0x2e8b632605e21673, 0x4bc4, 0, 0,].span();

    let expected = 0x4BC42E8B632605E21673;
    assert(words.try_into().unwrap() == expected, 'Wrong value');
}

#[test]
#[available_gas(99999999)]
fn test_reverse_endianness_u64() {
    let val = 0x1234567890abcdef;
    let expected = 0xefcdab9078563412;
    assert(reverse_endianness_u64(val, Option::None(())) == expected, 'Wrong value');
}

#[test]
#[available_gas(99999999)]
fn test_reverse_endianness_not_full() {
    let val = 0xabcdef;
    let expected = 0xefcdab;
    assert(reverse_endianness_u64(val, Option::Some(3)) == expected, 'Wrong value');
}

#[test]
#[available_gas(99999999)]
fn test_bytes_used() {
    let mut num = 0x1234567890abcdef;
    let pow2 = 0x100;

    let mut i = 8;
    loop {
        assert(bytes_used_u64(num) == i, 'Wrong value');
        num = num / pow2;

        if i == 0 {
            break ();
        }

        i -= 1;
    }
}
