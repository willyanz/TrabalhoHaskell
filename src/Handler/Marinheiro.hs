{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Marinheiro where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql


formMarinheiro :: Form Marinheiro
formMarinheiro = renderBootstrap $ Marinheiro
    <$> areq textField     "Nome: " Nothing 
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: "Nothing


getMarinheiroR :: Handler Html
getMarinheiroR = do
    defaultLayout $ do
    
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_ie10viewportbugworkaround_css)
        addStylesheet $ (StaticR css_jumbotron_css)
        addScript (StaticR js_ieemulationmodeswarning_js)
        addScript (StaticR js_bootstrap_min_js)
       
        
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
        
                <li> <a href=@{CadastrarMarinheiroR}>  Cadastrar Marinheiro
                <li> <a href=@{ListarMarinheiroR}>  Listar Marinheiro
                <li> <a href=@{HomeR}> Home
    |]


getCadastrarMarinheiroR :: Handler Html
getCadastrarMarinheiroR = do
    (widget, enctype) <- generateFormPost formMarinheiro
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_signin_css)
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
        
        <div class="container">
            <form class="form-signin">
                <h2 class="form-signin-heading">Cadastre - Se
                <form class="sign-in" action=@{CadastrarMarinheiroR} method=post >
                    ^{widget}
                        <button class="btn btn-lg btn-primary btn-block" type="submit">Cadastre se
                
                
            
        |]

postCadastrarMarinheiroR :: Handler Html
postCadastrarMarinheiroR = do 
    ((res,_),_) <- runFormPost formMarinheiro
    case res of 
        FormSuccess marinheiro -> do
            _ <- runDB $ insert marinheiro
            redirect MarinheiroR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarMarinheiroR
 

getListarMarinheiroR :: Handler Html
getListarMarinheiroR = undefined

putEditarMarinheiroR :: MarinheiroId -> Handler Html
putEditarMarinheiroR = undefined

getBuscarMarinheiroR :: MarinheiroId -> Handler Html
getBuscarMarinheiroR = undefined

postExcluirMarinheiroR :: MarinheiroId -> Handler Html
postExcluirMarinheiroR = undefined