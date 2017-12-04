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
        $(whamletFile "templates/Embarcacao.hamlet")
       



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


-- listar embarcações
getListarEmbarcacaoR :: Handler Html
getListarEmbarcacaoR = undefined
{-
do 
    embarcacoes <- runDB $ selectList [] [Asc EmbarcacaoNm_embarcacao]
    defaultLayout $ do 
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <table>
                <thead>
                    <tr>
                        <td> Id
                        <td> Número deInscrição 
                        <td> Responsável 
                        <td> Nome
                        <td>
                
                <tbody>
                    $forall (Entity eid embarcacao) <- embarcacoes
                        <tr> 
                            <td> #{fromSqlKey eid}
                            <td> #{embarcacaoInscricao embarcacao}
                            <td> #{embarcacaoResid embarcacao}
                            <td> #{embarcacaoNm_embarcacao embarcacao}
                            <td>
                                
                            <td>
                                <form action=@{ExcluirEmbarcacaoR eid} method=post>
                                    <input type="submit" value="Deletar">
                            
        |]
-}

getBuscarEmbarcacaoR :: EmbarcacaoId -> Handler Html
getBuscarEmbarcacaoR = undefined


postExcluirEmbarcacaoR :: EmbarcacaoId -> Handler Html
postExcluirEmbarcacaoR eid = do 
    _ <- runDB $ get404 eid
    runDB $ delete eid
    redirect ListarEmbarcacaoR