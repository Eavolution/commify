module Main (main) where

import Lib
import System.Environment

putHelpText :: IO()
putHelpText = do
    name <- getProgName
    putStrLn $ name ++ ": adds commas to numbers to make them more readable. Written by Eavolution."
    putStrLn $ "Usage: " ++ name ++ " optional <number> or recieve from STDIN."

main :: IO ()
main = do
    -- Get args and figure out how many there are
    args <- getArgs
    
    case length args of
        -- If none get from stdin (to allow for piping) then put the comma'd version to stdout
        0 -> (getLine >>= (\s -> putStrLn $ commaGl s))
        -- If one argument 
        1 -> putStrLn $ commaGl $ head args
        -- Else output help
        _ -> putHelpText

