class ArrayList:
    def __init__(self, size=10):
        self.max_size = size # maximum memory capacity
        self.list = [None] * self.max_size # allocate array
        self.size = 0 # current actual size (number of elements)

    def add(self, value):
        if self.size >= self.max_size: # check if enough memory capacity
            self._increase_size()
        self.list[self.size] = value
        self.size += 1

    def _increase_size(self):
        new_max_size = self.max_size * 2 # double memory size
        new_list = [None] * new_max_size
        for i in range(0, self.max_size): # copy old list to new list
            new_list[i] = self.list[i]
        self.max_size = new_max_size
        self.list = new_list

    def get(self, index):
        if index >= self.size or index < 0:
            raise Exception('Invalid index')

        return self.list[index]

    def delete(self, index):
        if index >= self.size or index < 0:
            raise Exception('Invalid index')

        # shift list from deleted index onwards
        # element before index are not affected by deletion
        for i in range(index, self.size):
            print(i)
            print(index)
            print(self.list) 
            self.list[i] = self.list[i+1]
            print(self.list)

        self.size -= 1
