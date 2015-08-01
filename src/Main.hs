module Main where

import Prelude (Maybe(Just, Nothing), IO, Char, Either, return, ($))
import Data.Map as M
import Data.List as L
import Text.Parsec
import Control.Monad.State as S

import TeX.Lexer
import TeX.Category
import TeX.Parser
import TeX.HorizontalList
import TeX.Def
import TeX.MacroParser
import TeX.Token

lexAll :: Lexer -> CategoryMap -> [Token]
lexAll lexer map =
  case lexToken lexer map of
    Just (token, newLexer) -> token:(lexAll newLexer map)
    Nothing -> []

defaultMap :: CategoryMap
defaultMap = set '{' BeginGroup $ set '}' EndGroup $ set '#' Parameter $ set '^' Superscript initialMap

tryParser :: TeXParser a -> [Char] -> (Either ParseError a, TeXState)
tryParser parser str =
  runState testParse $ mkState defaultMap
  where
    lines = [str]

    --testParse :: (S.State TeXState) (Either ParseError a)
    testParse =
      runParserT parser
                   (TeXParserState 2)
                   "main.tex"
                   (TeXLexerStream (mkLexer lines) [])

main :: IO ()
main =
  return ()
