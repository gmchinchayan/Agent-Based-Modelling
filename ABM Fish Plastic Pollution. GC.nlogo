breed [fish a-fish]
breed [ships ship]
breed [bottles bottle]
fish-own [number
sick-time]

;; The setup is divided into four procedures
to setup
  clear-all
  setup-sea
  setup-fish
  setup-ships
  setup-bottles
  reset-ticks
end

to setup-sea
  ask patches [
    set pcolor blue ]
end

to setup-fish
  create-fish initial-fish
 ask fish [
   setxy random-pxcor random-pycor
   set size 1.5
   set color white
   set shape "fish"
   set number initial-fish
   set sick-time 0

  ]
end

to setup-ships
  create-ships initial-ships
  ask ships [
    setxy random-pxcor random-pycor
    set size 5
    set color green
    set shape "boat"
  ]
end


to setup-bottles
  create-bottles initial-plasticbottles
  ask bottles [
    setxy random-pxcor random-pycor
    set size 1
    set color red
    set shape "bottle"
  ]
end


to go

  ask fish [
    move
    reproduce-fish
    update-sickness
  ]

  ask ships[
    move

  ]
  ask bottles[
    move
  ]
infect-bottles
ship-fish
spawn-bottle

tick
end

to go-once

  ask fish [
    move
    reproduce-fish
    update-sickness
  ]

  ask ships[
    move

  ]
  ask bottles[
    move
  ]
infect-bottles
ship-fish
spawn-bottle
tick

end

to move
  rt random 50
  lt random 50
  fd 1
end

to reproduce-fish
  if random-float 1 < fish-reproduce / 100 [
    let is-infected 0
    if color = red [
    set is-infected 1
    ]
    hatch 1 [
      rt random-float 360
      fd 1
      if is-infected = 1 [
      set color red]
    ]
    set number count fish
  ]
end

to infect-bottles
  ask bottles
    [
      let infected 0
      ask fish in-radius 2
      [ set color red
        set infected 1
      ]
      if infected = 1 [
      die
      ]
    ]
end

to ship-fish
  if random 100 < 0.5
  [
    ask ships
    [
      let infected 0
      ask fish in-radius 1
      [
       if color = red [set infected 1]
        die
      ]

      if infected = 1 [set color yellow]
    ]
  ]
end

to update-sickness
  set sick-time (sick-time + 1 )
  if (sick-time > 2000) and (color = red) [
  set color white
  set sick-time 0
  ]
end

