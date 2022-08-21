module Main (main) where

import Lib
import Argsect

import System.Environment
import Data.Maybe

swHelp :: Switch
swHelp =
    Switch
    "-h"
    "--help"
    "Displays the help menu."

swEu :: Switch
swEu =
    Switch
    "-e"
    "--european"
    "Formats the numbers european style ie. '1.000,00'."

swGl :: Switch
swGl =
    Switch
    "-g"
    "--global"
    "Formats the numbers US/UK style ie. '1,000.00'."

swSwLc :: Switch
swSwLc =
    Switch
    "-s"
    "--swiss"
    "Formats the numbers Swiss/Lichenstein style ie. 1'000.00"

swCustom :: DataSwitch
swCustom =
    DataSwitch
    "-c"
    "--custom"
    "., for UK/US 1,000.00"
    (\ x -> (length x) == 2)
    False
    "Allows the setting of custom seperators in the form decimal followed\
    \by thousands seperator ie. .,"

definedSwitches :: [Switch]
definedSwitches = [swHelp, swEu, swGl, swSwLc]

definedDataSwitches :: [DataSwitch]
definedDataSwitches = [swCustom]

usageDescription :: String
usageDescription = "number [optional switches]\nNumbers must have only 0-9 \
        \and optionally only decimal character of the region\
        \(',' for europe, '.' globally)"

-- Chooses which function to call based on if a number was provided or not
handleSwitches :: Maybe PosArg 
                    -> [Switch]
                    -> [DataSwitch]
                    -> String
                    -> String
                    -> IO String
handleSwitches Nothing = handleSwitchesStdIn
handleSwitches num = handleSwitchesPure $ fromJust num

-- Produces final output based on what switches are present, try to remove IO
handleSwitchesPure :: PosArg 
                    -> [Switch]
                    -> [DataSwitch]
                    -> String
                    -> String
                    -> IO String
handleSwitchesPure num sws dsws oProgName oUsage
    -- Display the help menu on -h
    | swHelp `elem` sws = return helpText
    -- If the europe switch is present, format number EU style
    | swEu `elem` sws =
        return $ fromMaybe errorMsg (commaEu num)
    -- If the global switch is present, format number UK/US style
    | swGl `elem` sws =
        return $ fromMaybe errorMsg (commaGl num)
    -- Swiss/Lichenstein style
    | swSwLc `elem` sws =
        return $ fromMaybe errorMsg (commaSwLc num)
    | swCustom `elem` dsws =
        return $ fromMaybe errorMsg (comma dec thou num)
    -- Default to global
    | otherwise =
        return $ fromMaybe ("Invalid number given: " ++ num) (commaGl num)
    where
        errorMsg = "Invalid number given: " ++ num
        helpText = prettyHelpText
            definedSwitches definedDataSwitches oProgName oUsage
        customData =
            fromJust $ getDataFromDswList (dswIdShort swCustom) dsws
        dec = head customData
        thou = last customData

-- If no number was provided, it is got from STDIN and passed along
handleSwitchesStdIn :: [Switch]
                    -> [DataSwitch]
                    -> String
                    -> String
                    -> IO String
handleSwitchesStdIn sws dsws progName usage = do
    num <- getLine
    handleSwitchesPure num sws dsws progName usage

main :: IO ()
main = do
    cliArgs <- getArgs
    progName <- getProgName

    let parsed = argsect definedSwitches definedDataSwitches cliArgs
    
    (either
        (\ x -> return $ x progName usageDescription)
        (\ x ->
            handleSwitches
            (head' (aPositionals x))
        (aSwitches x)
        (aDataSwitches x)
        progName
        usageDescription)
        parsed)
        >>= putStrLn
    where
        head' :: [a] -> Maybe a
        head' [] = Nothing
        head' (x:_) = Just x
