{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cliente where

import Import
import Text.Cassius
import Text.Lucius
 
formCliente :: Form Cliente
formCliente = renderDivs $ Cliente
    <$> areq textField "Nome: "  Nothing
    <*> areq textField "CPF:  "  Nothing
    <*> areq intField  "Idade: " Nothing
    
getClienteR :: Handler Html
getClienteR = do
    (widget,_) <- generateFormPost formCliente
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Cadastro.cassius")
        $(whamletFile "templates/Cadastro.hamlet")

getCadastroR :: Handler Html
getCadastroR = do
    (widget,_) <- generateFormPost formCliente
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Cadastro.cassius")
        $(whamletFile "templates/Cadastro.hamlet")

postClienteR :: Handler Html
postClienteR = do
    ((result,_),_) <- runFormPost formCliente
    case result of
        FormSuccess cliente -> do
            runDB $ insert cliente
            setMessage [shamlet|
                <div>
                    Cliente #{clienteNome cliente} inserido com sucesso!
            |]
            redirect ClienteR
        _ -> redirect ClientesPageR

getPerfilR :: ClienteId -> Handler Html
getPerfilR cid = do
    cliente <- runDB $ get404 cid
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        $(whamletFile "templates/Cliente.hamlet")

getClientesPageR :: Handler Html
getClientesPageR = do
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")

        $(whamletFile "templates/Clientes.hamlet")

postApagarCliR :: ClienteId -> Handler Html
postApagarCliR cid = do
    runDB $ delete cid
    redirect ClientesPageR