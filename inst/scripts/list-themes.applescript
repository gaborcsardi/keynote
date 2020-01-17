
on escape(str)
    -- Save delimiter
    set prevdelim to text item delimiters of AppleScript
    -- Escape double quotes
    set text item delimiters of AppleScript to "\""
    set str to text items of str
    set text item delimiters of AppleScript to "\\\""
    set str to str as text
    -- Escape newlines as well
    set text item delimiters of Applescript to "\n"
    set str to text items of str
    set text item delimiters of Applescript to "\\n"
    set str to str as text
    -- restore delimiter
    set text item delimiters of AppleScript to prevdelim
    return str
end escape

tell application "Keynote"
    set out to "["
    set allthemes to properties of every theme
    repeat with i from 1 to the count of allthemes
        set nam to name of item i of allthemes
        set tid to id of item i of allthemes
        tell me to set nam to escape(nam)
        set rec to "{" & ¬
            "\"name\": \"" & nam & "\", " & ¬
            "\"id\": \"" & tid & "\"" & ¬
            "}"
        if i > 1 then
            set out to out & ", "
        end if
        set out to out & rec
    end repeat
    set out to out & "]"
    out
end tell
