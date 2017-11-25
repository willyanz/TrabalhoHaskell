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
autenticarFunc :: Text -> Text -> HandlerT App IO (Maybe (Entity Funcionario))
autenticarFunc email senha = runDB $ selectFirst [FuncionarioEmailf ==. email
                                             ,FuncionarioSenhaf ==. senha] []
                                             
autenticarResp :: Text -> Text -> HandlerT App IO (Maybe (Entity Responsavel))
autenticarResp email senha = runDB $ selectFirst [ResponsavelEmailr ==. email
                                             ,ResponsavelSenhar ==. senha] []

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
        FormSuccess ("root@root.com","root") -> do 
            setSession "_Adm" "admin"
            redirect HomeR
        FormSuccess (email,senha) -> do 
            func <- autenticarFunc email senha -- pega a resposta do form, executa o autenticar
            case func of 
                Just (Entity funcid func) -> do -- se a autentificaçao for sucesso
                    setSession "_Funcionario" (funcionarioNm_funcionario func)
                    redirect HomeR
                Nothing -> do 
                    resp <- autenticarResp email senha
                    case resp of
                        Just (Entity respid resp) -> do -- se a autentificaçao for sucesso
                            setSession "_Responsavel" (responsavelNm_responsavel resp)
                            redirect HomeR
                        Nothing -> do
                            setMessage $ [shamlet| Usuario ou senha invalido |] -- se a autentificaçao falhar
                            redirect LoginR 
            
        _ -> redirect HomeR
                
-- desloga da sessao devolvendo pra home
postLogoutR :: Handler Html
postLogoutR = do 
    lookupLogin >>= deleteSession 
    redirect HomeR