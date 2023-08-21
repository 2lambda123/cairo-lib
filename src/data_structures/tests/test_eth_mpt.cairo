use cairo_lib::data_structures::eth_mpt::{MPTNode, MPTTrait};
use array::{ArrayTrait, SpanTrait};
use result::ResultTrait;
use cairo_lib::utils::types::bytes::BytesPartialEq;

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_branch() {
    let rlp_node  = array![0xf9, 0x02, 0x11, 0xa0, 0x77, 0x70, 0xcf, 0x09, 0xb5, 0x06, 0x7a, 0x1b, 0x35, 0xdf, 0x62, 0xa9, 0x24, 0x89, 0x81, 0x75, 0xce, 0xae, 0xec, 0xad, 0x1f, 0x68, 0xcd, 0xb4, 0xa8, 0x44, 0x40, 0x0c, 0x73, 0xc1, 0x4a, 0xf4, 0xa0, 0x1e, 0xa3, 0x85, 0xd0, 0x5a, 0xb2, 0x61, 0x46, 0x6d, 0x5c, 0x04, 0x87, 0xfe, 0x68, 0x45, 0x34, 0xc1, 0x9f, 0x1a, 0x4b, 0x5c, 0x4b, 0x18, 0xdc, 0x1a, 0x36, 0x35, 0x60, 0x02, 0x50, 0x71, 0xb4, 0xa0, 0x2c, 0x4c, 0x04, 0xce, 0x35, 0x40, 0xd3, 0xd1, 0x46, 0x18, 0x72, 0x30, 0x3c, 0x53, 0xa5, 0xe5, 0x66, 0x83, 0xc1, 0x30, 0x4f, 0x8d, 0x36, 0xa8, 0x80, 0x0c, 0x6a, 0xf5, 0xfa, 0x3f, 0xcd, 0xee, 0xa0, 0xa9, 0xdc, 0x77, 0x8d, 0xc5, 0x4b, 0x7d, 0xd3, 0xc4, 0x82, 0x22, 0xe7, 0x39, 0xd1, 0x61, 0xfe, 0xb0, 0xc0, 0xee, 0xce, 0xb2, 0xdc, 0xd5, 0x17, 0x37, 0xf0, 0x5b, 0x8e, 0x37, 0xa6, 0x38, 0x51, 0xa0, 0xa9, 0x5f, 0x4d, 0x55, 0x56, 0xdf, 0x62, 0xdd, 0xc2, 0x62, 0x99, 0x04, 0x97, 0xae, 0x56, 0x9b, 0xcd, 0x8e, 0xfd, 0xda, 0x7b, 0x20, 0x07, 0x93, 0xf8, 0xd3, 0xde, 0x4c, 0xdb, 0x97, 0x18, 0xd7, 0xa0, 0x39, 0xd4, 0x06, 0x6d, 0x14, 0x38, 0x22, 0x6e, 0xaf, 0x4a, 0xc9, 0xe9, 0x43, 0xa8, 0x74, 0xa9, 0xa9, 0xc2, 0x5f, 0xb0, 0xd8, 0x1d, 0xb9, 0x86, 0x1d, 0x8c, 0x13, 0x36, 0xb3, 0xe2, 0x03, 0x4c, 0xa0, 0x7a, 0xcc, 0x7c, 0x63, 0xb4, 0x6a, 0xa4, 0x18, 0xb3, 0xc9, 0xa0, 0x41, 0xa1, 0x25, 0x6b, 0xcb, 0x73, 0x61, 0x31, 0x6b, 0x39, 0x7a, 0xda, 0x5a, 0x88, 0x67, 0x49, 0x1b, 0xbb, 0x13, 0x01, 0x30, 0xa0, 0x15, 0x35, 0x8a, 0x81, 0x25, 0x2e, 0xc4, 0x93, 0x71, 0x13, 0xfe, 0x36, 0xc7, 0x80, 0x46, 0xb7, 0x11, 0xfb, 0xa1, 0x97, 0x34, 0x91, 0xbb, 0x29, 0x18, 0x7a, 0x00, 0x78, 0x5f, 0xf8, 0x52, 0xae, 0xa0, 0x68, 0x91, 0x42, 0xd3, 0x16, 0xab, 0xfa, 0xa7, 0x1c, 0x8b, 0xce, 0xdf, 0x49, 0x20, 0x1d, 0xdb, 0xb2, 0x10, 0x4e, 0x25, 0x0a, 0xdc, 0x90, 0xc4, 0xe8, 0x56, 0x22, 0x1f, 0x53, 0x4a, 0x96, 0x58, 0xa0, 0xdc, 0x36, 0x50, 0x99, 0x25, 0x34, 0xfd, 0xa8, 0xa3, 0x14, 0xa7, 0xdb, 0xb0, 0xae, 0x3b, 0xa8, 0xc7, 0x9d, 0xb5, 0x55, 0x0c, 0x69, 0xce, 0x2a, 0x24, 0x60, 0xc0, 0x07, 0xad, 0xc4, 0xc1, 0xa3, 0xa0, 0x20, 0xb0, 0x68, 0x3b, 0x66, 0x55, 0xb0, 0x05, 0x9e, 0xe1, 0x03, 0xd0, 0x4e, 0x4b, 0x50, 0x6b, 0xcb, 0xc1, 0x39, 0x00, 0x63, 0x92, 0xb7, 0xda, 0xb1, 0x11, 0x78, 0xc2, 0x66, 0x03, 0x42, 0xe7, 0xa0, 0x8e, 0xed, 0xeb, 0x45, 0xfb, 0x63, 0x0f, 0x1c, 0xd9, 0x97, 0x36, 0xeb, 0x18, 0x57, 0x22, 0x17, 0xcb, 0xc6, 0xd5, 0xf3, 0x15, 0xb7, 0x1b, 0xe2, 0x03, 0xb0, 0x3c, 0xe8, 0xd9, 0x9b, 0x26, 0x14, 0xa0, 0x79, 0x23, 0xa3, 0x3d, 0xf6, 0x5a, 0x98, 0x6f, 0xd5, 0xe7, 0xf9, 0xe6, 0xe4, 0xc2, 0xb9, 0x69, 0x73, 0x6b, 0x08, 0x94, 0x4e, 0xbe, 0x99, 0x39, 0x4a, 0x86, 0x14, 0x61, 0x2f, 0xe6, 0x09, 0xf3, 0xa0, 0x65, 0x34, 0xd7, 0xd0, 0x1a, 0x20, 0x71, 0x4a, 0xa4, 0xfb, 0x2a, 0x55, 0xb9, 0x46, 0xce, 0x64, 0xc3, 0x22, 0x2d, 0xff, 0xad, 0x2a, 0xa2, 0xd1, 0x8a, 0x92, 0x34, 0x73, 0xc9, 0x2a, 0xb1, 0xfd, 0xa0, 0xbf, 0xf9, 0xc2, 0x8b, 0xfe, 0xb8, 0xbf, 0x2d, 0xa9, 0xb6, 0x18, 0xc8, 0xc3, 0xb0, 0x6f, 0xe8, 0x0c, 0xb1, 0xc0, 0xbd, 0x14, 0x47, 0x38, 0xf7, 0xc4, 0x21, 0x61, 0xff, 0x29, 0xe2, 0x50, 0x2f, 0xa0, 0x7f, 0x14, 0x61, 0x69, 0x3c, 0x70, 0x4e, 0xa5, 0x02, 0x1b, 0xbb, 0xa3, 0x5e, 0x72, 0xc5, 0x02, 0xf6, 0x43, 0x9e, 0x45, 0x8f, 0x98, 0x24, 0x2e, 0xd0, 0x37, 0x48, 0xea, 0x8f, 0xe2, 0xb3, 0x5f, 0x80];

    let expected = array![
        0x7770cf09b5067a1b35df62a924898175ceaeecad1f68cdb4a844400c73c14af4,
        0x1ea385d05ab261466d5c0487fe684534c19f1a4b5c4b18dc1a363560025071b4,
        0x2c4c04ce3540d3d1461872303c53a5e56683c1304f8d36a8800c6af5fa3fcdee,
        0xa9dc778dc54b7dd3c48222e739d161feb0c0eeceb2dcd51737f05b8e37a63851,
        0xa95f4d5556df62ddc262990497ae569bcd8efdda7b200793f8d3de4cdb9718d7,
        0x39d4066d1438226eaf4ac9e943a874a9a9c25fb0d81db9861d8c1336b3e2034c,
        0x7acc7c63b46aa418b3c9a041a1256bcb7361316b397ada5a8867491bbb130130,
        0x15358a81252ec4937113fe36c78046b711fba1973491bb29187a00785ff852ae,
        0x689142d316abfaa71c8bcedf49201ddbb2104e250adc90c4e856221f534a9658,
        0xdc3650992534fda8a314a7dbb0ae3ba8c79db5550c69ce2a2460c007adc4c1a3,
        0x20b0683b6655b0059ee103d04e4b506bcbc139006392b7dab11178c2660342e7,
        0x8eedeb45fb630f1cd99736eb18572217cbc6d5f315b71be203b03ce8d99b2614,
        0x7923a33df65a986fd5e7f9e6e4c2b969736b08944ebe99394a8614612fe609f3,
        0x6534d7d01a20714aa4fb2a55b946ce64c3222dffad2aa2d18a923473c92ab1fd,
        0xbff9c28bfeb8bf2da9b618c8c3b06fe80cb1c0bd144738f7c42161ff29e2502f,
        0x7f1461693c704ea5021bbba35e72c502f6439e458f98242ed03748ea8fe2b35f
    ];

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    let expected_value = array![];
    let expected_node = MPTNode::Branch((expected.span(), expected_value.span()));
    assert(decoded == expected_node, 'Branch node differs');
}

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_leaf_odd() {
    let rlp_node  = array![0xf8, 0x66, 0x9d, 0x33, 0x8c, 0xfc, 0x99, 0x7a, 0x82, 0x25, 0x21, 0x67, 0xac, 0x25, 0xa1, 0x65, 0x80, 0xd9, 0x73, 0x03, 0x53, 0xeb, 0x1b, 0x9f, 0x0c, 0x6b, 0xbf, 0x0e, 0x4c, 0x82, 0xc4, 0xd0, 0xb8, 0x46, 0xf8, 0x44, 0x01, 0x80, 0xa0, 0x96, 0xc4, 0xbd, 0xfb, 0x8f, 0x2a, 0xd0, 0x89, 0x20, 0x0b, 0xad, 0x93, 0xf6, 0x21, 0x6f, 0xe9, 0x66, 0x52, 0xf9, 0xe2, 0x76, 0x1b, 0x55, 0xbf, 0xd8, 0xa7, 0x15, 0xad, 0x3d, 0x6e, 0xca, 0xf6, 0xa0, 0x4e, 0x36, 0xf9, 0x6e, 0xe1, 0x66, 0x7a, 0x66, 0x3d, 0xfa, 0xac, 0x57, 0xc4, 0xd1, 0x85, 0xa0, 0xe3, 0x69, 0xa3, 0xa2, 0x17, 0xe0, 0x07, 0x9d, 0x49, 0x62, 0x0f, 0x34, 0xf8, 0x5d, 0x1a, 0xc7];

    let expected_key_end = array![0x3, 0x8, 0xc, 0xf, 0xc, 0x9, 0x9, 0x7, 0xa, 0x8, 0x2, 0x2, 0x5, 0x2, 0x1, 0x6, 0x7, 0xa, 0xc, 0x2, 0x5, 0xa, 0x1, 0x6, 0x5, 0x8, 0x0, 0xd, 0x9, 0x7, 0x3, 0x0, 0x3, 0x5, 0x3, 0xe, 0xb, 0x1, 0xb, 0x9, 0xf, 0x0, 0xc, 0x6, 0xb, 0xb, 0xf, 0x0, 0xe, 0x4, 0xc, 0x8, 0x2, 0xc, 0x4, 0xd, 0x0];
    let expected_value = array![0xf8, 0x44, 0x01, 0x80, 0xa0, 0x96, 0xc4, 0xbd, 0xfb, 0x8f, 0x2a, 0xd0, 0x89, 0x20, 0x0b, 0xad, 0x93, 0xf6, 0x21, 0x6f, 0xe9, 0x66, 0x52, 0xf9, 0xe2, 0x76, 0x1b, 0x55, 0xbf, 0xd8, 0xa7, 0x15, 0xad, 0x3d, 0x6e, 0xca, 0xf6, 0xa0, 0x4e, 0x36, 0xf9, 0x6e, 0xe1, 0x66, 0x7a, 0x66, 0x3d, 0xfa, 0xac, 0x57, 0xc4, 0xd1, 0x85, 0xa0, 0xe3, 0x69, 0xa3, 0xa2, 0x17, 0xe0, 0x07, 0x9d, 0x49, 0x62, 0x0f, 0x34, 0xf8, 0x5d, 0x1a, 0xc7];

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    let expected_node = MPTNode::Leaf((expected_key_end.span(), expected_value.span()));
    assert(decoded == expected_node, 'Odd leaf node differs');
}

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_leaf_even() {
    let rlp_node  = array![0xf8, 0x66, 0x9d, 0x23, 0x8c, 0xfc, 0x99, 0x7a, 0x82, 0x25, 0x21, 0x67, 0xac, 0x25, 0xa1, 0x65, 0x80, 0xd9, 0x73, 0x03, 0x53, 0xeb, 0x1b, 0x9f, 0x0c, 0x6b, 0xbf, 0x0e, 0x4c, 0x82, 0xc4, 0xd0, 0xb8, 0x46, 0xf8, 0x44, 0x01, 0x80, 0xa0, 0x96, 0xc4, 0xbd, 0xfb, 0x8f, 0x2a, 0xd0, 0x89, 0x20, 0x0b, 0xad, 0x93, 0xf6, 0x21, 0x6f, 0xe9, 0x66, 0x52, 0xf9, 0xe2, 0x76, 0x1b, 0x55, 0xbf, 0xd8, 0xa7, 0x15, 0xad, 0x3d, 0x6e, 0xca, 0xf6, 0xa0, 0x4e, 0x36, 0xf9, 0x6e, 0xe1, 0x66, 0x7a, 0x66, 0x3d, 0xfa, 0xac, 0x57, 0xc4, 0xd1, 0x85, 0xa0, 0xe3, 0x69, 0xa3, 0xa2, 0x17, 0xe0, 0x07, 0x9d, 0x49, 0x62, 0x0f, 0x34, 0xf8, 0x5d, 0x1a, 0xc7];

    let expected_key_end = array![0x8, 0xc, 0xf, 0xc, 0x9, 0x9, 0x7, 0xa, 0x8, 0x2, 0x2, 0x5, 0x2, 0x1, 0x6, 0x7, 0xa, 0xc, 0x2, 0x5, 0xa, 0x1, 0x6, 0x5, 0x8, 0x0, 0xd, 0x9, 0x7, 0x3, 0x0, 0x3, 0x5, 0x3, 0xe, 0xb, 0x1, 0xb, 0x9, 0xf, 0x0, 0xc, 0x6, 0xb, 0xb, 0xf, 0x0, 0xe, 0x4, 0xc, 0x8, 0x2, 0xc, 0x4, 0xd, 0x0];
    let expected_value = array![0xf8, 0x44, 0x01, 0x80, 0xa0, 0x96, 0xc4, 0xbd, 0xfb, 0x8f, 0x2a, 0xd0, 0x89, 0x20, 0x0b, 0xad, 0x93, 0xf6, 0x21, 0x6f, 0xe9, 0x66, 0x52, 0xf9, 0xe2, 0x76, 0x1b, 0x55, 0xbf, 0xd8, 0xa7, 0x15, 0xad, 0x3d, 0x6e, 0xca, 0xf6, 0xa0, 0x4e, 0x36, 0xf9, 0x6e, 0xe1, 0x66, 0x7a, 0x66, 0x3d, 0xfa, 0xac, 0x57, 0xc4, 0xd1, 0x85, 0xa0, 0xe3, 0x69, 0xa3, 0xa2, 0x17, 0xe0, 0x07, 0x9d, 0x49, 0x62, 0x0f, 0x34, 0xf8, 0x5d, 0x1a, 0xc7];

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    let expected_node = MPTNode::Leaf((expected_key_end.span(), expected_value.span()));
    assert(decoded == expected_node, 'Even leaf node differs');
}

