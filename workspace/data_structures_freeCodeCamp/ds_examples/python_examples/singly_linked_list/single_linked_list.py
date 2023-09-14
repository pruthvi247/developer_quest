
## [source: https://stackabuse.com/linked-lists-in-detail-with-python-examples-single-linked-lists/]

from Node import Node

class LinkedList:
    def __init__(self):
        self.head = None
    def insert_at_start(self, data):
        new_node = Node(data)
        new_node.ref = self.head
        print(f"new_node.item: {new_node.item}")
        self.head= new_node
        print(f"self.head.item: {self.head.item}")
        print(f"self.head.ref: {self.head.ref}")
        if self.head.ref is not None:
               print(f"self.head.ref.item: {self.head.ref.item}")
    def insert_at_end(self, data):
        new_node = Node(data)
        if self.head is None:
            self.head= new_node
            return
        n = self.head
        while n.ref is not None:
            n= n.ref
        n.ref = new_node;

#In the above script, we create a function insert_at_end(), which inserts the element at the end of the linked list. The value of the item that we want to insert is passed as an argument to the function. The function consists of two parts. First we check if the linked list is empty or not, if the linked list is empty, all we have to do is set the value of the start_node variable to new_node object.
##
#On the other hand, if the list already contains some nodes. We initialize a variable n with the start node. We then iterate through all the nodes in the list using a while loop 

    def traverse_list(self):
        if self.head is None:
           print("List has no element")
           return
        else:
            n = self.head
            while n is not None:
                print(n.item , " ")
                n = n.ref
    def bub_sort_datachange(self):
        end = None
        while end != self.head:
            print(f"self.head.item : {self.head.item}")
            p = self.head
            while p.ref != end:
                q = p.ref
                if p.item > q.item:
                    p.item, q.item = q.item, p.item
                p = p.ref
                if p.ref is not None:
                       print(f"p.ref : {p.ref.item}")
                if p.ref is  None:
                       print(f"p.ref is None : {p.item}")
            print(">>>>")
            end = p


if __name__=="__main__":
    ll = LinkedList()
    print(ll)
    ll.insert_at_end(8)
    ll.insert_at_end(7)
    ll.insert_at_end(1)
    ll.insert_at_end(6)
    ll.insert_at_end(9)
    ll.traverse_list()
    ll.bub_sort_datachange()
    ll.traverse_list()


### must refer the link https://stackabuse.com/linked-lists-in-detail-with-python-examples-single-linked-lists/ , good example and also dont forget to read reverse linked list logic at the end

#### sorting linked list source code and explanation [source : https://stackabuse.com/sorting-and-merging-single-linked-list/]
