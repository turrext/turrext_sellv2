# turrext_sellv2
A highly customizable ESX FiveM script for dynamic NPC-based drug and item sales, police dispatch alerts, black-market shops, and job-specific delivery systems. Perfect for immersive and risk-driven roleplay servers.
# 💊 Customizable Drug & Delivery Selling Script for FiveM

> **Release Date:** November 27, 2023  
> **Framework:** ESX or QB-Core  
> **Inventory Support:** OX Inventory  
> **Dispatch Options:** Integrated / QS-Dispatch  
> **Version:** 1.0  
> **Author:** turrext

A flexible and immersive drug selling & delivery script for FiveM. Features dynamic NPC interactions, police dispatch system, black-market selling, and permanent NPC shops. Ideal for both street dealing and roleplay-friendly delivery tasks.

---

## 🔥 Features

- 🧍 Multiple NPC interaction styles (aggressive, passive, static)
- 🚓 Police notification system with adjustable chance
- 📡 Integrated or QS dispatch support with blip timer
- 🛍️ Support for item groups and specific item requests
- 💼 Black market integration (permanent NPC shops)
- 👷 Job-specific selling support (e.g. mechanics, civilians)
- 🧭 Configurable zones, blips, and selling logic
- 🔁 Optional item request system (specific/random)
- 🧠 Custom expiration timers and respawn logic per ped

---

## ⚙️ Configuration Overview

### Zones

- Define multiple interactive zones with radius and map blips
- Each zone has individual:
  - Radius
  - Ped spawn limits
  - Blip customization
  - NPC configuration per ped

### Ped Behavior Settings

- `ApproachPlayer`: Makes NPC walk to you before interacting
- `FreezePed`, `Wandering`, `Invincible`, `IgnoreEvents`
- `RequestSpecificItem`: NPCs can ask for specific items
- `PoliceNotifyChance`: % chance to trigger police alert
- `ExpireTimer`: Seconds until the NPC is removed/reset

### Dispatch

- `Dispatch = "integrated"` or `"qs-dispatch"`
- `DispatchBlipTimer = 30000` (30s default)

---

## 🛒 Selling Logic

### Dynamic Selling

- Peds sell items from a specified `ItemGroup`
- Sale amount randomized between `MinItem` and `MaxItem`
- Supports `money`, `bank`, or `black` accounts

### Permanent Black Market

- NPCs can be configured as infinite-sell shops
- Supports OX Target or manual interaction
- Ideal for drugs, smuggled goods, or illicit services

---

## 🧾 Selling Config Example

```lua
Config.Selling = {
  [1] = {
    NPCPermenentShop = false,
    Jobonly = false,
    Items = {
      { Name = "water", Label = "Bottle of Water", Price = 10, Account = "money", MinItem = 3, MaxItem = 6 }
    }
  },
  [3] = {
    NPCPermenentShop = true,
    JobOnly = false,
    Items = {
      { Name = "smokes", Label = "Cigarettes", Price = 10, Account = "black" },
      { Name = "weed", Label = "Weed Rolls", Price = 10, Account = "black" }
    }
  }
}
```

---

## 🧠 Use Cases

- 🚛 Use as a **delivery mission script** for jobs like mechanics or couriers
- 💸 Set up **black market shops** with unlimited sales
- 💊 Configure **drug dealing** zones with risk of police alerts

---

## 🧩 Customization Friendly

- Easily expand to more zones and ped types
- Full control of item prices, accounts, quantity ranges
- Modular config-based setup for quick edits

---

## 📣 Feedback & Contribution

Spotted an issue? Want to contribute or request features? Open an issue or PR on GitHub.

---

## 📜 License

MIT License — free to use, modify, and distribute with credit.

---

## 🙌 Credits

Developed with 💻 by turrext for immersive FiveM roleplay.
