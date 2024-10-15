struct AstTypes {
    Literal: u8,
    Concatenation: u8,
    Alternation: u8,
    KleeneStar: u8,
    Plus: u8,
    Question: u8,
    CharacterClass: u8,
    Any: u8,
}

pub global AST_TYPES: AstTypes = AstTypes {
    Literal: 0,
    Concatenation: 1,
    Alternation: 2,
    KleeneStar: 3,
    Plus: 4,
    Question: 5,
    CharacterClass: 6,
    Any: 7,
};

pub struct AstNode {
    node_type: u8,
    value: u32,
    left: u32,
    right: u32,
    expr: u32,
    chars: Vec<u32>,
    negate: bool,
}
