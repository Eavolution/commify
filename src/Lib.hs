module Lib 
(
    -- Expose common styles
    commaEu, commaGl, commaSwLc,
    -- Expose base function, so new styles can be added
    comma
) where

-- Use '.' as thousand seperator and ',' as decimal. European. 1.000,00
commaEu :: String -> Maybe String
commaEu = comma ',' '.'

-- Use ',' as thousand seperator and '.' as decimal. Global. 1,000.00
commaGl :: String -> Maybe String
commaGl = comma '.' ','

-- Switzerland and Lichenstein style. 1'000.00
commaSwLc :: String -> Maybe String
commaSwLc = comma '.' '\''

splitAtFirst :: Eq a => a -> [a] -> ([a], [a])
splitAtFirst x = fmap (drop 1) . break (x ==)

-- Puts commas in numbers using the supplied decimal and comma character
comma :: Char -> Char -> String -> Maybe String
comma decimal com string
    | not (checkNumber decimal string) = Nothing
    | decimal `elem` string = Just $ (commaNoDots com $ fst split) ++ (decimal : (snd split))
    | otherwise = Just $ commaNoDots com string        
    where
        split = splitAtFirst decimal string :: (String, String)

        -- Checks that a number conforms to rules:
        -- No characters other than number and decimal
        -- Only one or none decimal character
        checkNumber :: Char -> String -> Bool
        checkNumber decimal number 
            | any (\x -> not (x `elem` acceptable)) number = False
            | moreThanOne decimal number = False
            | otherwise = True
            where
                acceptable = decimal : ['0'..'9'] :: [Char]
                moreThanOne :: (Eq a) => a -> [a] -> Bool
                moreThanOne dec num = length (filter (\x -> x == dec) num) > 1

-- Puts commas in numbers with no decimals
commaNoDots :: Char -> String -> String
commaNoDots com = reverse . aux . reverse
    where 
        aux :: String -> String
        aux (x:y:z:w:xs) = x : y : z : com : aux (w:xs)
        aux (x:y:z:xs) = x : y : z : aux xs
        aux (x:y:xs) = x : y : aux xs
        aux (x:xs) = x : xs
        aux [] = []