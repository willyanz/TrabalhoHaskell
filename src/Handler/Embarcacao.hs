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
formEmbarcacao = renderDivs $ Embarcacao 
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
            <h1> Embarcações
            <ul>
                <li> <a href=@{CadastrarEmbarcacaoR}>  Cadastrar Embarcação
                <li> <a href=@{ListarEmbarcacaoR}>  Listar Embarcação
                <li> <a href=@{HomeR}>  Home
        |]
       



-- preenchimento de formulario para cadastro utilizando o form criado acima
getCadastrarEmbarcacaoR :: Handler Html
getCadastrarEmbarcacaoR = do 
    (widget,enctype) <- generateFormPost formEmbarcacao
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addScript (StaticR js_bootstrap_min_js)
        [whamlet|
            <li> <a href=@{EmbarcacaoR}>  Voltar
            <form action=@{CadastrarEmbarcacaoR} method=post>
                ^{widget}
                <input type="submit" value="Cadastrar">
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