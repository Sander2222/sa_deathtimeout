$(function() {
    function display(bool) {
        if (bool) {
            $("body").fadeIn();

        } else {
            $("body").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == "show") {
                display(true);
            } else if (item.status == "add") {
                //Vars für Daten
                var TimeInSec = item.time

                document.getElementById('Sec').innerHTML = `Du bist noch ${secondsToTime(TimeInSec)} bewusstlos`.toUpperCase();
            } else {
                display(false)
            }
        }
    })
})

function secondsToTime(seconds) {
    // Berechne die Minuten und Sekunden
    const minutes = Math.floor(seconds / 60);
    const remainingSeconds = seconds % 60;
    
    // Füge führende Nullen hinzu, wenn nötig
    const formattedMinutes = minutes.toString().padStart(2, '0');
    const formattedSeconds = remainingSeconds.toString().padStart(2, '0');
    
    // Gib das Ergebnis im Format "mm:ss" zurück
    return `${formattedMinutes}:${formattedSeconds}`;
  }