> [!WARNING]
> This plugin is all but complete. I myself am still learning as I go, so expect bugs and missing functionality. If there's any important features that I'm missing or bugs you came across you can create an issue and I will look into it. If you want you can also contribute features/bug-fixes yourself.

# Godot Network Orchestrator

Godot plugin that makes fast-paced multiplayer networking easier to implement and manage. 

## Installation

1) Download the plugin from the releases tab.
2) Unzip and place the downloaded folder in `res://addons`
3) Enable the plugin by clicking `project -> project settings -> plugins` and then checking the `enabled` box for NetworkOrchestrator.

## Set-up

The plugin has two main instantiatable nodes:

`AuthoritativeNetworkOrchestrator` and `ClientNetworkOrchestrator`

These nodes can both be placed in a scene by hand or created by code and dynamically added afterwards.

> [!IMPORTANT]
> These nodes assume you have already connected to your peers via [ENetMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html) or [SteamMultiplayerPeer](https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html).

There can be **only one** `AuthoritativeNetworkOrchestrator` in a network, the others have to be `ClientNetworkOrchestrator` nodes.

## Usage

To create your own state that can be exchanged you can make a new GDScript file and extend `LinkedState`. To share it with other Orchestrators in the network you'll add it to the tracked states by calling `orchestrator.link_state(state)`. To correctly work a `LinkedState` needs to implement the following methods:

> [!IMPORTANT]
> If any of below actions are omitted the state exchange will not work.

- `to_dict()`: Converts the state to a dictionary that can be sent to others over rpc.
- `apply_dict(dict)`: Will apply a dictionary created by `to_dict()` by updating the desired fields inside the state with what was in the dictionary. This is also required to call `input_buffer.acknowledge_input(dict.ack_input_id)` and then emit the `external_state_change` signal.
- `apply_input(input)`: Perform the needed checks for validity of input and then apply it to the state. Then emit the `external_state_change` signal.
- `get_update()`: Returns a dictionary that can be used to update the outside world that is depending on this state.
- `init_wrapper()`: Returns a `Variant` node or resource that will be used as a wrapper for the `LinkedState`.

There's also a few optional methods to override:

- Any Method that will create an `input` and then add it to the state by calling `input_buffer.add_input(input)`.

Seperation of different input types is not natively implemented.

An example of all of these implementations can be found in `res://example/entity_linked_state.gd`. A `LinkedState` takes an optional size for the `input window`. This defines how many inputs can be cached at one time.

> [!IMPORTANT]
> When overriding the _init() method of a `LinkedState` make sure to call `super._init()`. Without this the input_buffer will not work properly.

After defining the `LinkedState` implementation you link it to whatever object you want to use it with (this can be only one, or more). Then connect the `update` signal to any function that can then call `get_update()` to apply the updates to the object. Updates can also just be applied every physics loop, for things that require `move_and_slide()` for example.
To have the state update you can just call whatever method you defined to perform input.

To add a state to the world we can *link* and *unlink* it by calling the respective methods on the `AuthoritativeNetworkOrchestrator`.

When a `LinkedState` is added to the `GameState` the `state_linked` signal is emitted from the corresponding orchestrator, this signal carries the `wrapper` of that `LinkedState`. This can then be sorted or put into the right place.

An example of this can be found in `res://example/example_entity.gd` and of the whole scene in `res://example/example.gd` and it's corresponding scene.

That's all!

## Missing Features

- **Proper Native Interpolation**

- **Lag Compensation**: Because this is only used for certain cases I'm leaving this be until I need it myself.
