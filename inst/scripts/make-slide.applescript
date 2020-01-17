
on run argv
    tell document id (item 1 of argv) of application "Keynote"
        make new slide
    end tell
end run
