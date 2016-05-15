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

import Logo exposing (Colour(..))
import Sound exposing (Sound)
import Util

main : Program Never
main =
  Html.program {
    init = defaultState
    , view = renderModel
    , update = update
    , subscriptions = subscriptions }

type Msg = NewGame (Array Colour) | Next | Wait | Done | Click Colour

type GameState
  = Play
  | WaitForInput


type alias Model =
  { sequence : Array Logo.Colour
  , lightIndex : Int -- The index in the array of the current light
  , light : Colour --The colour to highlight
  , state : GameState
  , sound : Sound
  }

defaultState : (Model, Cmd Msg)
defaultState =
  ({ sequence = Array.empty
  , lightIndex = 0
  , light = Logo.None
  , state = Play
  , sound = Sound.initialSound
  }
  , Random.generate NewGame (randomSequence 5))

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = gameLoop msg model

gameLoop : Msg -> Model -> (Model, Cmd Msg)
gameLoop msg model =
  case msg of
    NewGame newSequence ->
      ({ model | sequence = newSequence }
       , delay (second * 1) Next)
    Next ->
      let
        curLight = Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
        _ = Sound.playNote (lightToNote curLight) model.sound
      in
        ({ model | light = curLight, lightIndex = model.lightIndex + 1 }
        , delay (millisecond * 500) Wait)
    Wait ->
      if model.lightIndex < (Array.length model.sequence) then
        ({ model | light = Logo.None }, (delay (millisecond * 100) Next))
      else
        --Sequence has finished
        ({ model | light = Logo.None
         , state = WaitForInput
         , lightIndex = 0 }, Cmd.none)
    Click light ->
      if model.state == WaitForInput then
        let
          expectedColour = Maybe.withDefault Logo.None (Array.get model.lightIndex model.sequence)
          sound = if light == expectedColour then (lightToNote light) else Sound.Nope
          newIndex = if light == expectedColour then model.lightIndex + 1 else 0
          _ = Sound.playNote sound model.sound
        in
          ({ model | light = light, lightIndex = newIndex }, delay (millisecond * 500) Done)
      else
        (model, Cmd.none)
    Done ->
      ({ model | light = Logo.None }, Cmd.none)

delay : Time -> Msg -> Cmd Msg
delay t msg = Task.perform (always msg) (always msg) (Process.sleep t)

randomSequence : Int -> Random.Generator (Array Colour)
randomSequence length =
  Random.map Array.fromList (Random.list length (Util.oneOf [Green, Yellow, Purple, Blue]))

lightToNote : Colour -> Sound.Note
lightToNote light =
  case light of
    Purple -> Sound.G3
    Green -> Sound.C4
    Yellow -> Sound.E4
    Blue -> Sound.G4
    None -> Sound.C4

renderModel : Model -> Html Msg
renderModel model =
  div [mainpanel]
    [
    h1 [] [text "Simon Says"],
    div [svgpanel] [Html.map logoMsgToMainMsg (Logo.logo model.light)]
    ]

logoMsgToMainMsg : Logo.Msg -> Msg
logoMsgToMainMsg logoMsg =
  case logoMsg of
    Logo.Click colour -> Click colour

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
