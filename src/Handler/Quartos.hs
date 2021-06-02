{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Quartos where

import Import
import Text.Cassius
import Handler.Util

getQuartosR :: Handler Html
getQuartosR = do
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quartos" 
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Quartos.cassius")
        toWidget (navWidget "Home")
        $(whamletFile "templates/Quartos.hamlet")
        toWidget footerWidget