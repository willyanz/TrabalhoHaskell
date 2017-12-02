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

-- tipo criado para alteração de senha
data Senhaf = Senhaf {senhaf::Text} deriving Generic
instance ToJSON Senhaf where
instance FromJSON Senhaf where

-- formulário de cadastro de funcionarios
formFuncionario :: Form Funcionario
formFuncionario = renderBootstrap $ Funcionario 
    <$> areq textField     "Nome: " Nothing
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

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
                    $forall (Entity fid funcionario) <- funcionarios
                        <tr> 
                            <td> #{fromSqlKey fid}
                            <td> #{funcionarioNm_funcionario funcionario}
                            <td> #{funcionarioEmailf funcionario}
                            <td> 
                                <form action=@{EditarSFuncionarioR fid} method=post>
                                    <input type="submit" value="Trocar Senha">
                            <td>
                                <form action=@{ExcluirFuncionarioR fid} method=post>
                                    <input type="submit" value="Deletar">
                            
        |]

-- alteração de senha
patchEditarSFuncionarioR :: FuncionarioId -> Handler Html
patchEditarSFuncionarioR fid = do 
    _ <- runDB $ get404 fid
    novaSenha <- requireJsonBody :: Handler Senhaf
    runDB $ update fid [FuncionarioSenhaf =. (senhaf novaSenha)]
    sendStatusJSON noContent204 (object ["resp" .= ("Atualizado " ++ show (fromSqlKey fid))])

getBuscarFuncionarioR :: FuncionarioId -> Handler Html
getBuscarFuncionarioR = undefined

-- exclusao de funcioanrios
postExcluirFuncionarioR :: FuncionarioId -> Handler Html
postExcluirFuncionarioR fid = do 
    _ <- runDB $ get404 fid
    runDB $ delete fid
    redirect ListarFuncionarioR