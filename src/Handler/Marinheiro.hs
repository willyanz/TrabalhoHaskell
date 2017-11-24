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

getMarinheiroR :: Handler Html
getMarinheiroR = undefined

getCadastrarMarinheiroR :: Handler Html
getCadastrarMarinheiroR = undefined

postCadastrarMarinheiroR :: Handler Html
postCadastrarMarinheiroR = undefined

getListarMarinheiroR :: Handler Html
getListarMarinheiroR = undefined

putEditarMarinheiroR :: MarinheiroId -> Handler Html
putEditarMarinheiroR = undefined

getBuscarMarinheiroR :: MarinheiroId -> Handler Html
getBuscarMarinheiroR = undefined

postExcluirMarinheiroR :: MarinheiroId -> Handler Html
postExcluirMarinheiroR = undefined