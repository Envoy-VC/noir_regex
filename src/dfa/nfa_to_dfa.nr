use crate::dfa::{DFAStruct, DFAStateStruct};
use crate::nfa::NFAStruct;

use crate::data_structures::stack::Stack;

pub struct NfaToDfaConverterStruct {
    dfa: DFAStruct,
    nfa: NFAStruct
}

pub trait NfaToDfaConverter {
    fn new(nfa: NFAStruct) -> Self;
    unconstrained fn convert(&mut self) -> DFAStruct;
    fn epsilon_closure(&mut self, states: &mut Vec<u32>) -> Vec<u32>;
    fn move(&mut self, states: &mut Vec<u32>, symbol: Option<i32>) -> Vec<u32>;
    fn is_accepting(&mut self, states: &mut Vec<u32>) -> bool;
}

impl NfaToDfaConverter for NfaToDfaConverterStruct {
    fn new(nfa: NFAStruct) -> Self {
        NfaToDfaConverterStruct { dfa: DFAStruct::new(), nfa }
    }

    unconstrained fn convert(&mut self) -> DFAStruct {
        let mut start_closure_states: Vec<u32> = Vec::new();
        start_closure_states.push(self.nfa.start);
        let mut start_closure = self.epsilon_closure(&mut start_closure_states);
        start_closure.sort();
        let is_accepting = self.is_accepting(&mut start_closure);

        let start_dfa_state = DFAStateStruct::from(0, Vec::new(), is_accepting);
        let _ = self.dfa.add_state(start_dfa_state);
        self.dfa.start_state = 0;

        let mut state_sets: Vec<Vec<u32>> = Vec::new();
        state_sets.push(start_closure);

        let queue_index: u32 = 0;

        for _ in 0..state_sets.len() {
            let mut current_set = state_sets.get(queue_index);
            let current_dfa_state_index = queue_index;

            for symbol in 0..256 {
                let mut move_set = self.move(&mut current_set, Option::some(symbol));

                if (move_set.len() == 0) {
                    continue;
                }

                let mut closure = self.epsilon_closure(&mut move_set);
                if (closure.len() == 0) {
                    continue;
                }
                closure.sort();
                let mut existingDFAStateIndex: i32 = -1;

                for i in 0..state_sets.len() {
                    if (state_sets.get(i).len() != closure.len()) {
                        continue;
                    }
                    let mut match = true;
                    for j in 0..closure.len() {
                        if (state_sets.get(i).get(j) != closure.get(j)) {
                            match = false;
                            break;
                        }
                    }
                    if (match) {
                        existingDFAStateIndex = i as i32;
                        break;
                    }
                }

                if (existingDFAStateIndex == -1) {
                    existingDFAStateIndex = state_sets.len() as i32;
                    state_sets.push(closure);
                    let is_accepting = self.is_accepting(&mut closure);
                    let new_dfa_state = DFAStateStruct::from(existingDFAStateIndex as u32, Vec::new(), is_accepting);
                    let _res = self.dfa.add_state(new_dfa_state);
                }

                let mut state = self.dfa.states.get(current_dfa_state_index);
                let mut transition = state.transitions.get(symbol as u32);
                let mut newOption = Option::some(existingDFAStateIndex as u32);

                transition = newOption;
            }
        }
        self.dfa
    }

    fn epsilon_closure(&mut self, states: &mut Vec<u32>) -> Vec<u32> {
        let mut closure: Vec<u32> = Vec::new();
        let mut stack = Stack::new();

        for i in 0..states.len() {
            let state = states.get(i);
            if (!closure.includes(state)) {
                closure.push(state);
                stack.push(state);
            }
        }

        for i in 0..stack.data.len() {
            let state = stack.data.get(i);
            let nfa_state = self.nfa.states.get(state);
            for j in 0..nfa_state.transitions.len() {
                let transition = nfa_state.transitions.get(j);
                if (transition.symbol == Option::none()) {
                    let target = transition.to;
                    if (!closure.includes(target)) {
                        closure.push(target);
                        stack.push(target);
                    }
                }
            }
        }
        closure
    }

    fn move(&mut self, states: &mut Vec<u32>, symbol: Option<i32>) -> Vec<u32> {
        let mut move_set: Vec<u32> = Vec::new();

        for i in 0..states.len() {
            let state = states.get(i);
            let nfa_state = self.nfa.states.get(state);
            for j in 0..nfa_state.transitions.len() {
                let transition = nfa_state.transitions.get(j);
                let is_same = transition.symbol == symbol;
                let is_dot = transition.symbol == Option::some(256 as i32);
                if (is_dot | is_same) {
                    move_set.push(transition.to);
                }
            }
        }

        move_set
    }
    fn is_accepting(&mut self, states: &mut Vec<u32>) -> bool {
        for i in 0..states.len() {
            let state = states.get(i);
            let nfa_state = self.nfa.states.get(state);
            if {
                {
                    nfa_state.is_accepting
                }
            } {
                true
            }
        }
        false
    }
}
