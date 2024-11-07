#!/bin/sh

DIRECTION=$1

# Get the window which has focus
window_frame=$(yabai -m query --windows --space | jq 'map(select(."has-focus" == true)).[0].frame')

# Get the display which has focus
focused_display=$(yabai -m query --displays | jq 'map(select(."has-focus" == true)).[0]')

# Extract the display's frame properties
display_frame=$(echo "$focused_display" | jq '.frame')
display_width=$(echo "$display_frame" | jq '.w')
half_display_width=$(echo "$display_width / 2" | bc)
third_display_width=$(echo "$display_width / 3" | bc)

# Extract the window frame properties
window_width=$(echo "$window_frame" | jq '.w' | awk '{print int($1)}')
window_x=$(echo "$window_frame" | jq '.x' | awk '{print int($1)}')

if [ "$DIRECTION" == left ]; then
	echo "Tiling left"
	CHECK_1=$((window_x == 0))
	TILE_1="1:3:0:0:2:1"
	TILE_0="1:2:0:0:1:1"

	CHECK_2=$CHECK_1
	TILE_2="1:3:0:0:1:1"

elif [ "$DIRECTION" == right ]; then
	echo "tiling right"
	CHECK_1=$((window_x == half_display_width + 1))
	TILE_1="1:3:1:0:2:1"
	TILE_0="1:2:1:0:1:1"

	CHECK_2=$((window_x == third_display_width + 1))
	TILE_2="1:3:2:0:1:1"
else
	echo "Tiling direction should be left or right"
	exit 1
fi

echo "CHECK_1=$CHECK_1"
echo "CHECK_2=$CHECK_2"

# Check if the window occupies half the display
if [ "$window_width" -eq $((half_display_width - 1)) ] &&
	[ "$CHECK_1" -eq 1 ]; then
	# Tile it to two thirds
	echo "Tiling to 2/3."
	yabai -m window --grid $TILE_1
elif [ "$window_width" -eq $((third_display_width * 2 - 1)) ] &&
	[ "$CHECK_2" -eq 1 ]; then
	echo "Tiling to 1/3."
	yabai -m window --grid $TILE_2
else
	# Tile it to halfs
	echo "Tiling to 1/2."
	yabai -m window --grid $TILE_0
fi
