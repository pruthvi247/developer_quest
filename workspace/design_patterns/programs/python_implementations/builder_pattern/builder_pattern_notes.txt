> A builder is useful when you need to do lots of things to build an object. For example imagine a DOM. You have to create plenty of nodes and attributes to get your final object. A factory is used when the factory can easily create the entire object within one method call.

> The builder pattern is a good choice when designing classes whose constructors or static factories would have more than a handful of parameters.

> Consider a restaurant. The creation of "today's meal" is a factory pattern, because you tell the kitchen "get me today's meal" and the kitchen (factory) decides what object to generate, based on hidden criteria.

The builder appears if you order a custom pizza. In this case, the waiter tells the chef (builder) "I need a pizza; add cheese, onions and bacon to it!" Thus, the builder exposes the attributes the generated object should have, but hides how to set them.

> *** But Python supports named parameters, so this is not necessary. You can just define a class's constructor:

class SomeClass(object):
    def __init__(self, foo="default foo", bar="default bar", baz="default baz"):
        # do something

call it using named parameters:

s = SomeClass(bar=1, foo=0)


> If you want any further functionality while assinging parameter of a class, like convert input form lower to upper these kind of logic can be using in builder pattern

[source : https://github.com/Sean-Bradley/Design-Patterns-In-Python/blob/master/builder/builder.py]

from abc import ABCMeta, abstractstaticmethod


class IHouseBuilder(metaclass=ABCMeta):
    """The Builder Interface"""

    @abstractstaticmethod
    def set_wall_material(value):
        """Set the wall_material"""

    @abstractstaticmethod
    def set_building_type(value):
        """Set the building_type"""

    @abstractstaticmethod
    def set_number_doors(value):
        """Set the number of doors"""

    @abstractstaticmethod
    def set_number_windows(value):
        """Set the number of windows"""

    @abstractstaticmethod
    def get_result():
        """Return the house"""


class HouseBuilder(IHouseBuilder):
    """The Concrete Builder."""

    def __init__(self):
        self.house = House()

    def set_wall_material(self, value):
        self.house.wall_material = value
        return self

    def set_building_type(self, value):
        self.house.building_type = value ## here we can add custome logic like converting input text from lower to upper case
        return self

    def set_number_doors(self, value):
        self.house.doors = value
        return self

    def set_number_windows(self, value):
        self.house.windows = value
        return self

    def build(self):
        return self.house


class House():
    """The Product"""

    def __init__(self, building_type="Apartment", doors=0, windows=0, wall_material="Brick"):
        #brick, wood, straw, ice
        self.wall_material = wall_material
        # Apartment, Bungalow, Caravan, Hut, Castle, Duplex, HouseBoat, Igloo
        self.building_type = building_type
        self.doors = doors
        self.windows = windows

    def __str__(self):
        return "This is a {0} {1} with {2} door(s) and {3} window(s).".format(
            self.wall_material, self.building_type, self.doors, self.windows
        )


class IglooDirector:
    """The Director, building a different representation."""
    @staticmethod
    def construct():
        return HouseBuilder()\
            .set_building_type("Igloo")\
            .set_wall_material("Ice")\
            .set_number_doors(1)\
            .set_number_windows(0)\
            .build()


class HouseBoatDirector:
    """The Director, building a different representation."""
    @staticmethod
    def construct():
        return HouseBuilder()\
            .set_building_type("House Boat")\
            .set_wall_material("Wooden")\
            .set_number_doors(6)\
            .set_number_windows(8)\
            .build()
