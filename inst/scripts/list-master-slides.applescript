
on run argv
    set out to "["
    tell document id (item 1 of argv) of application "Keynote"
        set nms to name of every master slide
        repeat with i from 1 to the count of nms
            set rec to "{" & ¬
                "\"name\": \"" & item i of nms & "\"" & ¬
                "}"
            if i > 1 then
                set out to out & ", "
            end if
            set out to out & rec
        end repeat
    end tell
    set out to out & "]"
    out
end run
