# Pico8
bleep bleep bleep.

## GIT Setup

On Windows, files get stored in ```%AppData%/pico-8```

On Windows open up the command prompt and enter ```cd "%AppData%/"```. This navigates the prompt to where your Pico-8 directory is. Now, to move your current data to your new folder, enter ```move "pico-8" "New/Path/To/pico-8"```.

Now that your data is where you want it to be, it's time to use a symlink to tell Pico-8 to start looking for it there. Symlinks are pretty damn handy.

On Windows enter ```mklink /d "pico-8" "New/Path/To/pico-8"``` into the command prompt.