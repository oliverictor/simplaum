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
    defaultLayout $ do
        setTitle "Home"
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidget (navWidget "Home")
        $(whamletFile "templates/Home.hamlet")
        toWidget footerWidget