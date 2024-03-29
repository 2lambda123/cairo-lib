use cairo_lib::utils::types::words64::{Words64, Words64Trait, reverse_endianness_u64};
use cairo_lib::utils::types::byte::Byte;

// @notice Enum with all possible RLP types
// For more info: https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
#[derive(Drop, PartialEq)]
enum RLPType {
    String: (),
    StringShort: (),
    StringLong: (),
    ListShort: (),
    ListLong: (),
}

#[generate_trait]
impl RLPTypeImpl of RLPTypeTrait {
    // @notice Returns RLPType from the leading byte
    // For more info: https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
    // @param byte Leading byte
    // @return Result with RLPType
    fn from_byte(byte: Byte) -> Result<RLPType, felt252> {
        if byte <= 0x7f {
            Result::Ok(RLPType::String(()))
        } else if byte <= 0xb7 {
            Result::Ok(RLPType::StringShort(()))
        } else if byte <= 0xbf {
            Result::Ok(RLPType::StringLong(()))
        } else if byte <= 0xf7 {
            Result::Ok(RLPType::ListShort(()))
        } else if byte <= 0xff {
            Result::Ok(RLPType::ListLong(()))
        } else {
            Result::Err('Invalid byte')
        }
    }
}

// @notice Represent a RLP item
#[derive(Drop)]
enum RLPItem {
    Bytes: Words64,
    // Should be Span<RLPItem> to allow for any depth/recursion, not yet supported by the compiler
    List: Span<Words64>
}

// @notice RLP decodes a rlp encoded byte array
// For more info: https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/
// @param input RLP encoded input, in little endian 64 bits words
// @return Result with RLPItem and size of the decoded item
fn rlp_decode(input: Words64) -> Result<(RLPItem, usize), felt252> {
    // It's guaranteed to fid in 32 bits, as we are masking with 0xff
    let prefix: u32 = (*input.at(0) & 0xff).try_into().unwrap();

    // It's guaranteed to be a valid RLPType, as we are masking with 0xff
    let rlp_type = RLPTypeTrait::from_byte(prefix.try_into().unwrap()).unwrap();
    match rlp_type {
        RLPType::String(()) => {
            let mut arr = array![prefix.into()];
            Result::Ok((RLPItem::Bytes(arr.span()), 1))
        },
        RLPType::StringShort(()) => {
            let len = prefix.into() - 0x80;
            let res = input.slice_le(6, len);

            Result::Ok((RLPItem::Bytes(res), 1 + len))
        },
        RLPType::StringLong(()) => {
            let len_len = prefix - 0xb7;
            let len_span = input.slice_le(6, len_len);
            // Enough to store 4.29 GB (fits in u32)
            assert(len_span.len() == 1 && *len_span.at(0) <= 0xffffffff, 'Len of len too big');

            // len fits in 32 bits, confirmed by previous assertion
            let len: u32 = reverse_endianness_u64(*len_span.at(0), Option::Some(len_len.into()))
                .try_into()
                .unwrap();
            let res = input.slice_le(6 - len_len, len);

            Result::Ok((RLPItem::Bytes(res), 1 + len_len + len))
        },
        RLPType::ListShort(()) => {
            let mut len = prefix - 0xc0;
            let mut in = input.slice_le(6, len);
            let res = rlp_decode_list(ref in, len)?;
            Result::Ok((RLPItem::List(res), 1 + len))
        },
        RLPType::ListLong(()) => {
            let len_len = prefix - 0xf7;
            let len_span = input.slice_le(6, len_len);
            // Enough to store 4.29 GB (fits in u32)
            assert(len_span.len() == 1 && *len_span.at(0) <= 0xffffffff, 'Len of len too big');

            // len fits in 32 bits, confirmed by previous assertion
            let len: u32 = reverse_endianness_u64(*len_span.at(0), Option::Some(len_len.into()))
                .try_into()
                .unwrap();
            let mut in = input.slice_le(6 - len_len, len);
            let res = rlp_decode_list(ref in, len)?;

            Result::Ok((RLPItem::List(res), 1 + len_len + len))
        }
    }
}

// @notice RLP decodes into RLPItem::List
// @param input RLP encoded input, in little endian 64 bits words
// @param len Length of the input
// @return Result with RLPItem::List
fn rlp_decode_list(ref input: Words64, len: usize) -> Result<Span<Words64>, felt252> {
    let mut i = 0;
    let mut output = ArrayTrait::new();
    let mut total_len = len;

    loop {
        if i >= len {
            break Result::Ok(output.span());
        }

        let (decoded, decoded_len) = match rlp_decode(input) {
            Result::Ok((d, dl)) => (d, dl),
            Result::Err(e) => {
                break Result::Err(e);
            }
        };
        match decoded {
            RLPItem::Bytes(b) => {
                output.append(b);
                let word = decoded_len / 8;
                let reversed = 7 - (decoded_len % 8);
                let next_start = word * 8 + reversed;
                if (total_len - decoded_len != 0) {
                    input = input.slice_le(next_start, total_len - decoded_len);
                }
                total_len -= decoded_len;
            },
            RLPItem::List(_) => {
                panic_with_felt252('Recursive list not supported');
            }
        }
        i += decoded_len;
    }
}

impl RLPItemPartialEq of PartialEq<RLPItem> {
    fn eq(lhs: @RLPItem, rhs: @RLPItem) -> bool {
        match lhs {
            RLPItem::Bytes(b) => {
                match rhs {
                    RLPItem::Bytes(b2) => {
                        b == b2
                    },
                    RLPItem::List(_) => false
                }
            },
            RLPItem::List(l) => {
                match rhs {
                    RLPItem::Bytes(_) => false,
                    RLPItem::List(l2) => {
                        let len_l = (*l).len();
                        if len_l != (*l2).len() {
                            return false;
                        }
                        let mut i: usize = 0;
                        loop {
                            if i >= len_l {
                                break true;
                            }
                            if (*l).at(i) != (*l2).at(i) {
                                break false;
                            }
                            i += 1;
                        }
                    }
                }
            }
        }
    }

    fn ne(lhs: @RLPItem, rhs: @RLPItem) -> bool {
        !(lhs == rhs)
    }
}

