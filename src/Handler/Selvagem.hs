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
        toWidgetHead $(cassiusFile "templates/quarto/Quarto.cassius")
        toWidget navWidget
        $(whamletFile "templates/quarto/Selvagem.hamlet")
        toWidget footerWidget