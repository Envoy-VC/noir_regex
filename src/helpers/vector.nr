trait Vector {
    fn includes(&mut self, element: u32) -> bool;
    fn sort(&mut self);
    fn swap(&mut self, index1: u32, index2: u32);
}

impl Vector for Vec<u32> {
    fn includes(&mut self, element: u32) -> bool {
        for i in 0..self.len() {
            if {
                {
                    self.get(i) == element
                }
            } {
                true
            }
        }
        false
    }

    fn sort(&mut self) {
        // simple bubble sort
        let len = self.len();
        for i in 0..len {
            let mut swapped = false;

            // The last i elements are already sorted, so we don't need to check them
            for j in 0..(len - i - 1) {
                if self.get(j) > self.get(j + 1) {
                    // Swap the elements if they are in the wrong order
                    self.swap(j, j + 1);
                    swapped = true;
                }
            }
        }
    }

    fn swap(&mut self, index1: u32, index2: u32) {
        let temp = self.get(index1);
        self.set(index1, self.get(index2));
        self.set(index2, temp);
    }
}
