use qmetaobject::prelude::*;
use std::process::Command;  

#[derive(QObject, Default)]
struct SyncBackend {
    base: qt_base_class!(trait QObject),

    sync: qt_method!(fn sync(&self) {
        let home = match std::env::var("HOME") {
            Ok(home) => home,
            Err(e) => {
                eprintln!("Failed to get HOME: {e}");
                return;
            }
        };

        let kscreen = format!("{home}/.local/share/kscreen");

        let output = Command::new("pkexec")
            .arg("cp")
            .arg("-r")
            .arg(&kscreen)
            .arg("/var/lib/sddm/.local/share/")
            .output();

        match output {
            Ok(output) => {
                if output.status.success() {
                    println!("Display configuration synced successfully.");
                } else {
                    let stderr = String::from_utf8_lossy(&output.stderr);
                    eprintln!("Sync failed: {stderr}");
                }
            }
            Err(e) => {
                eprintln!("Failed to execute pkexec: {e}");
            }
        }
    }),
}

fn main() {
    let mut engine = QmlEngine::new();
    let backend = QObjectBox::<SyncBackend>::default();

    engine.set_object_property("backend".into(), backend.pinned());

    let qml_path = concat!(env!("CARGO_MANIFEST_DIR"), "/qml/Main.qml");
    engine.load_file(qml_path.into());

    engine.exec();
}
