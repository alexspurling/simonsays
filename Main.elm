module Main where

import Array exposing (Array)
import Html exposing (..)
import Html.Attributes exposing (..)
import Time exposing (..)
import List
import Maybe

import Logo exposing (Highlight)

main = Signal.map renderModel model

type GameState
  = Start
  | Highlight
  | Pause
  | WaitForInput


type alias Model =
  { sequence : Array Logo.Highlight
  , highlightIndex : Int -- The index in the array of the current highlight
  , state : GameState
  , highlightDuration : Int -- Number of game loops to do a highlight
  , pauseDuration : Int -- Number of game loops between two highlights
  , highlightStep : Int -- The game loop number tracking how long a highlight has been active for
  , pauseStep : Int -- The game loop number tracking how long we have been paused for
  }

defaultState = 
  { sequence = Array.fromList [Logo.HYellow, Logo.HBlue, Logo.HPurple, Logo.HGreen] 
  , highlightIndex = 0
  , state = Start
  , highlightDuration = 100 -- 1s
  , pauseDuration = 10 -- 0.1s
  , highlightStep = 0
  , pauseStep = 0
  }

model : Signal Model
model = Signal.foldp gameLoop defaultState (every second)

gameLoop : Time -> Model -> Model
gameLoop time model =
  case model.state of
    Start ->
      { model | state = Highlight } -- TODO start count down to first highlight
    Highlight ->
      let
        highlightIndex = model.highlightIndex + 1
        newState = 
          if highlightIndex < Array.length model.sequence then Pause else WaitForInput
      in
        { model | 
          highlightIndex = highlightIndex,
          state = newState }
    Pause ->
      { model | state = Highlight }
    WaitForInput ->
      model

renderModel : Model -> Html
renderModel model =
  let
    currentHighlight =
      if model.state == Highlight then
        Maybe.withDefault Logo.None (Array.get model.highlightIndex model.sequence)
      else
        Logo.None
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