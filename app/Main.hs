module Main (main) where

import Lib
import System.Environment

putHelpText :: IO()
putHelpText = do
    name <- getProgName
    putStrLn $ "Usage: " ++ name ++ " optional <number> or recieve from STDIN."

main :: IO ()
main = do
    -- Get args and figure out how many there are
    args <- getArgs
    
    case length args of
        -- If none get from stdin (to allow for piping) then put the comma'd version to stdout
        0 -> (getLine >>= (\s -> putStrLn $ comma s))
        -- If one argument 
        1 -> putStrLn $ comma $ head args
        -- Else output help
        _ -> putHelpText

