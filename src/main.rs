use qmetaobject::QmlEngine;

fn main() {
    let mut engine = QmlEngine::new();

    let qml_path = concat!(env!("CARGO_MANIFEST_DIR"), "/qml/Main.qml");
    engine.load_file(qml_path.into());

    engine.exec();
}
