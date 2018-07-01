<h1 align="center">cnt</h1>
<h4 align="center">Carrot & Niall's Toolkit</h3>
<div align="center">
	<a href="#">
		<img src="https://img.shields.io/badge/status-incomplete-red.svg"/>
	</a>
	<a href="#">
		<img src="https://img.shields.io/badge/lua-%3E%3D%205.1-blue.svg" />
	</a>
  <a href="https://github.com/carat-ye/cnt/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/license-AGPLv3-663366.svg">
  </a>
</div>
<div align="center">
	Server essentials for <a href="https://finobe.com">Finobe</a> places.
</div>

## Installation
### Downloading from Source
- Clone from the GitHub using the Clone or Download button.
- Make 3 new scripts. Name one `Scan`, the other `Admin` and the last `Anticheat`. Place them all in workspace.
- Paste the scripts into the according script (e.g: the code in `admin.lua` goes into the `Admin` script)
- Paste this script into the command bar and hit enter:
```lua
game.Workspace.Admin.Parent = game game.Workspace.Anticheat.Parent = game game.Workspace.Scan.Parent = game game.Workspace.Scan.Disabled = true
```
### Downloading from Release
- Download the latest release from https://github.com/carat-ye/cnt/releases
- Extract the release zip.
- Click "Insert" on the menu bar and then click "Insert Model..."
- Choose the `rbxm` in the extracted zip and click OK.
- You're ready to go!
## Usage
### Adding Admins
To add admins, add them into the table in the configuration at the top of script:
```lua
local admins = {
  ["Raymonf"] = 1,
  [178] = 1,
}
```
Both user IDs and player names are supported.
#### Power Levels
Power levels determine the commands the user is allowed to use. You can declare power levels by changing the number after the equal sign of their entry in the admins list.<br><br>
Power Levels:
* 1: Owner / Finobe staff.
* 2: Administrator
* 3: Temporary Administrator
* 4: Moderator
* 5 and Above: Regular User
<br><br>
Command power levels can be changed using the `modifycommand <command> <level>` command.
### Adding Banned Users
To add banned users, add them into the table in the configuration near the admin table
```lua
local banned = {
  "dap300",
  "billy",
}
```
Like with admins, both user IDs and player names are supported.
Make sure to keep the curly brackets! Commas and block quotes are also necessary.
### Adding / Removing Prefixes
The prefix table is at the top of the script and it looks like this:
```lua
local prefixes = { -- Admin prefixes, e.g "<prefix>kill EnergyCell"
  ":",
  ";",
  "@",
  ".",
  ">",
  "/",
  "$",
  "!",
}
```
You can add prefixes the same way you'd add banned users or admins.
### Adding Commands
Advanced users may want to extend CNT's functionality by adding commands.<br><br>
To add commands, scroll down to the point in the script which says this:
```lua
local commands = {}
```
Commands are written like this:
```lua
-- Kills a player.
commands.kill = {}
commands.kill["command"] = function(sender, arguments, targets) -- sender is a Player object, arguments is a string table and targets is a Player table
  if NoArguments(arguments) then
    return
  end
  for _, player in pairs(targets) do -- for every player in targets do
    if player.Character and player.Character.Humanoid.Health > 0 then -- if players character exists and player is alive
      player.Character:BreakJoints() -- kill player
    end
  end
end
commands.kill["level"] = 4 -- level the command is at, more about levels below
commands.kill["description"] = "Kills a player by breaking their joints." -- description of the command
commands.murder = commands.kill -- alias for the command (not necessary)
```
The above command, when executed using `<prefix>kill <player>` will kill the player you chose. <br><br>
Functions are also fully documented in the code for anyone who would like to add more than just commands.
## Authors
* **Carrot** - *Developer* - [carat-ye](https://github.com/carat-ye)
* **Niall** - *Developer* - [Niall-R](https://github.com/Niall-R)
## Versioning
We use [SemVer](https://semver.org/) for versioning. To view the versions of CNT available, [see the tags on this repository.](https://github.com/carat-ye/cnt/tags)
## Built With
* [Atom](https://atom.io) - For making code
* [Teletype](https://atom.io/packages/teletype) - Tool used for team collaboration
## Acknowledgements
* **Raymonf** - For making Finobe
* **dap300** - For being dap300
## License
CNT is available under the GNU Affero General Public License v3.0. See [LICENSE](https://github.com/carat-ye/cnt/blob/master/LICENSE) for details.
