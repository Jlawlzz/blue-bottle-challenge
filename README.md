# Blue Bottle Coding Exercise

## My Implementation

1. Data Store:
  - The data store is in charge of processes involved with the retrieval and creation of data, these are lightweight on logic and not involved with manipulating pre existing data.
  - As a user, the data store is accessed through the subscription service.
    - An alternative approach would have been to treat the data store and subscription service as separate entities to be accessed and manipulated from a model or controller (which would be simulated through setup during testing). Although I think this would have been an acceptable approach, without context I made the decision to treat this app as its own environment, accessing the data store through the subscription service allows for a more wholesome user experience.

2. Subscription Service:
  - The subscription service is in charge of logic heavy tasks like manipulating data from an object fetched by the data store, and dictating data store behaviour based off of user input.  

3. Subscription Model:
  - The subscription model follows the pattern set by the customer and coffee models. Its methods allow for outside processes to inquire about its state, as well as set the status of the subscription ('active', 'paused', 'cancelled').

### Things I like about this implementation:
  - Its functionality is easily navigated through the Subscription Service, as a user there is no need to bounce around files from the terminal to achieve what is detailed in the tests.
  - Assuming the user only has access to the methods within subscription_service.rb, data is *relatively* protected from unwanted tampering.

### Things I do not like about this implementation:
  - If this app is intended to be part of a bigger system, it is less flexible than if the subscription service and data store were to be treated separately, with their interaction being delegated by a higher up process.
