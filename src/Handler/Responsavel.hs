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
                        <p>Responsáveis, escolha o que deseja fazer
                        <a class="btn btn-primary btn-lg" href="" role="button">Saiba Mais »
                <div class="container">
                    <div class="col-md-4">
                        <h2>Cadastrar Responsáveis
                        <p>Cadastre novos Responsáveis e vincule-as a uma Embarcação ou mais.
                        <a class="btn btn-default" href=@{CadastrarResponsavelR} role="button">Saiba Mais »
                    <div class="col-md-4">
                        <h2>Listar Responsáveis
                        <p>Veja todos os Responsáveis cadastrados no Sistema.
                        <a class="btn btn-default" href=@{ListarResponsavelR} role="button">Saiba Mais»
                    <div class="col-md-4">
                        <h2>Desligamento
                        <p>Desative Responsáveis do sistema.
                        <a class="btn btn-default" href="" role="button">Saiba Mais »
                <footer>
                    <center><p>© Garcia lindo
      
            
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


-- Listagem de responsavel

getListarResponsavelR :: Handler Html
getListarResponsavelR = do 
    responsaveis <- runDB $ selectList [] [Asc ResponsavelNm_responsavel]
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <table>
                <thead>
                    <tr>
                        <td> Id
                        <td> Nome 
                        <td> Email 
                        <td> 
                
                <tbody>
                    $forall (Entity rid responsavel) <- responsaveis
                        <tr> 
                            <td> #{fromSqlKey rid}
                            <td> #{responsavelNm_responsavel responsavel}
                            <td> #{responsavelEmailr responsavel}
                            <td> 
                                <form action=@{EditarResponsavelR rid} method=post>
                                    <input type="submit" value="Trocar Senha">
                            <td>
                                <form action=@{ExcluirResponsavelR rid} method=post>
                                    <input type="submit" value="Deletar">
                            
        |]

putEditarResponsavelR :: ResponsavelId -> Handler Html
putEditarResponsavelR = undefined

getBuscarResponsavelR :: ResponsavelId -> Handler Html
getBuscarResponsavelR = undefined

postExcluirResponsavelR :: ResponsavelId -> Handler Html
postExcluirResponsavelR = undefined