use qmetaobject::QmlEngine;

fn main() {
    let mut engine = QmlEngine::new();

    engine.load_file("../../qml/Main.qml".into());

    engine.exec();
}