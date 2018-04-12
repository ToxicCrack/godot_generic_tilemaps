# Dynamic tilemap loading for the Godot Engine

Here's an example GDScript on how to show/hide tilemaps dynamically, taking into account where the player's position is.
The tilemaps itself are named and ordered as shown in the tilemap_gen.png. Inside the scene, the tilemaps have to be layed out from top left to bottom right (0x0 is top left, 0x3 is bottom left in my example).

You have to adjust the script to your needs.

This got my game from ~30fps (all tilemaps visible) to ~500fps (1 tilemap visible) and ~140fps (4 tilemaps visible).
With this script, there can only be max. 4 tilemaps visible at the same time.
