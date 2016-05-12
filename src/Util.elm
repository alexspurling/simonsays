module Util exposing (..)

import Array exposing (..)
import Maybe
import Random

oneOf : List a -> Random.Generator a
oneOf list =
  oneOfArr (Array.fromList list)

{-- Returns a generator that returns a single random element from the
  provided array --}
oneOfArr : Array a -> Random.Generator a
oneOfArr arr =
  Random.map
    (\n ->
      case (Array.get n arr) of
        Just value -> value
        --This should never happen!
        Nothing ->
          Debug.crash ("Could not find element " ++ (toString n) ++ " in array " ++ (toString arr)))
    (Random.int 0 ((Array.length arr)-1))
