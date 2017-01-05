---------------------------------------------------------------------------------
-- Gluglis
-- Alfredo Chi
-- GeekBucket 2016
---------------------------------------------------------------------------------

local Sprites = {}

Sprites.loading = {
  source = "img/sprLoading.png",
  frames = {width=100, height=100, numFrames=6},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1000, frames={1,2,3,4,5,6,5,4,3,2}}
  }
}

Sprites.loadingMini = {
  source = "img/sprLoadingMini.png",
  frames = {width=64, height=64, numFrames=6},
  sequences = {
      { name = "stop", loopCount = 1, start = 1, count=1},
      { name = "play", time=1000, frames={1,2,3,4,5,6,5,4,3,2}}
  }
}

return Sprites