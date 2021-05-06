# Test Report
### Component Testing ###
* Shop
  * The first step to test the shop was to ensure that the user could access the shop screen by pressing the correct button.  
  * The next test was to make sure boxes with text and an image could be displayed properly as these would become the items that could be purchased.
  * After file manipulation was implemented, we tested that the shop would read data from a csv file and display that data properly.
  * Each item was then tested to ensure when the item was clicked, the proper amount of currency was removed and that item displayed as purchased.
  * Once a button class was developed the boxes for each item were replaced with a button object that was then tested to ensure the proper functionality was retained.  


* File Manipulation
  * Before file manipulation was tested, we made sure that our program could create and maintain files after closing the program.
  * After file creation, we learned how to write to them accurately and consistently.


* Minigame
  * The mini game was a specific part that was eventually added, but before it was moved over was tested separately. Three objects needed to be tested to make sure they were not only working correctly but synchronized with each other: coin value increasing, click input being registered, and the navigation to work. The way the testing was done was at first we tested for click input without restrictions, that is without needing to be on an actual fish for any type of click to be registered. After successfully passing the input test we moved on to test if and when a user decides to click, the coin value will increase and store this new increased value so when you exit the mini game the user keeps currency earned. After this test was completed, the mini-game was added to the rest of the system and a final test was done and that was on the actual navigation to and from the mini-game to the previous screen. We tested different reward amounts for the minigame to provide a balanced experience for the user.


* Fish Behavior
  * To debug and test border avoidance, we scaled the avoiding constant and spawned a bunch of fish to judge where the bounds were
  * constants were made for all


* User Interface
  * To test volume slider, it was tested for accurate motion and volume control, even when the window was resized.
  * For all buttons and other interactable game objects, either audio or visual feedback is provided to ensure they work properly.


* Currency Generation
  * Each fish was tested with different amounts of coins they generate per second.
  * To test the display for thousand, million , and billion. A cheat was made to give the player 1M coins.
  * When the game is closed, several timing tests were made to make sure that the currency generation is retained accurately.


### System Testing
The data that our program takes in is in the form of user input. So to test this, we let people play the game to see if any bugs were found from a new perspective on the game. As for System testing, our game can run on a toaster.

### Acceptance Testing
We introduced several test players to our game to conduct most of our acceptance testing. These alpha players were then asked a few questions about their experience playing.

* 3. Be Able to Pass the Time
  * Players asked if they found minigames entertaining, and whether any bugs were found.
  * Passed


* 4. Quick Access
  * Players were timed and asked to perform a check-in on their game
  * Passed


* 5. Accurate Fish Depictions
  * Players were asked about the designs of the fish and whether the fish looked like what the player would expect
  * Passed


* 7. Suitable for Younger Audiences
  * The group of alpha players included some testers of a younger age to make sure that the game was playable by younger individuals. The older alpha testers were also asked if they felt the game was suitable for a younger player
  * Passed


* 9. Interaction with the Game
  * Players were asked to try and interact with as much of the game as possible and then asked how they felt the interactivity improved their experience or what other features they might want to see
  * Passed


* 10. Requires Little Thought
  * Players were asked about what level of critical thinking the game required and how complex they felt the mechanics were
  * Passed
