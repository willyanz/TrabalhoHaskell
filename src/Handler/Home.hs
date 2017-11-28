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

-- home de acordo com o tipo de usuario
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
        <h1> Coisas de funcionario
        <h1> _{MsgBemvindo} - 
                    <br>
                    
                    <li> <a href=@{ResponsavelR}> Responsáveis 
                    <li> <a href=@{EmbarcacaoR}> Embarcações
                    <li> <a href=@{MarinheiroR}> Marinheiro
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