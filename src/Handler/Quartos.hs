{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes #-}
module Handler.Quartos where

import Import
import Text.Cassius
import Handler.Util

formQuarto :: Form Quarto
formQuarto = renderDivs $ Quarto
    <$> areq textField "Nome: "  Nothing
    <*> areq textField "Desc:  "  Nothing
    <*> areq doubleField  "Preço: " Nothing
    
getQuartoR :: Handler Html
getQuartoR = do
    (widget,_) <- generateFormPost formQuarto
    msg <- getMessage
    defaultLayout $ do
        addStylesheet (StaticR css_bootstrap_css)
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/components/Form.cassius")
        toWidget navWidget
        $(whamletFile "templates/quarto/Cadastro.hamlet")
        toWidget footerWidget

postQuartoR :: Handler Html
postQuartoR = do
    ((result,_),_) <- runFormPost formQuarto
    case result of
        FormSuccess quarto -> do
            _ <- runDB $ insert quarto
            setMessage [shamlet|
                <div>
                    #{quartoNome quarto} inserido com sucesso!
            |]
            redirect QuartoR
        _ -> redirect QuartosR

getQuartosR :: Handler Html
getQuartosR = do
    quartos <- runDB $ selectList [] [Asc QuartoNome]
    usuario <- lookupSession "_ID"
    a <- lookupSession "_ID"
    defaultLayout $ do 
        addStylesheet (StaticR css_bootstrap_css)
        setTitle "Quartos" 
        toWidgetHead $(cassiusFile "templates/Padrao.cassius")
        toWidgetHead $(cassiusFile "templates/quarto/Quartos.cassius")
        toWidget navWidget
        $(whamletFile "templates/quarto/Quartos.hamlet")
        toWidget footerWidget

postApagarQuartoR :: QuartoId -> Handler Html
postApagarQuartoR id = do
    runDB $ delete id
    redirect QuartosR
