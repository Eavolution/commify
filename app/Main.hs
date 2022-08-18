module Main (main) where

import Lib
import Argsect
import Types
import System.Environment

swHelp = Switch "-h" "--help" "Displays the help menu." :: Switch
swEu = Switch "-e" "--european" "Formats the numbers european style ie. '1.000,00'." :: Switch
swGl = Switch "-g" "--global"   "Formats the numbers US/UK style ie. '1,000.00'." :: Switch

definedSwitches :: [Switch]
definedSwitches = [swHelp, swEu, swGl]

main :: IO ()
main = do
    -- Get args and figure out how many there are
    cliArgs <- getArgs


    print $ argsect definedSwitches [] cliArgs