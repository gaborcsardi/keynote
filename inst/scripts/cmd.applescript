
on run argv
    set mycmd to item 1 of argv
    tell application "Keynote"
        if mycmd = "start_slideshow" then
            start slideshow
        else if mycmd = "stop_slideshow" then
            stop slideshow
        else if mycmd = "show_next" then
            show next
        else if mycmd = "show_previous" then
            show previous
        else
            error "Internal error, no such command: " & mycmd
        end if
    end tell
end run
