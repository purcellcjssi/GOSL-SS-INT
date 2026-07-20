@echo off


:: Script will merge the specified repository folders and merge them into a T-SQL script file.



:: This enables delayed expansion, which is necessary for variable manipulation within a for loop
setlocal enabledelayedexpansion


SET "source_dir=C:\Users\purce\OneDrive\Documents\Github\GOSL-SS-INT"
SET "output_dir=C:\Users\purce\OneDrive\Documents\Github\GOSL-SS-INT\Misc\PackageScripts\Output"

:: Ensure output directory exists
if not exist "%output_dir%" mkdir "%output_dir%"

:: 1) Iterate through main folders that begin with prefix 'DBS'
for /d %%d in ("%source_dir%\DBS*") do (
    set "parent_name=%%~nxd"
    ::echo !parent_name!


    :: Save current directory so we can safely return later
    :: NOTE: Using pushd and popd is safer than using cd because it handles paths with spaces and network drives better.
    ::pushd and popd: Instead of forcing FOR /R to evaluate a variable path
    ::(which causes the "system cannot find the drive specified" error),
    ::pushd "%%d" physically moves the command prompt context inside that DBS directory safely.
    pushd "%%d"

    :: 2) Iterate through each sub-directory inside the current DBS folder (including itself)
    :: NOTE
    :: for /d /r %%s in (.): This cleanly discovers every sub-folder relative to where we just moved,
    :: completely removing the buggy variable reference from the loop definition.
    for /d /r %%s in (.) do (

        set "sub_path=%%~fss"
        set "sub_name=%%~nxs"

        :: Determine the distinct output file name
        if "!parent_name!"=="!sub_name!" (
            :: There should be no files at this level in the repository,
            :: but if there are, we will merge them into a single file named after the parent folder.
            set "output_file=!parent_name!.sql"
        ) else (
            set "output_file=!parent_name!_!sub_name!.sql"
        )

        :: CRITICAL ADDITION: If old merged file exists for this subfolder,
        :: delete it right before we begin copying new files into it.
        if exist "!output_dir!\!output_file!" (
            echo Replacing old file: !output_file!
            del /q "!output_dir!\!output_file!"
        )

        :: 3) & 4) Iterate all *.sql files in this specific sub-directory and merge them
        :: NOTE:
        :: The inner loop looks directly inside "%%s\*.sql",
        :: ensuring it only grabs SQL files belonging strictly to that specific sub-folder.

        if exist "%%s\*.sql" (
            for %%i in ("%%s\*.sql") do (
                echo Merging: %%~nxi into !output_file!
                type "%%i" >> "!output_dir!\!output_file!"
                echo. >> "!output_dir!\!output_file!"
            )
        )
    )

    :: Restore the original directory
    popd
)
