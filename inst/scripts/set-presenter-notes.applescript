
on run argv
    tell document id (item 1 of argv) of application "Keynote"
        tell slide (item 2 of argv as number)
            set presenter notes to (item 3 of argv)
        end tell
    end tell
end run
