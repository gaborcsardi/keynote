
on run argv
    tell document id (item 1 of argv) of application "Keynote"
       tell slide (item 2 of argv as number)
          get presenter notes as text
       end tell
    end tell
end run
