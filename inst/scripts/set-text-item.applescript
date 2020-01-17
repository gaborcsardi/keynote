
on run argv
    tell document id (item 1 of argv) of application "Keynote"
        tell slide (item 2 of argv as number)
            set what to (item 3 of argv)
            if (what = "default title item") then
               set the object text of the default title item to (item 4 of argv)
            else if (what = "default body item") then
               set the object text of the default body item to (item 4 of argv)
            else
                error "Cannot set unsupported text item"
            end if
        end tell
    end tell
end run
