{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Indochina where

import Import
import Text.Cassius
import Text.Julius

getIndochinaR :: Handler Html
getIndochinaR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quarto Indochina" 
        toWidgetHead $(cassiusFile "templates/Indochina.cassius")
        $(whamletFile "templates/Indochina.hamlet")