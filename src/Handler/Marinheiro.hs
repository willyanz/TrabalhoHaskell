{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Marinheiro where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql


formMarinheiro :: Form Marinheiro
formMarinheiro = renderBootstrap $ Marinheiro
    <$> areq textField     "Nome: " Nothing 
    <*> areq emailField    "Email: " Nothing
    <*> areq passwordField "Senha: "Nothing
    
formBusca :: Form Text
formBusca = renderBootstrap $ 
    areq (searchField True) "Marinheiro" Nothing



getMarinheiroR :: Handler Html
getMarinheiroR = do
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
        $(whamletFile "templates/Marinheiro.hamlet")
        


getCadastrarMarinheiroR :: Handler Html
getCadastrarMarinheiroR = do
    (widget, enctype) <- generateFormPost formMarinheiro
    defaultLayout $ do
        addStylesheet $ (StaticR css_bootstrap_min_css)
        addStylesheet $ (StaticR css_signin_css)
        addScript (StaticR js_bootstrap_min_js)
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            <li> 
                <a href=@{HomeR}>  Voltar
            <div class="container">

                <h2 class="form-signin-heading">Cadastrar Maarinheiro
                <form class="sign-in" action=@{CadastrarMarinheiroR} method=post >
                    ^{widget}
                    <button class="btn btn-lg btn-primary btn-block" type="submit">Concluir
                
                
            
        |]

postCadastrarMarinheiroR :: Handler Html
postCadastrarMarinheiroR = do 
    ((res,_),_) <- runFormPost formMarinheiro
    case res of 
        FormSuccess marinheiro -> do
            _ <- runDB $ insert marinheiro
            redirect MarinheiroR
        _ -> do
            setMessage $ [shamlet| Falha no Cadastro |]
            redirect CadastrarMarinheiroR
 



getListarMarinheiroR :: Handler Html
getListarMarinheiroR = do 
    marin <- runDB $ selectList [] [] :: Handler [Entity Marinheiro]
    (searchWidget, enctype) <- generateFormPost formBusca
    defaultLayout $ do 
         addStylesheet $ (StaticR css_bootstrap_min_css)
         addScript (StaticR js_bootstrap_min_js)
         $(whamletFile "templates/MarinheiroLista.hamlet")


getEditarMarinheiroR :: MarinheiroId -> Handler Html
getEditarMarinheiroR = undefined

postEditarMarinheiroR :: MarinheiroId -> Handler Html
postEditarMarinheiroR = undefined

postBuscarMarinheiroR :: Handler Html
postBuscarMarinheiroR = do
    ((res, _), _) <- runFormPost formBusca  
    case res of
        FormSuccess mid -> do
            marinheiros <- runDB $ selectList [Filter MarinheiroNm_marinheiro (Left $ concat ["%",mid,"%"]) (BackendSpecificFilter "ILIKE")] []
            defaultLayout $ do
                addStylesheet $ (StaticR css_bootstrap_min_css)
                addScript (StaticR js_bootstrap_min_js)
                $(whamletFile "templates/MarinheiroBusca.hamlet")
               
        _ -> do
            setMessage $ [shamlet| Marinheiro não encontrado |]
            redirect ListarMarinheiroR


-- exclusao de marinheiro

postExcluirMarinheiroR :: MarinheiroId -> Handler Html
postExcluirMarinheiroR mid = do 
    _ <- runDB $ get404 mid
    runDB $ delete mid
    redirect ListarMarinheiroR  
    