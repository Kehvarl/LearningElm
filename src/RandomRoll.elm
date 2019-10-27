module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Events exposing (..)
import Random
import Svg exposing (..)
import Svg.Attributes exposing (..)



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
        [ h1 [] [ fromFace model.dieFace ]
        , button [ onClick Roll ] [ Html.text "Roll" ]
        ]


fromFace : Face -> Html Msg
fromFace face =
    case face of
        One ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "60", cy "60", r "5" ] [] ]

        Two ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "40", cy "40", r "5" ] []
                , circle [ cx "80", cy "80", r "5" ] []
                ]

        Three ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "40", cy "40", r "5" ] []
                , circle [ cx "60", cy "60", r "5" ] []
                , circle [ cx "80", cy "80", r "5" ] []
                ]

        Four ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "40", cy "40", r "5" ] []
                , circle [ cx "80", cy "40", r "5" ] []
                , circle [ cx "40", cy "80", r "5" ] []
                , circle [ cx "80", cy "80", r "5" ] []
                ]

        Five ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "40", cy "40", r "5" ] []
                , circle [ cx "80", cy "40", r "5" ] []
                , circle [ cx "60", cy "60", r "5" ] []
                , circle [ cx "40", cy "80", r "5" ] []
                , circle [ cx "80", cy "80", r "5" ] []
                ]

        Six ->
            svg
                [ width "120", height "120", viewBox "0 0 120 120" ]
                [ circle [ cx "40", cy "40", r "5" ] []
                , circle [ cx "80", cy "40", r "5" ] []
                , circle [ cx "40", cy "60", r "5" ] []
                , circle [ cx "80", cy "60", r "5" ] []
                , circle [ cx "40", cy "80", r "5" ] []
                , circle [ cx "80", cy "80", r "5" ] []
                ]
