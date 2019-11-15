module Test exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)


main =
    view { text = "hello world." }


view model =
    div []
        [ h1 [] [ text model.text ]
        ]
