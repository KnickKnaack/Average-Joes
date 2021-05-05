# Test Report

1. Component Testing

Mini-Game: The mini game was a specific part that, was eventually added to the system,
but before it was moved over was tested apart as its own unit. The problem with the mini-game
is that three objects needed to be tested to make sure they were not only working correctly but
synchronized with each other. The three objects to test were the coin value increasing, click input
being registered, and the navigation to work. The way the testing was done was at first we tested for
click input without restrictions, that is without needing to be on an actual fish for any type of click
to be registered. After succefully passing the input test we moved on to test if and when a user decides
to click, the coin value will increase AS WELL AS store this new increased value so when you exit the mini
game you retain your new coin count. After this test was completed the mini-game was added to the rest
of the system and at that time ANOTHER and final test was done and that was on the actual navigation to and
from the mini-game to the previous screen the user may have came from or accessed the mini-game from. I chose
to reuse the fish that were on the main screen as the fish in the mini game to test for input due to really there
being no restriction on the area of the click and to make sure we had the game states working correctly. For testing
coins I actually used different increments of coin while testing as well, so the user cannot simply "flood" the coin
value with a large and sudden increase but a large enough increase as to where the user is not discouraged from 
a mediocre gain in value.

2. System Testing

3. Acceptance Testing