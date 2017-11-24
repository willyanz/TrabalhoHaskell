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
getResponsavelR = undefined


getCadastrarResponsavelR :: Handler Html
getCadastrarResponsavelR = undefined

postCadastrarResponsavelR :: Handler Html
postCadastrarResponsavelR = undefined

getListarResponsavelR :: Handler Html
getListarResponsavelR = undefined

putEditarResponsavelR :: ResponsavelId -> Handler Html
putEditarResponsavelR = undefined

getBuscarResponsavelR :: ResponsavelId -> Handler Html
getBuscarResponsavelR = undefined

postExcluirResponsavelR :: ResponsavelId -> Handler Html
postExcluirResponsavelR = undefined