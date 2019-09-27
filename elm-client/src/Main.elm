port module Main exposing (main)

import Browser
import Element exposing (Element, centerX, centerY, column, el, fill, height, maximum, padding, pointer, px, rgb255, row, text, width, wrappedRow)
import Element.Background as Background
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input exposing (button)
import Html exposing (Html)
import Json.Decode as D



-----------
-- Model --
-----------


type Model
    = SubscriptionsLoading
    | Loaded (List Item)
    | NotLoaded Error


type Error
    = DecodeError
    | EmptyListError


type alias Item =
    { id : String
    , count : Int
    }



----------
-- Init --
----------


init : () -> ( Model, Cmd Msg )
init _ =
    ( SubscriptionsLoading
    , Cmd.none
    )



----------
-- Msgs --
----------


type Msg
    = SetSubscriptionsLoading Bool
    | SetItems D.Value
    | IncreaseCount String



------------
-- Update --
------------


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetSubscriptionsLoading True ->
            ( SubscriptionsLoading, Cmd.none )

        SetSubscriptionsLoading False ->
            ( model, Cmd.none )

        SetItems value ->
            case D.decodeValue itemsDecoder value of
                Ok items ->
                    case List.isEmpty items of
                        True ->
                            ( NotLoaded EmptyListError, Cmd.none )

                        False ->
                            ( Loaded items, Cmd.none )

                Err _ ->
                    ( NotLoaded DecodeError, Cmd.none )

        IncreaseCount id ->
            ( model, increaseCount id )



-------------------
-- Subscriptions --
-------------------


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ subscriptionsLoadingChanged SetSubscriptionsLoading
        , itemsChanged SetItems
        ]



-----------
-- Ports --
-----------


port itemsChanged : (D.Value -> msg) -> Sub msg


port subscriptionsLoadingChanged : (Bool -> msg) -> Sub msg


port increaseCount : String -> Cmd msg



-----------
-- Views --
-----------


viewItem : Item -> Element Msg
viewItem { count, id } =
    let
        asText =
            count
                |> String.fromInt
                |> text

        asBackgroundColor =
            rgb255 count count count

        asFontColor =
            if count > 170 then
                rgb255 0 0 0

            else
                rgb255 255 255 255
    in
    button
        [ height (px 50)
        , width (px 50)
        , Background.color asBackgroundColor
        , Font.color asFontColor
        ]
        { label = column [ centerX, centerY ] [ asText ]
        , onPress = Just (IncreaseCount id)
        }


viewItems : List Item -> Element Msg
viewItems items =
    column
        [ centerY
        , centerX
        , width (fill |> maximum 300)
        , height fill
        ]
        [ wrappedRow [] (List.map viewItem items) ]


view : Model -> Html Msg
view model =
    let
        content =
            case model of
                SubscriptionsLoading ->
                    el [] (text "subscriptions loading...")

                NotLoaded error ->
                    case error of
                        DecodeError ->
                            el [] (text "decoding error")

                        EmptyListError ->
                            el [] (text "no items found")

                Loaded items ->
                    viewItems items
    in
    Element.layout [ height fill, width fill ]
        (row [ centerY, centerX ] [ content ])



--------------
-- Decoders --
--------------


itemDecoder : D.Decoder Item
itemDecoder =
    D.map2 Item
        (D.field "_id" D.string)
        (D.field "count" D.int)


itemsDecoder : D.Decoder (List Item)
itemsDecoder =
    D.list itemDecoder



----------
-- Main --
----------


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
