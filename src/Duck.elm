module Duck exposing (..)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json



--MAIN


main =
    Browser.sandbox { init = init, update = update, view = view }



--MODEL


type alias Model =
    { question : String
    , content : List String
    }


init : Model
init =
    { question = "", content = [] }



--UPDATE


type Msg
    = Change String
    | Submit


update : Msg -> Model -> Model
update msg model =
    case msg of
        Change newQuestion ->
            { model | question = newQuestion }

        Submit ->
            { model | content = model.content ++ [ model.question ], question = "" }



--VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "Quack?"
            , value model.question
            , onEnter Submit
            ]
            []
        , Html.button [ onClick Submit ] [ text "Quack!" ]
        , Html.ul [] <| List.map (\c -> Html.li [] [ text c ]) model.content
        ]


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg

            else
                Json.fail "not ENTER"
    in
    on "keydown" (Json.andThen isEnter keyCode)
