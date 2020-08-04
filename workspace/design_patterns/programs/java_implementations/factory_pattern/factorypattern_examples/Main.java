public class Main {
    public static void main(String[] args) {
        AnimalFactory animalFactory = new AnimalFactory();
      
        Animal animal = animalFactory.getAnimal("dOg");
        animal.eat();
      
        Animal animal2 = animalFactory.getAnimal("CAT");
        animal2.eat();
      
        Animal animal3 = animalFactory.getAnimal("raBbIt");
        animal3.eat();
    }
}

/* factory method is more like if else, we could have directly called if else bolock in main program to create objects we are not doing it because,it violates SOLID principles like open to extension close to modification as we have to keep adding new 'if conditoins'and single responsibility principle as we have to add new 'if' condiotions for any new animal*/

/*Above given example is jus a simple factory pattern, there is also factory method pattern where we can control how the object is created and post/pre object creation logic */
