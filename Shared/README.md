#  General Text Game Engine

##  How to write the story (EN)
### Markdown, basically
General Text Game Engine supports limited subsets of Markdown (all usages are depicted in this article). The contents here will be shown on the game itself.

```
# TITLE
## SUBTITLE
### smol title

* italics *
** BOLD **

![Image Caption](image.png)

>> align right (align left by default)
>< align center

- Lists
- More lists

> Blockquotes

--- Horizontal line
```

Remember, these do NOT work mid-sentence, **EXCEPT** *italics* and bold

Special commands that can be used in story *.md files

```
!SET flag
!UNSET flag

!flag
a flag name cannot be ITEM, SET, UNSET, and other commands.
!END
```
`!GOTO filename_without_extension`
will load the next file(filename_without_extension.md) when the player clicks 'continue'

The following line defines an item. ** all items need to be defined in order to be used. **
`!ITEM item_name STR +4 DEX +1 CON +1 INT -1 WIS -2 CHA -1 HP +1`
* not every stat modifier has to exist, so something like !ITEM item_name HP +1 is also possible.

```
!PLAYER HP -4
!PLAYER HP RESTORE
!PLAYER XP +10%
!PLAYER ADD SPELL spell_name
!PLAYER REMOVE ITEM item_name
```
*not supplying name will result in something random added/removed instead.

You can also spawn someone like a player but not interactable (say, a companion).
```
!ACTOR actor_name
!ACTOR actor_name HP -4
```
* The rest is same with `!PLAYER` command.

```
!CONSUMABLE HP +1
```


### And now, the fight scene.
```
!FIGHT
[PLAYER ALLY1 ALLY2]
- ENEMY1 ENEMY2
- PLAYERBONUS +10%
- ENEMYBONUS -10%
- REWARD 200%
```
* PLAYERBONUS, ENEMYBONUS and REWARD is not required
REWARD only accepts percentages. Generally, loots are around 5~15 Gold(or 5% of player's total wealth if this is larger). By default, a fight NEVER drops an item.

After calling `!FIGHT`, you can use the result until the next fight.
This is how result can be used :

```
!FIGHT
[PLAYER]
[WEAKENEMY]

!WON
You are feeling particularly brave.
!END

!LOST
Some of your belongings are taken by the monster.
!PLAYER REMOVE ITEM
!END
```

Another tool is the 'choice' option.
```
!CHOICE
[choice name 1](choice_identifier)
[choice name 2](another_identifier)
[choice name 3](no_spaces_in_identifiers)

!choice_identifier
This is shown *ONLY IF* the player selects choice name 1.
!END
```
Remember, a choice identifier has to be unique to every file. Choice data does not persist across files. Only flags, player, actors, and item definitions persist.
