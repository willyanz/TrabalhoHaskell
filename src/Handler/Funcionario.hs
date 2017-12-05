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
formSenha :: Maybe Funcionario -> Form Funcionario
formSenha funci = renderBootstrap $ Funcionario
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
        [whamlet|
            <h1> Funcionarios
            <ul>
                <li> <a href=@{CadastrarFuncionarioR}>  Cadastrar Funcionario
                <li> <a href=@{ListarFuncionarioR}>  Listar Funcionarios
                <li> <a href=@{HomeR}>  Home
        |]

-- preenchimento de formulario para cadastro de funcionarios utilizando o form criado acima
getCadastrarFuncionarioR :: Handler Html
getCadastrarFuncionarioR = do 
    (widget,enctype) <- generateFormPost formFuncionario
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <li> 
                <a href=@{FuncionarioR}>  Voltar
            <form action=@{CadastrarFuncionarioR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
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
        [whamlet|
            <a href=@{FuncionarioR}>  Voltar
            <form action=@{BuscarFuncionarioR} method=post>
                ^{searchWidget}
                <input type="submit" value="Buscar">
            <table>
                <thead>
                    <tr>
                        <td> Id
                        <td> Nome 
                        <td> Email 
                        <td> 
                
                <tbody>
                    $forall (Entity fid funcionario) <- funcionarios
                        <tr> 
                            <td> #{fromSqlKey fid}
                            <td> #{funcionarioNm_funcionario funcionario}
                            <td> #{funcionarioEmailf funcionario}
                            <td> 
                                <form action=@{EditarFuncionarioR fid} method=post>
                                    <input type="submit" value="Editar">
                            <td>
                                <form action=@{ExcluirFuncionarioR fid} method=post>
                                    <input type="submit" value="Deletar">
                            
        |]

-- alteração de senha
getEditarFuncionarioR :: FuncionarioId -> Handler Html
getEditarFuncionarioR fid = do 
    func <- runDB $ get fid
    (widget,enctype) <- generateFormPost $ formSenha func
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet| 
            <li> 
                <a href=@{ListarFuncionarioR}>  Voltar
                <form action=@{EditarFuncionarioR fid} method=post>
                    ^{widget}
                    <input type="submit" value="Alterar">
        |]
        
postEditarFuncionarioR :: FuncionarioId -> Handler Html
postEditarFuncionarioR fid = do 
    ((res,_),_) <- runFormPost $ formSenha Nothing

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
                [whamlet|
                <a href=@{FuncionarioR}>  Voltar
                <table>
                    <thead>
                        <tr>
                            <td> Id
                            <td> Nome 
                            <td> Email 
                            <td> 
                    
                    <tbody>
                        $forall (Entity fid funcionario) <- funcionarios
                            <tr> 
                                <td> #{fromSqlKey fid}
                                <td> #{funcionarioNm_funcionario funcionario}
                                <td> #{funcionarioEmailf funcionario}
                                <td> 
                                    <a href=@{EditarFuncionarioR fid}>Editar
                                        
                                <td>
                                    <form action=@{ExcluirFuncionarioR fid} method=post>
                                        <input type="submit" value="Deletar">
                                
                |]
        _ -> do
            setMessage $ [shamlet| Funcionário não encontrado |]
            redirect ListarFuncionarioR


-- exclusao de funcioanrios
postExcluirFuncionarioR :: FuncionarioId -> Handler Html
postExcluirFuncionarioR fid = do 
    _ <- runDB $ get404 fid
    runDB $ delete fid
    redirect ListarFuncionarioR