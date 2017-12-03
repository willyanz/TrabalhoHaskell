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
                                
                                
                <div class="jumbotron">
                    <div class="container">
                        <h1>Venesa Santista
                        <p>Marinheiros, escolha o que deseja fazer
                        <a class="btn btn-primary btn-lg" href="" role="button">Saiba Mais »
                <div class="container">
                    <div class="col-md-4">
                        <h2>Cadastrar Marinheiros
                        <p>Cadastre novos Marinheiros e vincule-as a uma Embarcação ou mais.
                        <a class="btn btn-default" href=@{CadastrarMarinheiroR} role="button">Saiba Mais »
                    <div class="col-md-4">
                        <h2>Listar Marinheiros
                        <p>Veja todos os marinheiros cadastrados no Sistema.
                        <a class="btn btn-default" href=@{ListarMarinheiroR} role="button">Saiba Mais»
                    <div class="col-md-4">
                        <h2>Desligamento
                        <p>Desative Marinheiros do sistema.
                        <a class="btn btn-default" href="" role="button">Saiba Mais »
                <footer>
                    <center><p>© Garcia lindo
      
      
          
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
            <li> 
                <a href=@{HomeR}>  Voltar
            <div class="container">

                <h2 class="form-signin-heading">Cadastrar Maarinheiro
                <form class="sign-in" action=@{CadastrarMarinheiroR} method=post >
                    ^{widget}
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
                
                
            
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