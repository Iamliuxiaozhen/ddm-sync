use qmetaobject::prelude::*;
use std::env;
use std::path::{Path, PathBuf};
use std::process::Command;

#[derive(QObject, Default)]
struct SyncBackend {
    base: qt_base_class!(trait QObject),

    sync: qt_method!(
        fn sync(&self) -> QString {
            match sync_display_configs() {
                Ok(message) => format!("OK|{message}").into(),
                Err(message) => format!("ERROR|{message}").into(),
            }
        }
    ),
}

#[derive(Clone, Copy)]
enum SourceKind {
    Directory,
    File,
}

struct SyncTask {
    label: &'static str,
    source: PathBuf,
    target: &'static str,
    kind: SourceKind,
}

fn sync_display_configs() -> Result<String, String> {
    let home = env::var_os("HOME").ok_or_else(|| "HOME is not set.".to_owned())?;
    let home = PathBuf::from(home);

    let tasks = available_tasks(&home);
    if tasks.is_empty() {
        return Err("No display configuration was found to sync.".to_owned());
    }

    let mut synced = Vec::new();
    let mut failures = Vec::new();

    for task in tasks {
        match run_sync_task(&task) {
            Ok(()) => synced.push(task.label),
            Err(error) => failures.push(format!("{}: {}", task.label, error)),
        }
    }

    if failures.is_empty() {
        Ok(format!("Synced {}.", synced.join(" and ")))
    } else if synced.is_empty() {
        Err(failures.join("\n"))
    } else {
        Err(format!(
            "Synced {}, but failed:\n{}",
            synced.join(" and "),
            failures.join("\n")
        ))
    }
}

fn available_tasks(home: &Path) -> Vec<SyncTask> {
    let mut tasks = Vec::new();
    let kscreen = home.join(".local/share/kscreen");
    let monitors = home.join(".config/monitors.xml");

    if kscreen.is_dir() && Path::new("/var/lib/sddm").is_dir() {
        tasks.push(SyncTask {
            label: "SDDM",
            source: kscreen,
            target: "/var/lib/sddm/.local/share/kscreen",
            kind: SourceKind::Directory,
        });
    }

    if monitors.is_file() && Path::new("/var/lib/gdm3").is_dir() {
        tasks.push(SyncTask {
            label: "GDM3",
            source: monitors.clone(),
            target: "/var/lib/gdm3/.config/monitors.xml",
            kind: SourceKind::File,
        });
    }

    if monitors.is_file() && Path::new("/var/lib/gdm").is_dir() {
        tasks.push(SyncTask {
            label: "GDM",
            source: monitors,
            target: "/var/lib/gdm/.config/monitors.xml",
            kind: SourceKind::File,
        });
    }

    tasks
}

fn run_sync_task(task: &SyncTask) -> Result<(), String> {
    let parent = Path::new(task.target)
        .parent()
        .ok_or_else(|| format!("Invalid target path: {}", task.target))?;

    let script = match task.kind {
        SourceKind::Directory => "install -d -m 0755 \"$2\" && cp -aT \"$1\" \"$3\"",
        SourceKind::File => "install -d -m 0755 \"$2\" && cp -a \"$1\" \"$3\"",
    };

    let output = Command::new("pkexec")
        .arg("sh")
        .arg("-c")
        .arg(script)
        .arg("ddm-sync")
        .arg(&task.source)
        .arg(parent)
        .arg(task.target)
        .output()
        .map_err(|error| format!("Failed to execute pkexec: {error}"))?;

    if output.status.success() {
        return Ok(());
    }

    let stderr = String::from_utf8_lossy(&output.stderr);
    let stdout = String::from_utf8_lossy(&output.stdout);
    let details = stderr.trim();

    if details.is_empty() {
        let details = stdout.trim();
        if details.is_empty() {
            Err(format!("Command exited with status {}", output.status))
        } else {
            Err(details.to_owned())
        }
    } else {
        Err(details.to_owned())
    }
}

fn main() {
    let mut engine = QmlEngine::new();
    let backend = QObjectBox::<SyncBackend>::default();

    engine.set_object_property("backend".into(), backend.pinned());

    engine.load_file(qml_path().to_string_lossy().into_owned().into());

    engine.exec();
}

fn qml_path() -> PathBuf {
    let bundled_path = env::current_exe()
        .ok()
        .and_then(|path| path.parent().map(|parent| parent.join("qml/Main.qml")));

    if let Some(path) = bundled_path
        && path.is_file()
    {
        return path;
    }

    Path::new(env!("CARGO_MANIFEST_DIR")).join("qml/Main.qml")
}
