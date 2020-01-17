
on run argv
    tell application "Keynote"
        activate
        tell document id (item 1 of argv) of application "Keynote"
            set current slide to slide (item 2 of argv as number)
            set what to (item 3 of argv)
            if (what = "default title item") then
                set itm to default title item of current slide
            else if (what = "default body item") then
                set itm to default body item of current slide
            else
                error "Cannot set unsupported text item"
            end if
            -- this puts it into focus, apparently
            get position of itm
            set object text of itm to ""
        end tell
    end tell

    tell application "System Events"
        tell process "Keynote"
            key code 36
            keystroke "v" using command down
        end tell
        set visible of process "Keynote" to false
    end tell
end run
