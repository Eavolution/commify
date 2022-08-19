module Main (main) where

import Lib
import Argsect
import System.Environment
import Data.Maybe

swHelp = Switch "-h" "--help" "Displays the help menu." :: Switch
swEu = Switch "-e" "--european" "Formats the numbers european style ie. '1.000,00'." :: Switch
swGl = Switch "-g" "--global"   "Formats the numbers US/UK style ie. '1,000.00'." :: Switch

usageDescription = "number [optional switches]"

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
    progName <- getProgName
    let parsed = argsect definedSwitches [] cliArgs
    -- Check if an error in parsing
    if isJust (snd parsed) then
        putStrLn $ (fromJust (snd parsed)) progName usageDescription
    else do
        let args = fromJust $ fst parsed
        let numbers = aPositionals args
        let switches = aSwitches args

        -- Sort out args
        if swHelp `elem` switches || null numbers then
            putStrLn "Help"
            --putStrLn $ defaultHelpText definedSwitches [] progName "number [optional switches]"
        else 
            putStrLn "Comma'd value"
            --putStrLn $ comma switches $ head numbers