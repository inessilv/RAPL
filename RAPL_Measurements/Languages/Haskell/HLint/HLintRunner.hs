module Main where

import System.Environment (getArgs)
import System.Exit
import System.IO
import Control.Monad
import Language.Haskell.HLint

main :: IO ()
main = do
    args <- getArgs
    if null args
        then do
            putStrLn "Uso: hlint_runner <arquivo>"
            exitFailure
        else do
            let filename = head args
            putStrLn $ "Analisando arquivo: " ++ filename
            
            -- Chama a API do HLint diretamente
            ideas <- hlint [filename]
            
            -- Processa e exibe os resultados
            putStrLn $ "Encontradas " ++ show (length ideas) ++ " sugestões:"
            forM_ ideas $ \idea -> do
                putStrLn $ "  " ++ show idea