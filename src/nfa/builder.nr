use crate::ast::{AST_TYPES, AstNode};
use crate::nfa::{NFAStruct, NFA};

pub struct NFABuilderStruct {
    ast_nodes: Vec<AstNode>,
    current_index: u32
}

pub trait NFABuilder {
    fn new(nodes: Vec<AstNode>) -> Self;
    fn build(&mut self, startNode: u32) -> NFAStruct;
    fn build_nfa(&mut self, nfa: &mut NFAStruct, node_index: u32) -> [u32;2];
    fn build_literal(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32;2];
    fn build_concatenation(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32;2];
    fn build_alternation(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
    fn build_kleen_star(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
    fn build_plus(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
    fn build_question(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
    fn build_character_class(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
    fn build_any(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2];
}

impl NFABuilder for NFABuilderStruct {
    fn new(nodes: Vec<AstNode>) -> Self {
        NFABuilderStruct { ast_nodes: nodes, current_index: 0 }
    }
    fn build(&mut self, startNode: u32) -> NFAStruct {
        let mut nfa = NFA::new();
        let result = self.build_nfa(&mut nfa, startNode);
        nfa.add_transition(result[1], nfa.accept, Option::none());
        let mut state = nfa.states.get(nfa.accept);
        state.is_accepting = true;
        nfa.states.set(nfa.accept, state);
        nfa
    }
    fn build_nfa(&mut self, nfa: &mut NFAStruct, node_index: u32) -> [u32; 2] {
        let mut node = self.ast_nodes.get(node_index);
        let node_type = node.node_type;
        if (node_type == AST_TYPES.Literal) {
            let res = self.build_literal(&mut node, nfa);
            res
        }

        if (node_type == AST_TYPES.Concatenation) {
            let res = self.build_concatenation(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.Alternation) {
            let res = self.build_alternation(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.KleeneStar) {
            let res = self.build_kleen_star(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.Plus) {
            let res = self.build_plus(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.Question) {
            let res = self.build_question(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.CharacterClass) {
            let res = self.build_character_class(&mut node, nfa);
            res
        }
        if (node_type == AST_TYPES.Any) {
            let res = self.build_any(&mut node, nfa);
            res
        }
        [0, 0] // Placeholder return
    }
    fn build_literal(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let mut start = nfa.add_state();
        let mut accept = nfa.add_state();
        nfa.add_transition(start, accept, Option::some(node.value as i32));
        [start, accept]
    }

    fn build_concatenation(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let left = self.build_nfa(nfa, node.left);
        let right = self.build_nfa(nfa, node.right);

        nfa.add_transition(left[1], right[0], Option::none());

        [left[1], right[0]]
    }

    fn build_alternation(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let start = nfa.add_state();
        let accept = nfa.add_state();

        let left = self.build_nfa(nfa, node.left);
        let right = self.build_nfa(nfa, node.right);

        nfa.add_transition(start, left[0], Option::none());
        nfa.add_transition(start, right[0], Option::none());
        nfa.add_transition(left[1], accept, Option::none());
        nfa.add_transition(left[1], accept, Option::none());
        [start, accept]
    }

    fn build_kleen_star(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let start = nfa.add_state();
        let accept = nfa.add_state();

        let expr = self.build_nfa(nfa, node.expr);

        nfa.add_transition(start, expr[0], Option::none());
        nfa.add_transition(start, accept, Option::none());
        nfa.add_transition(expr[1], expr[0], Option::none());
        nfa.add_transition(expr[1], accept, Option::none());
        [start, accept]
    }
    fn build_plus(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let accept = nfa.add_state();

        let expr = self.build_nfa(nfa, node.expr);

        nfa.add_transition(expr[1], expr[0], Option::none());
        nfa.add_transition(expr[1], accept, Option::none());
        [expr[0], accept]
    }
    fn build_question(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let start = nfa.add_state();
        let accept = nfa.add_state();

        let expr = self.build_nfa(nfa, node.expr);

        nfa.add_transition(start, expr[0], Option::none());
        nfa.add_transition(start, accept, Option::none());
        nfa.add_transition(expr[1], accept, Option::none());
        [expr[0], accept]
    }
    fn build_character_class(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let start = nfa.add_state();
        let accept = nfa.add_state();

        for i in 0..node.chars.len() {
            let ch = node.chars.get(i);
            nfa.add_transition(start, accept, Option::some(ch as i32));
        }

        if node.negate {
            nfa.add_transition(start, accept, Option::some(-1));
        }

        [start, accept]
    }
    fn build_any(&mut self, node: &mut AstNode, nfa: &mut NFAStruct) -> [u32; 2] {
        let start = nfa.add_state();
        let accept = nfa.add_state();

        nfa.add_transition(start, accept, Option::some(256)); // 256 represents .

        [start, accept]
    }
}
