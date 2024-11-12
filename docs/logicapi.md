# Logic API
## About
The Logic API contains all functions related to game mechanics.

## getDuo
> Returns the player which is in duo or in team with the local player. In case the client is not in the duos gamemode, this function always returns `false`.
```luau
function bpAPI.logicAPI.getDuo(): Player | nil | false
```

## hasKnife
> Returns the given player's or the local player's knife.
```luau
function bpAPI.logicAPI.hasKnife(player: Player?): Tool | nil
```

## isSit
> Returns whether the given player or the local player is sitting.
```luau
function bpAPI.logicAPI.isSit(player: Player?): boolean
```

## isInGlass
> Returns whether a `Instance` type or a `Vector3` is inside of the glass. Returns `nil` if the object given is neither.
```luau
function bpAPI.logicAPI.isInGlass(InstanceOrVector3: Instance | Vector3): boolean | nil
```

## hasWon
> Returns whether or not the local player has won the game.
```luau
function bpAPI.logicAPI.hasWon(): boolean
```

## throw
> Throws the knife at the given CoordinateFrame. (`CFrame`)
```luau
function bpAPI.logicAPI.throw(target: CFrame)
```

## slash
> Fires the stab handler inside of the client script.
```luau
function bpAPI.logicAPI.slash()
```

## isThrowing
> Returns whether or not the local player is in cooldown.
```luau
function bpAPI.logicAPI.isThrowing(): boolean
```

## allow
> Returns whether or not a `Character` can be attacked.
```luau
function bpAPI.logicAPI.allow(character: Character): boolean
```
