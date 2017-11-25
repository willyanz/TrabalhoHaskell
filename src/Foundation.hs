{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE ViewPatterns #-}

module Foundation where

import Import.NoFoundation
import Database.Persist.Sql (ConnectionPool, runSqlPool)
import Yesod.Core.Types     (Logger)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static 
    , appConnPool    :: ConnectionPool 
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }

mkMessage "App" "Message" "pt-BR"

mkYesodData "App" $(parseRoutesFile "config/routes")

type Form a = Html -> MForm Handler (FormResult a, Widget)

instance Yesod App where
    makeLogger = return . appLogger
    authRoute _ = Just $ LoginR
    isAuthorized HomeR _ = return Authorized
    isAuthorized LoginR _ = return Authorized
    isAuthorized LogoutR _ = return Authorized
    isAuthorized FuncionarioR _ = ehAdm
    isAuthorized MarinheiroR _ = ehFuncionario
    isAuthorized ResponsavelR _ = ehFuncionario
    isAuthorized EmbarcacaoR _ = ehFuncionario
    isAuthorized _ _ = return Authorized
    
ehFuncionario :: Handler AuthResult
ehFuncionario = do
    sessao <- lookupSession "_Funcionario"
    case sessao of 
        Nothing -> return AuthenticationRequired
        (Just _) -> return Authorized
        
ehAdm :: Handler AuthResult
ehAdm = do
    sessao <- lookupSession "_Adm"
    case sessao of 
        Nothing -> return AuthenticationRequired
        (Just _) -> return Authorized

        
instance YesodPersist App where
    type YesodPersistBackend App = SqlBackend
    runDB action = do
        master <- getYesod
        runSqlPool action $ appConnPool master

instance RenderMessage App FormMessage where
    renderMessage _ _ = defaultFormMessage

instance HasHttpManager App where
    getHttpManager = appHttpManager

-- verifica o tipo de usuario logado
lookupLogin :: Handler Text
lookupLogin = do
    logf <- lookupSession "_Funcionario"
    case logf of
        (Just _) -> return "_Funcionario"
        Nothing -> do 
           logr <- lookupSession "_Responsavel"
           case logr of
                (Just _) -> return "_Responsavel"
                Nothing -> do
                    logadm <- lookupSession "_Adm"
                    case logadm of
                        (Just _) -> return "_Adm"
                        Nothing -> return "_Visitante"