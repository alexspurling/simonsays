module Logo exposing (..)

import Array exposing (..)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Svg.Events exposing (..)
import Html exposing (Html)

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

type Msg = Click Colour | NewGame (Array Highlight) | Next | Wait

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

edge : Colour -> Highlight -> Attribute Msg
edge colour highlight =
  let
    edgeStyle =
      case colour of
        Yellow ->
          if highlight == HYellow then "stroke:#ffc229;stroke-width:2" else ""
        Green ->
          if highlight == HGreen then "stroke:#8cfe2f;stroke-width:2" else ""
        Blue ->
          if highlight == HBlue then "stroke:#38d4ff;stroke-width:2" else ""
        Purple ->
          if highlight == HPurple then "stroke:#3b3b97;stroke-width:2" else ""
  in
    Svg.Attributes.style edgeStyle

logo : Highlight -> Html Msg
logo highlight =
  let
    colourYellow = colour Yellow highlight
    colourGreen = colour Green highlight
    colourBlue = colour Blue highlight
    colourPurple = colour Purple highlight
    edgeYellow = edge Yellow highlight
    edgeGreen = edge Green highlight
    edgeBlue = edge Blue highlight
    edgePurple = edge Purple highlight
  in
    svg [ version "1.1", x "0", y "0", viewBox "0 0 323.141 322.95" ]
      [ polygon [ edgeYellow, fill colourYellow, onClick (Click Yellow), points "161.649,152.782 231.514,82.916 91.783,82.916" ] []
      , polygon [ edgeGreen, fill colourGreen, onClick (Click Green), points "8.867,0 79.241,70.375 232.213,70.375 161.838,0" ] []
      , rect
          [ edgeGreen, fill colourGreen, onClick (Click Green)
          , x "192.99", y "107.392", width "107.676", height "108.167"
          , transform "matrix(0.7071 0.7071 -0.7071 0.7071 186.4727 -127.2386)"
          ]
          []
      , polygon [ edgeBlue, fill colourBlue, onClick (Click Blue), points "323.298,143.724 323.298,0 179.573,0" ] []
      , polygon [ edgePurple, fill colourPurple, onClick (Click Purple), points "152.781,161.649 0,8.868 0,314.432" ] []
      , polygon [ edgeYellow, fill colourYellow, onClick (Click Yellow), points "255.522,246.655 323.298,314.432 323.298,178.879" ] []
      , polygon [ edgeBlue, fill colourBlue, onClick (Click Blue), points "161.649,170.517 8.869,323.298 314.43,323.298" ] []
      ]
