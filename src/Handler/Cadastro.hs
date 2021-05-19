{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cadastro where

import Import
import Text.Cassius
import Text.Julius

getCadastroR :: Handler Html
getCadastroR = do
    defaultLayout $ do 
        -- estatico
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Cadastro de Hospedes" 
        toWidgetHead $(cassiusFile "templates/Cadastro.cassius")
        $(whamletFile "templates/Cadastro.hamlet")