to spawn-bottle
  if random 100 < 0.5 [
  ifelse count bottles > 0
  [
      ask bottles
      [
          hatch 1 [
          setxy random-pxcor random-pycor
          ]
      ]
  ]
  [
  create-bottles 1
  ask bottles [
    setxy random-pxcor random-pycor
    set size 1
    set color red
    set shape "bottle"
  ]
  ]
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
197
10
641
454
-1
-1
13.455
1
10
1
1
1
0
1
1
1
-16
16
-16
16
1
1
1
ticks
30

BUTTON
66
25
129
58
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
114
62
177
95
go
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
14
115
186
148
initial-fish
initial-fish
0
200
173
1
1
NIL
HORIZONTAL

SLIDER
12
156
184
189
initial-ships
initial-ships
0
100
59
1
1
NIL
HORIZONTAL

SLIDER
17
238
189
271
fish-reproduce
fish-reproduce
0
.5
0.3
.1
1
NIL
HORIZONTAL

BUTTON
28
63
103
96
go once
go-once
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
11
195
183
228
initial-plasticbottles
initial-plasticbottles
0
100
47
1
1
NIL
HORIZONTAL

MONITOR
23
288
149
333
percent polluted fish
( ( count fish with [color = red] ) / (count fish) ) * 100
1
1
11

MONITOR
25
385
195
430
Ships with contaminated fish
count ships with [color = yellow]
1
1
11

MONITOR
24
337
148
382
percent healthy fish
( ( count fish with [color = white] ) / (count fish) ) * 100
1
1
11

PLOT
657
11
1157
253
Populations
Weeks
Fish
0
10
0
10
true
true
"" ""
PENS
"healthy fish" 1 0 -13840069 true "" "plot count fish with [ color = white ]"
"polluted fish" 1 0 -2674135 true "" "plot count fish with [ color = red ]"

PLOT
658
257
1167
465
Ships
Weeks
Ships
0
10
0
10
true
true
"" ""
PENS
"Uncontaminated Ships" 1 0 -13840069 true "" "plot count ships with [ color = green ] "
"Contaminated Ships" 1 0 -5298144 true "" "plot count ships with [ color = yellow ]"
@#$#@#$#@
## WHAT IS IT?

This is an ABM model that explains the ocean plastic pollution problem that is present in the fishing population that ends up in the plates of our foods for consumption.
 
Fish in the North Pacific ingest 12,000 to 24,000 tons of plastic each year, which can cause intestinal injury and death and transfers plastic up the food chain to bigger fish, marine mammals and human seafood eaters. A recent study found that a quarter of fish at markets in California contained plastic in their guts, mostly in the form of plastic microfibers.

## HOW IT WORKS

there are three agents in this ABM Model
1. Fish between 0 to 200 fish (in the thousands) : Can be polluted by plastic bottles (show up infected with a red bottle)
2. Plastic Bottles 0 to 100 bottles (in the thousands): Can dissapear once ingested by the fish but reppear in the water
3. Ships - 0 to 100 fishing boats (in the hundreds): Can be contaminated by fish and show up as Yellow color

## HOW TO USE IT

Each "tick" represents a week in the time scale of this model.

The INITIAL FISH slider determines the amount of fish (in the thousands)

the INITIAL SHIPS slider determines the amount of fishing boats present in the water (in the hundreds)

The INITIAL PLASTIC BOTTLES sliders determines the amount of plastic bottles present in the water (in the hundreds)

the FISH-REPRODUCE slider is the reproduction pattern of the fish, fish can be polluted by plastic and after some week duration be either healed by it or caught as contaminated to the boats


## THINGS TO NOTICE

As you can notice there is a domino effect when a Fish ingests plastic bottle, it will likely reproduce polluted and if a fishing boat is in the same radius area as the fish it will be fishing the polluted fish. Therefore the boat will be contaminated with polluted fish. As you notice over time, fish reproduction with plastic present will end up having higher numbers as week passes, and eventually all boats will be contaminated with polluted fish. As you can see in the Plots and Monitors, polluted fish start being more dominant present in the fishing population, which eventually gets caught in the fishing boat. 

## THINGS TO TRY

Try changing the sliders and notice how fast the fish population as well as fishing boats becomes polluted by plastic.

## EXTENDING THE MODEL

Adding other agents up the food supply chain, such as bigger fish, and humans to see how plastic travels from one end point (water) to the plate of humans. Include other factors related to the plastic pollution, such as weather, rising of water (global warming) etc.

## NETLOGO FEATURES

Usage of Radius for Fish to pick up Plastic Bottles, and the same for Fishing Boats to pick up polluted fish.

## RELATED MODELS

From NetLogo Library: Virus
This model simulates the transmission and perpetuation of a virus in a human population.

## CREDITS AND REFERENCES

Under the direction of DSTI Class "Agent Based Modeling" in November of 2021
This model was used with the Netlogo application and https://ccl.northwestern.edu/netlogo/ website where the application was downloaded from. 
It is authored by Uri Wilensky and developed at the CCL © 1999-2016 Uri Wilensky
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

boat
false
0
Polygon -1 true false 63 162 90 207 223 207 290 162
Rectangle -6459832 true false 150 32 157 162
Polygon -13345367 true false 150 34 131 49 145 47 147 48 149 49
Polygon -7500403 true true 158 33 230 157 182 150 169 151 157 156
Polygon -7500403 true true 149 55 88 143 103 139 111 136 117 139 126 145 130 147 139 147 146 146 149 55

bottle
false
0
Circle -7500403 true true 90 240 60
Rectangle -1 true false 135 8 165 31
Line -7500403 true 123 30 175 30
Circle -7500403 true true 150 240 60
Rectangle -7500403 true true 90 105 210 270
Rectangle -7500403 true true 120 270 180 300
Circle -7500403 true true 90 45 120
Rectangle -7500403 true true 135 27 165 51

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.1.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0
-0.2 0 0 1
0 1 1 0
0.2 0 0 1
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@

@#$#@#$#@
