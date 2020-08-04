public class AnimalFactory {
    
    public Animal getAnimal(String animal) {
        if(animal.equals(null)) return null;
        
        if(animal.equalsIgnoreCase("Dog")) {
            return new Dog();
        } else if(animal.equalsIgnoreCase("Cat")) {
            return new Cat();
        } else if(animal.equalsIgnoreCase("Rabbit")) {
            return new Rabbit();
        }
        return null;        
    }  
}
