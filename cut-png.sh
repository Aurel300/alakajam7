#!/bin/bash

pushd game_bin
convert brick.png -crop "256x128+0+0"   brick0.png
convert brick.png -crop "256x128+0+128" brick1.png
convert brick.png -crop "256x128+0+256" brick2.png
convert brick.png -crop "256x128+0+384" brick3.png
convert brick.png -crop "256x128+0+512" brick4.png

convert hair.png -crop "256x128+0+0"   hair0.png
convert hair.png -crop "256x128+0+128" hair1.png
convert hair.png -crop "256x128+0+256" hair2.png
popd
