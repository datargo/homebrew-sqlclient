cask "sqlclient" do
  # version und sha256 werden bei jedem Release von scripts/release.sh ersetzt.
  # Die beiden Zeilen deshalb bitte nicht von Hand umformatieren – das Skript erkennt sie
  # über ihren Anfang, nicht über eine Zeilennummer.
  version "1.2.7"
  sha256 "7fb55a37831cbfe466b19ec398e6a7c8673af6d690e901421fc4d8c5cd67f43f"

  url "https://dl.sqlclient.eu/sqlclient/sqlclient_#{version}_universal.dmg",
      verified: "dl.sqlclient.eu/sqlclient/"
  name "sqlclient"
  desc "Native macOS client for MySQL, MariaDB, PostgreSQL, SQL Server and SQLite"
  homepage "https://sqlclient.eu/"

  # Die App bringt einen eigenen Updater mit (signiert, gegen dasselbe latest.json).
  # Ohne diese Zeile hielte Homebrew sich für zuständig und installierte bei jedem
  # `brew upgrade` über eine App, die sich längst selbst aktualisiert hat – im besten
  # Fall unnötig, im schlechteren gegen die Fassung, die gerade läuft.
  #
  # Mit der Zeile überspringt `brew upgrade` den Cask (Cask#outdated_version), es sei
  # denn, jemand ruft ausdrücklich `--greedy`. Die Versionsangabe bleibt trotzdem
  # gepflegt: `brew install` holt damit die richtige Fassung, und livecheck unten
  # meldet weiterhin, was aktuell ist.
  auto_updates true

  # Homebrew fragt selbst nach, ob es eine neuere Fassung gibt. latest.json ist dieselbe
  # Datei, aus der auch die App ihre Updates zieht – es gibt also nur eine Wahrheit.
  livecheck do
    url "https://dl.sqlclient.eu/sqlclient/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  # Universal Binary, Apple-notarisiert. minimumSystemVersion steht in tauri.conf.json.
  #
  # Ohne Vergleichszeichen: die Schreibweise ">= :big_sur" ist seit Homebrew 6 abgekündigt
  # und wirft beim Tappen eine Warnung. Die Bedeutung bleibt dieselbe – für Casks setzt
  # Homebrew von sich aus ">=" davor (Cask::DSL::DependsOn#macos=, comparator: ">="), es
  # heisst also weiterhin „Big Sur oder neuer" und nicht „genau Big Sur".
  depends_on macos: :big_sur

  app "sqlclient.app"

  # Beim Deinstallieren mit `--zap` alles mitnehmen, was die App anlegt. Der Tresor gehört
  # ausdrücklich dazu: er enthält die gespeicherten Zugangsdaten und soll nicht als
  # verwaistes Verschlüsseltes zurückbleiben.
  zap trash: [
    "~/Library/Application Support/com.datargo.sqlclient",
    "~/Library/Caches/com.datargo.sqlclient",
    "~/Library/HTTPStorages/com.datargo.sqlclient",
    "~/Library/Preferences/com.datargo.sqlclient.plist",
    "~/Library/Saved Application State/com.datargo.sqlclient.savedState",
    "~/Library/WebKit/com.datargo.sqlclient",
  ]

  # Der Hinweis nennt jetzt beide Hälften. Vorher stand hier nur „Lesen bleibt frei",
  # und das verschwieg, dass SQLite überhaupt nicht lizenzpflichtig ist: die Engine
  # läuft nicht durch die Prüfung (state::is_free_engine, connection.rs:498), dort
  # bleibt auch das Schreiben dauerhaft frei.
  caveats <<~EOS
    sqlclient läuft 30 Tage als Vollversion.

    Danach bleibt SQLite vollständig kostenlos, mit Schreiben. Bei MySQL, MariaDB,
    PostgreSQL und SQL Server bleiben Lesen, Browsen und Exportieren dauerhaft frei;
    fürs Schreiben wird dort eine Lizenz gebraucht.

    Der Schlüsselbund-Eintrag für Touch ID wird beim Entfernen nicht gelöscht,
    weil `brew uninstall` nicht in den Schlüsselbund greift. Wer ihn loswerden
    will, entfernt in der Schlüsselbundverwaltung den Eintrag "sqlclient".
  EOS
end