#[test]
#[available_gas(9999999999)]
fn test_hash_rlp_node() {
    let mut rlp_node = array![0xf8, 0x66, 0x9d, 0x33, 0x8c, 0xfc, 0x99, 0x7a, 0x82, 0x25, 0x21, 0x67, 0xac, 0x25, 0xa1, 0x65, 0x80, 0xd9, 0x73, 0x03, 0x53, 0xeb, 0x1b, 0x9f, 0x0c, 0x6b, 0xbf, 0x0e, 0x4c, 0x82, 0xc4, 0xd0, 0xb8, 0x46, 0xf8, 0x44, 0x01, 0x80, 0xa0, 0x96, 0xc4, 0xbd, 0xfb, 0x8f, 0x2a, 0xd0, 0x89, 0x20, 0x0b, 0xad, 0x93, 0xf6, 0x21, 0x6f, 0xe9, 0x66, 0x52, 0xf9, 0xe2, 0x76, 0x1b, 0x55, 0xbf, 0xd8, 0xa7, 0x15, 0xad, 0x3d, 0x6e, 0xca, 0xf6, 0xa0, 0x4e, 0x36, 0xf9, 0x6e, 0xe1, 0x66, 0x7a, 0x66, 0x3d, 0xfa, 0xac, 0x57, 0xc4, 0xd1, 0x85, 0xa0, 0xe3, 0x69, 0xa3, 0xa2, 0x17, 0xe0, 0x07, 0x9d, 0x49, 0x62, 0x0f, 0x34, 0xf8, 0x5d, 0x1a, 0xc7];
    
    let hash = MPTTrait::hash_rlp_node(rlp_node.span());
    assert(hash == 0xa17f16b1638e6f7b596424b3b81d114a6aec7f1c79b93e2915e0bee8549a5f03, 'Wrong node rlp hash');
}

