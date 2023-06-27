use cairo_lib::utils::bitwise::left_shift;
use array::SpanTrait;
use traits::{TryInto, Into};

type Bytes = Span<u8>;

impl BytesTryIntoU256 of TryInto<Bytes, u256> {
    fn try_into(self: Bytes) -> Option<u256> {
        let len = self.len();
        if len > 32 {
            return Option::None(());
        }

        if self.is_empty() {
            return Option::Some(0);
        }

        let offset = len.into() - 1;
        let mut result: u256 = 0;
        let mut i: usize = 0;
        loop {
            if i >= len {
                break ();
            }
            let byte: u256 = (*self.at(i)).into();
            result += left_shift(byte, 8 * (offset - i.into()));

            i += 1;
        };

        Option::Some(result)
    }
}

impl BytesPartialEq of PartialEq<Bytes> {
    fn eq(lhs: @Bytes, rhs: @Bytes) -> bool {
        let len_lhs = (*lhs).len();
        if len_lhs != (*rhs).len() {
            return false;
        }

        let mut i: usize = 0;
        loop {
            if i >= len_lhs {
                break true;
            }

            if (*lhs).at(i) != (*rhs).at(i) {
                break false;
            }

            i += 1;
        }
    }

    fn ne(lhs: @Bytes, rhs: @Bytes) -> bool {
        let len_lhs = (*lhs).len();
        if len_lhs != (*rhs).len() {
            return true;
        }

        let mut i: usize = 0;
        loop {
            if i >= len_lhs {
                break false;
            }

            if (*lhs).at(i) != (*rhs).at(i) {
                break true;
            }

            i += 1;
        }
    }
}