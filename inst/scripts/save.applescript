
on run argv
    activate
    tell application "Keynote"
        save document id (item 1 of argv)
    end tell
end run
