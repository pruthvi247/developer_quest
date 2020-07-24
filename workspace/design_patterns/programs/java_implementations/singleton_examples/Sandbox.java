public class Sandbox {

    public static void main(String[] args) {
        
        //Class singleton
        
        ClassSingleton classSingleton1 = ClassSingleton.getInstance();
        //OurSingleton object1 = new OurSingleton(); // The constructor OurSingleton() is not visible
        
        System.out.println(classSingleton1.getInfo()); //Initial class info
        
        ClassSingleton classSingleton2 = ClassSingleton.getInstance();
        classSingleton2.setInfo("New class info");
        
        System.out.println(classSingleton1.getInfo()); //New class info
        System.out.println(classSingleton2.getInfo()); //New class info
        
        //Enum singleton
        
        EnumSingleton enumSingleton1 = EnumSingleton.INSTANCE.getInstance();
        
        System.out.println(enumSingleton1.getInfo()); //Initial enum info
        
        EnumSingleton enumSingleton2 = EnumSingleton.INSTANCE.getInstance();
        enumSingleton2.setInfo("New enum info");
        
        System.out.println(enumSingleton1.getInfo()); //New enum info
        System.out.println(enumSingleton2.getInfo()); //New enum info
	DclSingleton dcl = DclSingleton.getInstance();
	
        System.out.println(dcl.getInfo()); //New enum info
	
    }
}
// To run program
// step1 : javac Sanbox.java
// step2 : java Sandbox
