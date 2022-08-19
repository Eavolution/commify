module Lib (
            commaEu,
            commaGl,
            splitAtFirst
           ) where

-- Use '.' as thousand seperator and ',' as decimal point. European.
commaEu :: String -> String
commaEu = comma ',' '.'

-- Use ',' as thousand seperator and '.' as decimal point. Global.
commaGl :: String -> String
commaGl = comma '.' ','

splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)

comma :: Char -> Char -> String -> String
comma decimal com string = ""
--    if decimal `elem` string then
--        (commaNoDots com $ fst $ splitAtFirst decimal string) ++ (decimal : snd $ splitAtFirst decimal string)
 --   else
 --       commaNoDots com string


commaNoDots :: Char -> String -> String
commaNoDots com = reverse . aux . reverse
    where 
        aux :: String -> String
        aux (x:y:z:w:xs) = x : y : z : com : aux (w:xs)
        aux (x:y:z:xs) = x : y : z : aux xs
        aux (x:y:xs) = x : y : aux xs
        aux (x:xs) = x : xs
        aux [] = []