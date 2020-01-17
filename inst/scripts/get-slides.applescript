
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

on run argv
    set out to "["
    tell document id (item 1 of argv) of application "Keynote"
        repeat with i from 1 to the count of slides
            tell slide i
                set tit to object text of default title item
                set bod to object text of default body item
                set prn to presenter notes
                tell me to set tit to escape(tit)
                tell me to set bod to escape(bod)
                tell me to set prn to escape(prn)
                set rec to "{" & ¬
                    "\"number\": " & i as string & ", " & ¬
                    "\"page_number\": " & slide number & ", " & ¬
                    "\"id\": \"" & "NA" & "\", " & ¬
                    "\"master\": \"" & name of base slide & "\", " & ¬
                    "\"title_shown\": " & title showing & ", " & ¬
                    "\"body_shown\": " & body showing & ", " & ¬
                    "\"skipped\": " & skipped & ", " & ¬
                    "\"title\": \"" & tit & "\", " & ¬
                    "\"body\": \"" & bod & "\", " & ¬
                    "\"presenter_notes\": \"" & prn & "\"" & ¬
                    "}"
                if i > 1 then
                    set out to out & ", "
                end if
                set out to out & rec
            end tell
	end repeat
    end tell
    set out to out & "]"
    out
end run
