# Animation API
## About
The animation API contains all functions related to animating the local player. (Knife animations)

## play
> Plays an animation that was loaded. (Usually only: `raise`, `stab1`, `stab2`, `stab3`)
```luau
function bpAPI.animationAPI.play(AnimationName: string, Looped: boolean, Speed: number?)
```

## stop
> Stops an animation that was loaded and was playing. If no animation name is given, stops all animations.
```luau
function bpAPI.animationAPI.stop(AnimationName: string?)
```

## throw
> Plays the raising knife animation like it would if you were throwing normally by holding left click.
```luau
function bpAPI.animationAPI.throw()
```

## stab
> Plays the stab animation the same way it would in-game. (Rotating between stab1 to stab3 every stab)
```luau
function bpAPI.animationAPI.stab()
```
