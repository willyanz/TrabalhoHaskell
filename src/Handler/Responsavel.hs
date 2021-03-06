{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Responsavel where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Responsavel
formResponsavel :: Form Responsavel
formResponsavel = renderBootstrap $ Responsavel 
    <$> areq textField     "Nome: " Nothing
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

getResponsavelR :: Handler Html
getResponsavelR = do
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        $(whamletFile "templates/Responsavel.hamlet")

-- preenchimento de formulario para cadastro utilizando o form criado acima
getCadastrarResponsavelR :: Handler Html
getCadastrarResponsavelR = do 
    (widget,enctype) <- generateFormPost formResponsavel
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                            <a class="navbar-brand" href=@{HomeR}>Home
                        <div id="navbar" class="navbar-collapse collapse">
                            <form class="navbar-form navbar-right">
                                <div class="form-group">
                                <div class="form-group">
            <div class="container">

                <h2 class="form-signin-heading">Cadastrar Responsavel
                <form class="sign-in" action=@{CadastrarResponsavelR} method=post >
                    ^{widget}
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
            
        |]

-- inclusao do formulario preenchido no banco
postCadastrarResponsavelR :: Handler Html
postCadastrarResponsavelR = do 
    ((res,_),_) <- runFormPost formResponsavel
    case res of 
        FormSuccess resp -> do
            _ <- runDB $ insert resp
            redirect ResponsavelR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarResponsavelR


-- Listagem de responsavel

getListarResponsavelR :: Handler Html
getListarResponsavelR = do 
    responsaveis <- runDB $ selectList [] [Asc ResponsavelNm_responsavel]
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        $(whamletFile "templates/ResponsavelLista.hamlet")

getEditarResponsavelR :: ResponsavelId -> Handler Html
getEditarResponsavelR = undefined


postEditarResponsavelR :: ResponsavelId -> Handler Html
postEditarResponsavelR = undefined

postBuscarResponsavelR :: Handler Html
postBuscarResponsavelR = undefined



-- exclusao de responsavel
postExcluirResponsavelR :: ResponsavelId -> Handler Html
postExcluirResponsavelR rid = do 
    _ <- runDB $ get404 rid
    runDB $ delete rid
    redirect ListarResponsavelR
    
