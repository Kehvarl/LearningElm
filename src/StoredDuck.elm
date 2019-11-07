port module StoredDuck exposing (..)

import Browser
import Html exposing (Attribute, Html, div, input, text)
import Html.Attributes exposing (..)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Json



--MAIN


main =
    Browser.document
        { init = init
        , update = updateWithStorage
        , view = \model -> { title = "Elm • Duck", body = [ view model ] }
        , subscriptions = \_ -> Sub.none
        }


port setStorage : Model -> Cmd msg



--MODEL


type alias Question =
    { id : Int
    , question : String
    }


type alias Model =
    { question : String
    , uid : Int
    , content : List Question
    }


newQuestion : Model -> Question
newQuestion model =
    Question model.uid model.question


init : Maybe Model -> ( Model, Cmd Msg )
init maybeModel =
    ( Maybe.withDefault { question = "", uid = 0, content = [] } maybeModel
    , Cmd.none
    )



--UPDATE


type Msg
    = Change String
    | Submit
    | Delete Int


updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
    ( newModel
    , Cmd.batch [ setStorage newModel, cmds ]
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Change questionString ->
            ( { model | question = questionString }
            , Cmd.none
            )

        Submit ->
            ( { model | content = model.content ++ [ newQuestion model ], question = "", uid = model.uid + 1 }
            , Cmd.none
            )

        Delete id ->
            ( { model | content = List.filter (\c -> c.id /= id) model.content }
            , Cmd.none
            )



--VIEW


view : Model -> Html Msg
view model =
    div []
        [ input
            [ placeholder "Quack?"
            , value model.question
            , onEnter Submit
            , onInput Change
            ]
            []
        , Html.button [ onClick Submit ] [ text "Quack!" ]
        , Html.ul [] <| List.map viewQuestion model.content
        ]


viewQuestion : Question -> Html Msg
viewQuestion question =
    Html.li []
        [ text question.question
        , Html.button [ onClick (Delete question.id) ] [ text "UnQuack" ]
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
