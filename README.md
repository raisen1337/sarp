# ⚡ San Andreas Roleplay

A roleplay framework inspired by SA-MP RPG gamemodes. Currently still in development with the following features:

## 🙍‍♂️ Player Accounting System
The player accounting systems include the following features:
- Saving player data (money, admin level, job information, last position)
- Saving player clothing data

![Admin Menu](https://i.imgur.com/mkZeBzl.png)

## 💵 Economy System
The economy system is basic, with money being earned by doing jobs. There is also an unfinished banking system ⌛ and a PayDay system that pays players every hour based on their faction or active job.

## 💼 Jobs & Factions
There is currently only one job available: Fisherman. The factions system is still a work in progress.
The Fisherman job involves:
1. Using [/getjob] at the job place.
2. Going to the fishing spot and using [/fish].
3. Visiting a 24/7 store to automatically sell the fish and earn money. Players can increase job experience by fishing more, allowing them to catch up to 3 fish before selling.
To quit the job, use [/quitjob].

## ⚙ Admin System
### Admin Tickets
Admins can handle player help tickets and take the latest ticket using [/taketicket]. Players can create a ticket from the player menu or by using [/createticket].

![Admin Tickets](https://i.imgur.com/5tVUaJE.png)

## 🏠 Housing System
The framework includes a housing system. Houses can be created from the admin menu. After creation, complete the dialogues that pop up. Players can buy houses, upgrade interiors, and make other purchases. Houses can be sold to the state or specific players. Selling to the state yields only a percentage of the original house price. Management can be done via [/houses] menu or by selecting it from the player menu.

![House Admin Menu](https://i.imgur.com/EtciMXZ.png)
![House Admin Create Dialog](https://i.imgur.com/WNyaM1L.png)

## 🏢 Business System
Similar to the housing system, the framework features a business system. Businesses can be created from the admin menu.

## 🚗 Personal Vehicles
Personal Vehicles can be bought from the vehicle dealership (UI is being reworked). Players can view and manage their vehicles from the vehicles menu, accessible from the player menu or using the command [/v].

![Vehicle UI](https://i.imgur.com/YXrCVAy.png)
![Vehicle Management](https://i.imgur.com/rEZHsYA.png)

## 🗺 HUD & Player Information
The HUD displays players' cash balance, bank balance, current job, and player level.

![HUD](https://i.imgur.com/rFwHrkA.png)
