{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Login where

import Import
import Database.Persist.Postgresql

-- formulario de login
formLogin :: Form (Text, Text)
formLogin = renderDivs $ (,)
    <$> areq emailField "Email: " Nothing
    <*> areq passwordField "Senha: " Nothing

-- funcao de autentificaçao
autenticar :: Text -> Text -> HandlerT App IO (Maybe (Entity Funcionario))
autenticar email senha = runDB $ selectFirst [FuncionarioEmailf ==. email
                                             ,FuncionarioSenhaf ==. senha] []

-- executa o formulario recebendo os dados de login
getLoginR :: Handler Html
getLoginR = do 
    (widget,enctype) <- generateFormPost formLogin
    msg <- getMessage
    defaultLayout $ do 
        [whamlet|
            $maybe mensa <- msg 
                <h1> Usuario Invalido
            <form action=@{LoginR} method=post>
                ^{widget}
                <input type="submit" value="Login">  
        |]

-- autentifica os dados recebidos pelo form 
postLoginR :: Handler Html
postLoginR = do
    ((res,_),_) <- runFormPost formLogin -- recebe a resposta do form
    case res of 
        FormSuccess (email,senha) -> do 
            func <- autenticar email senha -- pega a resposta do form, executa o autenticar
            case func of 
                Nothing -> do -- se a autentificaçao falhar
                    setMessage $ [shamlet| Usuario ou senha invalido |]
                    redirect LoginR 
                Just (Entity funcid func) -> do -- se a autentificaçao for sucesso
                    setSession "_Funcionario" (funcionarioNm_funcionario func)
                    redirect HomeR
        _ -> redirect HomeR
                
-- desloga da sessao devolvendo pra home
postLogoutR :: Handler Html
postLogoutR = do 
    deleteSession "_Funcionario"
    redirect HomeR