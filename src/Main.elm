module Main exposing (..)

import Array exposing (Array)
import Html exposing (..)
import Html.App as Html
import Html.Attributes exposing (..)
import Task
import Process
import Time exposing (Time, second, millisecond)
import Maybe
import Random

import Logo exposing (Highlight(..), Colour, Msg(..))
import Util

main : Program Never
main =
  Html.program {
    init = defaultState
    , view = renderModel
    , update = update
    , subscriptions = subscriptions }

type GameState
  = Start
  | Highlight
  | Pause
  | WaitForInput


type alias Model =
  { sequence : Array Logo.Highlight
  , highlightIndex : Int -- The index in the array of the current highlight
  , state : GameState
  }

defaultState : (Model, Cmd Msg)
defaultState =
  ({ sequence = Array.empty
  , highlightIndex = 0
  , state = Start
  }
  , Random.generate NewGame (randomSequence 5))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = gameLoop msg model

gameLoop : Msg -> Model -> (Model, Cmd Msg)
gameLoop msg model =
  case msg of
    NewGame newSequence ->
      (Debug.log "new game model" ({ model | sequence = newSequence })
      , delay (second * 1) Next)
    Next ->
      ({ model | state = Highlight } --Highlight the current colour for 1 second
      , delay (millisecond * 1000) Wait)
    Wait ->
      let --Move to the next index, trigger the next colour or just wait if at the end
        highlightIndex = model.highlightIndex + 1
        cmd = if highlightIndex < (Array.length model.sequence)
          then (delay (millisecond * 300) Next)
          else Cmd.none
      in
        ({ model |
          highlightIndex = highlightIndex,
          state = Pause }, cmd)
    Click colour ->
      (model, Cmd.none)

delay : Time -> Msg -> Cmd Msg
delay t msg = Task.perform (always msg) (always msg) (Process.sleep t)

randomSequence : Int -> Random.Generator (Array Highlight)
randomSequence length =
  Random.map Array.fromList (Random.list length (Util.oneOf [HGreen, HYellow, HPurple, HBlue]))

highlight : Model -> (Model, Cmd Msg)
highlight model =
  let
    highlightIndex = model.highlightIndex + 1
    newState =
      if highlightIndex < (Array.length model.sequence) then Pause else WaitForInput
  in
    ({ model |
      highlightIndex = highlightIndex,
      state = newState }, Cmd.none)

renderModel : Model -> Html Msg
renderModel model =
  let
    currentHighlight =
      if model.state == Highlight then
        Maybe.withDefault Logo.None (Array.get model.highlightIndex model.sequence)
      else
        Logo.None
  in
    renderBoard currentHighlight


renderBoard : Highlight -> Html Msg
renderBoard highlight =
  div [mainpanel]
    [
    h1 [] [text "Simon Says"],
    div [svgpanel] [Logo.logo highlight]
    ]

mainpanel : Html.Attribute Msg
mainpanel =
  style [
    ("margin-left","20%"),
    ("margin-right","20%"),
    ("margin-top","40px")
    ]

svgpanel : Html.Attribute Msg
svgpanel =
  style [
    ("width","500px"),
    ("height","500px")
    ]

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none
