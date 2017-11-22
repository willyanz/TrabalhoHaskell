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
getMarinheiroR = do
    defaultLayout $ do 
    addStylesheet $ (StaticR css_bootstrap_min_css)
    addScript (StaticR js_bootstrap_min_js)


getListarMarinheiroR :: Handler Html
getListarMarinheiroR = undefined

getCriarMarinheiroR :: Handler Html
getCriarMarinheiroR = undefined

postDeletarMarinheiroR :: MarinheiroId -> Handler Html
postDeletarMarinheiroR = undefined

putEditarMarinheiroR :: MarinheiroId -> Handler Html
putEditarMarinheiroR = undefined

getBuscarMarinheiroR :: MarinheiroId -> Handler Html
getBuscarMarinheiroR = undefined