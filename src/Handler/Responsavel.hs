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
        [whamlet|
            
            <h1> Responsavel
            <ul>
                <li> <a href=@{CadastrarResponsavelR}>  Cadastrar Responsavel
                <li> <a href=@{ListarResponsavelR}>  Listar Responsavel
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro utilizando o form criado acima
getCadastrarResponsavelR :: Handler Html
getCadastrarResponsavelR = do 
    (widget,enctype) <- generateFormPost formResponsavel
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
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

getListarResponsavelR :: Handler Html
getListarResponsavelR = undefined

putEditarResponsavelR :: ResponsavelId -> Handler Html
putEditarResponsavelR = undefined

getBuscarResponsavelR :: ResponsavelId -> Handler Html
getBuscarResponsavelR = undefined

postExcluirResponsavelR :: ResponsavelId -> Handler Html
postExcluirResponsavelR = undefined