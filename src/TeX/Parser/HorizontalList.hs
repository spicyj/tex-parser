module TeX.Parser.HorizontalList
( HorizontalListElem(HBoxChar, HPenalty)
, horizontalList
)
where

import Prelude ( Char, Int, Show, Eq
               , (<$>), (>>), (<*>), ($), (<*), (*>), (++)
               )
import Text.Parsec

import TeX.Category
import TeX.Parser.MacroParser
import TeX.Parser.Parser
import TeX.Parser.Prim
import TeX.Token

data HorizontalListElem
  = HBoxChar Char
  | HPenalty Int
  deriving (Eq, Show)

horizontalListElem :: TeXParser HorizontalListElem
horizontalListElem =
  HBoxChar <$> (extractChar <$> (categoryToken Letter)) <|>
  HBoxChar <$> (extractChar <$> (categoryToken Other)) <|>
  HBoxChar <$> (extractChar <$> (categoryToken Space))
  <?> "horizontal list elem"

groupedHorizontalList :: TeXParser [HorizontalListElem]
groupedHorizontalList =
  (categoryToken BeginGroup) *> horizontalList <* (categoryToken EndGroup)

horizontalList :: TeXParser [HorizontalListElem]
horizontalList = do
  option [] $ ((:) <$> horizontalListElem <*> horizontalList) <|>
              ((++) <$> groupedHorizontalList <*> horizontalList)  <|>
              (parseMacros >> horizontalList)
