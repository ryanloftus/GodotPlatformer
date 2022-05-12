use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
struct HelloWorld;

#[methods]
impl HelloWorld {
    fn new(_owner: &Node) -> Self {
        HelloWorld
    }

    #[export]
    fn _ready(&self, _owner: &Node) {
        godot_print!("Hello Godot!")
    }
}

fn init(handle: InitHandle) {
    handle.add_class::<HelloWorld>();
}

godot_init!(init);

// Remember to set "entry" OSX.64="res://target/debug/libspinning_cube.dylib" in RustLib.gdnlib
