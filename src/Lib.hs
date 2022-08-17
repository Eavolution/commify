module Lib (comma) where

comma :: String -> String
comma = reverse . aux . reverse
    where 
        aux :: String -> String
        aux (x:y:z:w:xs) = x : y : z : ',' : aux (w:xs)
        aux (x:y:z:xs) = x : y : z : aux xs
        aux (x:y:xs) = x : y : aux xs
        aux (x:xs) = x : xs
        aux [] = []