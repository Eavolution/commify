module Lib (
            commaEU,
            commaGl
           ) where

-- Use '.' as thousand seperator and ',' as decimal point. European.
commaEU :: String -> String
commaEU = comma ',' '.'

-- Use ',' as thousand seperator and '.' as decimal point. Global.
commaGl :: String -> String
commaGl = comma '.' ','

splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)

comma :: Char -> Char -> String -> String
comma decimal com string = (commaNoDots com $ fst strings) ++ (decimal : snd strings)
    where 
        strings :: (String, String)
        strings = splitAtFirst decimal string


commaNoDots :: Char -> String -> String
commaNoDots com = reverse . aux . reverse
    where 
        aux :: String -> String
        aux (x:y:z:w:xs) = x : y : z : com : aux (w:xs)
        aux (x:y:z:xs) = x : y : z : aux xs
        aux (x:y:xs) = x : y : aux xs
        aux (x:xs) = x : xs
        aux [] = []