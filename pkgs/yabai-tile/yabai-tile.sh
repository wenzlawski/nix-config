#!/bin/sh

DIRECTION=$1

# Get the window which has focus
window_frame=$(yabai -m query --windows --space | jq 'map(select(."has-focus" == true)).[0].frame')

# Get the display which has focus
focused_display=$(yabai -m query --displays | jq 'map(select(."has-focus" == true)).[0]')

# Extract the display's frame properties
display_frame=$(echo "$focused_display" | jq '.frame')
display_width=$(echo "$display_frame" | jq '.w' | awk '{print int($1)}')
display_height=$(echo "$display_frame" | jq '.h' | awk '{print int($1)}')
half_display_width=$(echo "$display_width / 2" | bc)
third_display_width=$(echo "$display_width / 3" | bc)
half_display_height=$(echo "$display_height / 2 - 12" | bc)

# Extract the window frame properties
window_width=$(echo "$window_frame" | jq '.w' | awk '{print int($1)}')
window_height=$(echo "$window_frame" | jq '.h' | awk '{print int($1)}')
window_x=$(echo "$window_frame" | jq '.x' | awk '{print int($1)}')
window_y=$(echo "$window_frame" | jq '.y' | awk '{print int($1) - 25}')

if [ "$DIRECTION" == left ]; then
	echo "Tiling left"
	CHECK_1_0=$((window_width == half_display_width - 1))
	CHECK_1_1=$((window_x == 0))
	TILE_1="1:3:0:0:2:1" # left 2/3
	TILE_0="1:2:0:0:1:1" # left 1/2

	CHECK_2_0=$((window_width == third_display_width * 2 - 1))
	CHECK_2_1=$CHECK_1_1
	TILE_2="1:3:0:0:1:1" # left 1/3

elif [ "$DIRECTION" == right ]; then
	echo "tiling right"
	CHECK_1_0=$((window_width == half_display_width - 1))
	CHECK_1_1=$((window_x == half_display_width + 1))
	TILE_1="1:3:1:0:2:1" # right 2/3
	TILE_0="1:2:1:0:1:1" # right 1/2

	CHECK_2_0=$((window_width == third_display_width * 2 - 1))
	CHECK_2_1=$((window_x == third_display_width + 1))
	TILE_2="1:3:2:0:1:1" # right 1/3
elif [ "$DIRECTION" == up ]; then
	echo "tiling up"
	CHECK_1_0=$((window_height == half_display_height - 1 && window_width == display_width))
	CHECK_1_1=$((window_y == 0))
	TILE_1="2:2:0:0:1:1" # top left 1/4
	TILE_0="2:1:0:0:1:1" # top 1/2

	CHECK_2_0=$((window_height == half_display_height - 1 && window_width == half_display_width - 1))
	CHECK_2_1=$((CHECK_1_1 && window_x != half_display_width + 1))
	TILE_2="2:2:1:0:1:1" # top right 1/4

elif [ "$DIRECTION" == down ]; then
	echo "tiling down"
	CHECK_1_0=$((window_height == half_display_height - 1 && window_width == display_width))
	CHECK_1_1=$((window_y == half_display_height + 1))
	TILE_1="2:2:0:1:1:1" # bottom left 1/4
	TILE_0="2:1:0:1:1:1" # bottom 1/2

	CHECK_2_0=$((window_height == half_display_height - 1 && window_width == half_display_width - 1))
	CHECK_2_1=$((CHECK_1_1 && window_x != half_display_width + 1))
	TILE_2="2:2:1:1:1:1" # bottom right 1/4
else
	echo "Tiling direction should be left or right"
	exit 1
fi

echo "$half_display_height"
echo "$window_height"
echo "$window_y"
echo "CHECK_1_0=$CHECK_1_0"
echo "CHECK_1_1=$CHECK_1_1"
echo "CHECK_2_0=$CHECK_2_0"
echo "CHECK_2_1=$CHECK_2_1"

# Check if the window occupies half the display
if [ "$CHECK_1_0" -eq 1 ] &&
	[ "$CHECK_1_1" -eq 1 ]; then

	echo "Tiling to second stage."
	yabai -m window --grid $TILE_1

elif [ "$CHECK_2_0" -eq 1 ] &&
	[ "$CHECK_2_1" -eq 1 ]; then

	echo "Tiling to third."
	yabai -m window --grid $TILE_2

else

	echo "Tiling to first."
	yabai -m window --grid $TILE_0

fi
