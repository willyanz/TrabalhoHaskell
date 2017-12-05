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
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_jumbotron_css)
        
        addScript (StaticR js_ieemulationmodeswarning_js)
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            .btn_logout
            {
                float:right;
                margin-top:8px;
            }
        |]
        [whamlet|   
            ^{home logado} 
            
                
        
        |]
      
--home de acordo com o tipo de usuario
home :: Text -> Widget
home "_Adm" = 
    [whamlet|
         <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                                <span class="icon-bar">
                            <form action=@{LogoutR} method=post>
                                <button type="submit" value="" class="btn btn-danger btn_logout">
                                    Logout
                                    <span class="glyphicon glyphicon-remove" aria-hidden="true">
                        <div id="navbar" class="navbar-collapse collapse">
                            <form class="navbar-form navbar-right">
                                <div class="form-group">
                                <div class="form-group">
                                
                                
         <div class="jumbotron">
             <div class="container">
                 <h1>Seja Bem Vindo A Venesa Santista
                 <p>Sistema de Controle De Travessias
        <div class="container">
             <div class="col-md-4">
                <h2>Funcionários
                <p>Gerencie Funcionários 
                <a class="btn btn-default" href=@{FuncionarioR} role="button">Saiba Mais »
        <footer>
            <center><p>© Garcia lindo
                    
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
                    <form action=@{LogoutR} method=post>
                        <button type="submit" value="" class="btn btn-danger btn_logout">
                            Logout
                <div id="navbar" class="navbar-collapse collapse">
                    <form class="navbar-form navbar-right">
                        <div class="form-group">
                        <div class="form-group">
                        
                        
        <div class="jumbotron">
            <div class="container">
                <h1>Seja Bem Vindo A Venesa Santista
                <p>Sistema de Controle De Travessias
        <div class="container">
            <div class="col-md-4">
                <h2>Marinheiros
                <p>Veja em qual embarcação esta habilitado
                <a class="btn btn-default" href=@{MarinheiroR} role="button">Saiba Mais »
            <div class="col-md-4">
                <h2>Embarcações
                <p>Gerencia suas Viagens
                <a class="btn btn-default" href=@{EmbarcacaoR} role="button">Saiba Mais»
            <div class="col-md-4">
                <h2>Responsáveis
                <p>Contato direto com Responsáveis pelas Embarcações
                <a class="btn btn-default" href=@{ResponsavelR} role="button">Saiba Mais »
        <footer>
            <center><p>© Garcia lindo

    
        

    |]
home "_Responsavel" =
    [whamlet|
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                        <form action=@{LogoutR} method=post>
                            <button type="submit" value="" class="btn btn-danger btn_logout">
                                Logout
                    <div id="navbar" class="navbar-collapse collapse">
                        <form class="navbar-form navbar-right">
                            <div class="form-group">
                            <div class="form-group">
                                
                                
        <div class="jumbotron">
            <div class="container">
                <h1>Seja Bem Vindo A Venesa Santista
                <p>Sistema de Controle De Travessias
        <footer>
            <center><p>© Garcia lindo
    |]
home "_Marinheiro" =
    [whamlet|
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                        <form action=@{LogoutR} method=post>
                            <button type="submit" value="" class="btn btn-danger btn_logout">
                                Logout
                    <div id="navbar" class="navbar-collapse collapse">
                        <form class="navbar-form navbar-right">
                            <div class="form-group">
                            <div class="form-group">
                                
                                
        <div class="jumbotron">
            <div class="container">
                <h1>Seja Bem Vindo A Venesa Santista
                <p>Sistema de Controle De Travessias da Catraia
        
        <footer>
            <center><p>>© Garcia lindo
    |]
home _ = 
    [whamlet|
        <nav class="navbar navbar-inverse navbar-fixed-top">
            <div class="container">
                    <div class="navbar-header">
                        <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                            <span class="icon-bar">
                        <a class="navbar-brand" href=@{LoginR}>Login
                    <div id="navbar" class="navbar-collapse collapse">
                        <form class="navbar-form navbar-right">
                            <div class="form-group">
                            <div class="form-group">
                                
                                
        <div class="jumbotron">
            <div class="container">
                <h1>Seja Bem Vindo A Venesa Santista
                <p>Sistema de Controle De Travessias
      
        <footer>
            <center><p>© Garcia lindo
    
    |]