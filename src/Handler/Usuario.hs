{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Usuario where

import Import
import Handler.Util

formLogin :: Form (Usuario, Text)
formLogin = renderDivs $ (,)
    <$> (Usuario
        <$> areq textField "Email: " Nothing
        <*> areq passwordField "CPF:  " Nothing)
    <*> areq passwordField "Confirmação: " Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ (formWidget "Cadastrar" widget UsuarioR msg)

postUsuarioR :: Handler Html
postUsuarioR = do
    ((result,_),_) <- runFormPost formLogin
    case result of
        FormSuccess (usuario@(Usuario email senha), conf) -> do
            usuarioExiste <- runDB $ getBy (UniqueEmail2 email)
            case usuarioExiste of
                Just _ -> do
                    setMessage [shamlet|
                        <div>
                            E-mail já cadastrado!
                    |]
                    redirect UsuarioR
                Nothing -> do
                    if senha == conf then do
                        runDB $ insert usuario
                        setMessage [shamlet|
                            <div>
                                Usuário inserido com sucesso!
                        |]
                        redirect UsuarioR
                    else do
                        setMessage [shamlet|
                            <div>
                                Credenciais inválidas!
                        |]
                        redirect UsuarioR
        _ -> redirect HomeR

postSairR :: Handler Html
postSairR = do
    deleteSession "_ID"
    redirect HomeR