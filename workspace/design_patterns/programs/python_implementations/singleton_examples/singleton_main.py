from singletonGov import SingletonGovt
government = SingletonGovt()
print(government)

same_government = SingletonGovt.get_instance()
print(same_government)

another_government = SingletonGovt.get_instance()
print(another_government)
## Below line will give an error because we can not create instance twice
new_government = SingletonGovt()
print(new_government)
