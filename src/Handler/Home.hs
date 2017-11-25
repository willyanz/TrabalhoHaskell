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
    logado <- lookupLogin >>= lookupSession
    defaultLayout $ do
        toWidget [lucius|
            li {
                display: inline-block;
                list-style:  none;
            }
            
        |]
        [whamlet|
            $maybe logadof <- logado
                <h1> _{MsgBemvindo} - #{logadof}
                    <br>
                    <li> <a href=@{FuncionarioR}>  Funcionarios
                    <li> <a href=@{ResponsavelR}> Responsáveis
                    <li> <a href=@{EmbarcacaoR}> Embarcações
            $nothing
                <h1> _{MsgBemvindo} - _{MsgVisita}
            <ul>
                
                $maybe func <- logado
                    <li> 
                        <form action=@{LogoutR} method=post>
                            <input type="submit" value="Logout">
                $nothing
                    <li> <a href=@{LoginR}> Login
        |]
        
lookupLogin :: Handler Text
lookupLogin = do
    logf <- lookupSession "_Funcionario"
    case logf of
        (Just _) -> return "_Funcionario"
        Nothing -> do 
           logr <- lookupSession "_Responsavel"
           case logr of
                (Just _) -> return "_Responsavel"
                Nothing -> return "_Visitante"