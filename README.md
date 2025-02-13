# Lab Test 1 || Assigment 1
##
[ Instructions ]:

The screen should have the following requirements:

-- Numbers are appearing on the screen randomly

-- The user can tap on “Prime” or “Not Prime” labels

-- When the correct answer is selected, the green tick is displayed on the screen and
   the red cross for the wrong answer

-- The correct and wrong answers must be recorded

-- After each 10 attempts, a dialog should be displayed on the screen displaying the
   information of how many correct and wrong answers the user has selected

-- There is a timer integrated with the application which update the screen with a new
   number every 5 seconds. If the user does not select within this 5 second, a wrong
   answer would be recorded for them.
   ##
# Trialing Animations for Future Projects
##
For this Lab Assignment, considering how much time we had, I wanted to try and make this a concurrent activity as this Lab Test not only was challenging, it was inspiring when it came to the condsideration of future projects.

I wanted to add a small nuance within the UI as this is something I personally enjoy and considering the capacity of XCode and Swift in the general sense, adding the smallest of animations to the buttons when pressed by the user.
I felt this was small when I began, but it most certainly required research, but it also required a LOT of trial and error -- hence why it was appreciated the amount of time that we were allotted for this assignment.

Some really interesting things that I learned: 

## rotation3DEffect

This is a modifier that takes regular buttons we would normally employ and adds a clean flipping animation to them. 

The rotation itself is determined by the isFlipped Sate, but in order to obtain a horizontal flip, the axis of the rotation must be set to the y-axis. 

Combined with the .animation() modifier we can create a really smooth transition if and when the State is changed and ensure that the isFlipped State is animating in the first place.

The .easeInOut adds a clean transition and when we use @State variables, we are able to manage those dynamic UI updates as we have learned, and we see this further displayed with the correctAnswer and incorrectAnswer score updates.

One thing I did notice (that I will continue to study, practice and look into) is that thin opaque line that appears when the horizontal flip is activated, it is faint, but it is annoying none-the-less.

I look forward to practicing this even further and really getting the finer details down pat, I have had to rewrite the code for this way too many times as of right now, and I think that overdoing it will only pose frustration and render inaccurate syntax.

I hope to use this in my group project for our Group Study Games, so this is something I have been and continue to work on in the background as the semester continues.

https://developer.apple.com/documentation/swiftui/view/rotation3deffect(_:axis:anchor:anchorz:perspective:) <--- and its sub links

##

# References

https://developer.apple.com/documentation/swiftui

https://www.hackingwithswift.com/

https://www.swiftbysundell.com/



