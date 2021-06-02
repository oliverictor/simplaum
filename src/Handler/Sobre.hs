{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Sobre where

import Import
import Text.Cassius
import Handler.Util

getSobreR :: Handler Html
getSobreR = do
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Sobre" 
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Sobre.cassius")
        toWidget (navWidget "Home")
        $(whamletFile "templates/Sobre.hamlet")
        toWidget footerWidget