{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Util where

import Import

formWidget :: Text -> Widget -> Route App -> Maybe Html -> Widget
formWidget title widget route errorMsg = $(whamletFile "templates/Form.hamlet")

navWidget :: Text -> Widget
navWidget active = do
    usuario <- lookupSession "_ID"
    $(whamletFile "templates/Nav.hamlet")

footerWidget :: Widget
footerWidget = do
    $(whamletFile "templates/Footer.hamlet")