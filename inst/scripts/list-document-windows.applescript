
tell application "Keynote"
    set out to "["
    repeat with i from 1 to the count of documents
        set fil to file of document i
        set rec to "{" & ¬
            "\"id\": \"" & id of document i & "\", " & ¬
            "\"filename\": \"" & POSIX path of fil as text & "\"" & ¬
            "}"
        if i > 1 then
            set out to out & ", "
        end if
        set out to out & rec
    end repeat
    set out to out & "]"
    out
end tell
