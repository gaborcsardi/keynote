
on run argv
    set myid to item 1 of argv
    tell application "Keynote"
        set mydoc to document id myid of application "Keynote"
        set myprops to properties of mydoc
        set myfile to file of myprops
        if myfile is missing value
            myfile
        else
            get POSIX path of (file of myprops)
        end if
    end tell
end run
