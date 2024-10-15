mod builder;

pub struct Transition {
     symbol: Option<i32>, // none represents epsilon
     to: u32,            // Target state index
}

pub struct NFAStateStruct {
     transitions: Vec<Transition>,
     is_accepting: bool
}

pub trait NFAState {
     fn new() -> Self;
}

impl NFAState for NFAStateStruct {
    fn new() -> Self {
        NFAStateStruct { transitions: Vec::new(), is_accepting: false }
    }
}

pub struct NFAStruct {
     states: Vec<NFAStateStruct>,
     start: u32,
     accept: u32,
     state_count: u32
}

pub trait NFA {
     fn new() -> Self;
     fn add_state(&mut self) -> u32;
     fn add_transition(&mut self, from: u32, to: u32, symbol: Option<i32>);
}

impl NFA for NFAStruct {
    fn new() -> Self {
        let mut nfa = NFAStruct { states: Vec::new(), start: 0, accept: 0, state_count: 0 };
        nfa.start = nfa.add_state();
        nfa.accept = nfa.add_state();
        nfa.state_count = nfa.accept + 1;
        nfa
    }

    fn add_state(&mut self) -> u32 {
        let state = NFAStateStruct::new();
        self.states.push(state);
        self.state_count += 1;
        self.state_count - 1
    }

    fn add_transition(&mut self, from: u32, to: u32, symbol: Option<i32>) {
        let transition = Transition { symbol, to };
        self.states.get(from).transitions.push(transition);
    }
}
