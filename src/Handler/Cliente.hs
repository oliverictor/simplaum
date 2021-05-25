{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Cliente where

import Import

formCliente :: Form Cliente
formCliente = renderDivs $ Cliente 
    <$> areq textField "Nome: "  Nothing 
    <*> areq textField "Cpf:  "  Nothing
    <*> areq intField  "Idade: " Nothing
    
getClienteR :: Handler Html
getClienteR = do
    (widget,_) <- generateFormPost formCliente
    msg <- getMessage
    defaultLayout $ do
        [whamlet|
            $maybe mensa <- msg
                <div>
                    ^{mensa}
            
            <form method=post action=@{ClienteR}>
                ^{widget}
                <input type="submit" value="Cadastrar">
        |]

postClienteR :: Handler Html
postClienteR = do
    ((result,_),_) <- runFormPost formCliente
    case result of
        FormSuccess cliente -> do
            runDB $ insert cliente
            setMessage [shamlet|
                <div>
                    CLIENTE INSERIDO COM SUCESSO!
            |]
            redirect ClienteR
        _ -> redirect HomeR
    
-- /cliente/perfil/#ClienteId PerfilR GET
-- /clientes ListaCliR GET
-- /cliente/#ClienteId/apagar ApagarCliR POST

-- faz um select * from cliente where id = cid 
-- Se falhar mostra uma pagina de erro.
-- /cliente/perfil/1 => cid = 1
getPerfilR :: ClienteId -> Handler Html
getPerfilR cid = do
    cliente <- runDB $ get404 cid
    defaultLayout [whamlet|
        <h1>
            Perfil de #{clienteNome cliente}
        <h2>
            Cpf: #{clienteCpf cliente}
        <h2>
            Idade: #{clienteIdade cliente}
    |]

getListaCliR :: Handler Html
getListaCliR = do
    -- clientes = [Entity 1 (Cliente "Teste" "..." 45), Entity 2 (Cliente "Teste2" "..." 18), ...]
    clientes <- runDB $ selectList [] [Asc ClienteNome]
    defaultLayout $(whamletFile "templates/Cliente.hamlet")

-- delete from cliente where id = cid
postApagarCliR :: ClienteId -> Handler Html
postApagarCliR cid = do
    runDB $ delete cid
    redirect ListaCliR


   
