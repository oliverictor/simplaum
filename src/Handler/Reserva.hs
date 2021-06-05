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
        $(whamletFile "templates/cliente/Cadastro.hamlet")
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
        _ -> redirect HomeR

getReservasR :: ClienteId -> Handler Html
getReservasR cid = do
    let sql = "SELECT ??,??,?? FROM quarto \
        \ WHERE cliente.id = ?"
    cliente <- runDB $ get404 cid
    tudo <- runDB $ rawSql sql [toPersistValue cid] :: Handler [(Entity Quarto, Entity Reserva, Entity Cliente)]
    defaultLayout $ do
        [whamlet|
            <h1>
                Reservas de #{clienteNome cliente}
            <ul>
                $forall (Entity _ quarto, Entity _ reserva, Entity _ _) <- tudo
                    <li>
                        #{quartoNome quarto}: #{quartoPreco quarto} - #{show $ reservaData reserva}
        |]
