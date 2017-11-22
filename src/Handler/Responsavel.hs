{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies, DeriveGeneric #-}
module Handler.Responsavel where

import Import
import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getResponsavelR :: Handler Html
getResponsavelR = do
    defaultLayout $ do 
    addStylesheet $ (StaticR css_bootstrap_min_css)
    addScript (StaticR js_bootstrap_min_js)


getCriarResponsavelR :: Handler Html
getCriarResponsavelR = undefined

postCriarResponsavelR :: Handler Html
postCriarResponsavelR = undefined

postDeletarResponsavelR :: ResponsavelId -> Handler Html
postDeletarResponsavelR = undefined

getListarResponsavelR :: Handler Html
getListarResponsavelR = undefined

putEditarResponsavelR :: ResponsavelId -> Handler Html
putEditarResponsavelR = undefined

getBuscarResponsavelR :: ResponsavelId -> Handler Html
getBuscarResponsavelR = undefined