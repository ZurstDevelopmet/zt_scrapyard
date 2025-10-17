# ESX Scrapyard System

## 📦 Dependencies

- [es_extended](https://github.com/esx-framework/esx_core)
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory) (volitelné)

## 🔧 Installation

1. Zkopíruj složku `esx_scrapyard` do tvé `resources` složky
2. Přidej `ensure esx_scrapyard` do `server.cfg`
3. Spusť SQL skript `scripts/install_items.sql` ve své databázi
4. Restartuj server

## ⚙️ Configuration

Veškeré nastavení najdeš v `config.lua`:

- **Lokace šrotovacích dvorů** - coords, NPC, blips, scrap zóny
- **Části vozidel** - které části lze rozebrat, animace, odměny, required items
- **Blacklist/Whitelist** - která vozidla lze/nelze rozebrat
- **Odměny** - scrap items, peníze, bonusy
- **Minimální policie** - kolik policistů musí být online

\`\`\`lua
{
    name = "custom_part",
    label = "Vlastní část",
    bone = "bone_name", -- Viz GTA V bone names
    icon = "fas fa-icon",
    duration = 10000,
    animation = {...},
    rewards = {
        {item = "scrap_metal", min = 5, max = 10}
    },
    requiredItem = "wrench"
}
\`\`\`

## 🐛 Podpora

Pro problémy a dotazy vytvoř issue na GitHubu.

## 📄 Licence

MIT License - volně použitelné pro osobní i komerční projekty.
