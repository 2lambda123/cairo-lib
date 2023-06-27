use result::ResultTrait;
use option::OptionTrait;
use array::{Array, ArrayTrait, Span, SpanTrait};
use clone::Clone;
use traits::{Into, TryInto};
use cairo_lib::utils::types::{Bytes, BytesPartialEq, BytesTryIntoU256};

#[derive(Drop, PartialEq)]
enum RLPType {
    String: (),
    StringShort: (),
    StringLong: (),
    ListShort: (),
    ListLong: (),
}

trait RLPTypeTrait {
    fn from_byte(byte: u8) -> Result<RLPType, felt252>;
}

impl RLPTypeImpl of RLPTypeTrait {
    fn from_byte(byte: u8) -> Result<RLPType, felt252> {
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

#[derive(Drop)]
enum RLPItem {
    Bytes: Bytes,
    // Should be Array<RLPItem> to allow for any depth , but compiler panic
    List: Span<Bytes>
}

fn rlp_decode(input: Bytes) -> Result<(RLPItem, usize), felt252> {
    let prefix = *input.at(0);

    // Unwrap is impossible to panic here
    let rlp_type = RLPTypeTrait::from_byte(prefix).unwrap();
    match rlp_type {
        RLPType::String(()) => {
            let mut arr = ArrayTrait::new();
            arr.append(prefix);
            Result::Ok((RLPItem::Bytes(arr.span()), 1))
        },
        RLPType::StringShort(()) => {
            let len = prefix.into() - 0x80;
            let res = input.slice(1, len);

            Result::Ok((RLPItem::Bytes(res), 1 + len))
        },
        RLPType::StringLong(()) => {
            let len_len = prefix.into() - 0xb7;
            let len_span = input.slice(1, len_len);

            // TODO handle error of byte conversion
            // TODO handle error of converting u256 to u32
            // If RLP is correclty formated it should never fail, so using unwrap for now
            // Bytes => u256 => u32
            let len: u32 = len_span.try_into().unwrap().try_into().unwrap();
            let res = input.slice(1 + len_len, len); 

            Result::Ok((RLPItem::Bytes(res), 1 + len_len + len))
        },
        RLPType::ListShort(()) => {
            let len = prefix.into() - 0xc0;
            let mut in = input.slice(1, len);
            let res = rlp_decode_list(ref in);
            Result::Ok((RLPItem::List(res), 1 + len))
        },
        RLPType::ListLong(()) => {
            let len_len = prefix.into() - 0xf7;
            let len_span = input.slice(1, len_len);

            // TODO handle error of byte conversion
            // TODO handle error of converting u256 to u32
            // If RLP is correclty formated it should never fail, so using unwrap for now
            // Bytes => u256 => u32
            let len: u32 = len_span.try_into().unwrap().try_into().unwrap();
            let mut in = input.slice(1 + len_len, len);
            let res = rlp_decode_list(ref in);
            Result::Ok((RLPItem::List(res), 1 + len_len + len))
        }
    }
}

fn rlp_decode_list(ref input: Bytes) -> Span<Bytes> {
    let mut i = 0;
    let len = input.len();
    let mut output = ArrayTrait::new();

    loop {
        if i >= len {
            break ();
        }

        let (decoded, decoded_len) = rlp_decode(input).unwrap();
        match decoded {
            RLPItem::Bytes(b) => {
                output.append(b);
                input = input.slice(decoded_len, input.len() - decoded_len);
            },
            RLPItem::List(_) => {
                // TODO return Err
                panic_with_felt252('Recursive list not supported');
                // return Result::Err('Recursive list not supported');
            }
        }
        i += decoded_len;

    };
    output.span()
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
        // TODO optimize
        !(lhs == rhs)
    }
}
