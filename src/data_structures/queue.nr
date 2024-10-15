// // src/utils/FixedQueue.ts

// import { QUEUE_SIZE } from '../constants';

// export class FixedQueue<T> {
//   private data: T[];
//   private front: number;
//   private rear: number;
//   private size: number;

//   constructor() {
//     this.data = new Array<T>(QUEUE_SIZE) as T[];
//     this.front = 0;
//     this.rear = 0;
//     this.size = 0;
//   }

//   enqueue(item: T): boolean {
//     if (this.size >= QUEUE_SIZE) {
//       return false; // Queue full
//     }
//     this.data[this.rear] = item;
//     this.rear = (this.rear + 1) % QUEUE_SIZE;
//     this.size++;
//     return true;
//   }

//   dequeue(): T | null {
//     if (this.size === 0) {
//       return null; // Queue empty
//     }
//     const item = this.data[this.front];
//     this.front = (this.front + 1) % QUEUE_SIZE;
//     this.size--;
//     return item;
//   }

//   isEmpty(): boolean {
//     return this.size === 0;
//   }

//   clear(): void {
//     this.front = 0;
//     this.rear = 0;
//     this.size = 0;
//   }
// }

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
