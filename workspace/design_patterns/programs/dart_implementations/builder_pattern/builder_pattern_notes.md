> this pattern should be used when you want to create different representations of some product. That is, the pattern could be applied when the construction steps are similar, but they differ in the details. The builder interface defines those steps (some of them may even have the default implementation) while concrete builders implement these steps to construct a particular representation of the product.

> In simple words, it is just a simple extraction of the object’s creation logic from its own class. Therefore, the construction algorithm could evolve separately from the actual product it provides, the modification of this process does require changing the object’s code.


> in Dart builder design pattern can be acheived by cascading operation


[source : https://dev.to/inakiarroyo/the-builder-pattern-in-dart-efg,https://dev.to/jvarness/the-builder-pattern-in-java-and-dart-cascades-5l7,https://medium.com/flutter-community/flutter-design-patterns-18-builder-cdc90b222724]

FYI,The Builder pattern allows you to build objects rather than construct them.  When used as **verbs**, **build** means to form (something) by combining materials or parts, whereas **construct** means to build or form (something) by assembling parts.