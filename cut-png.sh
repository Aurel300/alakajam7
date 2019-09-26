#!/bin/bash

convert psd/brick.png -crop "256x128+0+0"   game_bin/png/brick0.png
convert psd/brick.png -crop "256x128+0+128" game_bin/png/brick1.png
convert psd/brick.png -crop "256x128+0+256" game_bin/png/brick2.png
convert psd/brick.png -crop "256x128+0+384" game_bin/png/brick3.png
convert psd/brick.png -crop "256x128+0+512" game_bin/png/brick4.png

convert psd/hair.png -crop "128x128+0+0"   game_bin/png/hair0.png
convert psd/hair.png -crop "128x128+0+128" game_bin/png/hair1.png
convert psd/hair.png -crop "128x128+0+256" game_bin/png/hair2.png
convert psd/hair.png -crop "128x128+0+384" game_bin/png/head.png
convert psd/hair.png -crop "128x128+128+0"   game_bin/png/darkhair0.png
convert psd/hair.png -crop "128x128+128+128" game_bin/png/darkhair1.png
convert psd/hair.png -crop "128x128+128+256" game_bin/png/darkhair2.png

convert psd/pole.png -crop "128x128+0+0"   game_bin/png/pole0.png
convert psd/pole.png -crop "128x128+128+0" game_bin/png/pole1.png
convert psd/pole.png -crop "128x128+256+0" game_bin/png/pole2.png
convert psd/pole.png -crop "128x128+384+0" game_bin/png/pole3.png

convert psd/spin.png -crop "256x256+0+0"   game_bin/png/spin0.png
convert psd/spin.png -crop "256x256+256+0" game_bin/png/spin1.png

convert psd/princess.png -crop "128x128+0+0"   game_bin/png/princess0.png
convert psd/princess.png -crop "256x256+128+0" game_bin/png/princess1.png

convert psd/cloud.png -crop "256x128+0+0"   game_bin/png/cloud0.png
convert psd/cloud.png -crop "256x128+256+0" game_bin/png/cloud1.png
convert psd/cloud.png -crop "256x128+512+0" game_bin/png/cloud2.png

convert psd/star.png -crop "128x128+0+0"   game_bin/png/star0.png
convert psd/star.png -crop "128x128+128+0" game_bin/png/star1.png
convert psd/star.png -crop "128x128+256+0" game_bin/png/star2.png
convert psd/star.png -crop "128x128+384+0" game_bin/png/star3.png
