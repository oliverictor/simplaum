{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Home where

import Import
import Handler.Util
import Text.Cassius

getHomeR :: Handler Html
getHomeR = do
    usuario <- lookupSession "_ID"
    defaultLayout $ do
        setTitle "Home"
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidget navWidget
        $(whamletFile "templates/Inicio.hamlet")
        toWidget footerWidget