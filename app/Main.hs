module Main (main) where

import Lib
import ArgParse
import System.Environment

swHelp = Switch "-h" "--help" "Displays the help menu." :: Switch
swEu = Switch "-e" "--european" "Formats the numbers european style ie. '1.000,00'." :: Switch
swGl = Switch "-g" "--global"   "Formats the numbers US/UK style ie. '1,000.00'." :: Switch

definedSwitches :: [Switch]
definedSwitches = [swHelp, swEu, swGl]

putHelpText :: IO()
putHelpText = do
    name <- getProgName
    putStrLn $ name ++ ": adds commas to numbers to make them more readable. Written by Eavolution."
    putStrLn $ "Usage: " ++ name ++ " <number> <switches>"

main :: IO ()
main = do
    -- Get args and figure out how many there are
    cliArgs <- getArgs

    -- Parse the arguments provided
    let args = parseArgs definedSwitches cmd
    let switches = snd args
    let numbers = fst args

    if (swHelp `elem` switches) then
        putHelpText
    else
        if null $ filter (\x -> x /= help) switches
            print $ commaEU head (fst)
    print args