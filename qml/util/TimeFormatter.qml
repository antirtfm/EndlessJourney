import QtQml

QtObject {
    function duration(seconds: real): string {
        const totalSeconds = Math.max(0, Math.floor(seconds))
        const minutes = Math.floor(totalSeconds / 60)
        const remainingSeconds = totalSeconds % 60
        return minutes + ":" + (remainingSeconds < 10 ? "0" : "")
                + remainingSeconds
    }
}
