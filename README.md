# SmartParking

SmartParking is a parking management system which is non-persistent and managing 
the state inside the GenServer. 

SmartParking application provide functionality to

  * Create parking lots
  * Extend existing parking lots
  * Parking slots inside the parking lot

Once parking slots are crated inside the parking lot we can start parking vehicles.

UI view:

![image](https://user-images.githubusercontent.com/20892499/141992652-f05b09de-d618-46ab-88a1-f7970245ee70.png)


### Basic installation and set up (Need to write properly)
To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Source: https://github.com/phoenixframework/phoenix
