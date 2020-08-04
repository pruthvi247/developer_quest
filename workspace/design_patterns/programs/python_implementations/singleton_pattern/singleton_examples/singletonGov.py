class SingletonGovt:
   __instance__ = None

   def __init__(self):
       """ Constructor.
       """
       if SingletonGovt.__instance__ is None:
           SingletonGovt.__instance__ = self
       else:
           raise Exception("You cannot create another SingletonGovt class")

   @staticmethod
   def get_instance():
       """ Static method to fetch the current instance.
       """
       if not SingletonGovt.__instance__:
           SingletonGovt()
       return SingletonGovt.__instance__
