module Main where

import System.Environment (getArgs)
import System.Exit
import System.IO
import Control.Monad
import Control.Exception
import Data.Aeson
import GHC.Generics
import qualified Data.ByteString.Lazy as BL
import qualified Data.Text as T
import System.CPUTime
import Text.Printf

-- Este programa usa a API do Aeson para processar um arquivo JSON
-- Data.Aeson fornece as funções encode e decode para conversão JSON <-> Haskell

data JSONValue = JSONValue
    { jsonStructure :: Value
    } deriving (Show, Generic)

instance FromJSON JSONValue where
    parseJSON v = return $ JSONValue v

instance ToJSON JSONValue

main :: IO ()
main = do
    args <- getArgs
    if null args
        then do
            putStrLn "Uso: aeson_runner <arquivo.json>"
            exitFailure
        else do
            let filename = head args
            putStrLn $ "Processando arquivo JSON: " ++ filename
            
            start <- getCPUTime
            
            -- Ler o arquivo JSON usando ByteString
            jsonData <- BL.readFile filename
            
            -- Decodificar o JSON usando a função decode do Aeson
            case eitherDecode jsonData of
                Left err -> do
                    putStrLn $ "Erro ao decodificar JSON: " ++ err
                    exitFailure
                Right (value :: JSONValue) -> do
                    -- Recodificar o JSON usando a função encode do Aeson
                    let reencoded = encode value
                    
                    -- Fazer algum processamento adicional para benchmarking
                    BL.writeFile "temp_output.json" reencoded
                    
                    end <- getCPUTime
                    let diff = fromIntegral (end - start) / (10^12)
                    
                    putStrLn $ "Processamento concluído em " ++ printf "%.6f" (diff :: Double) ++ " segundos"
                    putStrLn $ "Tamanho original: " ++ show (BL.length jsonData) ++ " bytes"
                    putStrLn $ "Tamanho após recodificação: " ++ show (BL.length reencoded) ++ " bytes"