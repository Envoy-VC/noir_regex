pub struct Queue<T> {
    data: Vec<T>,
    front: u32,
    rear: u32,
    size: u32,

}

trait QueueTrait<T>  {
    fn new() -> Queue<T>;
    fn enqueue(&mut self, item: T) -> bool;
    fn dequeue(&mut self) -> Option<T>;
    fn is_empty(&mut self) -> bool;
}

impl QueueTrait<u8> for Queue<u8> {
    fn new() -> Queue<u8> {
        Queue { data: Vec::new(), front: 0, rear: 0, size: 0 }
    }

    fn enqueue(&mut self, item: u8) -> bool {
        self.data.push(item);
        self.rear = self.rear + 1;
        self.size += 1;
        true
    }

    fn dequeue(&mut self) -> Option<u8> {
        if self.is_empty() {
            let none = Option::none();
            none
        }
        let item = self.data.get(self.front);
        self.front += 1;
        self.size -= 1;

        Option::some(item)
    }

    fn is_empty(&mut self) -> bool {
        self.size == 0
    }
}
