{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Quartos where

import Import
import Text.Cassius
import Text.Julius

getQuartosR :: Handler Html
getQuartosR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quartos" 
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Quartos.cassius")
        $(whamletFile "templates/Quartos.hamlet")