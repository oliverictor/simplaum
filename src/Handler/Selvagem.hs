{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Selvagem where

import Import
import Text.Cassius
import Handler.Util

getSelvagemR :: Handler Html
getSelvagemR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quarto Selvagem"
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Quarto.cassius")
        toWidget (navWidget "Home")
        $(whamletFile "templates/Selvagem.hamlet")
        toWidget footerWidget