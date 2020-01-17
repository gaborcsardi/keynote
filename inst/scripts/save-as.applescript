
on run argv
    tell application "Keynote"
        save document id (item 1 of argv) in posix file (item 2 of argv as text )
    end tell
end run
