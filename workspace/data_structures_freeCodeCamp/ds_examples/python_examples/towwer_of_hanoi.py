
###### Using recurssion
def TowerOfHanoi(n, source, destination, auxiliary):
    if n == 1:
        print("Move disk 1 from source", source, "to destination", destination)
        return
    TowerOfHanoi(n - 1, source, auxiliary, destination)
    print(">>>>>>.")

    print("Move disk", n, "from source", source, "to destination", destination)
    TowerOfHanoi(n - 1, auxiliary, destination, source)


# Driver code
if __name__=="__main__":
    n = 4
    TowerOfHanoi(n, 'A', 'B', 'C')


######### Using stack:

class TowerOfHanoi:
    def __init__(self, numDisks):
        self.numDisks = numDisks
        self.towers = [Stack(), Stack(), Stack()] ### we need to implement stack data structure
        for i in range(n, -1, -1):
            towers[0].push(i);


def moveDisk(src, dest):
    towers[dest].push(towers[src].pop())


def moveTower(n, src, spare, dest):
    if n == 0:
        moveDisk(src, dest)
    else:
        moveTower(n - 1, src, dest, spare)
        moveDisk(src, dest)
        moveTower(n - 1, spare, src, dest)