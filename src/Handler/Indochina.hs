{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Indochina where

import Import
import Text.Cassius
import Handler.Util

getIndochinaR :: Handler Html
getIndochinaR = do
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quarto Indochina"
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Quarto.cassius")
        toWidget (navWidget "Home")
        $(whamletFile "templates/Indochina.hamlet")
        toWidget footerWidget