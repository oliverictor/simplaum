{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Util where

import Import

formWidget :: Text -> Widget -> Route App -> Maybe Html -> Widget
formWidget title widget route errorMsg = $(whamletFile "templates/components/Form.hamlet")

navWidget :: Widget
navWidget = do
    usuario <- lookupSession "_ID"
    $(whamletFile "templates/components/Nav.hamlet")

footerWidget :: Widget
footerWidget = do
    $(whamletFile "templates/components/Footer.hamlet")