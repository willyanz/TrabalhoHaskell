{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Funcionario where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql


-- formulário de cadastro de funcionarios
formFuncionario :: Form Funcionario
formFuncionario = renderBootstrap $ Funcionario 
    <$> areq textField     "Nome: " Nothing
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

-- formulário de edição    
formEditar :: Maybe Funcionario -> Form Funcionario
formEditar funci = renderBootstrap $ Funcionario
    <$> areq textField "Nome"   (funcionarioNm_funcionario  <$> funci)
    <*> areq emailField "Email"  (funcionarioEmailf <$> funci)
    <*> areq passwordField "Senha"  (funcionarioSenhaf <$> funci)

formBusca :: Form Text
formBusca = renderBootstrap $ 
    areq (searchField True) "Funcionario" Nothing

-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de funcionarios
getFuncionarioR :: Handler Html
getFuncionarioR = do
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        $(whamletFile "templates/Funcionario.hamlet")

-- preenchimento de formulario para cadastro de funcionarios utilizando o form criado acima
getCadastrarFuncionarioR :: Handler Html
getCadastrarFuncionarioR = do 
    (widget,enctype) <- generateFormPost formFuncionario
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_jumbotron_css)
        addScript (StaticR js_ieemulationmodeswarning_js)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <nav class="navbar navbar-inverse navbar-fixed-top">
                    <div class="container">
                        <div class="navbar-header">
                            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                <span class="icon-bar">
                            <a class="navbar-brand" href=@{FuncionarioR}>Voltar
                        <div id="navbar" class="navbar-collapse collapse">
                            <form class="navbar-form navbar-right">
                                <div class="form-group">
                                <div class="form-group">
            
            <div class="container">
                <center> 
                    
                    <form action=@{CadastrarFuncionarioR} method=post>
                        ^{widget}
                        <ul>
                        <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
        |]

-- inclusao do formulario preenchido no banco
postCadastrarFuncionarioR :: Handler Html
postCadastrarFuncionarioR = do 
    ((res,_),_) <- runFormPost formFuncionario
    case res of 
        FormSuccess func -> do
            _ <- runDB $ insert func
            redirect FuncionarioR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarFuncionarioR
 
-- listagem de funcionarios
getListarFuncionarioR :: Handler Html
getListarFuncionarioR = do 
    funcionarios <- runDB $ selectList [] [Asc FuncionarioNm_funcionario]
    (searchWidget, enctype) <- generateFormPost formBusca
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        $(whamletFile "templates/FuncionarioLista.hamlet")

-- alteração de senha
getEditarFuncionarioR :: FuncionarioId -> Handler Html
getEditarFuncionarioR fid = do 
    func <- runDB $ get fid
    (widget,enctype) <- generateFormPost $ formEditar func
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_jumbotron_css)
        addScript (StaticR js_ieemulationmodeswarning_js)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <nav class="navbar navbar-inverse navbar-fixed-top">
                        <div class="container">
                            <div class="navbar-header">
                                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                                    <span class="icon-bar">
                                <a class="navbar-brand" href=@{ListarFuncionarioR}>Voltar
                            <div id="navbar" class="navbar-collapse collapse">
                                <form class="navbar-form navbar-right">
                                    <div class="form-group">
                                    <div class="form-group">
                                    
            <div class="container">
                <center>
                    <form action=@{EditarFuncionarioR fid} method=post>
                        ^{widget}
                        <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
        |]
        
postEditarFuncionarioR :: FuncionarioId -> Handler Html
postEditarFuncionarioR fid = do 
    ((res,_),_) <- runFormPost $ formEditar Nothing

    case res of 
        FormSuccess func -> do
            _ <- runDB $ replace fid func
            redirect FuncionarioR
        _ -> do
            setMessage $ [shamlet| Erro |]
            redirect ListarFuncionarioR
  


postBuscarFuncionarioR :: Handler Html
postBuscarFuncionarioR = do
    ((res, _), _) <- runFormPost formBusca  
    case res of
        FormSuccess fid -> do
            funcionarios <- runDB $ selectList [Filter FuncionarioNm_funcionario (Left $ concat ["%",fid,"%"]) (BackendSpecificFilter "ILIKE")] []
            defaultLayout $ do
                addStylesheet $ (StaticR css_bootstrap_min_css)
                addScript (StaticR js_bootstrap_min_js)
                $(whamletFile "templates/FuncionarioBusca.hamlet")
               
        _ -> do
            setMessage $ [shamlet| Funcionário não encontrado |]
            redirect ListarFuncionarioR


-- exclusao de funcioanrios
postExcluirFuncionarioR :: FuncionarioId -> Handler Html
postExcluirFuncionarioR fid = do 
    _ <- runDB $ get404 fid
    runDB $ delete fid
    redirect ListarFuncionarioR