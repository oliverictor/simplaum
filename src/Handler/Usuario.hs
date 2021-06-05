{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Usuario where

import Import
import Text.Cassius
import Handler.Util

formLogin :: Form (Usuario, Text)
formLogin = renderDivs $ (,)
    <$> (Usuario
        <$> areq textField (FieldSettings "E-mail: "
            (Just "E-mail do usuário") (Just "email") Nothing [("class","ml-2")]
        ) Nothing
        <*> areq passwordField (FieldSettings "Senha:  "
            (Just "Senha do usuário") (Just "senha") Nothing [("class","ml-2")]
        ) Nothing
    )
    <*> areq passwordField (FieldSettings "Confirmação: "
        (Just "Confirmação") (Just "confirm") Nothing [("class","ml-2")]
    ) Nothing

getUsuarioR :: Handler Html
getUsuarioR = do
    (widget,_) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/components/Form.cassius")
        navWidget
        formWidget "Cadastrar" widget UsuarioR msg
        toWidget footerWidget

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
                        _ <- runDB $ insert usuario
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