#[test]
#[available_gas(9999999999999)]
fn test_full_verify() {
    // Account : 0x7b5C526B7F8dfdff278b4a3e045083FBA4028790 | Goerli | Block 9000000
    //"0xf90211a0f09eae4e1e51fdde02a2884e285b8a8a9c72cc7e7cdaeef013714e3499bcd475a0ce33fd7097055e50d64c42759027e41ffb22d5b2a03ee67207dc94b547e40956a04817bf75497b71a78957ff89d05107cbf16ead02f7e68f13cead9e7d24dfcda5a00751841dcd0e21ff273930aa4722cabae7ea4e09d0f4e9f667b57ab68a41652ea047008ee2caeec1839c016d0a8efd2e901091bfae5388fc064db9f14f4bda362da0f952be9637ec6790bcdcf9ae3d4bca607259f26c0731e3cbd2882924c9db5653a061a8882bde126643739fe5f0acc5d234467718c27217f56513fd222009802336a061dbaa68a4290e8cce57166ffc6fd22d081c5893a081082b23668ef6c7d65c81a0ef2e0aea160700e14be7285c8b83535f4d104a74ac8db6c188d84ee48a8a647ca0c00853c7500db3c616d5d7dcd7503c02307045e7670a0749ffdebadc732a9ab4a068050da8f891b57fbeacffe4ba3e41f11c5d6b0ec8553fbb796f46951ecd1445a0762e36c38c548c5ae61da51205ef1dc66390702397becef53c50d969cae7a2ada0abff9de80f8e14979ebbe80ae3e702e61b31b91ea481c0e63a7bde12e866eeb5a017220448de88495fdf81446233768ef9441058e4602ecafc1da85a7cbbf1c16da084351381e6cad5052c82f731e8d19d86193794eccdf274529bed7e67309cca78a0784e83133c0ba8ff0262d0c96dc93f936d97eac46327d32f3c1baceb63934d9d80",
    //"0xf90211a0679ec41f2230e1f57eededf17732966880d9835d744ad769a1b246829341a588a09c2941acea1f1461a7d0af3bb9917c16e3a3339556623a6cad6d1f40ee8fc8a8a0211b79624826f8cd651f7a0123356cfef56854adf7285163988ba4eee0e8f964a062a3e341692078b717029cd105b462749386aecc1cb647721cc382872eac4a51a01a9fc7658bcc2948e1123273e83fb66894e64c2e19aa8f3ac546c45ef4b22290a08c5cdf2e341821e9c3163ec52847e33884f4797669607a60a8adafd00edead0ea08b07046b12762a58e03a482d597cca869aaffd85214bbd08c4624325a7cf80c9a0602d16a56550182218f642f56e66b1cf72555c38dac0fd061b8ef113d4653f4aa038fa2d962cfe43eb49f5a7d1787a436e8e3c6858665b1b0703c4e42ad43f962ea03a706c9b0e0757079f96d9df003eae31aafcf7525d6114033ee929c78adc580aa0f8a66bdc97088d4c73429b9ee00d7bcd0589be3462a53e9f5b9876d4b5231e40a04bbcbff81f2c0b65f29724ef71f6d439b6f857ad5fa7b643c1ea5dfc72ee240fa098cd5bf5aea320986616ff7bfc78efdf43091610fb457447058958e68a13e49ba02033016a2ef0512c926211fbec6f9b7398c58ae10116901d086905979649d968a07cf13191df973971dd4592a95c33cc3c248a4e919b8866c7c8ecff44a6e453a2a017010b7ff49cf72fbc13136f189457a2bc09e8c400ca9cb7997ff75bf34637ec80",
    //"0xf90211a06c86eef3a8754d952a265132ed86282d34ec24f9f5aa2f085629155798975c2ba02cef7b79076bddfe220fd88ca1a18414683b2f37e8b94cf8c6bdf743cff9d18ca00fe6e40f33bc1b76e34a6c92cdfce9b08f808bca7c6fe85348a7b7e838632a20a0f2f4d7b6fb649794a45288bfbc32274f3031ebc8bbf808146a3104ea27d72e7aa0cf2a353bb32b3b9c004c7586d6723ea5e2ccb99972c84b4b2c90166ca0c3c65ba0753fee595b7a0b80d3574db4e4615a599da7bedfa71bcb9ba214192c6dfb8a4fa0a7e45064974417eeef5556e4fa3533c819cc04825a33f0e244440d4d6a42828ca06cb2eaf789a62824a4a2b730bc4b8ee70e3648fbdf6cd61ea86d234dda67ccc3a0e42e79aeed163de73664c3b4f9451208b22b4874eae6c007b5f0405a64a55050a072f87da9fbd3c727080eef39891888876cdfbc54b732cf4f08ee19d067117d5ba0ce88e695612d636a6f73c2fcc0086e486249a0284cd6b88bf1cc3a7bef84ce9ba0d408599a558fc0ad84aba0bea36e00c1e99ddebf7b74e2f68912563bd5a62522a0154aef7de9275d13e860b11f138a811e6ed97fbf8985c524ccd5c231dbc62180a0282022799ec74b1dc2df4edad584b0b974113a06a857ff72ed17471908d28404a00c4fc7a3f7ded56f4da7093a875bd7c3a6cb35cc6bdf505cb79aee64708640aca0339829e86f4b7a2d68fe0b4707e32016534cdf8a48070a3921a48bcc0fd4b11c80",
    //"0xf90211a0b70bd38b197882c9e04dbdbc463bd74887af466e509bb9f61283796000649611a05b7c13208dc2fbd708005d510297a825e6ee16a541a1f7860b5226f39e7d31ada09fea01b1db9afdd63932fc4a335ca3af6824afcba793fab68a6536e4f302fc19a0d73148886a70f18c6a41f65a9d012b8a5198deacf33b0839b494a1338b23cf7ba0e6923675583267b502e2a6ac685651f4bfb54b6cf00cffdf7e603927107eca70a01e2fcb240f26a1d85e908bc77a75628b144f31b0f6d56ddc139cb5a56002420ca021420c0d6ab2d50504f7cad0e4d76109c2c93f2c49c9677863f290c8dc4e3c14a0379fe1bd0b044c94f67f844bd2c7f7abf83ac8049ab234ce301326d79fb7ae0ba0890ea9c4679262b86e65f2895ff9e6e97a0ed06d7beb9b4d3d8c8d3246a06715a04569c16e7ba91a901aec96cd999b89201e192670edaff70d2991edf779de5082a0adaed327e31819a530e941a4eebf0ed8e245b9272947199566e89e4496a6c05ba0c39e54b4ce440fbc36c43baafc9809a80e8cc5649b2f8753b5edbac3b7c043e3a0812541bed009f7cae97ba783dde88aced6e5f21fc80b41e91b9479d35184e45ea0708adda1f1ad89034e35a2fd063420d885713fb7f176960e47eebc0df8e8afc0a0a305e0528d3f6122a460eeffc54ce1c4c67f71f376e8d84a4ed23dfdc2cc4effa02928ce112a3e076214a2b1e25fbfc463411c378c12702506c1479f97ba5bffce80",
    //"0xf90211a09881800af81281b599a2ae599789501c2561294aeb892905e5f454bdcf79a187a047e8fd36ef03ad0479902154249d5e43071efbf78b4974f2cda490fa42d17ba6a063b7d25d086bdfa18c5beb67e4339f683de15346ef948b01139d8c0e83a96387a0b8662c97a229aa73ab190ab402a7fa2acad9cf66251ad0a44c9070732e298b11a0fac6584c1fa6aa7db2e615e10ba63a9b353f3febbe93d3ae2276891668aa7fc1a0777e0f4f2695a65939c8a191cc32e0bc74c557d057a46b5135f36e3c232b7fb8a0d78ec39c3544f76d77c0aa20b4cdb58c8ac29745713b240b7fdd3836497fdb04a04729097a95f6c001478b2ed057c71a9de89b0e4ee18cbf6c04d578bac2c7ed28a09f6f37e1ffed0554f4133b5743e4e7e807054ce7f9615df1fdcceb0264e31829a0cddde78e2ed07fd82b486cca326ec315f3d1df4a635f1898811b1d4d45d7361ca018f06484f8a256a810fdf6800d30c40094de7561a12b3cc9a9e90979e0ce4a10a08c01dbe66e1e60f5edea0e1bf2990aed610dadb9783f2070b206c88ffc05e7ffa09763ea84f4ae07ffec150a3d59674a49c944dc94409881b0380a3ed2e4ab6b70a0d0e86e1c6f991a9afb97bf1648487fcc90f61d4a6f7d8fa419cb829e11c5b764a042d00184633bd8df55db881b1b46457f1d0cff162c8843f9aea18509271f9407a081aad7099cafddcb44141737b986eec45e93aa16774c7d0480d395fca582cf8d80",
    //"0xf9019180a08eeac7bec8ceaaf659b328d4a04e418159914c7681f83470cd313d6e984a0754a06dac15ddea9fe0ba3097f94727c1f61cda2219e639c443e52b231ceb71b9c86fa0a6545f791304f8f4dfa8bae7699aff682733b246c6df78b03a955b87e974a330a0f75c6a10796830946f04645d5d11e5b0bcbc40f0cb83cd716440e6ef1d8b3d048080a0646d1cbea060b31a3ddfcb8e802620232a2164a64abc04dba88654667668261ba0c61e9aff13ad27a1d50510f88ff4879db3fd7cef1782982d3cf8702742b2941da0b2a8722ff78f03327b585da064ed79ea1818cff6cc41fe3249368cc04493ca41a001719ecf3a6e924abbdbb6f3de50794df3d9f9f503bfb54bab753e2d9b5c7230a08073f6a9ebd0c84a9dd5b6176d52bc80596eb74c192a7a551b3ae80620facaf7a0290f29ddbba5a789b068535aeda99809053bea7642e0bd7a604a15112b5818cb80a00bf0a7e8a9b0797f99bccaa5655462c00172c769c5bed589c149df04c9d748bfa02c83d167a8b35607906f4639c2442bacde5c67dab80bb2fc74564a32d3a3194380",
    //"0xf8679e20eb3d3905f6526cb7fbb8ca13df8d9c63efade348e70065aa05f578f315b846f8440180a06968aa4d96a817eb4d24aa4d096d0d841f9c52ed7bbc4ca7d7951bba6fc65571a089b1de4a1e012d6a62b18b6ad184985d57545bf1da0ae1c218f4cea34daf099b"

    let proof_0 = array![0xf9, 0x02, 0x11, 0xa0, 0xf0, 0x9e, 0xae, 0x4e, 0x1e, 0x51, 0xfd, 0xde, 0x02, 0xa2, 0x88, 0x4e, 0x28, 0x5b, 0x8a, 0x8a, 0x9c, 0x72, 0xcc, 0x7e, 0x7c, 0xda, 0xee, 0xf0, 0x13, 0x71, 0x4e, 0x34, 0x99, 0xbc, 0xd4, 0x75, 0xa0, 0xce, 0x33, 0xfd, 0x70, 0x97, 0x05, 0x5e, 0x50, 0xd6, 0x4c, 0x42, 0x75, 0x90, 0x27, 0xe4, 0x1f, 0xfb, 0x22, 0xd5, 0xb2, 0xa0, 0x3e, 0xe6, 0x72, 0x07, 0xdc, 0x94, 0xb5, 0x47, 0xe4, 0x09, 0x56, 0xa0, 0x48, 0x17, 0xbf, 0x75, 0x49, 0x7b, 0x71, 0xa7, 0x89, 0x57, 0xff, 0x89, 0xd0, 0x51, 0x07, 0xcb, 0xf1, 0x6e, 0xad, 0x02, 0xf7, 0xe6, 0x8f, 0x13, 0xce, 0xad, 0x9e, 0x7d, 0x24, 0xdf, 0xcd, 0xa5, 0xa0, 0x07, 0x51, 0x84, 0x1d, 0xcd, 0x0e, 0x21, 0xff, 0x27, 0x39, 0x30, 0xaa, 0x47, 0x22, 0xca, 0xba, 0xe7, 0xea, 0x4e, 0x09, 0xd0, 0xf4, 0xe9, 0xf6, 0x67, 0xb5, 0x7a, 0xb6, 0x8a, 0x41, 0x65, 0x2e, 0xa0, 0x47, 0x00, 0x8e, 0xe2, 0xca, 0xee, 0xc1, 0x83, 0x9c, 0x01, 0x6d, 0x0a, 0x8e, 0xfd, 0x2e, 0x90, 0x10, 0x91, 0xbf, 0xae, 0x53, 0x88, 0xfc, 0x06, 0x4d, 0xb9, 0xf1, 0x4f, 0x4b, 0xda, 0x36, 0x2d, 0xa0, 0xf9, 0x52, 0xbe, 0x96, 0x37, 0xec, 0x67, 0x90, 0xbc, 0xdc, 0xf9, 0xae, 0x3d, 0x4b, 0xca, 0x60, 0x72, 0x59, 0xf2, 0x6c, 0x07, 0x31, 0xe3, 0xcb, 0xd2, 0x88, 0x29, 0x24, 0xc9, 0xdb, 0x56, 0x53, 0xa0, 0x61, 0xa8, 0x88, 0x2b, 0xde, 0x12, 0x66, 0x43, 0x73, 0x9f, 0xe5, 0xf0, 0xac, 0xc5, 0xd2, 0x34, 0x46, 0x77, 0x18, 0xc2, 0x72, 0x17, 0xf5, 0x65, 0x13, 0xfd, 0x22, 0x20, 0x09, 0x80, 0x23, 0x36, 0xa0, 0x61, 0xdb, 0xaa, 0x68, 0xa4, 0x29, 0x0e, 0x8c, 0xce, 0x57, 0x16, 0x6f, 0xfc, 0x6f, 0xd2, 0x2d, 0x08, 0x1c, 0x58, 0x93, 0xa0, 0x81, 0x08, 0x2b, 0x23, 0x66, 0x8e, 0xf6, 0xc7, 0xd6, 0x5c, 0x81, 0xa0, 0xef, 0x2e, 0x0a, 0xea, 0x16, 0x07, 0x00, 0xe1, 0x4b, 0xe7, 0x28, 0x5c, 0x8b, 0x83, 0x53, 0x5f, 0x4d, 0x10, 0x4a, 0x74, 0xac, 0x8d, 0xb6, 0xc1, 0x88, 0xd8, 0x4e, 0xe4, 0x8a, 0x8a, 0x64, 0x7c, 0xa0, 0xc0, 0x08, 0x53, 0xc7, 0x50, 0x0d, 0xb3, 0xc6, 0x16, 0xd5, 0xd7, 0xdc, 0xd7, 0x50, 0x3c, 0x02, 0x30, 0x70, 0x45, 0xe7, 0x67, 0x0a, 0x07, 0x49, 0xff, 0xde, 0xba, 0xdc, 0x73, 0x2a, 0x9a, 0xb4, 0xa0, 0x68, 0x05, 0x0d, 0xa8, 0xf8, 0x91, 0xb5, 0x7f, 0xbe, 0xac, 0xff, 0xe4, 0xba, 0x3e, 0x41, 0xf1, 0x1c, 0x5d, 0x6b, 0x0e, 0xc8, 0x55, 0x3f, 0xbb, 0x79, 0x6f, 0x46, 0x95, 0x1e, 0xcd, 0x14, 0x45, 0xa0, 0x76, 0x2e, 0x36, 0xc3, 0x8c, 0x54, 0x8c, 0x5a, 0xe6, 0x1d, 0xa5, 0x12, 0x05, 0xef, 0x1d, 0xc6, 0x63, 0x90, 0x70, 0x23, 0x97, 0xbe, 0xce, 0xf5, 0x3c, 0x50, 0xd9, 0x69, 0xca, 0xe7, 0xa2, 0xad, 0xa0, 0xab, 0xff, 0x9d, 0xe8, 0x0f, 0x8e, 0x14, 0x97, 0x9e, 0xbb, 0xe8, 0x0a, 0xe3, 0xe7, 0x02, 0xe6, 0x1b, 0x31, 0xb9, 0x1e, 0xa4, 0x81, 0xc0, 0xe6, 0x3a, 0x7b, 0xde, 0x12, 0xe8, 0x66, 0xee, 0xb5, 0xa0, 0x17, 0x22, 0x04, 0x48, 0xde, 0x88, 0x49, 0x5f, 0xdf, 0x81, 0x44, 0x62, 0x33, 0x76, 0x8e, 0xf9, 0x44, 0x10, 0x58, 0xe4, 0x60, 0x2e, 0xca, 0xfc, 0x1d, 0xa8, 0x5a, 0x7c, 0xbb, 0xf1, 0xc1, 0x6d, 0xa0, 0x84, 0x35, 0x13, 0x81, 0xe6, 0xca, 0xd5, 0x05, 0x2c, 0x82, 0xf7, 0x31, 0xe8, 0xd1, 0x9d, 0x86, 0x19, 0x37, 0x94, 0xec, 0xcd, 0xf2, 0x74, 0x52, 0x9b, 0xed, 0x7e, 0x67, 0x30, 0x9c, 0xca, 0x78, 0xa0, 0x78, 0x4e, 0x83, 0x13, 0x3c, 0x0b, 0xa8, 0xff, 0x02, 0x62, 0xd0, 0xc9, 0x6d, 0xc9, 0x3f, 0x93, 0x6d, 0x97, 0xea, 0xc4, 0x63, 0x27, 0xd3, 0x2f, 0x3c, 0x1b, 0xac, 0xeb, 0x63, 0x93, 0x4d, 0x9d, 0x80];
    let proof_1 = array![0xf9, 0x02, 0x11, 0xa0, 0x67, 0x9e, 0xc4, 0x1f, 0x22, 0x30, 0xe1, 0xf5, 0x7e, 0xed, 0xed, 0xf1, 0x77, 0x32, 0x96, 0x68, 0x80, 0xd9, 0x83, 0x5d, 0x74, 0x4a, 0xd7, 0x69, 0xa1, 0xb2, 0x46, 0x82, 0x93, 0x41, 0xa5, 0x88, 0xa0, 0x9c, 0x29, 0x41, 0xac, 0xea, 0x1f, 0x14, 0x61, 0xa7, 0xd0, 0xaf, 0x3b, 0xb9, 0x91, 0x7c, 0x16, 0xe3, 0xa3, 0x33, 0x95, 0x56, 0x62, 0x3a, 0x6c, 0xad, 0x6d, 0x1f, 0x40, 0xee, 0x8f, 0xc8, 0xa8, 0xa0, 0x21, 0x1b, 0x79, 0x62, 0x48, 0x26, 0xf8, 0xcd, 0x65, 0x1f, 0x7a, 0x01, 0x23, 0x35, 0x6c, 0xfe, 0xf5, 0x68, 0x54, 0xad, 0xf7, 0x28, 0x51, 0x63, 0x98, 0x8b, 0xa4, 0xee, 0xe0, 0xe8, 0xf9, 0x64, 0xa0, 0x62, 0xa3, 0xe3, 0x41, 0x69, 0x20, 0x78, 0xb7, 0x17, 0x02, 0x9c, 0xd1, 0x05, 0xb4, 0x62, 0x74, 0x93, 0x86, 0xae, 0xcc, 0x1c, 0xb6, 0x47, 0x72, 0x1c, 0xc3, 0x82, 0x87, 0x2e, 0xac, 0x4a, 0x51, 0xa0, 0x1a, 0x9f, 0xc7, 0x65, 0x8b, 0xcc, 0x29, 0x48, 0xe1, 0x12, 0x32, 0x73, 0xe8, 0x3f, 0xb6, 0x68, 0x94, 0xe6, 0x4c, 0x2e, 0x19, 0xaa, 0x8f, 0x3a, 0xc5, 0x46, 0xc4, 0x5e, 0xf4, 0xb2, 0x22, 0x90, 0xa0, 0x8c, 0x5c, 0xdf, 0x2e, 0x34, 0x18, 0x21, 0xe9, 0xc3, 0x16, 0x3e, 0xc5, 0x28, 0x47, 0xe3, 0x38, 0x84, 0xf4, 0x79, 0x76, 0x69, 0x60, 0x7a, 0x60, 0xa8, 0xad, 0xaf, 0xd0, 0x0e, 0xde, 0xad, 0x0e, 0xa0, 0x8b, 0x07, 0x04, 0x6b, 0x12, 0x76, 0x2a, 0x58, 0xe0, 0x3a, 0x48, 0x2d, 0x59, 0x7c, 0xca, 0x86, 0x9a, 0xaf, 0xfd, 0x85, 0x21, 0x4b, 0xbd, 0x08, 0xc4, 0x62, 0x43, 0x25, 0xa7, 0xcf, 0x80, 0xc9, 0xa0, 0x60, 0x2d, 0x16, 0xa5, 0x65, 0x50, 0x18, 0x22, 0x18, 0xf6, 0x42, 0xf5, 0x6e, 0x66, 0xb1, 0xcf, 0x72, 0x55, 0x5c, 0x38, 0xda, 0xc0, 0xfd, 0x06, 0x1b, 0x8e, 0xf1, 0x13, 0xd4, 0x65, 0x3f, 0x4a, 0xa0, 0x38, 0xfa, 0x2d, 0x96, 0x2c, 0xfe, 0x43, 0xeb, 0x49, 0xf5, 0xa7, 0xd1, 0x78, 0x7a, 0x43, 0x6e, 0x8e, 0x3c, 0x68, 0x58, 0x66, 0x5b, 0x1b, 0x07, 0x03, 0xc4, 0xe4, 0x2a, 0xd4, 0x3f, 0x96, 0x2e, 0xa0, 0x3a, 0x70, 0x6c, 0x9b, 0x0e, 0x07, 0x57, 0x07, 0x9f, 0x96, 0xd9, 0xdf, 0x00, 0x3e, 0xae, 0x31, 0xaa, 0xfc, 0xf7, 0x52, 0x5d, 0x61, 0x14, 0x03, 0x3e, 0xe9, 0x29, 0xc7, 0x8a, 0xdc, 0x58, 0x0a, 0xa0, 0xf8, 0xa6, 0x6b, 0xdc, 0x97, 0x08, 0x8d, 0x4c, 0x73, 0x42, 0x9b, 0x9e, 0xe0, 0x0d, 0x7b, 0xcd, 0x05, 0x89, 0xbe, 0x34, 0x62, 0xa5, 0x3e, 0x9f, 0x5b, 0x98, 0x76, 0xd4, 0xb5, 0x23, 0x1e, 0x40, 0xa0, 0x4b, 0xbc, 0xbf, 0xf8, 0x1f, 0x2c, 0x0b, 0x65, 0xf2, 0x97, 0x24, 0xef, 0x71, 0xf6, 0xd4, 0x39, 0xb6, 0xf8, 0x57, 0xad, 0x5f, 0xa7, 0xb6, 0x43, 0xc1, 0xea, 0x5d, 0xfc, 0x72, 0xee, 0x24, 0x0f, 0xa0, 0x98, 0xcd, 0x5b, 0xf5, 0xae, 0xa3, 0x20, 0x98, 0x66, 0x16, 0xff, 0x7b, 0xfc, 0x78, 0xef, 0xdf, 0x43, 0x09, 0x16, 0x10, 0xfb, 0x45, 0x74, 0x47, 0x05, 0x89, 0x58, 0xe6, 0x8a, 0x13, 0xe4, 0x9b, 0xa0, 0x20, 0x33, 0x01, 0x6a, 0x2e, 0xf0, 0x51, 0x2c, 0x92, 0x62, 0x11, 0xfb, 0xec, 0x6f, 0x9b, 0x73, 0x98, 0xc5, 0x8a, 0xe1, 0x01, 0x16, 0x90, 0x1d, 0x08, 0x69, 0x05, 0x97, 0x96, 0x49, 0xd9, 0x68, 0xa0, 0x7c, 0xf1, 0x31, 0x91, 0xdf, 0x97, 0x39, 0x71, 0xdd, 0x45, 0x92, 0xa9, 0x5c, 0x33, 0xcc, 0x3c, 0x24, 0x8a, 0x4e, 0x91, 0x9b, 0x88, 0x66, 0xc7, 0xc8, 0xec, 0xff, 0x44, 0xa6, 0xe4, 0x53, 0xa2, 0xa0, 0x17, 0x01, 0x0b, 0x7f, 0xf4, 0x9c, 0xf7, 0x2f, 0xbc, 0x13, 0x13, 0x6f, 0x18, 0x94, 0x57, 0xa2, 0xbc, 0x09, 0xe8, 0xc4, 0x00, 0xca, 0x9c, 0xb7, 0x99, 0x7f, 0xf7, 0x5b, 0xf3, 0x46, 0x37, 0xec, 0x80];
    let proof_2 = array![0xf9, 0x02, 0x11, 0xa0, 0x6c, 0x86, 0xee, 0xf3, 0xa8, 0x75, 0x4d, 0x95, 0x2a, 0x26, 0x51, 0x32, 0xed, 0x86, 0x28, 0x2d, 0x34, 0xec, 0x24, 0xf9, 0xf5, 0xaa, 0x2f, 0x08, 0x56, 0x29, 0x15, 0x57, 0x98, 0x97, 0x5c, 0x2b, 0xa0, 0x2c, 0xef, 0x7b, 0x79, 0x07, 0x6b, 0xdd, 0xfe, 0x22, 0x0f, 0xd8, 0x8c, 0xa1, 0xa1, 0x84, 0x14, 0x68, 0x3b, 0x2f, 0x37, 0xe8, 0xb9, 0x4c, 0xf8, 0xc6, 0xbd, 0xf7, 0x43, 0xcf, 0xf9, 0xd1, 0x8c, 0xa0, 0x0f, 0xe6, 0xe4, 0x0f, 0x33, 0xbc, 0x1b, 0x76, 0xe3, 0x4a, 0x6c, 0x92, 0xcd, 0xfc, 0xe9, 0xb0, 0x8f, 0x80, 0x8b, 0xca, 0x7c, 0x6f, 0xe8, 0x53, 0x48, 0xa7, 0xb7, 0xe8, 0x38, 0x63, 0x2a, 0x20, 0xa0, 0xf2, 0xf4, 0xd7, 0xb6, 0xfb, 0x64, 0x97, 0x94, 0xa4, 0x52, 0x88, 0xbf, 0xbc, 0x32, 0x27, 0x4f, 0x30, 0x31, 0xeb, 0xc8, 0xbb, 0xf8, 0x08, 0x14, 0x6a, 0x31, 0x04, 0xea, 0x27, 0xd7, 0x2e, 0x7a, 0xa0, 0xcf, 0x2a, 0x35, 0x3b, 0xb3, 0x2b, 0x3b, 0x9c, 0x00, 0x4c, 0x75, 0x86, 0xd6, 0x72, 0x3e, 0xa5, 0xe2, 0xcc, 0xb9, 0x99, 0x72, 0xc8, 0x4b, 0x4b, 0x2c, 0x90, 0x16, 0x6c, 0xa0, 0xc3, 0xc6, 0x5b, 0xa0, 0x75, 0x3f, 0xee, 0x59, 0x5b, 0x7a, 0x0b, 0x80, 0xd3, 0x57, 0x4d, 0xb4, 0xe4, 0x61, 0x5a, 0x59, 0x9d, 0xa7, 0xbe, 0xdf, 0xa7, 0x1b, 0xcb, 0x9b, 0xa2, 0x14, 0x19, 0x2c, 0x6d, 0xfb, 0x8a, 0x4f, 0xa0, 0xa7, 0xe4, 0x50, 0x64, 0x97, 0x44, 0x17, 0xee, 0xef, 0x55, 0x56, 0xe4, 0xfa, 0x35, 0x33, 0xc8, 0x19, 0xcc, 0x04, 0x82, 0x5a, 0x33, 0xf0, 0xe2, 0x44, 0x44, 0x0d, 0x4d, 0x6a, 0x42, 0x82, 0x8c, 0xa0, 0x6c, 0xb2, 0xea, 0xf7, 0x89, 0xa6, 0x28, 0x24, 0xa4, 0xa2, 0xb7, 0x30, 0xbc, 0x4b, 0x8e, 0xe7, 0x0e, 0x36, 0x48, 0xfb, 0xdf, 0x6c, 0xd6, 0x1e, 0xa8, 0x6d, 0x23, 0x4d, 0xda, 0x67, 0xcc, 0xc3, 0xa0, 0xe4, 0x2e, 0x79, 0xae, 0xed, 0x16, 0x3d, 0xe7, 0x36, 0x64, 0xc3, 0xb4, 0xf9, 0x45, 0x12, 0x08, 0xb2, 0x2b, 0x48, 0x74, 0xea, 0xe6, 0xc0, 0x07, 0xb5, 0xf0, 0x40, 0x5a, 0x64, 0xa5, 0x50, 0x50, 0xa0, 0x72, 0xf8, 0x7d, 0xa9, 0xfb, 0xd3, 0xc7, 0x27, 0x08, 0x0e, 0xef, 0x39, 0x89, 0x18, 0x88, 0x87, 0x6c, 0xdf, 0xbc, 0x54, 0xb7, 0x32, 0xcf, 0x4f, 0x08, 0xee, 0x19, 0xd0, 0x67, 0x11, 0x7d, 0x5b, 0xa0, 0xce, 0x88, 0xe6, 0x95, 0x61, 0x2d, 0x63, 0x6a, 0x6f, 0x73, 0xc2, 0xfc, 0xc0, 0x08, 0x6e, 0x48, 0x62, 0x49, 0xa0, 0x28, 0x4c, 0xd6, 0xb8, 0x8b, 0xf1, 0xcc, 0x3a, 0x7b, 0xef, 0x84, 0xce, 0x9b, 0xa0, 0xd4, 0x08, 0x59, 0x9a, 0x55, 0x8f, 0xc0, 0xad, 0x84, 0xab, 0xa0, 0xbe, 0xa3, 0x6e, 0x00, 0xc1, 0xe9, 0x9d, 0xde, 0xbf, 0x7b, 0x74, 0xe2, 0xf6, 0x89, 0x12, 0x56, 0x3b, 0xd5, 0xa6, 0x25, 0x22, 0xa0, 0x15, 0x4a, 0xef, 0x7d, 0xe9, 0x27, 0x5d, 0x13, 0xe8, 0x60, 0xb1, 0x1f, 0x13, 0x8a, 0x81, 0x1e, 0x6e, 0xd9, 0x7f, 0xbf, 0x89, 0x85, 0xc5, 0x24, 0xcc, 0xd5, 0xc2, 0x31, 0xdb, 0xc6, 0x21, 0x80, 0xa0, 0x28, 0x20, 0x22, 0x79, 0x9e, 0xc7, 0x4b, 0x1d, 0xc2, 0xdf, 0x4e, 0xda, 0xd5, 0x84, 0xb0, 0xb9, 0x74, 0x11, 0x3a, 0x06, 0xa8, 0x57, 0xff, 0x72, 0xed, 0x17, 0x47, 0x19, 0x08, 0xd2, 0x84, 0x04, 0xa0, 0x0c, 0x4f, 0xc7, 0xa3, 0xf7, 0xde, 0xd5, 0x6f, 0x4d, 0xa7, 0x09, 0x3a, 0x87, 0x5b, 0xd7, 0xc3, 0xa6, 0xcb, 0x35, 0xcc, 0x6b, 0xdf, 0x50, 0x5c, 0xb7, 0x9a, 0xee, 0x64, 0x70, 0x86, 0x40, 0xac, 0xa0, 0x33, 0x98, 0x29, 0xe8, 0x6f, 0x4b, 0x7a, 0x2d, 0x68, 0xfe, 0x0b, 0x47, 0x07, 0xe3, 0x20, 0x16, 0x53, 0x4c, 0xdf, 0x8a, 0x48, 0x07, 0x0a, 0x39, 0x21, 0xa4, 0x8b, 0xcc, 0x0f, 0xd4, 0xb1, 0x1c, 0x80];
    let proof_3 = array![0xf9, 0x02, 0x11, 0xa0, 0xb7, 0x0b, 0xd3, 0x8b, 0x19, 0x78, 0x82, 0xc9, 0xe0, 0x4d, 0xbd, 0xbc, 0x46, 0x3b, 0xd7, 0x48, 0x87, 0xaf, 0x46, 0x6e, 0x50, 0x9b, 0xb9, 0xf6, 0x12, 0x83, 0x79, 0x60, 0x00, 0x64, 0x96, 0x11, 0xa0, 0x5b, 0x7c, 0x13, 0x20, 0x8d, 0xc2, 0xfb, 0xd7, 0x08, 0x00, 0x5d, 0x51, 0x02, 0x97, 0xa8, 0x25, 0xe6, 0xee, 0x16, 0xa5, 0x41, 0xa1, 0xf7, 0x86, 0x0b, 0x52, 0x26, 0xf3, 0x9e, 0x7d, 0x31, 0xad, 0xa0, 0x9f, 0xea, 0x01, 0xb1, 0xdb, 0x9a, 0xfd, 0xd6, 0x39, 0x32, 0xfc, 0x4a, 0x33, 0x5c, 0xa3, 0xaf, 0x68, 0x24, 0xaf, 0xcb, 0xa7, 0x93, 0xfa, 0xb6, 0x8a, 0x65, 0x36, 0xe4, 0xf3, 0x02, 0xfc, 0x19, 0xa0, 0xd7, 0x31, 0x48, 0x88, 0x6a, 0x70, 0xf1, 0x8c, 0x6a, 0x41, 0xf6, 0x5a, 0x9d, 0x01, 0x2b, 0x8a, 0x51, 0x98, 0xde, 0xac, 0xf3, 0x3b, 0x08, 0x39, 0xb4, 0x94, 0xa1, 0x33, 0x8b, 0x23, 0xcf, 0x7b, 0xa0, 0xe6, 0x92, 0x36, 0x75, 0x58, 0x32, 0x67, 0xb5, 0x02, 0xe2, 0xa6, 0xac, 0x68, 0x56, 0x51, 0xf4, 0xbf, 0xb5, 0x4b, 0x6c, 0xf0, 0x0c, 0xff, 0xdf, 0x7e, 0x60, 0x39, 0x27, 0x10, 0x7e, 0xca, 0x70, 0xa0, 0x1e, 0x2f, 0xcb, 0x24, 0x0f, 0x26, 0xa1, 0xd8, 0x5e, 0x90, 0x8b, 0xc7, 0x7a, 0x75, 0x62, 0x8b, 0x14, 0x4f, 0x31, 0xb0, 0xf6, 0xd5, 0x6d, 0xdc, 0x13, 0x9c, 0xb5, 0xa5, 0x60, 0x02, 0x42, 0x0c, 0xa0, 0x21, 0x42, 0x0c, 0x0d, 0x6a, 0xb2, 0xd5, 0x05, 0x04, 0xf7, 0xca, 0xd0, 0xe4, 0xd7, 0x61, 0x09, 0xc2, 0xc9, 0x3f, 0x2c, 0x49, 0xc9, 0x67, 0x78, 0x63, 0xf2, 0x90, 0xc8, 0xdc, 0x4e, 0x3c, 0x14, 0xa0, 0x37, 0x9f, 0xe1, 0xbd, 0x0b, 0x04, 0x4c, 0x94, 0xf6, 0x7f, 0x84, 0x4b, 0xd2, 0xc7, 0xf7, 0xab, 0xf8, 0x3a, 0xc8, 0x04, 0x9a, 0xb2, 0x34, 0xce, 0x30, 0x13, 0x26, 0xd7, 0x9f, 0xb7, 0xae, 0x0b, 0xa0, 0x89, 0x0e, 0xa9, 0xc4, 0x67, 0x92, 0x62, 0xb8, 0x6e, 0x65, 0xf2, 0x89, 0x5f, 0xf9, 0xe6, 0xe9, 0x7a, 0x0e, 0xd0, 0x6d, 0x7b, 0xeb, 0x9b, 0x4d, 0x3d, 0x8c, 0x8d, 0x32, 0x46, 0xa0, 0x67, 0x15, 0xa0, 0x45, 0x69, 0xc1, 0x6e, 0x7b, 0xa9, 0x1a, 0x90, 0x1a, 0xec, 0x96, 0xcd, 0x99, 0x9b, 0x89, 0x20, 0x1e, 0x19, 0x26, 0x70, 0xed, 0xaf, 0xf7, 0x0d, 0x29, 0x91, 0xed, 0xf7, 0x79, 0xde, 0x50, 0x82, 0xa0, 0xad, 0xae, 0xd3, 0x27, 0xe3, 0x18, 0x19, 0xa5, 0x30, 0xe9, 0x41, 0xa4, 0xee, 0xbf, 0x0e, 0xd8, 0xe2, 0x45, 0xb9, 0x27, 0x29, 0x47, 0x19, 0x95, 0x66, 0xe8, 0x9e, 0x44, 0x96, 0xa6, 0xc0, 0x5b, 0xa0, 0xc3, 0x9e, 0x54, 0xb4, 0xce, 0x44, 0x0f, 0xbc, 0x36, 0xc4, 0x3b, 0xaa, 0xfc, 0x98, 0x09, 0xa8, 0x0e, 0x8c, 0xc5, 0x64, 0x9b, 0x2f, 0x87, 0x53, 0xb5, 0xed, 0xba, 0xc3, 0xb7, 0xc0, 0x43, 0xe3, 0xa0, 0x81, 0x25, 0x41, 0xbe, 0xd0, 0x09, 0xf7, 0xca, 0xe9, 0x7b, 0xa7, 0x83, 0xdd, 0xe8, 0x8a, 0xce, 0xd6, 0xe5, 0xf2, 0x1f, 0xc8, 0x0b, 0x41, 0xe9, 0x1b, 0x94, 0x79, 0xd3, 0x51, 0x84, 0xe4, 0x5e, 0xa0, 0x70, 0x8a, 0xdd, 0xa1, 0xf1, 0xad, 0x89, 0x03, 0x4e, 0x35, 0xa2, 0xfd, 0x06, 0x34, 0x20, 0xd8, 0x85, 0x71, 0x3f, 0xb7, 0xf1, 0x76, 0x96, 0x0e, 0x47, 0xee, 0xbc, 0x0d, 0xf8, 0xe8, 0xaf, 0xc0, 0xa0, 0xa3, 0x05, 0xe0, 0x52, 0x8d, 0x3f, 0x61, 0x22, 0xa4, 0x60, 0xee, 0xff, 0xc5, 0x4c, 0xe1, 0xc4, 0xc6, 0x7f, 0x71, 0xf3, 0x76, 0xe8, 0xd8, 0x4a, 0x4e, 0xd2, 0x3d, 0xfd, 0xc2, 0xcc, 0x4e, 0xff, 0xa0, 0x29, 0x28, 0xce, 0x11, 0x2a, 0x3e, 0x07, 0x62, 0x14, 0xa2, 0xb1, 0xe2, 0x5f, 0xbf, 0xc4, 0x63, 0x41, 0x1c, 0x37, 0x8c, 0x12, 0x70, 0x25, 0x06, 0xc1, 0x47, 0x9f, 0x97, 0xba, 0x5b, 0xff, 0xce, 0x80];
    let proof_4 = array![0xf9, 0x02, 0x11, 0xa0, 0x98, 0x81, 0x80, 0x0a, 0xf8, 0x12, 0x81, 0xb5, 0x99, 0xa2, 0xae, 0x59, 0x97, 0x89, 0x50, 0x1c, 0x25, 0x61, 0x29, 0x4a, 0xeb, 0x89, 0x29, 0x05, 0xe5, 0xf4, 0x54, 0xbd, 0xcf, 0x79, 0xa1, 0x87, 0xa0, 0x47, 0xe8, 0xfd, 0x36, 0xef, 0x03, 0xad, 0x04, 0x79, 0x90, 0x21, 0x54, 0x24, 0x9d, 0x5e, 0x43, 0x07, 0x1e, 0xfb, 0xf7, 0x8b, 0x49, 0x74, 0xf2, 0xcd, 0xa4, 0x90, 0xfa, 0x42, 0xd1, 0x7b, 0xa6, 0xa0, 0x63, 0xb7, 0xd2, 0x5d, 0x08, 0x6b, 0xdf, 0xa1, 0x8c, 0x5b, 0xeb, 0x67, 0xe4, 0x33, 0x9f, 0x68, 0x3d, 0xe1, 0x53, 0x46, 0xef, 0x94, 0x8b, 0x01, 0x13, 0x9d, 0x8c, 0x0e, 0x83, 0xa9, 0x63, 0x87, 0xa0, 0xb8, 0x66, 0x2c, 0x97, 0xa2, 0x29, 0xaa, 0x73, 0xab, 0x19, 0x0a, 0xb4, 0x02, 0xa7, 0xfa, 0x2a, 0xca, 0xd9, 0xcf, 0x66, 0x25, 0x1a, 0xd0, 0xa4, 0x4c, 0x90, 0x70, 0x73, 0x2e, 0x29, 0x8b, 0x11, 0xa0, 0xfa, 0xc6, 0x58, 0x4c, 0x1f, 0xa6, 0xaa, 0x7d, 0xb2, 0xe6, 0x15, 0xe1, 0x0b, 0xa6, 0x3a, 0x9b, 0x35, 0x3f, 0x3f, 0xeb, 0xbe, 0x93, 0xd3, 0xae, 0x22, 0x76, 0x89, 0x16, 0x68, 0xaa, 0x7f, 0xc1, 0xa0, 0x77, 0x7e, 0x0f, 0x4f, 0x26, 0x95, 0xa6, 0x59, 0x39, 0xc8, 0xa1, 0x91, 0xcc, 0x32, 0xe0, 0xbc, 0x74, 0xc5, 0x57, 0xd0, 0x57, 0xa4, 0x6b, 0x51, 0x35, 0xf3, 0x6e, 0x3c, 0x23, 0x2b, 0x7f, 0xb8, 0xa0, 0xd7, 0x8e, 0xc3, 0x9c, 0x35, 0x44, 0xf7, 0x6d, 0x77, 0xc0, 0xaa, 0x20, 0xb4, 0xcd, 0xb5, 0x8c, 0x8a, 0xc2, 0x97, 0x45, 0x71, 0x3b, 0x24, 0x0b, 0x7f, 0xdd, 0x38, 0x36, 0x49, 0x7f, 0xdb, 0x04, 0xa0, 0x47, 0x29, 0x09, 0x7a, 0x95, 0xf6, 0xc0, 0x01, 0x47, 0x8b, 0x2e, 0xd0, 0x57, 0xc7, 0x1a, 0x9d, 0xe8, 0x9b, 0x0e, 0x4e, 0xe1, 0x8c, 0xbf, 0x6c, 0x04, 0xd5, 0x78, 0xba, 0xc2, 0xc7, 0xed, 0x28, 0xa0, 0x9f, 0x6f, 0x37, 0xe1, 0xff, 0xed, 0x05, 0x54, 0xf4, 0x13, 0x3b, 0x57, 0x43, 0xe4, 0xe7, 0xe8, 0x07, 0x05, 0x4c, 0xe7, 0xf9, 0x61, 0x5d, 0xf1, 0xfd, 0xcc, 0xeb, 0x02, 0x64, 0xe3, 0x18, 0x29, 0xa0, 0xcd, 0xdd, 0xe7, 0x8e, 0x2e, 0xd0, 0x7f, 0xd8, 0x2b, 0x48, 0x6c, 0xca, 0x32, 0x6e, 0xc3, 0x15, 0xf3, 0xd1, 0xdf, 0x4a, 0x63, 0x5f, 0x18, 0x98, 0x81, 0x1b, 0x1d, 0x4d, 0x45, 0xd7, 0x36, 0x1c, 0xa0, 0x18, 0xf0, 0x64, 0x84, 0xf8, 0xa2, 0x56, 0xa8, 0x10, 0xfd, 0xf6, 0x80, 0x0d, 0x30, 0xc4, 0x00, 0x94, 0xde, 0x75, 0x61, 0xa1, 0x2b, 0x3c, 0xc9, 0xa9, 0xe9, 0x09, 0x79, 0xe0, 0xce, 0x4a, 0x10, 0xa0, 0x8c, 0x01, 0xdb, 0xe6, 0x6e, 0x1e, 0x60, 0xf5, 0xed, 0xea, 0x0e, 0x1b, 0xf2, 0x99, 0x0a, 0xed, 0x61, 0x0d, 0xad, 0xb9, 0x78, 0x3f, 0x20, 0x70, 0xb2, 0x06, 0xc8, 0x8f, 0xfc, 0x05, 0xe7, 0xff, 0xa0, 0x97, 0x63, 0xea, 0x84, 0xf4, 0xae, 0x07, 0xff, 0xec, 0x15, 0x0a, 0x3d, 0x59, 0x67, 0x4a, 0x49, 0xc9, 0x44, 0xdc, 0x94, 0x40, 0x98, 0x81, 0xb0, 0x38, 0x0a, 0x3e, 0xd2, 0xe4, 0xab, 0x6b, 0x70, 0xa0, 0xd0, 0xe8, 0x6e, 0x1c, 0x6f, 0x99, 0x1a, 0x9a, 0xfb, 0x97, 0xbf, 0x16, 0x48, 0x48, 0x7f, 0xcc, 0x90, 0xf6, 0x1d, 0x4a, 0x6f, 0x7d, 0x8f, 0xa4, 0x19, 0xcb, 0x82, 0x9e, 0x11, 0xc5, 0xb7, 0x64, 0xa0, 0x42, 0xd0, 0x01, 0x84, 0x63, 0x3b, 0xd8, 0xdf, 0x55, 0xdb, 0x88, 0x1b, 0x1b, 0x46, 0x45, 0x7f, 0x1d, 0x0c, 0xff, 0x16, 0x2c, 0x88, 0x43, 0xf9, 0xae, 0xa1, 0x85, 0x09, 0x27, 0x1f, 0x94, 0x07, 0xa0, 0x81, 0xaa, 0xd7, 0x09, 0x9c, 0xaf, 0xdd, 0xcb, 0x44, 0x14, 0x17, 0x37, 0xb9, 0x86, 0xee, 0xc4, 0x5e, 0x93, 0xaa, 0x16, 0x77, 0x4c, 0x7d, 0x04, 0x80, 0xd3, 0x95, 0xfc, 0xa5, 0x82, 0xcf, 0x8d, 0x80];
    let proof_5 = array![0xf9, 0x01, 0x91, 0x80, 0xa0, 0x8e, 0xea, 0xc7, 0xbe, 0xc8, 0xce, 0xaa, 0xf6, 0x59, 0xb3, 0x28, 0xd4, 0xa0, 0x4e, 0x41, 0x81, 0x59, 0x91, 0x4c, 0x76, 0x81, 0xf8, 0x34, 0x70, 0xcd, 0x31, 0x3d, 0x6e, 0x98, 0x4a, 0x07, 0x54, 0xa0, 0x6d, 0xac, 0x15, 0xdd, 0xea, 0x9f, 0xe0, 0xba, 0x30, 0x97, 0xf9, 0x47, 0x27, 0xc1, 0xf6, 0x1c, 0xda, 0x22, 0x19, 0xe6, 0x39, 0xc4, 0x43, 0xe5, 0x2b, 0x23, 0x1c, 0xeb, 0x71, 0xb9, 0xc8, 0x6f, 0xa0, 0xa6, 0x54, 0x5f, 0x79, 0x13, 0x04, 0xf8, 0xf4, 0xdf, 0xa8, 0xba, 0xe7, 0x69, 0x9a, 0xff, 0x68, 0x27, 0x33, 0xb2, 0x46, 0xc6, 0xdf, 0x78, 0xb0, 0x3a, 0x95, 0x5b, 0x87, 0xe9, 0x74, 0xa3, 0x30, 0xa0, 0xf7, 0x5c, 0x6a, 0x10, 0x79, 0x68, 0x30, 0x94, 0x6f, 0x04, 0x64, 0x5d, 0x5d, 0x11, 0xe5, 0xb0, 0xbc, 0xbc, 0x40, 0xf0, 0xcb, 0x83, 0xcd, 0x71, 0x64, 0x40, 0xe6, 0xef, 0x1d, 0x8b, 0x3d, 0x04, 0x80, 0x80, 0xa0, 0x64, 0x6d, 0x1c, 0xbe, 0xa0, 0x60, 0xb3, 0x1a, 0x3d, 0xdf, 0xcb, 0x8e, 0x80, 0x26, 0x20, 0x23, 0x2a, 0x21, 0x64, 0xa6, 0x4a, 0xbc, 0x04, 0xdb, 0xa8, 0x86, 0x54, 0x66, 0x76, 0x68, 0x26, 0x1b, 0xa0, 0xc6, 0x1e, 0x9a, 0xff, 0x13, 0xad, 0x27, 0xa1, 0xd5, 0x05, 0x10, 0xf8, 0x8f, 0xf4, 0x87, 0x9d, 0xb3, 0xfd, 0x7c, 0xef, 0x17, 0x82, 0x98, 0x2d, 0x3c, 0xf8, 0x70, 0x27, 0x42, 0xb2, 0x94, 0x1d, 0xa0, 0xb2, 0xa8, 0x72, 0x2f, 0xf7, 0x8f, 0x03, 0x32, 0x7b, 0x58, 0x5d, 0xa0, 0x64, 0xed, 0x79, 0xea, 0x18, 0x18, 0xcf, 0xf6, 0xcc, 0x41, 0xfe, 0x32, 0x49, 0x36, 0x8c, 0xc0, 0x44, 0x93, 0xca, 0x41, 0xa0, 0x01, 0x71, 0x9e, 0xcf, 0x3a, 0x6e, 0x92, 0x4a, 0xbb, 0xdb, 0xb6, 0xf3, 0xde, 0x50, 0x79, 0x4d, 0xf3, 0xd9, 0xf9, 0xf5, 0x03, 0xbf, 0xb5, 0x4b, 0xab, 0x75, 0x3e, 0x2d, 0x9b, 0x5c, 0x72, 0x30, 0xa0, 0x80, 0x73, 0xf6, 0xa9, 0xeb, 0xd0, 0xc8, 0x4a, 0x9d, 0xd5, 0xb6, 0x17, 0x6d, 0x52, 0xbc, 0x80, 0x59, 0x6e, 0xb7, 0x4c, 0x19, 0x2a, 0x7a, 0x55, 0x1b, 0x3a, 0xe8, 0x06, 0x20, 0xfa, 0xca, 0xf7, 0xa0, 0x29, 0x0f, 0x29, 0xdd, 0xbb, 0xa5, 0xa7, 0x89, 0xb0, 0x68, 0x53, 0x5a, 0xed, 0xa9, 0x98, 0x09, 0x05, 0x3b, 0xea, 0x76, 0x42, 0xe0, 0xbd, 0x7a, 0x60, 0x4a, 0x15, 0x11, 0x2b, 0x58, 0x18, 0xcb, 0x80, 0xa0, 0x0b, 0xf0, 0xa7, 0xe8, 0xa9, 0xb0, 0x79, 0x7f, 0x99, 0xbc, 0xca, 0xa5, 0x65, 0x54, 0x62, 0xc0, 0x01, 0x72, 0xc7, 0x69, 0xc5, 0xbe, 0xd5, 0x89, 0xc1, 0x49, 0xdf, 0x04, 0xc9, 0xd7, 0x48, 0xbf, 0xa0, 0x2c, 0x83, 0xd1, 0x67, 0xa8, 0xb3, 0x56, 0x07, 0x90, 0x6f, 0x46, 0x39, 0xc2, 0x44, 0x2b, 0xac, 0xde, 0x5c, 0x67, 0xda, 0xb8, 0x0b, 0xb2, 0xfc, 0x74, 0x56, 0x4a, 0x32, 0xd3, 0xa3, 0x19, 0x43, 0x80];
    let proof_6 = array![0xf8, 0x67, 0x9e, 0x20, 0xeb, 0x3d, 0x39, 0x05, 0xf6, 0x52, 0x6c, 0xb7, 0xfb, 0xb8, 0xca, 0x13, 0xdf, 0x8d, 0x9c, 0x63, 0xef, 0xad, 0xe3, 0x48, 0xe7, 0x00, 0x65, 0xaa, 0x05, 0xf5, 0x78, 0xf3, 0x15, 0xb8, 0x46, 0xf8, 0x44, 0x01, 0x80, 0xa0, 0x69, 0x68, 0xaa, 0x4d, 0x96, 0xa8, 0x17, 0xeb, 0x4d, 0x24, 0xaa, 0x4d, 0x09, 0x6d, 0x0d, 0x84, 0x1f, 0x9c, 0x52, 0xed, 0x7b, 0xbc, 0x4c, 0xa7, 0xd7, 0x95, 0x1b, 0xba, 0x6f, 0xc6, 0x55, 0x71, 0xa0, 0x89, 0xb1, 0xde, 0x4a, 0x1e, 0x01, 0x2d, 0x6a, 0x62, 0xb1, 0x8b, 0x6a, 0xd1, 0x84, 0x98, 0x5d, 0x57, 0x54, 0x5b, 0xf1, 0xda, 0x0a, 0xe1, 0xc2, 0x18, 0xf4, 0xce, 0xa3, 0x4d, 0xaf, 0x09, 0x9b];
    
    let proof = array![proof_0.span(), proof_1.span(), proof_2.span(), proof_3.span(), proof_4.span(), proof_5.span(), proof_6.span()];

    // 6464aaeb3d3905f6526cb7fbb8ca13df8d9c63efade348e70065aa05f578f315
    let key = array![0x6, 0x4, 0x6, 0x4, 0xa, 0xa, 0xe, 0xb, 0x3, 0xd, 0x3, 0x9, 0x0, 0x5, 0xf, 0x6, 0x5, 0x2, 0x6, 0xc, 0xb, 0x7, 0xf, 0xb, 0xb, 0x8, 0xc, 0xa, 0x1, 0x3, 0xd, 0xf, 0x8, 0xd, 0x9, 0xc, 0x6, 0x3, 0xe, 0xf, 0xa, 0xd, 0xe, 0x3, 0x4, 0x8, 0xe, 0x7, 0x0, 0x0, 0x6, 0x5, 0xa, 0xa, 0x0, 0x5, 0xf, 0x5, 0x7, 0x8, 0xf, 0x3, 0x1, 0x5];

    let expected_res = array![0xf8, 0x44, 0x01, 0x80, 0xa0, 0x69, 0x68, 0xaa, 0x4d, 0x96, 0xa8, 0x17, 0xeb, 0x4d, 0x24, 0xaa, 0x4d, 0x09, 0x6d, 0x0d, 0x84, 0x1f, 0x9c, 0x52, 0xed, 0x7b, 0xbc, 0x4c, 0xa7, 0xd7, 0x95, 0x1b, 0xba, 0x6f, 0xc6, 0x55, 0x71, 0xa0, 0x89, 0xb1, 0xde, 0x4a, 0x1e, 0x01, 0x2d, 0x6a, 0x62, 0xb1, 0x8b, 0x6a, 0xd1, 0x84, 0x98, 0x5d, 0x57, 0x54, 0x5b, 0xf1, 0xda, 0x0a, 0xe1, 0xc2, 0x18, 0xf4, 0xce, 0xa3, 0x4d, 0xaf, 0x09, 0x9b];

    let mpt = MPTTrait::new(0xc2b5189e67f029875a3a375dce537add0f4d6b30adeb4bf146344f5cb08bbf2b);
    let res = mpt.verify(key.span(), proof.span()).unwrap();
    assert(res == expected_res.span(), 'Result not matching');
}
