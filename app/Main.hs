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

comma :: [Switch] -> String -> String
comma switches
    | swEu `elem` switches = commaEu
    | swGl `elem` switches = commaGl
    | otherwise = commaGl

main :: IO ()
main = do
    cliArgs <- getArgs
    let args = argsect definedSwitches [] cliArgs
    let numbers = aPositionals args
    let switches = aSwitches args

    -- Sort out args
    if swHelp `elem` switches || (UndefinedSwitch "") `elem` switches then 
        getDefaultHelpText switches [] 