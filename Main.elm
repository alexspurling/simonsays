module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (..)
import List
import Maybe

import Logo exposing (Highlight)

main = Signal.map renderGameState gameState

type alias GameState =
  { sequence : List Logo.Highlight
  }

defaultState = 
  { sequence = [Logo.HYellow, Logo.HBlue, Logo.HPurple, Logo.HGreen] 
  }

gameState : Signal GameState
gameState = Signal.foldp gameLoop defaultState (every second)

gameLoop : Time -> GameState -> GameState
gameLoop time gameState =
  { gameState | sequence <- List.drop 1 gameState.sequence }

renderGameState : GameState -> Html
renderGameState gameState =
  let
    currentHighlight = Maybe.withDefault Logo.None (List.head gameState.sequence)
  in
    renderBoard currentHighlight

renderBoard : Highlight -> Html
renderBoard highlight = 
  div [mainpanel] 
    [
    h1 [] [text "Simon Says"],
    div [svgpanel] [Logo.logo highlight]
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