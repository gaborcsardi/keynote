
on run argv
    set thm to item 1 of argv
    tell application "Keynote"
        if thm = "-" then
            make new document
        else
	    make new document with properties ¬
	        { document theme: theme thm }
        end if
    end tell
end run
