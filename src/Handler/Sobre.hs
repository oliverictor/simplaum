{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Sobre where

import Import
import Text.Cassius
import Text.Julius

getSobreR :: Handler Html
getSobreR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Sobre" 
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Sobre.cassius")
        $(whamletFile "templates/Sobre.hamlet")