{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Reserva where

import Import
import Text.Cassius
import Handler.Util
import Database.Persist.Postgresql

formReserva :: ClienteId -> Form Reserva
formReserva cid = renderDivs $ Reserva
    <$> pure cid
    <*> areq (selectField reservasCB) "Quarto: " Nothing
    <*> lift (liftIO (map utctDay getCurrentTime))
    <*> areq intField "Dias: " Nothing

reservasCB :: HandlerFor App (OptionList (Key Quarto))
reservasCB = do
    quartos <- runDB $ selectList [] [Asc QuartoNome]
    optionsPairs $
        map (\r -> (quartoNome $ entityVal r, entityKey r)) quartos

getReservaR :: ClienteId -> Handler Html
getReservaR cid = do
    (widget,_) <- generateFormPost (formReserva cid)
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/components/Form.cassius")
        toWidget navWidget
        $(whamletFile "templates/reserva/Reservar.hamlet")
        toWidget footerWidget

postReservaR :: ClienteId -> Handler Html
postReservaR cid = do
    ((result,_),_) <- runFormPost (formReserva cid)
    case result of
        FormSuccess reserva -> do
            _ <- runDB $ insert reserva
            setMessage [shamlet|
                <div>
                    Reserva feita com sucesso!
            |]
            redirect (ReservasR cid)
        _ -> redirect (ReservasR cid)

getReservasR :: ClienteId -> Handler Html
getReservasR cid = do
    msg <- getMessage
    let sql = "SELECT ??,??,?? FROM quarto \
        \ INNER JOIN reserva ON reserva.quarto_id = quarto.id \
        \ INNER JOIN cliente ON reserva.cliente_id = cliente.id \
        \ WHERE cliente.id = ?"
    cliente <- runDB $ get404 cid
    tudo <- runDB $ rawSql sql [toPersistValue cid] :: Handler [(Entity Quarto, Entity Reserva, Entity Cliente)]
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/components/Form.cassius")
        toWidget navWidget
        $(whamletFile "templates/reserva/Reservas.hamlet")
        toWidget footerWidget