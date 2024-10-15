pub struct Stack<T> {
    data: Vec<T>,
    topIndex: i32

}

trait StackTrait<T>  {
    fn new() -> Stack<T>;
    fn push(&mut self, _: T);
    fn pop(&mut self) -> Option<T>;
    fn is_empty(&mut self)  -> bool;
    fn clear(&mut self) ;
}

impl StackTrait<u8> for Stack<u8> {
    fn new() -> Stack<u8> {
        Stack { data: Vec::new(), topIndex: -1 }
    }
    fn push(&mut self, value: u8) {
        self.data.push(value);
    }
    fn pop(&mut self) -> Option<u8> {
        if (self.topIndex == -1) {
            let none = Option::none();
            none
        }
        let item: u8 = self.data.get(self.topIndex as u32);

        Option::some(item)
    }
    fn is_empty(&mut self) -> bool {
        self.topIndex == -1
    }
    fn clear(&mut self) {
        self.topIndex = -1;
    }
}
