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
formFuncionario = renderDivs $ Funcionario 
    <$> areq textField     "Nome: " Nothing
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

-- pagina principal de acesso para cadastro, listagem, exclusao ou ediçao de funcionarios
getFuncionarioR :: Handler Html
getFuncionarioR = do
    defaultLayout $ do
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
        [whamlet|
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
 

getListarFuncionarioR :: Handler Html
getListarFuncionarioR = undefined

putEditarFuncionarioR :: FuncionarioId -> Handler Html
putEditarFuncionarioR = undefined

getBuscarFuncionarioR :: FuncionarioId -> Handler Html
getBuscarFuncionarioR = undefined

postExcluirFuncionarioR :: FuncionarioId -> Handler Html
postExcluirFuncionarioR = undefined