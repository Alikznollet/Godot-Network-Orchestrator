> [!WARNING]
> This plugin is all but complete. I myself am still learning as I go, so expect bugs and missing functionality. If there's any important features that I'm missing or bugs you came across you can create an issue and I will look into it. If you want you can also contribute features/bug-fixes yourself.

# Godot Network Orchestrator

Godot plugin that makes fast-paced multiplayer networking easier to implement and manage. 

## Installation

1) Download the plugin from the releases tab.
2) Unzip and place the downloaded folder in `res:///addons`
3) Enable the plugin by clicking `project -> project settings -> plugins` and then checking the `enabled` box for NetworkOrchestrator.

## Set-up

The plugin has two main instantiatable nodes:

`AuthoritativeNetworkOrchestrator` and `ClientNetworkOrchestrator`

These nodes can both be placed in a scene by hand or created by code and dynamically added afterwards.

> [!IMPORTANT]
> These nodes assume you have already connected to your peers via [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) or [SteamMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html).

There can be **only one** `AuthoritativeNetworkOrchestrator` in a network, the others have to be `ClientNetworkOrchestrator` nodes.

## Usage

To create your own state that can be exchanged you can make a new GDScript file and extend `LinkState`. To share it with other Orchestrators in the network you'll add it to the tracked states by calling `orchestrator.game_state.add_state(state)`. To correctly work a `LinkState` needs to have the following methods:

> [!IMPORTANT]
> If any of below actions are omitted the state exchange will not work.

- `to_dict()`: Converts the state to a dictionary that can be sent to others over rpc.
- `apply_dict(dict)`: Will apply a dictionary created by `to_dict()` by updating the desired fields inside the state with what was in the dictionary. This is also required to call `input_tracker.acknowledge_input(dict.ack_input_id)` and then emit the `external_state_change` signal.
- `apply_input(input)`: Perform the needed checks for validity of input and then apply it to the state. Then emit the `external_state_change` signal.
- `get_update()`: Returns a dictionary that can be used to update the outside world that is depending on this state.

There's also a few optional methods to override:

- `init_node()`: Return a brand new node of the type this state is meant for.
- Any Method that will create an `input` and then add it to the state by calling `input_tracker.add_input(input)`.

An example of all of these implementations can be found in `res://example/entity_link_state.gd`. A `LinkState` takes an optional size for the `input window`. This defines how many inputs can be cached at one time.

> [!IMPORTANT]
> When overriding the _init() method of a `LinkState` make sure to call super._init(). Without this the input_tracker will not work correctly.

After defining the `LinkState` implementation you link it to whatever object you want to use it with (this can be only one, or more). Then connect the `update` signal to any function that can then call `get_update()` to apply the updates to the object. Updates can also just be applied every physics loop, for things that require `move_and_slide()` for example.
To have the state update you can just call whatever method you defined to perform input.

To add a state to the world we can *link* and *unlink* it by calling the respective methods on the `AuthoritativeNetworkOrchestrator`.

An example of this can be found in `res://example/demo_entity.gd` and of the whole scene in `res://example/demo.gd` and it's corresponding scene.

When a `LinkState` is linked to a node the `node_added` signal of the dedicated orchestrator will be emitted. This signal can be caught and then the node can be tested and sorted into the correct place.

That's all!

## TODO

- Implement Entity interpolation.
- Implement Lag Compensation.
