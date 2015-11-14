module Main where

import Html exposing (..)
import Html.Attributes exposing (..)

import Logo

main : Html
main = 
  div [mainpanel] 
    [
    h1 [] [text "Simon Says"],
    div [svgpanel] [Logo.logo]
    ]

mainpanel : Html.Attribute
mainpanel = 
  style [
    ("margin-left","20%"),
    ("margin-right","20%"),
    ("margin-top","40px")
    ]

svgpanel : Html.Attribute
svgpanel = 
  style [
    ("width","500px"),
    ("height","500px")
    ]