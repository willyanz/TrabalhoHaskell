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