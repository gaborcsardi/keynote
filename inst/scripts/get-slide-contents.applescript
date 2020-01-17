
on run argv
    set out to "["
    set cnt to 0
    tell document id (item 1 of argv) of application "Keynote"
        tell slide (item 2 of argv as number)
            -- add title item if visible
            if title showing then
                set tit to my jsonrecord(default title item, ¬
                                         "default title item")
                set out to out & tit
                set cnt to cnt + 1
            end if

            -- add body item if visible
            if body showing then
                set bod to my jsonrecord(default body item, ¬
                                         "default body item")
                if cnt > 0 then
                    set out to out & ", "
                end if
                set out to out & bod
                set cnt to cnt + 1
            end if

            -- add the other items as well
            repeat with i from 1 to the count of text items
                try
                    if (text item i = default title item) then
                        error "counted already"
                    end if
                    if (text item i = default body item) then
                        error "counted already"
                    end if
                    set itm to my jsonrecord(item i, "text item")
                    if cnt > 0 then
                        set out to out & ", "
                    end if
                    set out to out & itm
                    set cnt to cnt + 1
                end try
            end repeat
        end tell
    end tell
    set out to out & "]"
    out
end run

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

on jsonrecord(itm, itmtype)
    tell application "Keynote"
        set pos to position of itm
        set fill to background fill type of itm
        set refsh to reflection showing of itm
        set refval to reflection value of itm
        set txt to my escape(object text of itm)
        return "{" & ¬
            "\"type\": \"" & itmtype & "\", " & ¬
            "\"object_text\": \"" & txt & "\"," & ¬
            "\"horizontal_position\": " & item 1 of pos as string & ", " & ¬
            "\"vertial_position\": " & item 2 of pos as string & ", " & ¬
            "\"width\": " & width of itm as string & ", " & ¬
            "\"height\": " & height of itm as string & ", " & ¬
            "\"background_fill_type\": \"" & fill & "\", " & ¬
            "\"rotation\": " & rotation of itm as string & ", " & ¬
            "\"locked\": " & locked of itm & ", " & ¬
            "\"opacity\": " & opacity of itm & ", " & ¬
            "\"reflection_showing\": " & refsh & ", " & ¬
            "\"reflection_value\": " & refval & ¬
            "}"
    end tell
end jsonrecord
