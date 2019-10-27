module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random



--MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--MODEL


type Face
    = One
    | Two
    | Three
    | Four
    | Five
    | Six


type alias Model =
    { dieFace : Face
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model One
    , Cmd.none
    )



--UPDATE


type Msg
    = Roll
    | NewFace Face


roll : Random.Generator Face
roll =
    Random.weighted
        ( 10, One )
        [ ( 10, Two )
        , ( 10, Three )
        , ( 10, Four )
        , ( 20, Five )
        , ( 40, Six )
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Roll ->
            ( model
            , Random.generate NewFace roll
            )

        NewFace newFace ->
            ( Model newFace
            , Cmd.none
            )



--subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text (fromFace model.dieFace) ]
        , button [ onClick Roll ] [ text "Roll" ]
        ]


fromFace : Face -> String
fromFace face =
    case face of
        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"

        Six ->
            "6"
