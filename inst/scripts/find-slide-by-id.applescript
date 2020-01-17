
on run argv
    set slideid to (item 2 of argv)
    tell document id (item 1 of argv) of application "Keynote"
        set notes to the presenter notes of every slide
        repeat with i from 1 to the count of notes
            set notei to item i of notes
	    if (offset of slideid in notei) > 0
                return i
            end if
        end repeat
        return 0
    end tell
end run
