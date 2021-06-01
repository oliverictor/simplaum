{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cliente where

import Import
import Text.Cassius

-- formCliente :: Form Cliente
-- formCliente = renderDivs $ Cliente
--     <$> areq textField "Nome: "  Nothing
--     <*> areq textField "CPF:  "  Nothing
--     <*> areq intField  "Idade: " Nothing
formCliente :: Maybe Cliente -> Form Cliente
formCliente mc = renderDivs $ Cliente
    <$> areq textField "Nome: "  (fmap clienteNome mc)
    <*> areq textField "CPF:  "  (fmap clienteCpf mc)
    <*> areq intField  "Idade: " (fmap clienteIdade mc)
    
getClienteR :: Handler Html
getClienteR = do
    (widget,_) <- generateFormPost (formCliente Nothing)
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Cadastro.cassius")
        $(whamletFile "templates/Cadastro.hamlet")

getCadastroR :: Handler Html
getCadastroR = do
    (widget,_) <- generateFormPost (formCliente Nothing)
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/Cadastro.cassius")
        $(whamletFile "templates/Cadastro.hamlet")

postClienteR :: Handler Html
postClienteR = do
    ((result,_),_) <- runFormPost (formCliente Nothing)
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

getEditarCliR :: ClienteId -> Handler Html
getEditarCliR cid = do
    cliente <- runDB $ get404 cid
    (widget,_) <- generateFormPost (formCliente (Just cliente))
    msg <- getMessage
    defaultLayout $ (formWidget "Editar" widget (EditarCliR cid) msg)

postEditarCliR :: ClienteId -> Handler Html
postEditarCliR cid = do
    clienteAntigo <- runDB $ get404 cid
    ((result,_),_) <- runFormPost (formCliente Nothing)
    case result of
        FormSuccess novoCliente -> do
            runDB $ replace cid novoCliente
            redirect ClientesPageR
        _ -> redirect ClientesPageR

postApagarCliR :: ClienteId -> Handler Html
postApagarCliR cid = do
    runDB $ delete cid
    redirect ClientesPageR

formWidget :: Text -> Widget -> Route App -> Maybe Html -> Widget
formWidget title widget route errorMsg = $(whamletFile "templates/ClienteForm.hamlet")