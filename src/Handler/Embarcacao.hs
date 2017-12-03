{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Embarcacao where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

-- formulário de cadastro de Embarcacao
formEmbarcacao :: Form Embarcacao
formEmbarcacao = renderBootstrap $ Embarcacao 
    <$> areq intField     "Nº de inscrição: " Nothing
    <*> areq (selectField $ optionsPersistKey [] [] responsavelNm_responsavel)  "Responsavel: " Nothing
    <*> areq textField "Nome da Embarcação: " Nothing

getEmbarcacaoR :: Handler Html
getEmbarcacaoR = do
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
                        <p>Embarcações, escolha o que deseja fazer
                        <a class="btn btn-primary btn-lg" href="" role="button">Saiba Mais »
                <div class="container">
                    <div class="col-md-4">
                        <h2>Cadastrar Embarcações
                        <p>Cadastre novas embarcações e vincule-as a um responsável
                        <a class="btn btn-default" href=@{CadastrarEmbarcacaoR} role="button">Saiba Mais »
                    <div class="col-md-4">
                        <h2>Listar Embarcações
                        <p>Veja todas as embarcações cadastradas no Sistema.
                        <a class="btn btn-default" href=@{ListarEmbarcacaoR} role="button">Saiba Mais»
                    <div class="col-md-4">
                        <h2>Desligamento
                        <p>Desative Embarcações do sistema.
                        <a class="btn btn-default" href="" role="button">Saiba Mais »
                <footer>
                    <center><p>© Garcia lindo
      
    
        

        |]
       



-- preenchimento de formulario para cadastro utilizando o form criado acima
getCadastrarEmbarcacaoR :: Handler Html
getCadastrarEmbarcacaoR = do 
    (widget,enctype) <- generateFormPost formEmbarcacao
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <li>
            <div class="container">

                <h2 class="form-signin-heading">Cadastrar Embarcação
                <form class="sign-in" action=@{CadastrarEmbarcacaoR} method=post >
                    ^{widget}
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
               
        |]


-- inclusao do formulario preenchido no banco
postCadastrarEmbarcacaoR :: Handler Html
postCadastrarEmbarcacaoR = do 
    ((res,_),_) <- runFormPost formEmbarcacao
    case res of 
        FormSuccess mari -> do
            _ <- runDB $ insert mari
            redirect EmbarcacaoR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarEmbarcacaoR

getListarEmbarcacaoR :: Handler Html
getListarEmbarcacaoR = undefined

getBuscarEmbarcacaoR :: EmbarcacaoId -> Handler Html
getBuscarEmbarcacaoR = undefined

putEditarEmbarcacaoR :: EmbarcacaoId -> Handler Html
putEditarEmbarcacaoR = undefined

postExcluirEmbarcacaoR :: EmbarcacaoId -> Handler Html
postExcluirEmbarcacaoR = undefined