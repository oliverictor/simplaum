{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Login where

import Import
import Handler.Util

formLogin :: Form Usuario
formLogin = renderDivs $ Usuario
        <$> areq textField "E-mail: " Nothing
        <*> areq passwordField "Senha: " Nothing

getAuthR :: Handler Html
getAuthR = do
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ formWidget "Cadastrar" widget AuthR msg

postAuthR :: Handler Html
postAuthR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (Usuario email senha) -> do
            usuarioExiste <- runDB $ getBy (UniqueEmail2 email)
            case usuarioExiste of
                Nothing -> do
                    setMessage [shamlet|
                        Usuário não cadastrado
                    |]
                    redirect AuthR
                Just (Entity _ usuario) -> do
                    if senha == usuarioSenha usuario then do
                        setSession "_ID" (usuarioEmail usuario)
                        redirect HomeR
                    else do
                        setMessage [shamlet|
                            Credenciais inválidas!
                        |]
                        redirect AuthR
        _ -> redirect HomeR 