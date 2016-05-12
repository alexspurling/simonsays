module Logo exposing (..)

import Array exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Html exposing (Html)
import Time exposing (Time)

type Highlight
  = None
  | HGreen
  | HYellow
  | HPurple
  | HBlue

type Colour
  = Green
  | Yellow
  | Purple
  | Blue

type alias ColourString = String

type Msg = Tick Time | Click Colour | NewGame (Array Highlight)

colour : Colour -> Highlight -> ColourString
colour colour highlight =
  case colour of
    Yellow ->
      if highlight == HYellow then "#ffc229" else "#F0AD00"
    Green ->
      if highlight == HGreen then "#8cfe2f" else "#7FD13B"
    Blue ->
      if highlight == HBlue then "#38d4ff" else "#60B5CC"
    Purple ->
      if highlight == HPurple then "#3b3b97" else "#5A6378"

logo : Highlight -> Html Msg
logo highlight =
  svg [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95" ]
    [ polygon [ fill (colour Yellow highlight), onClick (Click Yellow), points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
    , polygon [ fill (colour Green highlight), onClick (Click Green), points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
    , rect
        [ fill (colour Green highlight), onClick (Click Green)
        , x "192.99", y "107.392", width "107.676", height "108.167"
        , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
        ]
        []
    , polygon [ fill (colour Blue highlight), onClick (Click Blue), points "323.298,143.724 323.298,0 179.573,0" ] []
    , polygon [ fill (colour Purple highlight), onClick (Click Purple), points "152.781,161.649 0,8.868 0,314.432" ] []
    , polygon [ fill (colour Yellow highlight), onClick (Click Yellow), points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
    , polygon [ fill (colour Blue highlight), onClick (Click Blue), points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
    ]
