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
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <h1> Funcionarios
            
                {--<li> <a href=@{CadastrarMarinheiroR}>  Cadastrar Marinheiro
                <li> <a href=@{ListarMarinheiroR}>  Listar Marinheiro
                <li> <a href=@{HomeR}>  Home--}
                <nav class="navbar navbar-inverse navbar-fixed-top">
                 <div class="container">
                 <div class="navbar-header">
                 <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                 <span class="sr-only">Toggle navigation
                 <span class="icon-bar">
                 <span class="icon-bar">
                 <span class="icon-bar">
                 <a class="navbar-brand" href="">Scale Service
        
                 <div id="navbar" class="navbar-collapse collapse">
                 <form class="navbar-form navbar-right">
                 <div class="form-group">
            
                 <div class="form-group">


                 <div class="jumbotron">
                 <div class="container">
                 <h1>TECH PARSE
                 <p>Empresa de tecnologia voltada para o desenvolvimento de Softwares e aplicativos Mobile
                 <p><a class="btn btn-primary btn-lg" href="Index.html" role="button">Saiba Mais »
      
               
    

        |]


getCadastrarMarinheiroR :: Handler Html
getCadastrarMarinheiroR = do
    (widget, enctype) <- generateFormPost formMarinheiro
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <li> <a href=@{MarinheiroR}>  Voltar
            <form action=@{CadastrarMarinheiroR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
            
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