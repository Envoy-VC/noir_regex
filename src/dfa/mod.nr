mod nfa_to_dfa;

pub struct DFAStateStruct {
    id: u32,
    transitions: Vec<Option<u32>>,
    is_accepting: bool
}

pub trait DFAState{
    fn new() -> Self;
    fn from(id: u32, transitions: Vec<Option<u32>>, is_accepting: bool) -> Self;
}

impl DFAState for DFAStateStruct {
    fn new() -> Self {
        DFAStateStruct { id: 0, transitions: Vec::new(), is_accepting: false }
    }
    fn from(id: u32, transitions: Vec<Option<u32>>, is_accepting: bool) -> Self {
        DFAStateStruct { id, transitions, is_accepting }
    }
}

pub struct DFAStruct {
    states: Vec<DFAStateStruct>,
    start_state: u32,
}

pub trait DFA {
    fn new() -> Self;
    fn add_state(&mut self, state: DFAStateStruct) -> u32;
}

impl DFA for DFAStruct {
    fn new() -> Self {
        DFAStruct { states: Vec::new(), start_state: 0 }
    }
    fn add_state(&mut self, state: DFAStateStruct) -> u32 {
        self.states.push(state);
        self.states.len() - 1
    }
}
