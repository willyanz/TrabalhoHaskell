{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Home where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do
    logado <- lookupLogin
    logado' <- lookupSession logado
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
            ^{home logado} 
            <ul>    
                $maybe logar <- logado'
               
                     <li> 
                         <form action=@{LogoutR} method=post>
                             <input type="submit" value="Logout">
                $nothing
                    <li> <a href=@{LoginR}> Login
        
        |]
      
--home de acordo com o tipo de usuario
home :: Text -> Widget
home "_Adm" = 
    [whamlet|
        <h1> Coisas de ADM
        <h1> _{MsgBemvindo} - Adm 
            <br>
            <li> <a href=@{FuncionarioR}> Funcionarios
    |]
home "_Funcionario" =
    [whamlet|
                <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                            <a class="navbar-brand" href="">Scale Service
                            <a class="navbar-brand" href="">Adm
                        <div id="navbar" class="navbar-collapse collapse">
                            <form class="navbar-form navbar-right">
                                <div class="form-group">
                                <div class="form-group">
                                
                                
                <div class="jumbotron">
                    <div class="container">
                        <h1>TECH PARSE
                        <p>Empresa de tecnologia voltada para o desenvolvimento de Softwares e aplicativos Mobile
                        <a class="btn btn-primary btn-lg" href="Index.html" role="button">Saiba Mais »
                <div class="container">
                    <div class="col-md-4">
                        <h2>Marinheiros
                        <p>Gerenciamento de Seus Colabores e Embarcacoes
                        <a class="btn btn-default" href=@{MarinheiroR} role="button">Saiba Mais »
                    <div class="col-md-4">
                        <h2>Embarcacoes
                        <p>Cadastro e Controle de Embarcacoes
                        <a class="btn btn-default" href=@{EmbarcacaoR} role="button">Saiba Mais»
                    <div class="col-md-4">
                        <h2>Colaboradores
                        <p>Controle de suas viagens e tenha um melhor gerenciamento
                        <a class="btn btn-default" href=@{ResponsavelR} role="button">Saiba Mais »
                <footer>
                    <center><p>© 2016 Tech Parse, LTDA.
      
    
        

    |]
home "_Responsavel" =
    [whamlet|
        <h1> Coisas de responsável
            <li> <a href=@{ListarEmbarcacaoR}> Minhas Embarcações
    |]
home "_Marinheiro" =
    [whamlet|
        <h1> Coisas de marinheiro
    |]
home _ = 
    [whamlet|
        <h1> Coisas de visitante
    |]