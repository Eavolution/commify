module Main (main) where

import Lib
import Argsect
import System.Environment
import Data.Maybe

swHelp = Switch "-h" "--help" "Displays the help menu." :: Switch
swEu = Switch "-e" "--european" "Formats the numbers european style ie. '1.000,00'." :: Switch
swGl = Switch "-g" "--global"   "Formats the numbers US/UK style ie. '1,000.00'." :: Switch
swSwLc = Switch "-s" "--swiss" "Formats the numbers Swiss/Lichenstein style ie. 1'000.00" :: Switch

definedSwitches = [swHelp, swEu, swGl, swSwLc] :: [Switch]

swCustom = DataSwitch "-c"
    "--custom"
    "., for UK/US 1,000.00" 
    (\d -> (length d) == 2)
    False 
    "Allows the setting of custom seperators in the form decimal followed by thousands seperator\
    \ ie. .," :: DataSwitch

definedDataSwitches = [swCustom] :: [DataSwitch] 

usageDescription = "number [optional switches]" :: String

main :: IO ()
main = do
    cliArgs <- getArgs
    progName <- getProgName
    let parsed = argsect definedSwitches definedDataSwitches cliArgs
    let usage = "number [optional switches]\nNumbers must have only 0-9 \
        \and optionally only decimal character of the region (',' for europe, '.' globally)"

    -- Check if an error in parsing
    if isJust (snd parsed) then
        putStrLn $ (fromJust (snd parsed)) progName usageDescription
    else do
        -- Args deemed to be valid, therefore parse them and seperate positionals from switches

        let args = fromJust $ fst parsed :: Args
        let numbers = aPositionals args :: [PosArg]
        let switches = aSwitches args :: [Switch]
        let dataSwitches = aDataSwitches args :: [DataSwitch]

        putStrLn $ output switches dataSwitches numbers progName usage
        where
            output :: [Switch] -> [DataSwitch] -> [PosArg] -> String -> String -> String
            output sws dsws nums oProgName oUsage
                -- Display the help menu on -h
                | swHelp `elem` sws =
                    defaultHelpText
                        definedSwitches definedDataSwitches oProgName oUsage
                -- Require one number unless help was specified, obviously
                | length nums /= 1 = "1 positional argument required, " ++
                    show (length nums) ++ "given."
                -- If the europe switch is present, format number EU style if number is valid
                | swEu `elem` sws =
                    fromMaybe errorMsg (commaEu num)
                -- If the global switch is present, format number UK/US style if number is valid
                | swGl `elem` sws =
                    fromMaybe errorMsg (commaGl num)
                -- Swiss/Lichenstein style
                | swSwLc `elem` sws =
                    fromMaybe errorMsg (commaSwLc num)
                | swCustom `elem` dsws =
                    fromMaybe errorMsg (comma (head customData) (last customData) num)
                -- Default to global
                | otherwise = 
                    fromMaybe ("Invalid number given: " ++ num) (commaGl num)
                        where
                            num = head nums
                            errorMsg = "Invalid number given: " ++ num
                            customData = fromJust $ getDataFromDswList (dswIdShort swCustom) dsws