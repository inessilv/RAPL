-- small.hs
module Small where

-- Algumas funções com issues simples para o HLint detectar
factorial :: Int -> Int
factorial n = if n <= 1 then 1 else n * factorial (n - 1)

map' :: (a -> b) -> [a] -> [b]
map' f []     = []
map' f (x:xs) = f x : map' f xs

-- Problemas comuns que o HLint detectará:
sumList xs = foldr (\x acc -> x + acc) 0 xs

-- Função com parênteses desnecessários
double x = (x * 2)

-- Uso de head/tail quando pattern matching é melhor
firstElem list = head list