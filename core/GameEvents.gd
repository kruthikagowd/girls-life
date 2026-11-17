extends Node

## GameEvents.gd
## Central signal bus for decoupling UI, player session, and world events.

## Emitted when an authentication session begins (e.g. guest or user login)
signal session_started(user_data: Dictionary)

## Emitted when the player logs out or session is terminated
signal session_ended()

## Emitted when a system-wide or UI notification should be displayed
signal notification_requested(title: String, message: String)

## Emitted when Character Salon is requested
signal character_salon_requested()

## Emitted when Settings menu is requested
signal settings_requested()
