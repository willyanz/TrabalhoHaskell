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

getEmbarcacaoR :: Handler Html
getEmbarcacaoR = do
    defaultLayout $ do 
    addStylesheet $ (StaticR css_bootstrap_min_css)
    addScript (StaticR js_bootstrap_min_js)


getCriarEmbarcacaoR :: Handler Html
getCriarEmbarcacaoR = undefined

getListarEmbarcacaoR :: Handler Html
getListarEmbarcacaoR = undefined

getBuscarEmbarcacaoR :: EmbarcacaoId -> Handler Html
getBuscarEmbarcacaoR = undefined

putEditarEmbarcacaoR :: EmbarcacaoId -> Handler Html
putEditarEmbarcacaoR = undefined

postExcluirEmbarcacaoR :: EmbarcacaoId -> Handler Html
postExcluirEmbarcacaoR = undefined